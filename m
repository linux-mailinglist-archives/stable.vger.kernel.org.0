Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9242159BFF5
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHVM5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiHVM5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FA7220F7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3724B811D2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0107C433D6;
        Mon, 22 Aug 2022 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173065;
        bh=fuFLNmqKo+iHdG58lSSlnp85QVL2Ol8Ykjl/t9vEKus=;
        h=Subject:To:Cc:From:Date:From;
        b=frH2BPBPj/fizEmGcV96WxCKPOb6cyGL/4hS9eOgOfONGGPSmE0vpEnBY/gdnpUbC
         UHF5OFnAPpr2vlZR0w1Q68XMhUYQFFX11DceuhA98llb5PtibU+x0Tg9cBCHPK8OSw
         GBc7r12WSPS1pp1DlIe8CNP7+ML1nDt7nmGdCIHA=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: report ndo_get_stats64 from the" failed to apply to 5.4-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:57:32 +0200
Message-ID: <16611730523969@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e780e3193e889fd8358b862f7cd18ec5a4901caf Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 16 Aug 2022 16:53:52 +0300
Subject: [PATCH] net: mscc: ocelot: report ndo_get_stats64 from the
 wraparound-resistant ocelot->stats

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

