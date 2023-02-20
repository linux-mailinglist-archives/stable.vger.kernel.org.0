Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1702869CCC0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBTNnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjBTNnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF791C7F0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE8560E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35A9C433D2;
        Mon, 20 Feb 2023 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900595;
        bh=55pvcCvWvUieAFlIV5D+mq7qbwla3bDfxNmApJKYhSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09KnocWyNt3v1HWNwBX4sXQAJV2ywdDCJYnu3Tv+R9q1O4zRkEynRin78WQEGo5EI
         MzYmiKjaZ5w3VW2FuJuZvYWuDvRvjJ9Iem9Y0MCeozidC3944JbWjLY9h3+hgYB1sp
         q/dzZJBSdIr4YZT6ZlePHJRQFMgJ+NI0gWruKN+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Minter <jimminter@microsoft.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/89] pinctrl: intel: Restore the pins that used to be in Direct IRQ mode
Date:   Mon, 20 Feb 2023 14:35:54 +0100
Message-Id: <20230220133555.074474472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a8520be3ffef3d25b53bf171a7ebe17ee0154175 ]

If the firmware mangled the register contents too much,
check the saved value for the Direct IRQ mode. If it
matches, we will restore the pin state.

Reported-by: Jim Minter <jimminter@microsoft.com>
Fixes: 6989ea4881c8 ("pinctrl: intel: Save and restore pins in "direct IRQ" mode")
Tested-by: Jim Minter <jimminter@microsoft.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20230206141558.20916-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 198121bd89bbf..b786d9797f404 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1432,6 +1432,12 @@ int intel_pinctrl_probe(struct platform_device *pdev,
 EXPORT_SYMBOL_GPL(intel_pinctrl_probe);
 
 #ifdef CONFIG_PM_SLEEP
+static bool __intel_gpio_is_direct_irq(u32 value)
+{
+	return (value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	       (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO);
+}
+
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
@@ -1465,8 +1471,7 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
 	 */
 	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
-	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
-	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+	if (__intel_gpio_is_direct_irq(value))
 		return true;
 
 	return false;
@@ -1551,7 +1556,12 @@ int intel_pinctrl_resume(struct device *dev)
 		void __iomem *padcfg;
 		u32 val;
 
-		if (!intel_pinctrl_should_save(pctrl, desc->number))
+		if (!(intel_pinctrl_should_save(pctrl, desc->number) ||
+		      /*
+		       * If the firmware mangled the register contents too much,
+		       * check the saved value for the Direct IRQ mode.
+		       */
+		      __intel_gpio_is_direct_irq(pads[i].padcfg0)))
 			continue;
 
 		padcfg = intel_get_padcfg(pctrl, desc->number, PADCFG0);
-- 
2.39.0



