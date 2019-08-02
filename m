Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F267F378
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406861AbfHBJ5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406859AbfHBJ5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8236721773;
        Fri,  2 Aug 2019 09:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739835;
        bh=V5MJKdWxbvfMHveL83rIHKBwqsovD/stD4vavj7+vSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZkO6vRZjCW+7Lzz0/6GYwqIIHSWmxv+2i6fawve+93Y/VkwWlGl3eAK/QnnEkBfL
         ojAhLxzVQovIQYibpTuvtg/92yhnwMmO1JfeJUZ51wWARWoQ9B/9thElX+WBGUXIol
         cUXxkz03PzmYcx4+6cR1fkjw2rE9OqMD0tKebJAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 22/32] vhost: vsock: add weight support
Date:   Fri,  2 Aug 2019 11:39:56 +0200
Message-Id: <20190802092108.961740258@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit e79b431fb901ba1106670bcc80b9b617b25def7d upstream.

This patch will check the weight and exit the loop if we exceeds the
weight. This is useful for preventing vsock kthread from hogging cpu
which is guest triggerable. The weight can help to avoid starving the
request from on direction while another direction is being processed.

The value of weight is picked from vhost-net.

This addresses CVE-2019-3900.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vsock.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -86,6 +86,7 @@ vhost_transport_do_send_pkt(struct vhost
 			    struct vhost_virtqueue *vq)
 {
 	struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
+	int pkts = 0, total_len = 0;
 	bool added = false;
 	bool restart_tx = false;
 
@@ -97,7 +98,7 @@ vhost_transport_do_send_pkt(struct vhost
 	/* Avoid further vmexits, we're already processing the virtqueue */
 	vhost_disable_notify(&vsock->dev, vq);
 
-	for (;;) {
+	do {
 		struct virtio_vsock_pkt *pkt;
 		struct iov_iter iov_iter;
 		unsigned out, in;
@@ -182,8 +183,9 @@ vhost_transport_do_send_pkt(struct vhost
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
+		total_len += pkt->len;
 		virtio_transport_free_pkt(pkt);
-	}
+	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
 		vhost_signal(&vsock->dev, vq);
 
@@ -358,7 +360,7 @@ static void vhost_vsock_handle_tx_kick(s
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head;
+	int head, pkts = 0, total_len = 0;
 	unsigned int out, in;
 	bool added = false;
 
@@ -368,7 +370,7 @@ static void vhost_vsock_handle_tx_kick(s
 		goto out;
 
 	vhost_disable_notify(&vsock->dev, vq);
-	for (;;) {
+	do {
 		u32 len;
 
 		if (!vhost_vsock_more_replies(vsock)) {
@@ -409,9 +411,11 @@ static void vhost_vsock_handle_tx_kick(s
 		else
 			virtio_transport_free_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + len);
+		len += sizeof(pkt->hdr);
+		vhost_add_used(vq, head, len);
+		total_len += len;
 		added = true;
-	}
+	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 
 no_more_replies:
 	if (added)


