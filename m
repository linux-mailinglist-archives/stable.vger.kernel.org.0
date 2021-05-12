Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFF37C19B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhELPCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhELPAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F7C26144F;
        Wed, 12 May 2021 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831429;
        bh=wOGjIcwZDKt2pSSXPP+oTyaelETqNT9qt+DqBU1YDOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oy3SS1b+I5HNKY2SGaR9uo/q7lVUwFoie6FPorLjHQNmN0/ZW8Kq6CmXuhrsh9TZL
         V6uAnBguC2hm4GEkpAtSZGlso+tyqJMng9mXFwWZQA97u5/Vq4829gwiXIZZoSjozY
         9cOi/OnxLAa6PzYQYFx65GT1TBtloFLJo0bYiQsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Anders Trier Olesen <anders.trier.olesen@gmail.com>,
        Philip Soares <philips@netisense.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/244] cpufreq: armada-37xx: Fix setting TBG parent for load levels
Date:   Wed, 12 May 2021 16:48:06 +0200
Message-Id: <20210512144746.701697796@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 22592df194e31baf371906cc720da38fa0ab68f5 ]

With CPU frequency determining software [1] we have discovered that
after this driver does one CPU frequency change, the base frequency of
the CPU is set to the frequency of TBG-A-P clock, instead of the TBG
that is parent to the CPU.

This can be reproduced on EspressoBIN and Turris MOX:
  cd /sys/devices/system/cpu/cpufreq/policy0
  echo powersave >scaling_governor
  echo performance >scaling_governor

Running the mhz tool before this driver is loaded reports 1000 MHz, and
after loading the driver and executing commands above the tool reports
800 MHz.

The change of TBG clock selector is supposed to happen in function
armada37xx_cpufreq_dvfs_setup. Before the function returns, it does
this:
  parent = clk_get_parent(clk);
  clk_set_parent(clk, parent);

The armada-37xx-periph clock driver has the .set_parent method
implemented correctly for this, so if the method was actually called,
this would work. But since the introduction of the common clock
framework in commit b2476490ef11 ("clk: introduce the common clock..."),
the clk_set_parent function checks whether the parent is actually
changing, and if the requested new parent is same as the old parent
(which is obviously the case for the code above), the .set_parent method
is not called at all.

This patch fixes this issue by filling the correct TBG clock selector
directly in the armada37xx_cpufreq_dvfs_setup during the filling of
other registers at the same address. But the determination of CPU TBG
index cannot be done via the common clock framework, therefore we need
to access the North Bridge Peripheral Clock registers directly in this
driver.

[1] https://github.com/wtarreau/mhz

Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Pali Rohár <pali@kernel.org>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 92ce45fb875d ("cpufreq: Add DVFS support for Armada 37xx")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 35 ++++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index b4af4094309b..b8dc6c849579 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -25,6 +25,10 @@
 
 #include "cpufreq-dt.h"
 
+/* Clk register set */
+#define ARMADA_37XX_CLK_TBG_SEL		0
+#define ARMADA_37XX_CLK_TBG_SEL_CPU_OFF	22
+
 /* Power management in North Bridge register set */
 #define ARMADA_37XX_NB_L0L1	0x18
 #define ARMADA_37XX_NB_L2L3	0x1C
@@ -120,10 +124,15 @@ static struct armada_37xx_dvfs *armada_37xx_cpu_freq_info_get(u32 freq)
  * will be configured then the DVFS will be enabled.
  */
 static void __init armada37xx_cpufreq_dvfs_setup(struct regmap *base,
-						 struct clk *clk, u8 *divider)
+						 struct regmap *clk_base, u8 *divider)
 {
+	u32 cpu_tbg_sel;
 	int load_lvl;
-	struct clk *parent;
+
+	/* Determine to which TBG clock is CPU connected */
+	regmap_read(clk_base, ARMADA_37XX_CLK_TBG_SEL, &cpu_tbg_sel);
+	cpu_tbg_sel >>= ARMADA_37XX_CLK_TBG_SEL_CPU_OFF;
+	cpu_tbg_sel &= ARMADA_37XX_NB_TBG_SEL_MASK;
 
 	for (load_lvl = 0; load_lvl < LOAD_LEVEL_NR; load_lvl++) {
 		unsigned int reg, mask, val, offset = 0;
@@ -142,6 +151,11 @@ static void __init armada37xx_cpufreq_dvfs_setup(struct regmap *base,
 		mask = (ARMADA_37XX_NB_CLK_SEL_MASK
 			<< ARMADA_37XX_NB_CLK_SEL_OFF);
 
+		/* Set TBG index, for all levels we use the same TBG */
+		val = cpu_tbg_sel << ARMADA_37XX_NB_TBG_SEL_OFF;
+		mask = (ARMADA_37XX_NB_TBG_SEL_MASK
+			<< ARMADA_37XX_NB_TBG_SEL_OFF);
+
 		/*
 		 * Set cpu divider based on the pre-computed array in
 		 * order to have balanced step.
@@ -160,14 +174,6 @@ static void __init armada37xx_cpufreq_dvfs_setup(struct regmap *base,
 
 		regmap_update_bits(base, reg, mask, val);
 	}
-
-	/*
-	 * Set cpu clock source, for all the level we keep the same
-	 * clock source that the one already configured. For this one
-	 * we need to use the clock framework
-	 */
-	parent = clk_get_parent(clk);
-	clk_set_parent(clk, parent);
 }
 
 /*
@@ -358,11 +364,16 @@ static int __init armada37xx_cpufreq_driver_init(void)
 	struct platform_device *pdev;
 	unsigned long freq;
 	unsigned int cur_frequency, base_frequency;
-	struct regmap *nb_pm_base, *avs_base;
+	struct regmap *nb_clk_base, *nb_pm_base, *avs_base;
 	struct device *cpu_dev;
 	int load_lvl, ret;
 	struct clk *clk, *parent;
 
+	nb_clk_base =
+		syscon_regmap_lookup_by_compatible("marvell,armada-3700-periph-clock-nb");
+	if (IS_ERR(nb_clk_base))
+		return -ENODEV;
+
 	nb_pm_base =
 		syscon_regmap_lookup_by_compatible("marvell,armada-3700-nb-pm");
 
@@ -439,7 +450,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 	armada37xx_cpufreq_avs_configure(avs_base, dvfs);
 	armada37xx_cpufreq_avs_setup(avs_base, dvfs);
 
-	armada37xx_cpufreq_dvfs_setup(nb_pm_base, clk, dvfs->divider);
+	armada37xx_cpufreq_dvfs_setup(nb_pm_base, nb_clk_base, dvfs->divider);
 	clk_put(clk);
 
 	for (load_lvl = ARMADA_37XX_DVFS_LOAD_0; load_lvl < LOAD_LEVEL_NR;
-- 
2.30.2



