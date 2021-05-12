Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08A37C8DA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhELQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239199AbhELQHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA3961C50;
        Wed, 12 May 2021 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833809;
        bh=jjUBIP4SiM0ATLRglWSDxzYDel7xBraSSOu2ZrBNxoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayfgmA8CvDdfIW9LcCpobDeqRQ97KkJ7fU0ZAgOGtRzsKGvPL0N7YkjHpvNnFE83q
         eJqJYjTg8/0jgb+HW4MsIP/gxUU8fJfN9/2HhfYcb4DVWOXNSUi4NYZwM9G8EkZEZ2
         8G+w20OJ+nE36nUJQgFztpXsJa/EuGUdmC5CKeWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Anders Trier Olesen <anders.trier.olesen@gmail.com>,
        Philip Soares <philips@netisense.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 262/601] clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock
Date:   Wed, 12 May 2021 16:45:39 +0200
Message-Id: <20210512144836.445904057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 4e435a9dd26c46ac018997cc0562d50b1a96f372 ]

Remove the .set_parent method in clk_pm_cpu_ops.

This method was supposed to be needed by the armada-37xx-cpufreq driver,
but was never actually called due to wrong assumptions in the cpufreq
driver. After this was fixed in the cpufreq driver, this method is not
needed anymore.

Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Pali Rohár <pali@kernel.org>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 2089dc33ea0e ("clk: mvebu: armada-37xx-periph: add DVFS support for cpu clocks")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/armada-37xx-periph.c | 28 --------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/clk/mvebu/armada-37xx-periph.c b/drivers/clk/mvebu/armada-37xx-periph.c
index f5746f9ea929..6507bd2c5f31 100644
--- a/drivers/clk/mvebu/armada-37xx-periph.c
+++ b/drivers/clk/mvebu/armada-37xx-periph.c
@@ -440,33 +440,6 @@ static u8 clk_pm_cpu_get_parent(struct clk_hw *hw)
 	return val;
 }
 
-static int clk_pm_cpu_set_parent(struct clk_hw *hw, u8 index)
-{
-	struct clk_pm_cpu *pm_cpu = to_clk_pm_cpu(hw);
-	struct regmap *base = pm_cpu->nb_pm_base;
-	int load_level;
-
-	/*
-	 * We set the clock parent only if the DVFS is available but
-	 * not enabled.
-	 */
-	if (IS_ERR(base) || armada_3700_pm_dvfs_is_enabled(base))
-		return -EINVAL;
-
-	/* Set the parent clock for all the load level */
-	for (load_level = 0; load_level < LOAD_LEVEL_NR; load_level++) {
-		unsigned int reg, mask,  val,
-			offset = ARMADA_37XX_NB_TBG_SEL_OFF;
-
-		armada_3700_pm_dvfs_update_regs(load_level, &reg, &offset);
-
-		val = index << offset;
-		mask = ARMADA_37XX_NB_TBG_SEL_MASK << offset;
-		regmap_update_bits(base, reg, mask, val);
-	}
-	return 0;
-}
-
 static unsigned long clk_pm_cpu_recalc_rate(struct clk_hw *hw,
 					    unsigned long parent_rate)
 {
@@ -592,7 +565,6 @@ static int clk_pm_cpu_set_rate(struct clk_hw *hw, unsigned long rate,
 
 static const struct clk_ops clk_pm_cpu_ops = {
 	.get_parent = clk_pm_cpu_get_parent,
-	.set_parent = clk_pm_cpu_set_parent,
 	.round_rate = clk_pm_cpu_round_rate,
 	.set_rate = clk_pm_cpu_set_rate,
 	.recalc_rate = clk_pm_cpu_recalc_rate,
-- 
2.30.2



