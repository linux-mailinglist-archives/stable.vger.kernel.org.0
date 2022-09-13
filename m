Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854245B7243
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiIMOuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiIMOsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2D717AAA;
        Tue, 13 Sep 2022 07:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4001614D4;
        Tue, 13 Sep 2022 14:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02C1C433C1;
        Tue, 13 Sep 2022 14:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079101;
        bh=9QA8oLkj1XmUYdLVqkdgiweOcE/VgWb06ZXPT0B5lk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4uJc9ZFAzum2JCDyQxdEdIm1moxiBtNeAYy5kLN1Cm5JL4nt2P65ftF4iIcwAN4J
         PwthUDNGyeFIOUWJKwHsT1823IITyhvBVb/HJAwOjDk8x7okGEm895W2McutdLWS2E
         d5zL/6SrPK+KFdTqmHBSGVuKloT9BtqAORq89MXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH 5.10 59/79] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Date:   Tue, 13 Sep 2022 16:05:04 +0200
Message-Id: <20220913140353.063220321@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
index 6ea98af63b341..e7b23d4a22d0a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -523,7 +523,6 @@ struct fec_enet_private {
 	struct clk *clk_ptp;
 
 	bool ptp_clk_on;
-	struct mutex ptp_clk_mutex;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d8bdaf2e5365c..674591751a676 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1937,6 +1937,7 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	unsigned long flags;
 	int ret;
 
 	if (enable) {
@@ -1945,15 +1946,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
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
@@ -1964,10 +1965,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
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
 	}
@@ -1976,10 +1977,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 
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
@@ -3665,7 +3666,7 @@ fec_probe(struct platform_device *pdev)
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



