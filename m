Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F175830AE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbiG0Rkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242936AbiG0Rjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B4D88CC3;
        Wed, 27 Jul 2022 09:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9258616ED;
        Wed, 27 Jul 2022 16:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0172AC433D6;
        Wed, 27 Jul 2022 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940665;
        bh=BFJdDl0BVAGoHtb4izvkJFUW5xUjgpjEeVVSQdffYQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX4yihu5iT90RDwCPIgPp5TVLt+tx8yOWaITc85Nt0SlkwcQ7gkaQ+bWBITFZb0EN
         sb4tVYC4C/zOLH6FSBx2niPq7kgaV71T2vCbTSfk/4WsIgDEeRE8tzyAyiOCBMadvW
         80+Nr6frLUvOnpvcrylNKPwvNr7ksWF32MFMKk5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 097/158] gpio: pca953x: use the correct register address when regcache sync during init
Date:   Wed, 27 Jul 2022 18:12:41 +0200
Message-Id: <20220727161025.335410255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

[ Upstream commit b8c768ccdd8338504fb78370747728d5002b1b5a ]

For regcache_sync_region, we need to use pca953x_recalc_addr() to get
the real register address.

Fixes: ec82d1eba346 ("gpio: pca953x: Zap ad-hoc reg_output cache")
Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 60b7616dd4aa..64befd6f702b 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -897,15 +897,18 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
 {
 	DECLARE_BITMAP(val, MAX_LINE);
+	u8 regaddr;
 	int ret;
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->output,
-				   chip->regs->output + NBANK(chip) - 1);
+	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr,
+				   regaddr + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->direction,
-				   chip->regs->direction + NBANK(chip) - 1);
+	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr,
+				   regaddr + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
-- 
2.35.1



