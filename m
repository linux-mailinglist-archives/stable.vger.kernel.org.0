Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8609233C00E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhCOPgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhCOPf5 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA8564E64;
        Mon, 15 Mar 2021 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822556;
        bh=oiN6/ckVW1XwEtFABKb0jMekxqUpEKAmt3AAlCeXleE=;
        h=Subject:To:From:Date:From;
        b=yV9kW/dVaMUK6QSC1Ft/DRBivBPBFJ8ACv1qFI+YfAAjKQnRJPW4GrDFvTRuQanWp
         iHvbi9SUTdJJEubz2pU5kB7cn8M1CFePE2d+4PPUZ3EwihYVF1zw7u4qo1Xjv/iwoD
         aznoE999bkHFBEaz7y4FSEmHLaF0gCgy/nskXySE=
Subject: patch "counter: stm32-timer-cnt: fix ceiling miss-alignment with reload" added to staging-linus
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:26 +0100
Message-ID: <161582252698195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    counter: stm32-timer-cnt: fix ceiling miss-alignment with reload

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b14d72ac731753708a7c1a6b3657b9312b6f0042 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Wed, 3 Mar 2021 18:49:49 +0100
Subject: counter: stm32-timer-cnt: fix ceiling miss-alignment with reload
 register

Ceiling value may be miss-aligned with what's actually configured into the
ARR register. This is seen after probe as currently the ARR value is zero,
whereas ceiling value is set to the maximum. So:
- reading ceiling reports zero
- in case the counter gets enabled without any prior configuration,
  it won't count.
- in case the function gets set by the user 1st, (priv->ceiling) is used.

Fix it by getting rid of the cached "priv->ceiling" variable. Rather use
the ARR register value directly by using regmap read or write when needed.
There should be no drawback on performance as priv->ceiling isn't used in
performance critical path.
There's also no point in writing ARR while setting function (sms), so
it can be safely removed.

Fixes: ad29937e206f ("counter: Add STM32 Timer quadrature encoder")
Suggested-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1614793789-10346-1-git-send-email-fabrice.gasnier@foss.st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/counter/stm32-timer-cnt.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 2295be3f309a..75bc401fdd18 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -31,7 +31,6 @@ struct stm32_timer_cnt {
 	struct counter_device counter;
 	struct regmap *regmap;
 	struct clk *clk;
-	u32 ceiling;
 	u32 max_arr;
 	bool enabled;
 	struct stm32_timer_regs bak;
@@ -75,8 +74,10 @@ static int stm32_count_write(struct counter_device *counter,
 			     const unsigned long val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
+	u32 ceiling;
 
-	if (val > priv->ceiling)
+	regmap_read(priv->regmap, TIM_ARR, &ceiling);
+	if (val > ceiling)
 		return -EINVAL;
 
 	return regmap_write(priv->regmap, TIM_CNT, val);
@@ -138,10 +139,6 @@ static int stm32_count_function_set(struct counter_device *counter,
 
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
 
-	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
-	regmap_write(priv->regmap, TIM_ARR, priv->ceiling);
-
 	regmap_update_bits(priv->regmap, TIM_SMCR, TIM_SMCR_SMS, sms);
 
 	/* Make sure that registers are updated */
@@ -199,7 +196,6 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	priv->ceiling = ceiling;
 	return len;
 }
 
@@ -374,7 +370,6 @@ static int stm32_timer_cnt_probe(struct platform_device *pdev)
 
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
-	priv->ceiling = ddata->max_arr;
 	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);
-- 
2.30.2


