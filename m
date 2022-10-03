Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF05F2A30
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiJCHcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiJCHbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AA54D27B;
        Mon,  3 Oct 2022 00:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 039BD60F97;
        Mon,  3 Oct 2022 07:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15B8C433D6;
        Mon,  3 Oct 2022 07:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781537;
        bh=cGxYMM7fPRmJc/t1JctwKv/zF2KZVsMYsKES/QT78ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXGoEfDX5uMfFEcMxgNpD83uwAJ2EXyRoBM4FO+rlPQn5tDpWdLjGyXFf2ViYVVgN
         AgGk7Q8iT/vjwLsv4waLLNjI08vKYBJSuMDTmbemzY7DNcx24qnJGuKFDIueXeHhmH
         F48tg5McVQVKt0TqHMWlVmIBis+tfm/5NvEKot+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/83] gpio: mvebu: Fix check for pwm support on non-A8K platforms
Date:   Mon,  3 Oct 2022 09:11:20 +0200
Message-Id: <20221003070723.384232731@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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
index 1448dc874dfc..a245bfd5a617 100644
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



