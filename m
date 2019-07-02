Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE495D990
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfGCArr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:47 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:62490 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfGCArq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:46 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="740136594"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 02 Jul 2019 21:02:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id C42E5A2638;
        Tue,  2 Jul 2019 21:02:32 +0000 (UTC)
Received: from EX13D01UWA001.ant.amazon.com (10.43.160.60) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d01UWA001.ant.amazon.com (10.43.160.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:31 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Balbir Singh <sblbir@amazon.com>
Subject: [backport to v4.14 CVE-2019-3900 2/7] vhost_net: use packet weight for rx handler, too
Date:   Tue, 2 Jul 2019 21:02:05 +0000
Message-ID: <20190702210210.2375-3-sblbir@amzn.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20190702210210.2375-1-sblbir@amzn.com>
References: <20190702210210.2375-1-sblbir@amzn.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

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

[upstream - db688c24eada63b1efe6d0d7d835e5c3bdd71fd3]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Balbir Singh <sblbir@amazon.com>
---
 drivers/vhost/net.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index a60fcf07f86c..9fcf7bf25249 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -45,8 +45,10 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
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
@@ -578,7 +580,7 @@ static void handle_tx(struct vhost_net *net)
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
 		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT(vq))) {
+		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -760,6 +762,7 @@ static void handle_rx(struct vhost_net *net)
 	struct socket *sock;
 	struct iov_iter fixup;
 	__virtio16 num_buffers;
+	int recv_pkts = 0;
 
 	mutex_lock_nested(&vq->mutex, 0);
 	sock = vq->private_data;
@@ -860,7 +863,8 @@ static void handle_rx(struct vhost_net *net)
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
+		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
+		    unlikely(++recv_pkts >= VHOST_NET_PKT_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
 			goto out;
 		}
-- 
2.16.5

