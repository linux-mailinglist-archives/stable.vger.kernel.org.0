Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE4D582ED9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbiG0RSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiG0RRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D2D78DED;
        Wed, 27 Jul 2022 09:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D7D7B821C6;
        Wed, 27 Jul 2022 16:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B570C433D6;
        Wed, 27 Jul 2022 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940202;
        bh=OUAQxsIyHhoQKpoTT2pFpB3kZknsg4snkdYeH8FRRwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/QMINbtrPXhR3jCwIODQer0XYcI1xrUdOT5EWwBmj1FImmNjfuyJ2OR5lVel2QhW
         hBrgtQG0DTG/Vk7Oizz41aHl4qXeEnsw9XO/8mROePgK5RLnt5orMN4gKp1EuDg6KH
         l+gk0Hrnck1mQzy0gxYHfxPSEQihbMpzrrzW8AMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/201] gpio: pca953x: use the correct range when do regmap sync
Date:   Wed, 27 Jul 2022 18:10:14 +0200
Message-Id: <20220727161032.319284427@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 2abc17a93867dc816f0ed9d32021dda8078e7330 ]

regmap will sync a range of registers, here use the correct range
to make sure the sync do not touch other unexpected registers.

Find on pca9557pw on imx8qxp/dxl evk board, this device support
8 pin, so only need one register(8 bits) to cover all the 8 pins's
property setting. But when sync the output, we find it actually
update two registers, output register and the following register.

Fixes: b76574300504 ("gpio: pca953x: Restore registers after suspend/resume cycle")
Fixes: ec82d1eba346 ("gpio: pca953x: Zap ad-hoc reg_output cache")
Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index f334c8556a22..60b7616dd4aa 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -900,12 +900,12 @@ static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
 	int ret;
 
 	ret = regcache_sync_region(chip->regmap, chip->regs->output,
-				   chip->regs->output + NBANK(chip));
+				   chip->regs->output + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
 	ret = regcache_sync_region(chip->regmap, chip->regs->direction,
-				   chip->regs->direction + NBANK(chip));
+				   chip->regs->direction + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
@@ -1118,14 +1118,14 @@ static int pca953x_regcache_sync(struct device *dev)
 	 * sync these registers first and only then sync the rest.
 	 */
 	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
-	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip) - 1);
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO dir registers: %d\n", ret);
 		return ret;
 	}
 
 	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
-	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip) - 1);
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO out registers: %d\n", ret);
 		return ret;
@@ -1135,7 +1135,7 @@ static int pca953x_regcache_sync(struct device *dev)
 	if (chip->driver_data & PCA_PCAL) {
 		regaddr = pca953x_recalc_addr(chip, PCAL953X_IN_LATCH, 0);
 		ret = regcache_sync_region(chip->regmap, regaddr,
-					   regaddr + NBANK(chip));
+					   regaddr + NBANK(chip) - 1);
 		if (ret) {
 			dev_err(dev, "Failed to sync INT latch registers: %d\n",
 				ret);
@@ -1144,7 +1144,7 @@ static int pca953x_regcache_sync(struct device *dev)
 
 		regaddr = pca953x_recalc_addr(chip, PCAL953X_INT_MASK, 0);
 		ret = regcache_sync_region(chip->regmap, regaddr,
-					   regaddr + NBANK(chip));
+					   regaddr + NBANK(chip) - 1);
 		if (ret) {
 			dev_err(dev, "Failed to sync INT mask registers: %d\n",
 				ret);
-- 
2.35.1



