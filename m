Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A14657A9A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiL1PNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiL1PNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:13:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE8A13EA6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2F54B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDFC433D2;
        Wed, 28 Dec 2022 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240364;
        bh=4j8H0VEGe8dFvw+jGsodxBJGbFvHSYzj64b0IBIVgHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kx9j8IPY8UQZVlVyqUwF8bAYt9CyzZjNe2PPs73VKr/7vHyDGM48MmIDzq0CGSUOs
         8wkiy+YkHCDD9MdgYbkskSXKpGcsyTCikwnNsw2I+07LlfLbKDZ0aj83+r3z0skMYY
         +jBkDDMhZlNJ4sAABenGBlSQDnyhpdsoLSUganmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vivek Yadav <vivek.2311@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/731] can: m_can: Call the RAM init directly from m_can_chip_config
Date:   Wed, 28 Dec 2022 15:37:28 +0100
Message-Id: <20221228144306.451373259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Yadav <vivek.2311@samsung.com>

[ Upstream commit eaacfeaca7ad0804b9a6eff7afeba93a87db7638 ]

When we try to access the mcan message ram addresses during the probe,
hclk is gated by any other drivers or disabled, because of that probe
gets failed.

Move the mram init functionality to mcan chip config called by
m_can_start from mcan open function, by that time clocks are
enabled.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
Link: https://lore.kernel.org/all/20221207100632.96200-2-vivek.2311@samsung.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 67727a17a6b3 ("can: tcan4x5x: Fix use of register error status mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c          | 32 +++++++++++++++++++++-----
 drivers/net/can/m_can/m_can_platform.c |  4 ----
 drivers/net/can/m_can/tcan4x5x-core.c  |  5 ----
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 46ab6155795c..e027229c1955 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1248,10 +1248,17 @@ static int m_can_set_bittiming(struct net_device *dev)
  * - setup bittiming
  * - configure timestamp generation
  */
-static void m_can_chip_config(struct net_device *dev)
+static int m_can_chip_config(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 cccr, test;
+	int err;
+
+	err = m_can_init_ram(cdev);
+	if (err) {
+		dev_err(cdev->dev, "Message RAM configuration failed\n");
+		return err;
+	}
 
 	m_can_config_endisable(cdev, true);
 
@@ -1375,18 +1382,25 @@ static void m_can_chip_config(struct net_device *dev)
 
 	if (cdev->ops->init)
 		cdev->ops->init(cdev);
+
+	return 0;
 }
 
-static void m_can_start(struct net_device *dev)
+static int m_can_start(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int ret;
 
 	/* basic m_can configuration */
-	m_can_chip_config(dev);
+	ret = m_can_chip_config(dev);
+	if (ret)
+		return ret;
 
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
+
+	return 0;
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1824,7 +1838,9 @@ static int m_can_open(struct net_device *dev)
 	}
 
 	/* start the m_can controller */
-	m_can_start(dev);
+	err = m_can_start(dev);
+	if (err)
+		goto exit_irq_fail;
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
@@ -2082,9 +2098,13 @@ int m_can_class_resume(struct device *dev)
 		ret = m_can_clk_start(cdev);
 		if (ret)
 			return ret;
+		ret  = m_can_start(ndev);
+		if (ret) {
+			m_can_clk_stop(cdev);
+
+			return ret;
+		}
 
-		m_can_init_ram(cdev);
-		m_can_start(ndev);
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
 	}
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index eee47bad0592..de6d8e01bf2e 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -140,10 +140,6 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
-	if (ret)
-		goto probe_fail;
-
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 9b735eccec8a..a0eee69e52ea 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -229,11 +229,6 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	/* Zero out the MCAN buffers */
-	ret = m_can_init_ram(cdev);
-	if (ret)
-		return ret;
-
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
 	if (ret)
-- 
2.35.1



