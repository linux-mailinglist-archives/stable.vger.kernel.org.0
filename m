Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2E55F2988
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiJCHVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiJCHUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736A74360F;
        Mon,  3 Oct 2022 00:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA1E960F99;
        Mon,  3 Oct 2022 07:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B92C433D6;
        Mon,  3 Oct 2022 07:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781297;
        bh=aQkC18YX8ieVc7dyMexU5cFq2VZtUWkJcX6Z3IBJ8GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8RjS6YqZb3lBzpwe1C3bG140zS04eTzFI+lneWb3AEz7211t88bewTmdIY+oxYr+
         kXA/p1Lkn9K4kGCch4LmIt1eoQzubKa5v/VozBHuGr2BdbBHAA1ERo2cFXeJ6oduIW
         27YBXCXGIBFRlKAAvIhsJjdUxEh37SKoQSoQMd0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 069/101] gpio: mvebu: Fix check for pwm support on non-A8K platforms
Date:   Mon,  3 Oct 2022 09:11:05 +0200
Message-Id: <20221003070726.187680370@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 4335417da2b8d6d9b2d4411b5f9e248e5bb2d380 ]

pwm support incompatible with Armada 80x0/70x0 API is not only in
Armada 370, but also in Armada XP, 38x and 39x. So basically every non-A8K
platform. Fix check for pwm support appropriately.

Fixes: 85b7d8abfec7 ("gpio: mvebu: add pwm support for Armada 8K/7K")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 2db19cd640a4..de1e7a1a76f2 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -793,8 +793,12 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 	u32 offset;
 	u32 set;
 
-	if (of_device_is_compatible(mvchip->chip.of_node,
-				    "marvell,armada-370-gpio")) {
+	if (mvchip->soc_variant == MVEBU_GPIO_SOC_VARIANT_A8K) {
+		int ret = of_property_read_u32(dev->of_node,
+					       "marvell,pwm-offset", &offset);
+		if (ret < 0)
+			return 0;
+	} else {
 		/*
 		 * There are only two sets of PWM configuration registers for
 		 * all the GPIO lines on those SoCs which this driver reserves
@@ -804,13 +808,6 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 		if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "pwm"))
 			return 0;
 		offset = 0;
-	} else if (mvchip->soc_variant == MVEBU_GPIO_SOC_VARIANT_A8K) {
-		int ret = of_property_read_u32(dev->of_node,
-					       "marvell,pwm-offset", &offset);
-		if (ret < 0)
-			return 0;
-	} else {
-		return 0;
 	}
 
 	if (IS_ERR(mvchip->clk))
-- 
2.35.1



