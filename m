Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E5D33C00C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhCOPgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234095AbhCOPfs (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A6164E74;
        Mon, 15 Mar 2021 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822548;
        bh=f0Jv0x1N5MtpHDuqTanDbxZeRxFZI4g4VUau1mU18Eo=;
        h=Subject:To:From:Date:From;
        b=L4G8jOWFOgSYWRCfRKI2B9MgrbSU4/hB41kKCQ7Flggss+vaN9nYpqgG3kzbcM16M
         hZugExyDkUyD7tYdXftmjS4GpW1zCpCzMmbu/Dm/t6DUsGtsWSDIInBy5310eQvqmu
         w+t2FU3OKoW1hHCyJoPn6LpL7pJZXrRoM/ORjYx8=
Subject: patch "counter: stm32-timer-cnt: fix ceiling write max value" added to staging-linus
To:     fabrice.gasnier@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, vilhelm.gray@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:25 +0100
Message-ID: <161582252598140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    counter: stm32-timer-cnt: fix ceiling write max value

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e4c3e133294c0a292d21073899b05ebf530169bd Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Date: Tue, 2 Mar 2021 15:43:55 +0100
Subject: counter: stm32-timer-cnt: fix ceiling write max value

The ceiling value isn't checked before writing it into registers. The user
could write a value higher than the counter resolution (e.g. 16 or 32 bits
indicated by max_arr). This makes most significant bits to be truncated.
Fix it by checking the max_arr to report a range error [1] to the user.

[1] https://lkml.org/lkml/2021/2/12/358

Fixes: ad29937e206f ("counter: Add STM32 Timer quadrature encoder")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1614696235-24088-1-git-send-email-fabrice.gasnier@foss.st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/counter/stm32-timer-cnt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index cd50dc12bd02..2295be3f309a 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -32,6 +32,7 @@ struct stm32_timer_cnt {
 	struct regmap *regmap;
 	struct clk *clk;
 	u32 ceiling;
+	u32 max_arr;
 	bool enabled;
 	struct stm32_timer_regs bak;
 };
@@ -191,6 +192,9 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	if (ret)
 		return ret;
 
+	if (ceiling > priv->max_arr)
+		return -ERANGE;
+
 	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
@@ -371,6 +375,7 @@ static int stm32_timer_cnt_probe(struct platform_device *pdev)
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
 	priv->ceiling = ddata->max_arr;
+	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);
 	priv->counter.parent = dev;
-- 
2.30.2


