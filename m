Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2118805B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgCQLJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgCQLJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CDA20658;
        Tue, 17 Mar 2020 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443369;
        bh=DiCVXP/aHJUd1ZVxWFfOzQZjVo79BztW3rOqtk9aNpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTTgd5VtXSplW2ktcQMg17MKB5DaybipcqttQe8YfqWqTXg/pddaCkg/VUyOReUt+
         6dfUX8GQ6b4xLUWbz9ot+rFlI/4NOajN4KQA2h/LK1TI3G+nzfRZqqAxNOVmekP3U8
         OXRi4OUE9/8F1vgeXURbKoX/aL+vbzgCpk7SEP7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 022/151] net: mscc: ocelot: properly account for VLAN header length when setting MRU
Date:   Tue, 17 Mar 2020 11:53:52 +0100
Message-Id: <20200317103328.371421403@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a8015ded89ad740d21355470d41879c5bd82aab7 ]

What the driver writes into MAC_MAXLEN_CFG does not actually represent
VLAN_ETH_FRAME_LEN but instead ETH_FRAME_LEN + ETH_FCS_LEN. Yes they are
numerically equal, but the difference is important, as the switch treats
VLAN-tagged traffic specially and knows to increase the maximum accepted
frame size automatically. So it is always wrong to account for VLAN in
the MAC_MAXLEN_CFG register.

Unconditionally increase the maximum allowed frame size for
double-tagged traffic. Accounting for the additional length does not
mean that the other VLAN membership checks aren't performed, so there's
no harm done.

Also, stop abusing the MTU name for configuring the MRU. There is no
support for configuring the MRU on an interface at the moment.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Fixes: fa914e9c4d94 ("net: mscc: ocelot: create a helper for changing the port MTU")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c     |   28 +++++++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_dev.h |    2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2175,24 +2175,29 @@ static int ocelot_init_timestamp(struct
 	return 0;
 }
 
-static void ocelot_port_set_mtu(struct ocelot *ocelot, int port, size_t mtu)
+/* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
+ * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
+ */
+static void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
 	int atop_wm;
 
-	ocelot_port_writel(ocelot_port, mtu, DEV_MAC_MAXLEN_CFG);
+	ocelot_port_writel(ocelot_port, maxlen, DEV_MAC_MAXLEN_CFG);
 
 	/* Set Pause WM hysteresis
-	 * 152 = 6 * mtu / OCELOT_BUFFER_CELL_SZ
-	 * 101 = 4 * mtu / OCELOT_BUFFER_CELL_SZ
+	 * 152 = 6 * maxlen / OCELOT_BUFFER_CELL_SZ
+	 * 101 = 4 * maxlen / OCELOT_BUFFER_CELL_SZ
 	 */
 	ocelot_write_rix(ocelot, SYS_PAUSE_CFG_PAUSE_ENA |
 			 SYS_PAUSE_CFG_PAUSE_STOP(101) |
 			 SYS_PAUSE_CFG_PAUSE_START(152), SYS_PAUSE_CFG, port);
 
 	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * mtu) / OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * mtu),
+	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
+		   OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * maxlen),
 			 SYS_ATOP, port);
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
@@ -2221,9 +2226,10 @@ void ocelot_init_port(struct ocelot *oce
 			   DEV_MAC_HDX_CFG);
 
 	/* Set Max Length and maximum tags allowed */
-	ocelot_port_set_mtu(ocelot, port, VLAN_ETH_FRAME_LEN);
+	ocelot_port_set_maxlen(ocelot, port, ETH_DATA_LEN);
 	ocelot_port_writel(ocelot_port, DEV_MAC_TAGS_CFG_TAG_ID(ETH_P_8021AD) |
 			   DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+			   DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA |
 			   DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA,
 			   DEV_MAC_TAGS_CFG);
 
@@ -2309,18 +2315,18 @@ void ocelot_set_cpu_port(struct ocelot *
 	 * Only one port can be an NPI at the same time.
 	 */
 	if (cpu < ocelot->num_phys_ports) {
-		int mtu = VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
+		int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
 
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
 			     QSYS_EXT_CPU_CFG);
 
 		if (injection == OCELOT_TAG_PREFIX_SHORT)
-			mtu += OCELOT_SHORT_PREFIX_LEN;
+			sdu += OCELOT_SHORT_PREFIX_LEN;
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
-			mtu += OCELOT_LONG_PREFIX_LEN;
+			sdu += OCELOT_LONG_PREFIX_LEN;
 
-		ocelot_port_set_mtu(ocelot, cpu, mtu);
+		ocelot_port_set_maxlen(ocelot, cpu, sdu);
 	}
 
 	/* CPU port Injection/Extraction configuration */
--- a/drivers/net/ethernet/mscc/ocelot_dev.h
+++ b/drivers/net/ethernet/mscc/ocelot_dev.h
@@ -74,7 +74,7 @@
 #define DEV_MAC_TAGS_CFG_TAG_ID_M                         GENMASK(31, 16)
 #define DEV_MAC_TAGS_CFG_TAG_ID_X(x)                      (((x) & GENMASK(31, 16)) >> 16)
 #define DEV_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA                 BIT(2)
-#define DEV_MAC_TAGS_CFG_PB_ENA                           BIT(1)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA                 BIT(1)
 #define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA                     BIT(0)
 
 #define DEV_MAC_ADV_CHK_CFG                               0x2c


