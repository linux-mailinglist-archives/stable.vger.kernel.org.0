Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C299549565
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353881AbiFMMgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357563AbiFMMe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38E61C106;
        Mon, 13 Jun 2022 04:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97452B80D31;
        Mon, 13 Jun 2022 11:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69FEC34114;
        Mon, 13 Jun 2022 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118469;
        bh=RtEXNlkzwJJXelVxr5GQUBzq7Qc5cnQyf3vlI1HEOQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcwttFP6YIda3cSxy7iKREQ3Jd9TyWPdyifbHwoYtfCo9Izm787NsJ2gdy8Xlf76W
         f0QIj37u+AKOmoT5BDuz8CAZPxwjbn6ofby0iBy4iNtD9sjpzNXh0IrGSZoGiu0tAR
         Iu13jIZvJ53RvtnozwOpJkZ0/ypEJDUL2SEB1PqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/172] gpio: pca953x: use the correct register address to do regcache sync
Date:   Mon, 13 Jun 2022 12:10:29 +0200
Message-Id: <20220613094907.013759674@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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
index e936e1eb1f95..bb4ca064447e 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1107,20 +1107,21 @@ static int pca953x_regcache_sync(struct device *dev)
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
@@ -1128,16 +1129,18 @@ static int pca953x_regcache_sync(struct device *dev)
 
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



