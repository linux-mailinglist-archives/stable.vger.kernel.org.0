Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7FE431EBF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhJROFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234941AbhJRODf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F139A61378;
        Mon, 18 Oct 2021 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564619;
        bh=G8DU1zHqpje3il4KgpPReKV8gohkNIP0QaTgxbSpEOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCw1/WKhxf2oy+zKiF1Nz+tj/v+08nI/Syf5g2CbW5Bz7jOu9tXtlCIyleoV2s3eZ
         XxZ16KJJjZasznNGzk8f3v7Xh/Arfr5qJiLgnA2YtrbRGcCf1zM3GWs3Rr1fcIPb3k
         m3xUyUGcDok0Y058pLPUWyku2HT+bK8wbxm2YIEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 146/151] net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
Date:   Mon, 18 Oct 2021 15:25:25 +0200
Message-Id: <20211018132345.409460758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 52849bcf0029ccc553be304e4f804938a39112e2 upstream.

PTP packets with 2-step TX timestamp requests are matched to packets
based on the egress port number and a 6-bit timestamp identifier.
All PTP timestamps are held in a common FIFO that is 128 entry deep.

This patch ensures that back-to-back timestamping requests cannot exceed
the hardware FIFO capacity. If that happens, simply send the packets
without requesting a TX timestamp to be taken (in the case of felix,
since the DSA API has a void return code in ds->ops->port_txtstamp) or
drop them (in the case of ocelot).

I've moved the ts_id_lock from a per-port basis to a per-switch basis,
because we need separate accounting for both numbers of PTP frames in
flight. And since we need locking to inc/dec the per-switch counter,
that also offers protection for the per-port counter and hence there is
no reason to have a per-port counter anymore.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c     |    6 +++++-
 drivers/net/ethernet/mscc/ocelot.c |   37 ++++++++++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |    5 ++++-
 include/soc/mscc/ocelot_ptp.h      |    1 +
 4 files changed, 40 insertions(+), 9 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1406,8 +1406,12 @@ static void felix_txtstamp(struct dsa_sw
 	if (!ocelot->ptp)
 		return;
 
-	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone))
+	if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone)) {
+		dev_err_ratelimited(ds->dev,
+				    "port %d delivering skb without TX timestamp\n",
+				    port);
 		return;
+	}
 
 	if (clone)
 		OCELOT_SKB_CB(skb)->clone = clone;
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -536,22 +536,36 @@ void ocelot_port_disable(struct ocelot *
 }
 EXPORT_SYMBOL(ocelot_port_disable);
 
-static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-					 struct sk_buff *clone)
+static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+					struct sk_buff *clone)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	unsigned long flags;
+
+	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
 
-	spin_lock(&ocelot_port->ts_id_lock);
+	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
+	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
+		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+		return -EBUSY;
+	}
 
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
+
 	ocelot_port->ts_id++;
 	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
 		ocelot_port->ts_id = 0;
+
+	ocelot_port->ptp_skbs_in_flight++;
+	ocelot->ptp_skbs_in_flight++;
+
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
-	spin_unlock(&ocelot_port->ts_id_lock);
+	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+
+	return 0;
 }
 
 u32 ocelot_ptp_rew_op(struct sk_buff *skb)
@@ -600,6 +614,7 @@ int ocelot_port_txtstamp_request(struct
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	int err;
 
 	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
 	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
@@ -617,7 +632,10 @@ int ocelot_port_txtstamp_request(struct
 		if (!(*clone))
 			return -ENOMEM;
 
-		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		if (err)
+			return err;
+
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 	}
 
@@ -676,9 +694,14 @@ void ocelot_get_txtstamp(struct ocelot *
 		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
 		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
 
-		/* Retrieve its associated skb */
 		port = ocelot->ports[txport];
 
+		spin_lock(&ocelot->ts_id_lock);
+		port->ptp_skbs_in_flight--;
+		ocelot->ptp_skbs_in_flight--;
+		spin_unlock(&ocelot->ts_id_lock);
+
+		/* Retrieve its associated skb */
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
@@ -1917,7 +1940,6 @@ void ocelot_init_port(struct ocelot *oce
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	skb_queue_head_init(&ocelot_port->tx_skbs);
-	spin_lock_init(&ocelot_port->ts_id_lock);
 
 	/* Basic L2 initialization */
 
@@ -2041,6 +2063,7 @@ int ocelot_init(struct ocelot *ocelot)
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
+	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(ocelot->dev));
 	ocelot->stats_queue = create_singlethread_workqueue(queue_name);
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -600,10 +600,10 @@ struct ocelot_port {
 	/* The VLAN ID that will be transmitted as untagged, on egress */
 	struct ocelot_vlan		native_vlan;
 
+	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
 	u8				ts_id;
-	spinlock_t			ts_id_lock;
 
 	phy_interface_t			phy_mode;
 
@@ -677,6 +677,9 @@ struct ocelot {
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
 	struct hwtstamp_config		hwtstamp_config;
+	unsigned int			ptp_skbs_in_flight;
+	/* Protects the 2-step TX timestamp ID logic */
+	spinlock_t			ts_id_lock;
 	/* Protects the PTP interface state */
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -14,6 +14,7 @@
 #include <soc/mscc/ocelot.h>
 
 #define OCELOT_MAX_PTP_ID		63
+#define OCELOT_PTP_FIFO_SIZE		128
 
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ


