Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C220690B3B
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfHPXAc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 19:00:32 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:51294 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfHPXAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 19:00:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hylCv-0004jP-TO; Sat, 17 Aug 2019 00:00:30 +0100
Date:   Sat, 17 Aug 2019 00:00:28 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.9 05/13] vhost_net: use packet weight for rx handler, too
Message-ID: <20190816230028.GI9843@xylophone.i.decadent.org.uk>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

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
---
 drivers/vhost/net.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 64431c0d2a53..4093b4eea8b9 100644
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
@@ -480,7 +482,7 @@ static void handle_tx(struct vhost_net *net)
 		total_len += len;
 		vhost_net_tx_packet(net);
 		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT(vq))) {
+		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -662,6 +664,7 @@ static void handle_rx(struct vhost_net *net)
 	struct socket *sock;
 	struct iov_iter fixup;
 	__virtio16 num_buffers;
+	int recv_pkts = 0;
 
 	mutex_lock_nested(&vq->mutex, 0);
 	sock = vq->private_data;
@@ -760,7 +763,8 @@ static void handle_rx(struct vhost_net *net)
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
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


