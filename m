Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B7E69CCBF
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjBTNnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjBTNnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ADE1B33A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3729E60E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBCCC433EF;
        Mon, 20 Feb 2023 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900592;
        bh=qb+pjUlLj3FMINxDapJOMJDK1TEA/4MUZsQjxdFMu70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYx53cToRromajn4VhRmiE6VQ0h8s1J1hjqNWX9JQyNbIJM/oJLirwKd3VYcBwWSV
         4WA2VBl9IpuEFg1RP8MUqBhQ/WHzuLGu7wvYbdtS0Fj9P1B0Zl8LcTPWClQ+SigJVL
         GyOqIXpL6CiJGMvCGwIDHjXi2EJ4WU97VOanKGtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/89] pinctrl: intel: Convert unsigned to unsigned int
Date:   Mon, 20 Feb 2023 14:35:53 +0100
Message-Id: <20230220133555.033936973@linuxfoundation.org>
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

[ Upstream commit 04035f7f59bd106219d062293234bba683f6db71 ]

Simple type conversion with no functional change implied.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a8520be3ffef ("pinctrl: intel: Restore the pins that used to be in Direct IRQ mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 101 +++++++++++++-------------
 drivers/pinctrl/intel/pinctrl-intel.h |  32 ++++----
 2 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index f9eb37bb39051..198121bd89bbf 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -116,7 +116,7 @@ struct intel_pinctrl {
 #define padgroup_offset(g, p)	((p) - (g)->base)
 
 static struct intel_community *intel_get_community(struct intel_pinctrl *pctrl,
-						   unsigned pin)
+						   unsigned int pin)
 {
 	struct intel_community *community;
 	int i;
@@ -134,7 +134,7 @@ static struct intel_community *intel_get_community(struct intel_pinctrl *pctrl,
 
 static const struct intel_padgroup *
 intel_community_get_padgroup(const struct intel_community *community,
-			     unsigned pin)
+			     unsigned int pin)
 {
 	int i;
 
@@ -148,11 +148,11 @@ intel_community_get_padgroup(const struct intel_community *community,
 	return NULL;
 }
 
-static void __iomem *intel_get_padcfg(struct intel_pinctrl *pctrl, unsigned pin,
-				      unsigned reg)
+static void __iomem *intel_get_padcfg(struct intel_pinctrl *pctrl,
+				      unsigned int pin, unsigned int reg)
 {
 	const struct intel_community *community;
-	unsigned padno;
+	unsigned int padno;
 	size_t nregs;
 
 	community = intel_get_community(pctrl, pin);
@@ -168,11 +168,11 @@ static void __iomem *intel_get_padcfg(struct intel_pinctrl *pctrl, unsigned pin,
 	return community->pad_regs + reg + padno * nregs * 4;
 }
 
-static bool intel_pad_owned_by_host(struct intel_pinctrl *pctrl, unsigned pin)
+static bool intel_pad_owned_by_host(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct intel_community *community;
 	const struct intel_padgroup *padgrp;
-	unsigned gpp, offset, gpp_offset;
+	unsigned int gpp, offset, gpp_offset;
 	void __iomem *padown;
 
 	community = intel_get_community(pctrl, pin);
@@ -193,11 +193,11 @@ static bool intel_pad_owned_by_host(struct intel_pinctrl *pctrl, unsigned pin)
 	return !(readl(padown) & PADOWN_MASK(gpp_offset));
 }
 
-static bool intel_pad_acpi_mode(struct intel_pinctrl *pctrl, unsigned pin)
+static bool intel_pad_acpi_mode(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct intel_community *community;
 	const struct intel_padgroup *padgrp;
-	unsigned offset, gpp_offset;
+	unsigned int offset, gpp_offset;
 	void __iomem *hostown;
 
 	community = intel_get_community(pctrl, pin);
@@ -217,11 +217,11 @@ static bool intel_pad_acpi_mode(struct intel_pinctrl *pctrl, unsigned pin)
 	return !(readl(hostown) & BIT(gpp_offset));
 }
 
-static bool intel_pad_locked(struct intel_pinctrl *pctrl, unsigned pin)
+static bool intel_pad_locked(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	struct intel_community *community;
 	const struct intel_padgroup *padgrp;
-	unsigned offset, gpp_offset;
+	unsigned int offset, gpp_offset;
 	u32 value;
 
 	community = intel_get_community(pctrl, pin);
@@ -254,7 +254,7 @@ static bool intel_pad_locked(struct intel_pinctrl *pctrl, unsigned pin)
 	return false;
 }
 
-static bool intel_pad_usable(struct intel_pinctrl *pctrl, unsigned pin)
+static bool intel_pad_usable(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	return intel_pad_owned_by_host(pctrl, pin) &&
 		!intel_pad_locked(pctrl, pin);
@@ -268,15 +268,15 @@ static int intel_get_groups_count(struct pinctrl_dev *pctldev)
 }
 
 static const char *intel_get_group_name(struct pinctrl_dev *pctldev,
-				      unsigned group)
+				      unsigned int group)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
 	return pctrl->soc->groups[group].name;
 }
 
-static int intel_get_group_pins(struct pinctrl_dev *pctldev, unsigned group,
-			      const unsigned **pins, unsigned *npins)
+static int intel_get_group_pins(struct pinctrl_dev *pctldev, unsigned int group,
+			      const unsigned int **pins, unsigned int *npins)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
@@ -286,7 +286,7 @@ static int intel_get_group_pins(struct pinctrl_dev *pctldev, unsigned group,
 }
 
 static void intel_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
-			       unsigned pin)
+			       unsigned int pin)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	void __iomem *padcfg;
@@ -345,7 +345,7 @@ static int intel_get_functions_count(struct pinctrl_dev *pctldev)
 }
 
 static const char *intel_get_function_name(struct pinctrl_dev *pctldev,
-					   unsigned function)
+					   unsigned int function)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
@@ -353,9 +353,9 @@ static const char *intel_get_function_name(struct pinctrl_dev *pctldev,
 }
 
 static int intel_get_function_groups(struct pinctrl_dev *pctldev,
-				     unsigned function,
+				     unsigned int function,
 				     const char * const **groups,
-				     unsigned * const ngroups)
+				     unsigned int * const ngroups)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
@@ -364,8 +364,8 @@ static int intel_get_function_groups(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static int intel_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned function,
-				unsigned group)
+static int intel_pinmux_set_mux(struct pinctrl_dev *pctldev,
+				unsigned int function, unsigned int group)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	const struct intel_pingroup *grp = &pctrl->soc->groups[group];
@@ -447,7 +447,7 @@ static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
 
 static int intel_gpio_request_enable(struct pinctrl_dev *pctldev,
 				     struct pinctrl_gpio_range *range,
-				     unsigned pin)
+				     unsigned int pin)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	void __iomem *padcfg0;
@@ -485,7 +485,7 @@ static int intel_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 static int intel_gpio_set_direction(struct pinctrl_dev *pctldev,
 				    struct pinctrl_gpio_range *range,
-				    unsigned pin, bool input)
+				    unsigned int pin, bool input)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	void __iomem *padcfg0;
@@ -510,7 +510,7 @@ static const struct pinmux_ops intel_pinmux_ops = {
 	.gpio_set_direction = intel_gpio_set_direction,
 };
 
-static int intel_config_get(struct pinctrl_dev *pctldev, unsigned pin,
+static int intel_config_get(struct pinctrl_dev *pctldev, unsigned int pin,
 			    unsigned long *config)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
@@ -599,11 +599,11 @@ static int intel_config_get(struct pinctrl_dev *pctldev, unsigned pin,
 	return 0;
 }
 
-static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned pin,
+static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 				 unsigned long config)
 {
-	unsigned param = pinconf_to_config_param(config);
-	unsigned arg = pinconf_to_config_argument(config);
+	unsigned int param = pinconf_to_config_param(config);
+	unsigned int arg = pinconf_to_config_argument(config);
 	const struct intel_community *community;
 	void __iomem *padcfg1;
 	unsigned long flags;
@@ -685,8 +685,8 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned pin,
 	return ret;
 }
 
-static int intel_config_set_debounce(struct intel_pinctrl *pctrl, unsigned pin,
-				     unsigned debounce)
+static int intel_config_set_debounce(struct intel_pinctrl *pctrl,
+				     unsigned int pin, unsigned int debounce)
 {
 	void __iomem *padcfg0, *padcfg2;
 	unsigned long flags;
@@ -732,8 +732,8 @@ static int intel_config_set_debounce(struct intel_pinctrl *pctrl, unsigned pin,
 	return ret;
 }
 
-static int intel_config_set(struct pinctrl_dev *pctldev, unsigned pin,
-			  unsigned long *configs, unsigned nconfigs)
+static int intel_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
+			  unsigned long *configs, unsigned int nconfigs)
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 	int i, ret;
@@ -790,7 +790,7 @@ static const struct pinctrl_desc intel_pinctrl_desc = {
  * automatically translated to pinctrl pin number. This function can be
  * used to find out the corresponding pinctrl pin.
  */
-static int intel_gpio_to_pin(struct intel_pinctrl *pctrl, unsigned offset,
+static int intel_gpio_to_pin(struct intel_pinctrl *pctrl, unsigned int offset,
 			     const struct intel_community **community,
 			     const struct intel_padgroup **padgrp)
 {
@@ -824,7 +824,7 @@ static int intel_gpio_to_pin(struct intel_pinctrl *pctrl, unsigned offset,
 	return -EINVAL;
 }
 
-static int intel_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct intel_pinctrl *pctrl = gpiochip_get_data(chip);
 	void __iomem *reg;
@@ -846,7 +846,8 @@ static int intel_gpio_get(struct gpio_chip *chip, unsigned offset)
 	return !!(padcfg0 & PADCFG0_GPIORXSTATE);
 }
 
-static void intel_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static void intel_gpio_set(struct gpio_chip *chip, unsigned int offset,
+			   int value)
 {
 	struct intel_pinctrl *pctrl = gpiochip_get_data(chip);
 	unsigned long flags;
@@ -895,12 +896,12 @@ static int intel_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 	return !!(padcfg0 & PADCFG0_GPIOTXDIS);
 }
 
-static int intel_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
 	return pinctrl_gpio_direction_input(chip->base + offset);
 }
 
-static int intel_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+static int intel_gpio_direction_output(struct gpio_chip *chip, unsigned int offset,
 				       int value)
 {
 	intel_gpio_set(chip, offset, value);
@@ -929,7 +930,7 @@ static void intel_gpio_irq_ack(struct irq_data *d)
 
 	pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), &community, &padgrp);
 	if (pin >= 0) {
-		unsigned gpp, gpp_offset, is_offset;
+		unsigned int gpp, gpp_offset, is_offset;
 
 		gpp = padgrp->reg_num;
 		gpp_offset = padgroup_offset(padgrp, pin);
@@ -951,7 +952,7 @@ static void intel_gpio_irq_enable(struct irq_data *d)
 
 	pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), &community, &padgrp);
 	if (pin >= 0) {
-		unsigned gpp, gpp_offset, is_offset;
+		unsigned int gpp, gpp_offset, is_offset;
 		unsigned long flags;
 		u32 value;
 
@@ -980,7 +981,7 @@ static void intel_gpio_irq_mask_unmask(struct irq_data *d, bool mask)
 
 	pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), &community, &padgrp);
 	if (pin >= 0) {
-		unsigned gpp, gpp_offset;
+		unsigned int gpp, gpp_offset;
 		unsigned long flags;
 		void __iomem *reg;
 		u32 value;
@@ -1011,11 +1012,11 @@ static void intel_gpio_irq_unmask(struct irq_data *d)
 	intel_gpio_irq_mask_unmask(d, false);
 }
 
-static int intel_gpio_irq_type(struct irq_data *d, unsigned type)
+static int intel_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct intel_pinctrl *pctrl = gpiochip_get_data(gc);
-	unsigned pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), NULL, NULL);
+	unsigned int pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), NULL, NULL);
 	unsigned long flags;
 	void __iomem *reg;
 	u32 value;
@@ -1072,7 +1073,7 @@ static int intel_gpio_irq_wake(struct irq_data *d, unsigned int on)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct intel_pinctrl *pctrl = gpiochip_get_data(gc);
-	unsigned pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), NULL, NULL);
+	unsigned int pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), NULL, NULL);
 
 	if (on)
 		enable_irq_wake(pctrl->irq);
@@ -1167,7 +1168,7 @@ static int intel_gpio_add_pin_ranges(struct intel_pinctrl *pctrl,
 static unsigned intel_gpio_ngpio(const struct intel_pinctrl *pctrl)
 {
 	const struct intel_community *community;
-	unsigned ngpio = 0;
+	unsigned int ngpio = 0;
 	int i, j;
 
 	for (i = 0; i < pctrl->ncommunities; i++) {
@@ -1243,8 +1244,8 @@ static int intel_pinctrl_add_padgroups(struct intel_pinctrl *pctrl,
 				       struct intel_community *community)
 {
 	struct intel_padgroup *gpps;
-	unsigned npins = community->npins;
-	unsigned padown_num = 0;
+	unsigned int npins = community->npins;
+	unsigned int padown_num = 0;
 	size_t ngpps, i;
 
 	if (community->gpps)
@@ -1260,7 +1261,7 @@ static int intel_pinctrl_add_padgroups(struct intel_pinctrl *pctrl,
 		if (community->gpps) {
 			gpps[i] = community->gpps[i];
 		} else {
-			unsigned gpp_size = community->gpp_size;
+			unsigned int gpp_size = community->gpp_size;
 
 			gpps[i].reg_num = i;
 			gpps[i].base = community->pin_base + i * gpp_size;
@@ -1431,7 +1432,7 @@ int intel_pinctrl_probe(struct platform_device *pdev,
 EXPORT_SYMBOL_GPL(intel_pinctrl_probe);
 
 #ifdef CONFIG_PM_SLEEP
-static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned pin)
+static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
 	u32 value;
@@ -1502,7 +1503,7 @@ int intel_pinctrl_suspend(struct device *dev)
 	for (i = 0; i < pctrl->ncommunities; i++) {
 		struct intel_community *community = &pctrl->communities[i];
 		void __iomem *base;
-		unsigned gpp;
+		unsigned int gpp;
 
 		base = community->regs + community->ie_offset;
 		for (gpp = 0; gpp < community->ngpps; gpp++)
@@ -1520,7 +1521,7 @@ static void intel_gpio_irq_init(struct intel_pinctrl *pctrl)
 	for (i = 0; i < pctrl->ncommunities; i++) {
 		const struct intel_community *community;
 		void __iomem *base;
-		unsigned gpp;
+		unsigned int gpp;
 
 		community = &pctrl->communities[i];
 		base = community->regs;
@@ -1584,7 +1585,7 @@ int intel_pinctrl_resume(struct device *dev)
 	for (i = 0; i < pctrl->ncommunities; i++) {
 		struct intel_community *community = &pctrl->communities[i];
 		void __iomem *base;
-		unsigned gpp;
+		unsigned int gpp;
 
 		base = community->regs + community->ie_offset;
 		for (gpp = 0; gpp < community->ngpps; gpp++) {
diff --git a/drivers/pinctrl/intel/pinctrl-intel.h b/drivers/pinctrl/intel/pinctrl-intel.h
index 1785abf157e4b..737a545b448f0 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.h
+++ b/drivers/pinctrl/intel/pinctrl-intel.h
@@ -25,10 +25,10 @@ struct device;
  */
 struct intel_pingroup {
 	const char *name;
-	const unsigned *pins;
+	const unsigned int *pins;
 	size_t npins;
 	unsigned short mode;
-	const unsigned *modes;
+	const unsigned int *modes;
 };
 
 /**
@@ -56,11 +56,11 @@ struct intel_function {
  * to specify them.
  */
 struct intel_padgroup {
-	unsigned reg_num;
-	unsigned base;
-	unsigned size;
+	unsigned int reg_num;
+	unsigned int base;
+	unsigned int size;
 	int gpio_base;
-	unsigned padown_num;
+	unsigned int padown_num;
 };
 
 /**
@@ -96,17 +96,17 @@ struct intel_padgroup {
  * pass custom @gpps and @ngpps instead.
  */
 struct intel_community {
-	unsigned barno;
-	unsigned padown_offset;
-	unsigned padcfglock_offset;
-	unsigned hostown_offset;
-	unsigned is_offset;
-	unsigned ie_offset;
-	unsigned pin_base;
-	unsigned gpp_size;
-	unsigned gpp_num_padown_regs;
+	unsigned int barno;
+	unsigned int padown_offset;
+	unsigned int padcfglock_offset;
+	unsigned int hostown_offset;
+	unsigned int is_offset;
+	unsigned int ie_offset;
+	unsigned int pin_base;
+	unsigned int gpp_size;
+	unsigned int gpp_num_padown_regs;
 	size_t npins;
-	unsigned features;
+	unsigned int features;
 	const struct intel_padgroup *gpps;
 	size_t ngpps;
 	/* Reserved for the core driver */
-- 
2.39.0



