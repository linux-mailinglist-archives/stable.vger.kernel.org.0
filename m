Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ECE28B83C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbgJLNu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731889AbgJLNsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464C02225F;
        Mon, 12 Oct 2020 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510452;
        bh=i4mslZ8SpxWMr9P7e6inTuFPBZH2WK1EnEHJzpvTMAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8CiIqt/bhzUJFu6rg3iJ9W2WYdjuYYBn9KbyGeWh1VMFUX2cYbERi+RGFOOwrgJJ
         7UYW7PWj70oqMBpOJRkq89QichlsyXcZNar+t182eyvo+34DMG7Vie8/oq7G9HZd1L
         IJaWoUTGluUK8D0axL1uLR7fn9E5XZ7bBqogIJbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 105/124] net: mscc: ocelot: split writes to pause frame enable bit and to thresholds
Date:   Mon, 12 Oct 2020 15:31:49 +0200
Message-Id: <20201012133151.943997510@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e8e6e73db14273464b374d49ca7242c0994945f3 ]

We don't want ocelot_port_set_maxlen to enable pause frame TX, just to
adjust the pause thresholds.

Move the unconditional enabling of pause TX to ocelot_init_port. There
is no good place to put such setting because it shouldn't be
unconditional. But at the moment it is, we're not changing that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d0b79cca51840..6e68713c0ac6b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2012,6 +2012,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
+	int pause_start, pause_stop;
 	int atop_wm;
 
 	if (port == ocelot->npi) {
@@ -2025,13 +2026,13 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 
 	ocelot_port_writel(ocelot_port, maxlen, DEV_MAC_MAXLEN_CFG);
 
-	/* Set Pause WM hysteresis
-	 * 152 = 6 * maxlen / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * maxlen / OCELOT_BUFFER_CELL_SZ
-	 */
-	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
-			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
-			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
+	/* Set Pause watermark hysteresis */
+	pause_start = 6 * maxlen / OCELOT_BUFFER_CELL_SZ;
+	pause_stop = 4 * maxlen / OCELOT_BUFFER_CELL_SZ;
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_START(pause_start),
+		       SYS_PAUSE_CFG_PAUSE_START_M, SYS_PAUSE_CFG, port);
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_STOP(pause_stop),
+		       SYS_PAUSE_CFG_PAUSE_STOP_M, SYS_PAUSE_CFG, port);
 
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
@@ -2094,6 +2095,10 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_HIGH_CFG);
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_FC_MAC_LOW_CFG);
 
+	/* Enable transmission of pause frames */
+	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA, SYS_PAUSE_CFG_PAUSE_ENA,
+		       SYS_PAUSE_CFG, port);
+
 	/* Drop frames with multicast source address */
 	ocelot_rmw_gix(ocelot, ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
 		       ANA_PORT_DROP_CFG_DROP_MC_SMAC_ENA,
-- 
2.25.1



