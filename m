Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3EA43177F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhJRLiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhJRLiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7900760E76;
        Mon, 18 Oct 2021 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556959;
        bh=pP0cdlPFZcBRYFCDYa7fMqVe2Jwjn6R51+vdaKj9HN0=;
        h=Subject:To:Cc:From:Date:From;
        b=fD4l3LpX8YZkJdmQnM5BiE31Bu2/6fNtCX9iHkETypEccQzTYr0yeZQoqCFjjRHsC
         aP59/+/55TguWy3qm3hwTZLZLvhdxn2C4J3LqV4haQc85RDrUMTBWK551wumxDL7U3
         9aCZD0+9nVzubi/12uipkw10dYJdX4AVhS+RCInY=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: cross-check the sequence id from the" failed to apply to 5.10-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:35:48 +0200
Message-ID: <1634556948192112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ebb4c6a990f786d7e0e4618a0d3766cd660125d8 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:39 +0300
Subject: [PATCH] net: mscc: ocelot: cross-check the sequence id from the
 timestamp FIFO with the skb PTP header

The sad reality is that when a PTP frame with a TX timestamping request
is transmitted, it isn't guaranteed that it will make it all the way to
the wire (due to congestion inside the switch), and that a timestamp
will be taken by the hardware and placed in the timestamp FIFO where an
IRQ will be raised for it.

The implication is that if enough PTP frames are silently dropped by the
hardware such that the timestamp ID has rolled over, it is possible to
match a timestamp to an old skb.

Furthermore, nobody will match on the real skb corresponding to this
timestamp, since we stupidly matched on a previous one that was stale in
the queue, and stopped there.

So PTP timestamping will be broken and there will be no way to recover.

It looks like the hardware parses the sequenceID from the PTP header,
and also provides that metadata for each timestamp. The driver currently
ignores this, but it shouldn't.

As an extra resiliency measure, do the following:

- check whether the PTP sequenceID also matches between the skb and the
  timestamp, treat the skb as stale otherwise and free it

- if we see a stale skb, don't stop there and try to match an skb one
  more time, chances are there's one more skb in the queue with the same
  timestamp ID, otherwise we wouldn't have ever found the stale one (it
  is by timestamp ID that we matched it).

While this does not prevent PTP packet drops, it at least prevents
the catastrophic consequences of incorrect timestamp matching.

Since we already call ptp_classify_raw in the TX path, save the result
in the skb->cb of the clone, and just use that result in the interrupt
code path.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3b1f0bb6a414..f0044329e3d7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -675,6 +675,7 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 			return err;
 
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
 	}
 
 	return 0;
@@ -708,6 +709,17 @@ static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
 	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
 }
 
+static bool ocelot_validate_ptp_skb(struct sk_buff *clone, u16 seqid)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(clone, OCELOT_SKB_CB(clone)->ptp_class);
+	if (WARN_ON(!hdr))
+		return false;
+
+	return seqid == ntohs(hdr->sequence_id);
+}
+
 void ocelot_get_txtstamp(struct ocelot *ocelot)
 {
 	int budget = OCELOT_PTP_QUEUE_SZ;
@@ -715,10 +727,10 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 	while (budget--) {
 		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
 		struct skb_shared_hwtstamps shhwtstamps;
+		u32 val, id, seqid, txport;
 		struct ocelot_port *port;
 		struct timespec64 ts;
 		unsigned long flags;
-		u32 val, id, txport;
 
 		val = ocelot_read(ocelot, SYS_PTP_STATUS);
 
@@ -731,6 +743,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		/* Retrieve the ts ID and Tx port */
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+		seqid = SYS_PTP_STATUS_PTP_MESS_SEQ_ID(val);
 
 		port = ocelot->ports[txport];
 
@@ -740,6 +753,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		spin_unlock(&ocelot->ts_id_lock);
 
 		/* Retrieve its associated skb */
+try_again:
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -755,6 +769,14 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 		if (WARN_ON(!skb_match))
 			continue;
 
+		if (!ocelot_validate_ptp_skb(skb_match, seqid)) {
+			dev_err_ratelimited(ocelot->dev,
+					    "port %d received stale TX timestamp for seqid %d, discarding\n",
+					    txport, seqid);
+			dev_kfree_skb_any(skb);
+			goto try_again;
+		}
+
 		/* Get the h/w timestamp */
 		ocelot_get_hwtimestamp(ocelot, &ts);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b0ece85d9a76..cabacef8731c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -697,6 +697,7 @@ struct ocelot_policer {
 
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
+	unsigned int ptp_class; /* valid only for clones */
 	u8 ptp_cmd;
 	u8 ts_id;
 };

