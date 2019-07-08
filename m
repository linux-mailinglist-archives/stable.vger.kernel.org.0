Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515CA62263
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731540AbfGHPZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388603AbfGHPZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:25:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E54F217D4;
        Mon,  8 Jul 2019 15:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599528;
        bh=0kw5P18G4j3qrgM0UcDgYuj3COmMTxB/GNf33UXOcts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klEDArTuEsefwaSzH4wjDJlFR7CXx3P2hjBnEDnefIg9r1YA5GuCVjwf3okwbNPTI
         SwAFOmyoP/dl+Z2mXL2HzJCuyTTnGLDhBEHd7FuP1KO6wrqTklU+oiWOp4h43Z4dp6
         90T0wxVG/yAoW+DnSvjxG2uYZvAk0F/6AT0uqoCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Balbir Singh <sblbir@amzn.com>
Subject: [PATCH 4.14 45/56] vhost_net: fix possible infinite loop
Date:   Mon,  8 Jul 2019 17:13:37 +0200
Message-Id: <20190708150523.805847811@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit e2412c07f8f3040593dfb88207865a3cd58680c0 upstream.

When the rx buffer is too small for a packet, we will discard the vq
descriptor and retry it for the next packet:

while ((sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
					      &busyloop_intr))) {
...
	/* On overrun, truncate and discard */
	if (unlikely(headcount > UIO_MAXIOV)) {
		iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
		err = sock->ops->recvmsg(sock, &msg,
					 1, MSG_DONTWAIT | MSG_TRUNC);
		pr_debug("Discarded rx packet: len %zd\n", sock_len);
		continue;
	}
...
}

This makes it possible to trigger a infinite while..continue loop
through the co-opreation of two VMs like:

1) Malicious VM1 allocate 1 byte rx buffer and try to slow down the
   vhost process as much as possible e.g using indirect descriptors or
   other.
2) Malicious VM2 generate packets to VM1 as fast as possible

Fixing this by checking against weight at the end of RX and TX
loop. This also eliminate other similar cases when:

- userspace is consuming the packets in the meanwhile
- theoretical TOCTOU attack if guest moving avail index back and forth
  to hit the continue after vhost find guest just add new buffers

This addresses CVE-2019-3900.

Fixes: d8316f3991d20 ("vhost: fix total length when packets are too short")
Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Balbir Singh <sblbir@amzn.com>

---
 drivers/vhost/net.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -482,7 +482,7 @@ static void handle_tx(struct vhost_net *
 	hdr_size = nvq->vhost_hlen;
 	zcopy = nvq->ubufs;
 
-	for (;;) {
+	do {
 		/* Release DMAs done buffers first */
 		if (zcopy)
 			vhost_zerocopy_signal_used(net, vq);
@@ -578,10 +578,7 @@ static void handle_tx(struct vhost_net *
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
-						  total_len)))
-			break;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -779,7 +776,11 @@ static void handle_rx(struct vhost_net *
 		vq->log : NULL;
 	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
 
-	while ((sock_len = vhost_net_rx_peek_head_len(net, sock->sk))) {
+	do {
+		sock_len = vhost_net_rx_peek_head_len(net, sock->sk);
+
+		if (!sock_len)
+			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
 		headcount = get_rx_bufs(vq, vq->heads, vhost_len,
@@ -860,9 +861,8 @@ static void handle_rx(struct vhost_net *
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
-			goto out;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
+
 	vhost_net_enable_vq(net, vq);
 out:
 	mutex_unlock(&vq->mutex);
@@ -941,7 +941,7 @@ static int vhost_net_open(struct inode *
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);


