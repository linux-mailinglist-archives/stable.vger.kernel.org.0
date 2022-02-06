Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347C34AAF42
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiBFMvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:51:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3403C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49FA460F08
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9FCC340E9;
        Sun,  6 Feb 2022 12:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151863;
        bh=UQxrClW2EcpI0IHmuX5XeDcK6AchCFZc3NiCy9asi+w=;
        h=Subject:To:Cc:From:Date:From;
        b=jdDb4Q3PXD370QdCc8mZpHQduXr6aUJJ/iR17YhSTWhijXQephiMwW4SNx72FDn1M
         qCziN+d2WMof5WNjZ3fWO09iVxKfWCwX/ShatLJNneCaiW0Dq80fEJDVjAffbnflqA
         3W3JNfvxfW6qzzBkVD1Ql2IkczBeUXqWa7EFTHas=
Subject: FAILED: patch "[PATCH] pinctrl: intel: fix unexpected interrupt" failed to apply to 5.4-stable tree
To:     lb@semihalf.com, andriy.shevchenko@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:51:00 +0100
Message-ID: <164415186022654@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e986f0e602f19ecb7880b04dd1db415ed9bca3f6 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>
Date: Mon, 24 Jan 2022 13:55:29 +0100
Subject: [PATCH] pinctrl: intel: fix unexpected interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ASUS Chromebook C223 with Celeron N3350 crashes sometimes during
cold booot. Inspection of the kernel log showed that it gets into
an inifite loop logging the following message:

->handle_irq():  000000009cdb51e8, handle_bad_irq+0x0/0x251
->irq_data.chip(): 000000005ec212a7, 0xffffa043009d8e7
->action(): 00000
   IRQ_NOPROBE set
unexpected IRQ trap at vector 7c

The issue happens during cold boot but only if cold boot happens
at most several dozen seconds after Chromebook is powered off. For
longer intervals between power off and power on (cold boot) the issue
does not reproduce. The unexpected interrupt is sourced from INT3452
GPIO pin which is used for SD card detect. Investigation relevealed
that when the interval between power off and power on (cold boot)
is less than several dozen seconds then values of INT3452 GPIO interrupt
enable and interrupt pending registers survive power off and power
on sequence and interrupt for SD card detect pin is enabled and pending
during probe of SD controller which causes the unexpected IRQ message.
"Intel Pentium and Celeron Processor N- and J- Series" volume 3 doc
mentions that GPIO interrupt enable and status registers default
value is 0x0.
The fix clears INT3452 GPIO interrupt enabled and interrupt pending
registers in its probe function.

Fixes: 7981c0015af2 ("pinctrl: intel: Add Intel Sunrisepoint pin controller and GPIO support")
Signed-off-by: Łukasz Bartosik <lb@semihalf.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 85750974d182..e9bb98cb9112 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1216,6 +1216,39 @@ static irqreturn_t intel_gpio_irq(int irq, void *data)
 	return IRQ_RETVAL(ret);
 }
 
+static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
+{
+	int i;
+
+	for (i = 0; i < pctrl->ncommunities; i++) {
+		const struct intel_community *community;
+		void __iomem *base;
+		unsigned int gpp;
+
+		community = &pctrl->communities[i];
+		base = community->regs;
+
+		for (gpp = 0; gpp < community->ngpps; gpp++) {
+			/* Mask and clear all interrupts */
+			writel(0, base + community->ie_offset + gpp * 4);
+			writel(0xffff, base + community->is_offset + gpp * 4);
+		}
+	}
+}
+
+static int intel_gpio_irq_init_hw(struct gpio_chip *gc)
+{
+	struct intel_pinctrl *pctrl = gpiochip_get_data(gc);
+
+	/*
+	 * Make sure the interrupt lines are in a proper state before
+	 * further configuration.
+	 */
+	intel_gpio_irq_init(pctrl);
+
+	return 0;
+}
+
 static int intel_gpio_add_community_ranges(struct intel_pinctrl *pctrl,
 				const struct intel_community *community)
 {
@@ -1320,6 +1353,7 @@ static int intel_gpio_probe(struct intel_pinctrl *pctrl, int irq)
 	girq->num_parents = 0;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_bad_irq;
+	girq->init_hw = intel_gpio_irq_init_hw;
 
 	ret = devm_gpiochip_add_data(pctrl->dev, &pctrl->chip, pctrl);
 	if (ret) {
@@ -1695,26 +1729,6 @@ int intel_pinctrl_suspend_noirq(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(intel_pinctrl_suspend_noirq);
 
-static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
-{
-	size_t i;
-
-	for (i = 0; i < pctrl->ncommunities; i++) {
-		const struct intel_community *community;
-		void __iomem *base;
-		unsigned int gpp;
-
-		community = &pctrl->communities[i];
-		base = community->regs;
-
-		for (gpp = 0; gpp < community->ngpps; gpp++) {
-			/* Mask and clear all interrupts */
-			writel(0, base + community->ie_offset + gpp * 4);
-			writel(0xffff, base + community->is_offset + gpp * 4);
-		}
-	}
-}
-
 static bool intel_gpio_update_reg(void __iomem *reg, u32 mask, u32 value)
 {
 	u32 curr, updated;

