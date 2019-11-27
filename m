Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06B10BD80
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfK0U5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbfK0U5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18201217AB;
        Wed, 27 Nov 2019 20:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888227;
        bh=UgCUPv+FXXkrqQZEGsb62ZUpxRa20bdJWsSt6ZQqkLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StZ53zpG2TlVtnlWMUVu93IZBg3AB+UGoJe34FyNepg7qTN+1G5n6QtSSRIwtkmbf
         eFYFG9ZAcgkgrNxzh25oGBfE6Q3K2zECb3+CiiTcsz4melSwZXMfNnkYqA6YLh96zV
         b2CT328+kOAb4cZLEgcXAhg6GqTb3qS7f3gUGHQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 011/306] vhost/vsock: split packets to send using multiple buffers
Date:   Wed, 27 Nov 2019 21:27:41 +0100
Message-Id: <20191127203115.549140598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 6dbd3e66e7785a2f055bf84d98de9b8fd31ff3f5 upstream.

If the packets to sent to the guest are bigger than the buffer
available, we can split them, using multiple buffers and fixing
the length in the packet header.
This is safe since virtio-vsock supports only stream sockets.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vsock.c                   |   66 +++++++++++++++++++++++---------
 net/vmw_vsock/virtio_transport_common.c |   15 +++++--
 2 files changed, 60 insertions(+), 21 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -103,7 +103,7 @@ vhost_transport_do_send_pkt(struct vhost
 		struct iov_iter iov_iter;
 		unsigned out, in;
 		size_t nbytes;
-		size_t len;
+		size_t iov_len, payload_len;
 		int head;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
@@ -148,8 +148,24 @@ vhost_transport_do_send_pkt(struct vhost
 			break;
 		}
 
-		len = iov_length(&vq->iov[out], in);
-		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
+		iov_len = iov_length(&vq->iov[out], in);
+		if (iov_len < sizeof(pkt->hdr)) {
+			virtio_transport_free_pkt(pkt);
+			vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
+			break;
+		}
+
+		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
+		payload_len = pkt->len - pkt->off;
+
+		/* If the packet is greater than the space available in the
+		 * buffer, we split it using multiple buffers.
+		 */
+		if (payload_len > iov_len - sizeof(pkt->hdr))
+			payload_len = iov_len - sizeof(pkt->hdr);
+
+		/* Set the correct length in the header */
+		pkt->hdr.len = cpu_to_le32(payload_len);
 
 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
 		if (nbytes != sizeof(pkt->hdr)) {
@@ -158,33 +174,47 @@ vhost_transport_do_send_pkt(struct vhost
 			break;
 		}
 
-		nbytes = copy_to_iter(pkt->buf, pkt->len, &iov_iter);
-		if (nbytes != pkt->len) {
+		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
+				      &iov_iter);
+		if (nbytes != payload_len) {
 			virtio_transport_free_pkt(pkt);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
 		}
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + pkt->len);
+		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
 		added = true;
 
-		if (pkt->reply) {
-			int val;
-
-			val = atomic_dec_return(&vsock->queued_replies);
-
-			/* Do we have resources to resume tx processing? */
-			if (val + 1 == tx_vq->num)
-				restart_tx = true;
-		}
-
 		/* Deliver to monitoring devices all correctly transmitted
 		 * packets.
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
-		total_len += pkt->len;
-		virtio_transport_free_pkt(pkt);
+		pkt->off += payload_len;
+		total_len += payload_len;
+
+		/* If we didn't send all the payload we can requeue the packet
+		 * to send it with the next available buffer.
+		 */
+		if (pkt->off < pkt->len) {
+			spin_lock_bh(&vsock->send_pkt_list_lock);
+			list_add(&pkt->list, &vsock->send_pkt_list);
+			spin_unlock_bh(&vsock->send_pkt_list_lock);
+		} else {
+			if (pkt->reply) {
+				int val;
+
+				val = atomic_dec_return(&vsock->queued_replies);
+
+				/* Do we have resources to resume tx
+				 * processing?
+				 */
+				if (val + 1 == tx_vq->num)
+					restart_tx = true;
+			}
+
+			virtio_transport_free_pkt(pkt);
+		}
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
 		vhost_signal(&vsock->dev, vq);
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -92,8 +92,17 @@ static struct sk_buff *virtio_transport_
 	struct virtio_vsock_pkt *pkt = opaque;
 	struct af_vsockmon_hdr *hdr;
 	struct sk_buff *skb;
+	size_t payload_len;
+	void *payload_buf;
 
-	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + pkt->len,
+	/* A packet could be split to fit the RX buffer, so we can retrieve
+	 * the payload length from the header and the buffer pointer taking
+	 * care of the offset in the original packet.
+	 */
+	payload_len = le32_to_cpu(pkt->hdr.len);
+	payload_buf = pkt->buf + pkt->off;
+
+	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + payload_len,
 			GFP_ATOMIC);
 	if (!skb)
 		return NULL;
@@ -133,8 +142,8 @@ static struct sk_buff *virtio_transport_
 
 	skb_put_data(skb, &pkt->hdr, sizeof(pkt->hdr));
 
-	if (pkt->len) {
-		skb_put_data(skb, pkt->buf, pkt->len);
+	if (payload_len) {
+		skb_put_data(skb, payload_buf, payload_len);
 	}
 
 	return skb;


