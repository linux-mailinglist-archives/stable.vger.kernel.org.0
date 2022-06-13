Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB81C548680
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378249AbiFMNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379225AbiFMNkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA433D114;
        Mon, 13 Jun 2022 04:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69942B80D3A;
        Mon, 13 Jun 2022 11:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4298C34114;
        Mon, 13 Jun 2022 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119843;
        bh=MNaiuG4N1VwUKOrgpMZ+BnxOCSCj0LiesIi3WOBys/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8GAzGJtQEOzgOv9ZtLQM0Y/wpGgDKXoXkTozSITazjF7V37NCwGdfJEZ9YTO+sUp
         6dyPZ+V12GocKXigHXw6drzyM/XM24BNoDTMqzZ0oRWc7ZX5nObGt14HnIiL3qWZ40
         P1IOUopb6EjUK3iNFX4yl36soQNT0KBhsNBNWc/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 139/339] gpio: pca953x: use the correct register address to do regcache sync
Date:   Mon, 13 Jun 2022 12:09:24 +0200
Message-Id: <20220613094930.899043513@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 43624eda86c98b0de726d0b6f2516ccc3ef7313f ]

For regcache_sync_region, need to use pca953x_recalc_addr() to get
the real register address.

Fixes: b76574300504 ("gpio: pca953x: Restore registers after suspend/resume cycle")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 8726921a1129..33683295a0bf 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1108,20 +1108,21 @@ static int pca953x_regcache_sync(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 	int ret;
+	u8 regaddr;
 
 	/*
 	 * The ordering between direction and output is important,
 	 * sync these registers first and only then sync the rest.
 	 */
-	ret = regcache_sync_region(chip->regmap, chip->regs->direction,
-				   chip->regs->direction + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO dir registers: %d\n", ret);
 		return ret;
 	}
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->output,
-				   chip->regs->output + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO out registers: %d\n", ret);
 		return ret;
@@ -1129,16 +1130,18 @@ static int pca953x_regcache_sync(struct device *dev)
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	if (chip->driver_data & PCA_PCAL) {
-		ret = regcache_sync_region(chip->regmap, PCAL953X_IN_LATCH,
-					   PCAL953X_IN_LATCH + NBANK(chip));
+		regaddr = pca953x_recalc_addr(chip, PCAL953X_IN_LATCH, 0);
+		ret = regcache_sync_region(chip->regmap, regaddr,
+					   regaddr + NBANK(chip));
 		if (ret) {
 			dev_err(dev, "Failed to sync INT latch registers: %d\n",
 				ret);
 			return ret;
 		}
 
-		ret = regcache_sync_region(chip->regmap, PCAL953X_INT_MASK,
-					   PCAL953X_INT_MASK + NBANK(chip));
+		regaddr = pca953x_recalc_addr(chip, PCAL953X_INT_MASK, 0);
+		ret = regcache_sync_region(chip->regmap, regaddr,
+					   regaddr + NBANK(chip));
 		if (ret) {
 			dev_err(dev, "Failed to sync INT mask registers: %d\n",
 				ret);
-- 
2.35.1



