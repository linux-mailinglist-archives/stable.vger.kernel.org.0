Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718CA59D691
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348724AbiHWJMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348324AbiHWJJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:09:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011C7868B9;
        Tue, 23 Aug 2022 01:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 461A7B81C4B;
        Tue, 23 Aug 2022 08:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A092DC433C1;
        Tue, 23 Aug 2022 08:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243357;
        bh=8xUMIArOW/4IiPvkqpo2CnRg7A2HIRsEk0ozSnmCl/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLXQ0mEeMU74Hu3hc91UYYkXuy5Ybia++e4Pp+ZldXB8W7ndcdODSjb1QZSVjJ4y8
         wxM9H1HO8Lu1fS/BQWZ03emAzoDypdFagxnCbEnsCJwKbbLEfa6+Apn2l3PbKPJ/GE
         hS13+YL+nMqv6P2J/I7NTyBHj48f7p54+Wpzk1aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 251/365] net: mscc: ocelot: turn stats_lock into a spinlock
Date:   Tue, 23 Aug 2022 10:02:32 +0200
Message-Id: <20220823080128.688845638@linuxfoundation.org>
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

[ Upstream commit 22d842e3efe56402c33b5e6e303bb71ce9bf9334 ]

ocelot_get_stats64() currently runs unlocked and therefore may collide
with ocelot_port_update_stats() which indirectly accesses the same
counters. However, ocelot_get_stats64() runs in atomic context, and we
cannot simply take the sleepable ocelot->stats_lock mutex. We need to
convert it to an atomic spinlock first. Do that as a preparatory change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |  4 ++--
 drivers/net/ethernet/mscc/ocelot.c     | 11 +++++------
 include/soc/mscc/ocelot.h              |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 61b1bf4399c4..601fae886b26 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2177,7 +2177,7 @@ static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 
 	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
 		   SYS_STAT_CFG_STAT_VIEW_M,
@@ -2194,7 +2194,7 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
 		     SYS_STAT_CFG);
 
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 }
 
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4649e4ee0e7..c67f162f8ab5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1906,13 +1906,13 @@ static void ocelot_check_stats_work(struct work_struct *work)
 					     stats_work);
 	int i, err;
 
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		err = ocelot_port_update_stats(ocelot, i);
 		if (err)
 			break;
 	}
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
@@ -1925,7 +1925,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i, err;
 
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 
 	/* check and update now */
 	err = ocelot_port_update_stats(ocelot, port);
@@ -1934,7 +1934,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
@@ -3363,7 +3363,7 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats)
 		return -ENOMEM;
 
-	mutex_init(&ocelot->stats_lock);
+	spin_lock_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	mutex_init(&ocelot->mact_lock);
 	mutex_init(&ocelot->fwd_domain_lock);
@@ -3511,7 +3511,6 @@ void ocelot_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	destroy_workqueue(ocelot->owq);
-	mutex_destroy(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_deinit);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e7e5b06deb2d..72b9474391da 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -752,7 +752,7 @@ struct ocelot {
 	struct ocelot_psfp_list		psfp;
 
 	/* Workqueue to check statistics for overflow with its lock */
-	struct mutex			stats_lock;
+	spinlock_t			stats_lock;
 	u64				*stats;
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
-- 
2.35.1



