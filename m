Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5237C1B8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhELPDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232946AbhELPCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E954361622;
        Wed, 12 May 2021 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831480;
        bh=yzFSaGaIxhetW/+mmDxDSvd5XhxXCYrLj4Eaj4rldLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFcBu9QViUCJZ8Myj3OjEDikhat5er0xo0zTXBUlxcBTg/bM65Rx1tX98ZX8wpGmw
         /YCnlircTc6TTpfKkiXvc2SYkZWlPiwY4gTRZ8OLoPr+pPFEWwzvZHSr33WIrhQyqH
         j76wuuB7imxvK8cWb/nv5O/FwlKl9vkM2PvhLDZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Anders Trier Olesen <anders.trier.olesen@gmail.com>,
        Philip Soares <philips@netisense.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/244] clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0
Date:   Wed, 12 May 2021 16:48:10 +0200
Message-Id: <20210512144746.831148231@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit e93033aff684641f71a436ca7a9d2a742126baaf ]

When CPU frequency is at 250 MHz and set_rate() is called with 500 MHz (L1)
quickly followed by a call with 1 GHz (L0), the CPU does not necessarily
stay in L1 for at least 20ms as is required by Marvell errata.

This situation happens frequently with the ondemand cpufreq governor and
can be also reproduced with userspace governor. In most cases it causes CPU
to crash.

This change fixes the above issue and ensures that the CPU always stays in
L1 for at least 20ms when switching from any state to L0.

Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 61c40f35f5cd ("clk: mvebu: armada-37xx-periph: Fix switching CPU rate from 300Mhz to 1.2GHz")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/armada-37xx-periph.c | 45 ++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/mvebu/armada-37xx-periph.c b/drivers/clk/mvebu/armada-37xx-periph.c
index 5193dc817197..07e47c34e073 100644
--- a/drivers/clk/mvebu/armada-37xx-periph.c
+++ b/drivers/clk/mvebu/armada-37xx-periph.c
@@ -84,6 +84,7 @@ struct clk_pm_cpu {
 	void __iomem *reg_div;
 	u8 shift_div;
 	struct regmap *nb_pm_base;
+	unsigned long l1_expiration;
 };
 
 #define to_clk_double_div(_hw) container_of(_hw, struct clk_double_div, hw)
@@ -502,22 +503,52 @@ static long clk_pm_cpu_round_rate(struct clk_hw *hw, unsigned long rate,
  * 2. Sleep 20ms for stabling VDD voltage
  * 3. Then switch from L1 (500/600 MHz) to L0 (1000/1200 MHz).
  */
-static void clk_pm_cpu_set_rate_wa(unsigned long rate, struct regmap *base)
+static void clk_pm_cpu_set_rate_wa(struct clk_pm_cpu *pm_cpu,
+				   unsigned int new_level, unsigned long rate,
+				   struct regmap *base)
 {
 	unsigned int cur_level;
 
-	if (rate < 1000 * 1000 * 1000)
-		return;
-
 	regmap_read(base, ARMADA_37XX_NB_CPU_LOAD, &cur_level);
 	cur_level &= ARMADA_37XX_NB_CPU_LOAD_MASK;
-	if (cur_level <= ARMADA_37XX_DVFS_LOAD_1)
+
+	if (cur_level == new_level)
+		return;
+
+	/*
+	 * System wants to go to L1 on its own. If we are going from L2/L3,
+	 * remember when 20ms will expire. If from L0, set the value so that
+	 * next switch to L0 won't have to wait.
+	 */
+	if (new_level == ARMADA_37XX_DVFS_LOAD_1) {
+		if (cur_level == ARMADA_37XX_DVFS_LOAD_0)
+			pm_cpu->l1_expiration = jiffies;
+		else
+			pm_cpu->l1_expiration = jiffies + msecs_to_jiffies(20);
 		return;
+	}
+
+	/*
+	 * If we are setting to L2/L3, just invalidate L1 expiration time,
+	 * sleeping is not needed.
+	 */
+	if (rate < 1000*1000*1000)
+		goto invalidate_l1_exp;
+
+	/*
+	 * We are going to L0 with rate >= 1GHz. Check whether we have been at
+	 * L1 for long enough time. If not, go to L1 for 20ms.
+	 */
+	if (pm_cpu->l1_expiration && jiffies >= pm_cpu->l1_expiration)
+		goto invalidate_l1_exp;
 
 	regmap_update_bits(base, ARMADA_37XX_NB_CPU_LOAD,
 			   ARMADA_37XX_NB_CPU_LOAD_MASK,
 			   ARMADA_37XX_DVFS_LOAD_1);
 	msleep(20);
+
+invalidate_l1_exp:
+	pm_cpu->l1_expiration = 0;
 }
 
 static int clk_pm_cpu_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -551,7 +582,9 @@ static int clk_pm_cpu_set_rate(struct clk_hw *hw, unsigned long rate,
 			reg = ARMADA_37XX_NB_CPU_LOAD;
 			mask = ARMADA_37XX_NB_CPU_LOAD_MASK;
 
-			clk_pm_cpu_set_rate_wa(rate, base);
+			/* Apply workaround when base CPU frequency is 1000 or 1200 MHz */
+			if (parent_rate >= 1000*1000*1000)
+				clk_pm_cpu_set_rate_wa(pm_cpu, load_level, rate, base);
 
 			regmap_update_bits(base, reg, mask, load_level);
 
-- 
2.30.2



