Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D027236AE59
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhDZHnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhDZHm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC95613AC;
        Mon, 26 Apr 2021 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422766;
        bh=oBC+dwlVZO+RPkhhqBHg07yV4vgCDUVynGMprcDaUek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEGMZ5Crp2TNz1BMLCuUytw8HJu7WZ9KkZyZV8/v67Ct11FM0M78mftq+zMcZyFSd
         8XmBUTKOdWS3pk9Zd5U1lKaY2duWBm5+0BICrHBOUzVjET8uooatume9Q7VW3QHMpM
         tS2S8nyss4DLdxWXyOVG+0qlxJPSPv6z9JRjaa3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        Andreas Kemnade <andreas@kemnade.info>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/36] gpio: omap: Save and restore sysconfig
Date:   Mon, 26 Apr 2021 09:29:44 +0200
Message-Id: <20210426072818.872067252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit ddd8d94ca31e768c76cf8bfe34ba7b10136b3694 ]

As we are using cpu_pm to save and restore context, we must also save and
restore the GPIO sysconfig register. This is needed because we are not
calling PM runtime functions at all with cpu_pm.

We need to save the sysconfig on idle as it's value can get reconfigured by
PM runtime and can be different from the init time value. Device specific
flags like "ti,no-idle-on-init" can affect the init value.

Fixes: b764a5863fd8 ("gpio: omap: Remove custom PM calls and use cpu_pm instead")
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Adam Ford <aford173@gmail.com>
Cc: Andreas Kemnade <andreas@kemnade.info>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c                | 9 +++++++++
 include/linux/platform_data/gpio-omap.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index f7ceb2b11afc..a7e8ed5191a8 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -29,6 +29,7 @@
 #define OMAP4_GPIO_DEBOUNCINGTIME_MASK 0xFF
 
 struct gpio_regs {
+	u32 sysconfig;
 	u32 irqenable1;
 	u32 irqenable2;
 	u32 wake_en;
@@ -1072,6 +1073,7 @@ static void omap_gpio_init_context(struct gpio_bank *p)
 	const struct omap_gpio_reg_offs *regs = p->regs;
 	void __iomem *base = p->base;
 
+	p->context.sysconfig	= readl_relaxed(base + regs->sysconfig);
 	p->context.ctrl		= readl_relaxed(base + regs->ctrl);
 	p->context.oe		= readl_relaxed(base + regs->direction);
 	p->context.wake_en	= readl_relaxed(base + regs->wkup_en);
@@ -1091,6 +1093,7 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 	const struct omap_gpio_reg_offs *regs = bank->regs;
 	void __iomem *base = bank->base;
 
+	writel_relaxed(bank->context.sysconfig, base + regs->sysconfig);
 	writel_relaxed(bank->context.wake_en, base + regs->wkup_en);
 	writel_relaxed(bank->context.ctrl, base + regs->ctrl);
 	writel_relaxed(bank->context.leveldetect0, base + regs->leveldetect0);
@@ -1118,6 +1121,10 @@ static void omap_gpio_idle(struct gpio_bank *bank, bool may_lose_context)
 
 	bank->saved_datain = readl_relaxed(base + bank->regs->datain);
 
+	/* Save syconfig, it's runtime value can be different from init value */
+	if (bank->loses_context)
+		bank->context.sysconfig = readl_relaxed(base + bank->regs->sysconfig);
+
 	if (!bank->enabled_non_wakeup_gpios)
 		goto update_gpio_context_count;
 
@@ -1282,6 +1289,7 @@ static int gpio_omap_cpu_notifier(struct notifier_block *nb,
 
 static const struct omap_gpio_reg_offs omap2_gpio_regs = {
 	.revision =		OMAP24XX_GPIO_REVISION,
+	.sysconfig =		OMAP24XX_GPIO_SYSCONFIG,
 	.direction =		OMAP24XX_GPIO_OE,
 	.datain =		OMAP24XX_GPIO_DATAIN,
 	.dataout =		OMAP24XX_GPIO_DATAOUT,
@@ -1305,6 +1313,7 @@ static const struct omap_gpio_reg_offs omap2_gpio_regs = {
 
 static const struct omap_gpio_reg_offs omap4_gpio_regs = {
 	.revision =		OMAP4_GPIO_REVISION,
+	.sysconfig =		OMAP4_GPIO_SYSCONFIG,
 	.direction =		OMAP4_GPIO_OE,
 	.datain =		OMAP4_GPIO_DATAIN,
 	.dataout =		OMAP4_GPIO_DATAOUT,
diff --git a/include/linux/platform_data/gpio-omap.h b/include/linux/platform_data/gpio-omap.h
index 8b30b14b47d3..f377817ce75c 100644
--- a/include/linux/platform_data/gpio-omap.h
+++ b/include/linux/platform_data/gpio-omap.h
@@ -85,6 +85,7 @@
  * omap2+ specific GPIO registers
  */
 #define OMAP24XX_GPIO_REVISION		0x0000
+#define OMAP24XX_GPIO_SYSCONFIG		0x0010
 #define OMAP24XX_GPIO_IRQSTATUS1	0x0018
 #define OMAP24XX_GPIO_IRQSTATUS2	0x0028
 #define OMAP24XX_GPIO_IRQENABLE2	0x002c
@@ -108,6 +109,7 @@
 #define OMAP24XX_GPIO_SETDATAOUT	0x0094
 
 #define OMAP4_GPIO_REVISION		0x0000
+#define OMAP4_GPIO_SYSCONFIG		0x0010
 #define OMAP4_GPIO_EOI			0x0020
 #define OMAP4_GPIO_IRQSTATUSRAW0	0x0024
 #define OMAP4_GPIO_IRQSTATUSRAW1	0x0028
@@ -148,6 +150,7 @@
 #ifndef __ASSEMBLER__
 struct omap_gpio_reg_offs {
 	u16 revision;
+	u16 sysconfig;
 	u16 direction;
 	u16 datain;
 	u16 dataout;
-- 
2.30.2



