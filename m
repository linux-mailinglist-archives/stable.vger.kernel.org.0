Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D55B7136
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiIMOjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiIMOhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:37:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC866B8E2;
        Tue, 13 Sep 2022 07:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CADA614A8;
        Tue, 13 Sep 2022 14:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E429C433D6;
        Tue, 13 Sep 2022 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078794;
        bh=Q83UYvvGgPJ5Yy7LZn6xwgV627m5YsW0M8zEvrvHtNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxgj6+RCAkZGKyG56gB9DYnGiYRk1vO2rAUBRccOkYNhpiQWFl1uj4xYM8y3nqaII
         O/wcxteXm696qUEUm8M8RKU/tMzDQy32CGrke06cZbxGWvNvr0gGAVH5Gps0keg80x
         Uiqr++0PTmJLGtRAPYbA73plFYPblluDMHElbz8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH 5.15 084/121] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Date:   Tue, 13 Sep 2022 16:04:35 +0200
Message-Id: <20220913140400.979880696@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Csókás Bence <csokas.bence@prolan.hu>

[ Upstream commit b353b241f1eb9b6265358ffbe2632fdcb563354f ]

Mutexes cannot be taken in a non-preemptible context,
causing a panic in `fec_ptp_save_state()`. Replacing
`ptp_clk_mutex` by `tmreg_lock` fixes this.

Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Apalis iMX6
Link: https://lore.kernel.org/r/20220901140402.64804-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      |  1 -
 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++-------
 drivers/net/ethernet/freescale/fec_ptp.c  | 28 ++++++++---------------
 3 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index ed7301b691694..939720a75f87c 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -557,7 +557,6 @@ struct fec_enet_private {
 	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
-	struct mutex ptp_clk_mutex;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 67eb9b671244b..7561524e7c361 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1984,6 +1984,7 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	unsigned long flags;
 	int ret;
 
 	if (enable) {
@@ -1992,15 +1993,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			return ret;
 
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->tmreg_lock, flags);
 			ret = clk_prepare_enable(fep->clk_ptp);
 			if (ret) {
-				mutex_unlock(&fep->ptp_clk_mutex);
+				spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 				goto failed_clk_ptp;
 			} else {
 				fep->ptp_clk_on = true;
 			}
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		}
 
 		ret = clk_prepare_enable(fep->clk_ref);
@@ -2015,10 +2016,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->tmreg_lock, flags);
 			clk_disable_unprepare(fep->clk_ptp);
 			fep->ptp_clk_on = false;
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		}
 		clk_disable_unprepare(fep->clk_ref);
 		clk_disable_unprepare(fep->clk_2x_txclk);
@@ -2031,10 +2032,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
-		mutex_lock(&fep->ptp_clk_mutex);
+		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		clk_disable_unprepare(fep->clk_ptp);
 		fep->ptp_clk_on = false;
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
 failed_clk_ptp:
 	clk_disable_unprepare(fep->clk_enet_out);
@@ -3866,7 +3867,7 @@ fec_probe(struct platform_device *pdev)
 		fep->clk_enet_out = NULL;
 
 	fep->ptp_clk_on = false;
-	mutex_init(&fep->ptp_clk_mutex);
+	spin_lock_init(&fep->tmreg_lock);
 
 	/* clk_ref is optional, depends on board */
 	fep->clk_ref = devm_clk_get(&pdev->dev, "enet_clk_ref");
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index c5ae673005908..99bd67d3befd0 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -366,21 +366,19 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct fec_enet_private *adapter =
+	struct fec_enet_private *fep =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 	u64 ns;
 	unsigned long flags;
 
-	mutex_lock(&adapter->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	/* Check the ptp clock */
-	if (!adapter->ptp_clk_on) {
-		mutex_unlock(&adapter->ptp_clk_mutex);
+	if (!fep->ptp_clk_on) {
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return -EINVAL;
 	}
-	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	ns = timecounter_read(&adapter->tc);
-	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-	mutex_unlock(&adapter->ptp_clk_mutex);
+	ns = timecounter_read(&fep->tc);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -405,10 +403,10 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	u32 counter;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return -EINVAL;
 	}
 
@@ -418,11 +416,9 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	 */
 	counter = ns & fep->cc.mask;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(counter, fep->hwp + FEC_ATIME);
 	timecounter_init(&fep->tc, &fep->cc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-	mutex_unlock(&fep->ptp_clk_mutex);
 	return 0;
 }
 
@@ -523,13 +519,11 @@ static void fec_time_keep(struct work_struct *work)
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
 	unsigned long flags;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	if (fep->ptp_clk_on) {
-		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		timecounter_read(&fep->tc);
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
-	mutex_unlock(&fep->ptp_clk_mutex);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
@@ -604,8 +598,6 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
-	spin_lock_init(&fep->tmreg_lock);
-
 	fec_ptp_start_cyclecounter(ndev);
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
-- 
2.35.1



