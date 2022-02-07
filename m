Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DE94ABB69
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiBGLaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383673AbiBGLXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:23:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16639C0401D4;
        Mon,  7 Feb 2022 03:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F191B811B2;
        Mon,  7 Feb 2022 11:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E90C004E1;
        Mon,  7 Feb 2022 11:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232996;
        bh=P/8x4z9awNIPRoU7bcgMNv3+1kOQLXdXrq64xhcsXlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9/9ywJ1kds7R86qarGs2WHyi+E7C1fW2kIYSDf2q1hS1SS0yGASLPSydJ2DZHil5
         Ex36Do/UzxOQh3ezoh0Mbop+gctFenYXiSUjHlPcMNho17+G9RreNNJyQL+C32Uu8B
         BGXgFffHvH7R0KVrhsD76o/84iBJKocei/LqpuJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 50/74] pinctrl: intel: fix unexpected interrupt
Date:   Mon,  7 Feb 2022 12:06:48 +0100
Message-Id: <20220207103758.859492624@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Łukasz Bartosik <lb@semihalf.com>

commit e986f0e602f19ecb7880b04dd1db415ed9bca3f6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |   54 +++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 20 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1201,6 +1201,39 @@ static irqreturn_t intel_gpio_irq(int ir
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
@@ -1305,6 +1338,7 @@ static int intel_gpio_probe(struct intel
 	girq->num_parents = 0;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_bad_irq;
+	girq->init_hw = intel_gpio_irq_init_hw;
 
 	ret = devm_gpiochip_add_data(pctrl->dev, &pctrl->chip, pctrl);
 	if (ret) {
@@ -1634,26 +1668,6 @@ int intel_pinctrl_suspend_noirq(struct d
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


