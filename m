Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1669A8E32
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732038AbfIDR4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387619AbfIDR4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D197122CF7;
        Wed,  4 Sep 2019 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619796;
        bh=Wf0yReSvmLtQN3TZjus7kyYzHe+ulnlqZnDfcwXGxiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7WV3lS0KQ0oOeHE+tqz3p3XBlLfdXdEcaCrH9Gcv+PGhIKi+la1K1Oj1Df0j6tKX
         IzKRj5rvEoaCh2a1wOxxN6THlYITIwHecIyDsIupKdh34bVwQP+auYWvqQ8XF+8T6K
         9TUOl4Vr32EBwhA0kAUYt6U9zE71AHKMJV7PTqgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 37/77] vhost_net: use packet weight for rx handler, too
Date:   Wed,  4 Sep 2019 19:53:24 +0200
Message-Id: <20190904175307.104169907@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit db688c24eada63b1efe6d0d7d835e5c3bdd71fd3 upstream.

Similar to commit a2ac99905f1e ("vhost-net: set packet weight of
tx polling to 2 * vq size"), we need a packet-based limit for
handler_rx, too - elsewhere, under rx flood with small packets,
tx can be delayed for a very long time, even without busypolling.

The pkt limit applied to handle_rx must be the same applied by
handle_tx, or we will get unfair scheduling between rx and tx.
Tying such limit to the queue length makes it less effective for
large queue length values and can introduce large process
scheduler latencies, so a constant valued is used - likewise
the existing bytes limit.

The selected limit has been validated with PVP[1] performance
test with different queue sizes:

queue size		256	512	1024

baseline		366	354	362
weight 128		715	723	670
weight 256		740	745	733
weight 512		600	460	583
weight 1024		423	427	418

A packet weight of 256 gives peek performances in under all the
tested scenarios.

No measurable regression in unidirectional performance tests has
been detected.

[1] https://developers.redhat.com/blog/2017/06/05/measuring-and-comparing-open-vswitch-performance/

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b8496f713bc62..c1b5bccab293f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -40,8 +40,10 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
 #define VHOST_NET_WEIGHT 0x80000
 
 /* Max number of packets transferred before requeueing the job.
- * Using this limit prevents one virtqueue from starving rx. */
-#define VHOST_NET_PKT_WEIGHT(vq) ((vq)->num * 2)
+ * Using this limit prevents one virtqueue from starving others with small
+ * pkts.
+ */
+#define VHOST_NET_PKT_WEIGHT 256
 
 /* MAX number of TX used buffers for outstanding zerocopy */
 #define VHOST_MAX_PEND 128
@@ -414,7 +416,7 @@ static void handle_tx(struct vhost_net *net)
 		total_len += len;
 		vhost_net_tx_packet(net);
 		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT(vq))) {
+		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -545,6 +547,7 @@ static void handle_rx(struct vhost_net *net)
 	struct socket *sock;
 	struct iov_iter fixup;
 	__virtio16 num_buffers;
+	int recv_pkts = 0;
 
 	mutex_lock(&vq->mutex);
 	sock = vq->private_data;
@@ -637,7 +640,8 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(vq_log))
 			vhost_log_write(vq, vq_log, log, vhost_len);
 		total_len += vhost_len;
-		if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
+		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
+		    unlikely(++recv_pkts >= VHOST_NET_PKT_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
-- 
2.20.1



