Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF359D833
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiHWJMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348206AbiHWJJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC8B74DD6;
        Tue, 23 Aug 2022 01:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC5D8614CA;
        Tue, 23 Aug 2022 08:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60ADC433B5;
        Tue, 23 Aug 2022 08:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243367;
        bh=TwqLt3hNn9yFWoN1IQ77dG1SLU8ADuZswLmHKbLb61w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVKNRmVHoQYeCVWeHwmWYI9CPl2hVG9TcfCrBrmtIQJ/RziwEY26enWN4Zgs3uzpd
         dsKKh077qRDRiqR+hdvMrs7etBY07XMQLbmGFlR60Kn5m7nzY3GdDCH74jsrUt7dbx
         C7kcBra7r2jKDBfAXepoRFa/DUWenHti/mK3t5C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 254/365] net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats
Date:   Tue, 23 Aug 2022 10:02:35 +0200
Message-Id: <20220823080128.824469865@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e780e3193e889fd8358b862f7cd18ec5a4901caf ]

Rather than reading the stats64 counters directly from the 32-bit
hardware, it's better to rely on the output produced by the periodic
ocelot_port_update_stats().

It would be even better to call ocelot_port_update_stats() right from
ocelot_get_stats64() to make sure we report the current values rather
than the ones from 2 seconds ago. But we need to export
ocelot_port_update_stats() from the switch lib towards the switchdev
driver for that, and future work will largely undo that.

There are more ocelot-based drivers waiting to be introduced, an example
of which is the SPI-controlled VSC7512. In that driver's case, it will
be impossible to call ocelot_port_update_stats() from ndo_get_stats64
context, since the latter is atomic, and reading the stats over SPI is
sleepable. So the compromise taken here, which will also hold going
forward, is to report 64-bit counters to stats64, which are not 100% up
to date.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 53 +++++++++++++-------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 6b9d37138844..330d30841cdc 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -725,41 +725,40 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
+	u64 *s;
 
 	spin_lock(&ocelot->stats_lock);
 
-	/* Configure the port to read the stats from */
-	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
-		     SYS_STAT_CFG);
+	s = &ocelot->stats[port * OCELOT_NUM_STATS];
 
 	/* Get Rx stats */
-	stats->rx_bytes = ocelot_read(ocelot, SYS_COUNT_RX_OCTETS);
-	stats->rx_packets = ocelot_read(ocelot, SYS_COUNT_RX_SHORTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_FRAGMENTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_JABBERS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_LONGS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_256_511) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_512_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
-	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
+	stats->rx_bytes = s[OCELOT_STAT_RX_OCTETS];
+	stats->rx_packets = s[OCELOT_STAT_RX_SHORTS] +
+			    s[OCELOT_STAT_RX_FRAGMENTS] +
+			    s[OCELOT_STAT_RX_JABBERS] +
+			    s[OCELOT_STAT_RX_LONGS] +
+			    s[OCELOT_STAT_RX_64] +
+			    s[OCELOT_STAT_RX_65_127] +
+			    s[OCELOT_STAT_RX_128_255] +
+			    s[OCELOT_STAT_RX_256_511] +
+			    s[OCELOT_STAT_RX_512_1023] +
+			    s[OCELOT_STAT_RX_1024_1526] +
+			    s[OCELOT_STAT_RX_1527_MAX];
+	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
 	stats->rx_dropped = dev->stats.rx_dropped;
 
 	/* Get Tx stats */
-	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
-	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_256_511) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
-	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
-	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
+	stats->tx_packets = s[OCELOT_STAT_TX_64] +
+			    s[OCELOT_STAT_TX_65_127] +
+			    s[OCELOT_STAT_TX_128_255] +
+			    s[OCELOT_STAT_TX_256_511] +
+			    s[OCELOT_STAT_TX_512_1023] +
+			    s[OCELOT_STAT_TX_1024_1526] +
+			    s[OCELOT_STAT_TX_1527_MAX];
+	stats->tx_dropped = s[OCELOT_STAT_TX_DROPS] +
+			    s[OCELOT_STAT_TX_AGED];
+	stats->collisions = s[OCELOT_STAT_TX_COLLISION];
 
 	spin_unlock(&ocelot->stats_lock);
 }
-- 
2.35.1



