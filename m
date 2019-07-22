Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163D570079
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfGVNDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 09:03:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45248 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbfGVNDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 09:03:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so34628876eda.12
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRPCD1o2rc36HWQKD5G+VhhqWnQ6h+sxleJXDzNLSiU=;
        b=GAFW/S2YTCiSZfLDFY5eFcg1i4ZSbrKyMNM8V9ElYqk7hDJtohxsa9w4raLg6+F8W7
         3jqmFacauLz/PLz9ls6osfkvPzACBal2Ee1Pif0r+IzuMhwa//6wz7nURcY6+PrMXpM9
         C5GYXzt5s/6TOgcO2cHcUM072OS1pvOmn2PUiQurZdXjPZuLACiEONMazVbNf443j24V
         gYEpTSZXPMmGvFqzzUzUzAROrrZrRHmUpr5IzdoBdRDG6cCT0EvPeBWf6/Bh8h1zBRs8
         JnAbx2ObGvnLksubafl15Q7MM2dCPTnjhn2E1qW4cq70cQ1PbQevxcXvIv4KwZLG7guV
         VLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BRPCD1o2rc36HWQKD5G+VhhqWnQ6h+sxleJXDzNLSiU=;
        b=djHQOHZPXJJr8MZskmIIKmMqj0W0HIDyNrtTsZIAceO1ZNzKHsYWiuUvCWsFM7MzgY
         QIbvfrdZwFQY9QqSNly5wyrARbJB50ufRzuNN3Rs5vfcvVAgN0unQD4u1no/WIKSSRZ0
         jGmi7lUvHaFdeTDFbWR1tULg3x3UNicNKpX1mh6OD1Lp91TFj9xryrGvV5LxAnLBijZo
         LY+Swx4f9mo1Ev8J1J+KosxyXuU0bwdm5IsbcPDSi1Qcf5qBg9I1jwPfpQtd8wrYKO1i
         z/PHW5np5UVlcbdn46bH7meBj2gbrVEO8YI580/t/YH+DSgKeeVmRBY4oFknhnH0RBl5
         BmRg==
X-Gm-Message-State: APjAAAWNCtqH1AceuU9Ur0Mb5NQUFDClLy/XS0gVY7SJAut9U1MRWtxo
        95O76xLu62b3hBocDA1+6ds=
X-Google-Smtp-Source: APXvYqyeZREyruNXsyZWQsLP6s9jaDUrKqSU0FR+HgWqTM7+eAKfDzSwbkfc70xV04/LE8CJrH6hmw==
X-Received: by 2002:a50:eb8b:: with SMTP id y11mr60042289edr.154.1563800596807;
        Mon, 22 Jul 2019 06:03:16 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id v12sm7996085ejj.52.2019.07.22.06.03.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 06:03:16 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.19 2/4] vhost_net: fix possible infinite loop
Date:   Mon, 22 Jul 2019 15:03:11 +0200
Message-Id: <20190722130313.18562-3-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
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
[jwang: backport to 4.19]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/vhost/net.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f6cf6825c15f..9a20ec796c12 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -551,7 +551,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int err;
 	int sent_pkts = 0;
 
-	for (;;) {
+	do {
 		bool busyloop_intr = false;
 
 		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
@@ -592,9 +592,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				 err, len);
 		if (++nvq->done_idx >= VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
-		if (vhost_exceeds_weight(vq, ++sent_pkts, total_len))
-			break;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
 	vhost_net_signal_used(nvq);
 }
@@ -618,7 +616,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	bool zcopy_used;
 	int sent_pkts = 0;
 
-	for (;;) {
+	do {
 		bool busyloop_intr;
 
 		/* Release DMAs done buffers first */
@@ -693,10 +691,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
-						  total_len)))
-			break;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 }
 
 /* Expects to be always run from workqueue - which acts as
@@ -932,8 +927,11 @@ static void handle_rx(struct vhost_net *net)
 		vq->log : NULL;
 	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
 
-	while ((sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
-						      &busyloop_intr))) {
+	do {
+		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
+						      &busyloop_intr);
+		if (!sock_len)
+			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
 		headcount = get_rx_bufs(vq, vq->heads + nvq->done_idx,
@@ -1018,12 +1016,11 @@ static void handle_rx(struct vhost_net *net)
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
-			goto out;
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
+
 	if (unlikely(busyloop_intr))
 		vhost_poll_queue(&vq->poll);
-	else
+	else if (!sock_len)
 		vhost_net_enable_vq(net, vq);
 out:
 	vhost_net_signal_used(nvq);
@@ -1105,7 +1102,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
 		       UIO_MAXIOV + VHOST_NET_BATCH,
-		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
-- 
2.17.1

