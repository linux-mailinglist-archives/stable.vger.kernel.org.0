Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315EF694A44
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjBMPF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjBMPFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C985A4ED6
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCDE2CE181A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A68C433EF;
        Mon, 13 Feb 2023 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300736;
        bh=LZwQWR/4sFlVCZklViry1Gt46Guk5CkphDHZRb6Ba9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPzA4BShqWXGvNnoR6etGj3GN+Wy53zI+PSk3ZgkzNNhjMCzwwCoqY0toPTdZkzTN
         kpg44l0rC+cb1c1Gv4loHIaXVXQP2olMIkHsvivcjH404KnCgViPxehFrquTniKKmX
         8bMZk1EiFtddzIx8XuhdJlNhS4y6Gloo1xMF/kDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Minter <jimminter@microsoft.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/139] pinctrl: intel: Restore the pins that used to be in Direct IRQ mode
Date:   Mon, 13 Feb 2023 15:51:12 +0100
Message-Id: <20230213144752.649589674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index db9087c129c0d..2ef9e2d8fd9c5 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1606,6 +1606,12 @@ const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_
 EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_data);
 
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
@@ -1639,8 +1645,7 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
 	 */
 	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
-	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
-	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+	if (__intel_gpio_is_direct_irq(value))
 		return true;
 
 	return false;
@@ -1770,7 +1775,12 @@ int intel_pinctrl_resume_noirq(struct device *dev)
 	for (i = 0; i < pctrl->soc->npins; i++) {
 		const struct pinctrl_pin_desc *desc = &pctrl->soc->pins[i];
 
-		if (!intel_pinctrl_should_save(pctrl, desc->number))
+		if (!(intel_pinctrl_should_save(pctrl, desc->number) ||
+		      /*
+		       * If the firmware mangled the register contents too much,
+		       * check the saved value for the Direct IRQ mode.
+		       */
+		      __intel_gpio_is_direct_irq(pads[i].padcfg0)))
 			continue;
 
 		intel_restore_padcfg(pctrl, desc->number, PADCFG0, pads[i].padcfg0);
-- 
2.39.0



