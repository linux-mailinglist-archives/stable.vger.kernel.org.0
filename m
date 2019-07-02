Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556925D98C
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGCArn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:43 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:62750 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfGCArm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:42 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="772995219"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Jul 2019 21:02:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 6B553A2130;
        Tue,  2 Jul 2019 21:02:33 +0000 (UTC)
Received: from EX13D20UWC004.ant.amazon.com (10.43.162.41) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D20UWC004.ant.amazon.com (10.43.162.41) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:32 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Balbir Singh <sblbir@amzn.com>
Subject: [backport to v4.14 CVE-2019-3900 5/7] vhost_net: fix possible infinite loop
Date:   Tue, 2 Jul 2019 21:02:08 +0000
Message-ID: <20190702210210.2375-6-sblbir@amzn.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20190702210210.2375-1-sblbir@amzn.com>
References: <20190702210210.2375-1-sblbir@amzn.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

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

[upstream e2412c07f8f3040593dfb88207865a3cd58680c0
Balbir - backport to stable 4.14]
Fixes: d8316f3991d20 ("vhost: fix total length when packets are too short")
Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Balbir Singh <sblbir@amzn.com>
---
 drivers/vhost/net.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index a4ca0346da3e..b40e8ded49c6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -482,7 +482,7 @@ static void handle_tx(struct vhost_net *net)
 	hdr_size = nvq->vhost_hlen;
 	zcopy = nvq->ubufs;
 
-	for (;;) {
+	do {
 		/* Release DMAs done buffers first */
 		if (zcopy)
 			vhost_zerocopy_signal_used(net, vq);
@@ -578,10 +578,7 @@ static void handle_tx(struct vhost_net *net)
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
@@ -779,7 +776,11 @@ static void handle_rx(struct vhost_net *net)
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
@@ -860,9 +861,8 @@ static void handle_rx(struct vhost_net *net)
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
@@ -941,7 +941,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
-- 
2.16.5

