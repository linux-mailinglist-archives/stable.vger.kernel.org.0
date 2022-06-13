Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF1548C69
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbiFMLRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352952AbiFMLOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:14:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C57B635A;
        Mon, 13 Jun 2022 03:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70505CE1109;
        Mon, 13 Jun 2022 10:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7BCC34114;
        Mon, 13 Jun 2022 10:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116640;
        bh=CbWbCCvuesMrHwINjiqgQKrzxOnwFtCdFWx6o7tT/mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjfhkpGPVU+k4fkyROYvi8YEaT86hwhe4/cxcrMkfT7xAxUi6/QLNoLjxi2tAs4Md
         2tRB+9HKvYjeE8F7LcXVcrtmdGJZ1q6r7Eko6DAeRlYq/2FFVI4FGY12DrBMOcWc8h
         dOLjF0NXSYu5vaetb/XeAd89NWI9hUm2hR+sI2u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/411] irqchip/exiu: Fix acknowledgment of edge triggered interrupts
Date:   Mon, 13 Jun 2022 12:06:33 +0200
Message-Id: <20220613094932.273181124@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit 4efc851c36e389f7ed432edac0149acc5f94b0c7 ]

Currently the EXIU uses the fasteoi interrupt flow that is configured by
it's parent (irq-gic-v3.c). With this flow the only chance to clear the
interrupt request happens during .irq_eoi() and (obviously) this happens
after the interrupt handler has run. EXIU requires edge triggered
interrupts to be acked prior to interrupt handling. Without this we
risk incorrect interrupt dismissal when a new interrupt is delivered
after the handler reads and acknowledges the peripheral but before the
irq_eoi() takes place.

Fix this by clearing the interrupt request from .irq_ack() if we are
configured for edge triggered interrupts. This requires adopting the
fasteoi-ack flow instead of the fasteoi to ensure the ack gets called.

These changes have been tested using the power button on a
Developerbox/SC2A11 combined with some hackery in gpio-keys so I can
play with the different trigger mode [and an mdelay(500) so I can
can check what happens on a double click in both modes].

Fixes: 706cffc1b912 ("irqchip/exiu: Add support for Socionext Synquacer EXIU controller")
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220503134541.2566457-1-daniel.thompson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig.platforms   |  1 +
 drivers/irqchip/irq-sni-exiu.c | 25 ++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 9dccf4db319b..90202e5608d1 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -225,6 +225,7 @@ config ARCH_STRATIX10
 
 config ARCH_SYNQUACER
 	bool "Socionext SynQuacer SoC Family"
+	select IRQ_FASTEOI_HIERARCHY_HANDLERS
 
 config ARCH_TEGRA
 	bool "NVIDIA Tegra SoC Family"
diff --git a/drivers/irqchip/irq-sni-exiu.c b/drivers/irqchip/irq-sni-exiu.c
index abd011fcecf4..c7db617e1a2f 100644
--- a/drivers/irqchip/irq-sni-exiu.c
+++ b/drivers/irqchip/irq-sni-exiu.c
@@ -37,11 +37,26 @@ struct exiu_irq_data {
 	u32		spi_base;
 };
 
-static void exiu_irq_eoi(struct irq_data *d)
+static void exiu_irq_ack(struct irq_data *d)
 {
 	struct exiu_irq_data *data = irq_data_get_irq_chip_data(d);
 
 	writel(BIT(d->hwirq), data->base + EIREQCLR);
+}
+
+static void exiu_irq_eoi(struct irq_data *d)
+{
+	struct exiu_irq_data *data = irq_data_get_irq_chip_data(d);
+
+	/*
+	 * Level triggered interrupts are latched and must be cleared during
+	 * EOI or the interrupt will be jammed on. Of course if a level
+	 * triggered interrupt is still asserted then the write will not clear
+	 * the interrupt.
+	 */
+	if (irqd_is_level_type(d))
+		writel(BIT(d->hwirq), data->base + EIREQCLR);
+
 	irq_chip_eoi_parent(d);
 }
 
@@ -91,10 +106,13 @@ static int exiu_irq_set_type(struct irq_data *d, unsigned int type)
 	writel_relaxed(val, data->base + EILVL);
 
 	val = readl_relaxed(data->base + EIEDG);
-	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
+	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH) {
 		val &= ~BIT(d->hwirq);
-	else
+		irq_set_handler_locked(d, handle_fasteoi_irq);
+	} else {
 		val |= BIT(d->hwirq);
+		irq_set_handler_locked(d, handle_fasteoi_ack_irq);
+	}
 	writel_relaxed(val, data->base + EIEDG);
 
 	writel_relaxed(BIT(d->hwirq), data->base + EIREQCLR);
@@ -104,6 +122,7 @@ static int exiu_irq_set_type(struct irq_data *d, unsigned int type)
 
 static struct irq_chip exiu_irq_chip = {
 	.name			= "EXIU",
+	.irq_ack		= exiu_irq_ack,
 	.irq_eoi		= exiu_irq_eoi,
 	.irq_enable		= exiu_irq_enable,
 	.irq_mask		= exiu_irq_mask,
-- 
2.35.1



