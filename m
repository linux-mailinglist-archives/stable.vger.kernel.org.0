Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789439F69E
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfH0XKs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 19:10:48 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58977 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfH0XKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:10:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1i2kbt-0000ii-1d; Wed, 28 Aug 2019 00:10:45 +0100
Date:   Wed, 28 Aug 2019 00:10:43 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 07/13] vhost_net: fix possible infinite loop
Message-ID: <20190827231043.GG11046@xylophone.i.decadent.org.uk>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
[bwh: Backported to 4.4:
 - Both Tx modes are handled in one loop in handle_tx()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/vhost/net.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 20062531f1ea..1459dc9fd701 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -326,7 +326,7 @@ static void handle_tx(struct vhost_net *net)
 	hdr_size = nvq->vhost_hlen;
 	zcopy = nvq->ubufs;
 
-	for (;;) {
+	do {
 		/* Release DMAs done buffers first */
 		if (zcopy)
 			vhost_zerocopy_signal_used(net, vq);
@@ -415,10 +415,7 @@ static void handle_tx(struct vhost_net *net)
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
-						  total_len)))
-			break;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -560,7 +557,10 @@ static void handle_rx(struct vhost_net *net)
 		vq->log : NULL;
 	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
 
-	while ((sock_len = peek_head_len(sock->sk))) {
+	do {
+		sock_len = peek_head_len(sock->sk);
+		if (!sock_len)
+			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
 		headcount = get_rx_bufs(vq, vq->heads, vhost_len,
@@ -638,9 +638,8 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(vq_log))
 			vhost_log_write(vq, vq_log, log, vhost_len);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
-			break;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
+
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -710,7 +709,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].sock_hlen = 0;
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


