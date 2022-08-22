Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4124E59C03C
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiHVNKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiHVNKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318602A958
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA988B811E3
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497BFC433D7;
        Mon, 22 Aug 2022 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173824;
        bh=sA7jqH6IFNaXCoJct8xalgHyGzmTxDlR4wrpqVaLq/8=;
        h=Subject:To:Cc:From:Date:From;
        b=oaCvpCLwzlboLBjFSOq8r0Ayi4ntOs5q8+YI7g3S5E5mGNLndHO0VEsPPoUaLj9sz
         LDTOY1ywWW0as2fR/Ec/TV1+sxsopVx5iY9Ea2+t6ZJb4CKM7rSaKx1vTqhSusHyFq
         N7sNBtIGoRWogvc8cktMmFl8vKzcAvdlqBO9/DpM=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: fix race between ndo_get_stats64 and" failed to apply to 5.15-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 15:10:22 +0200
Message-ID: <166117382215570@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 18d8e67df184081bc6ce6220a2dd965cfd3d7e6b Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 16 Aug 2022 16:53:49 +0300
Subject: [PATCH] net: mscc: ocelot: fix race between ndo_get_stats64 and
 ocelot_check_stats_work

The 2 methods can run concurrently, and one will change the window of
counters (SYS_STAT_CFG_STAT_VIEW) that the other sees. The fix is
similar to what commit 7fbf6795d127 ("net: mscc: ocelot: fix mutex lock
error during ethtool stats read") has done for ethtool -S.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9d8cea16245e..6b9d37138844 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -726,6 +726,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
+	spin_lock(&ocelot->stats_lock);
+
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
 		     SYS_STAT_CFG);
@@ -758,6 +760,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+
+	spin_unlock(&ocelot->stats_lock);
 }
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],

