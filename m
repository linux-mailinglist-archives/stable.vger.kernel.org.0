Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D634419D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCVMeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhCVMdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE243619AE;
        Mon, 22 Mar 2021 12:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416416;
        bh=J0Y3sIMV2n/Y1OuK3iAET8+O3YG9ezdpmXSxTGcPkOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1m7fyEwmnbxusyTcH8o4V3d93TG8ABg+nxUdVHmQau/svLgoyWJDXyvPCeCLrgBr
         GQknX+JbDchVlHNnd+ElhJi5La0baP7NZ6tKcFiaAKH4Cut5ndsl3b16VlqUp1fI4T
         K7f6f7vUYO4w9hzJdxn9Gc8bdxEQS9E3nPxgn48Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 098/120] counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register
Date:   Mon, 22 Mar 2021 13:28:01 +0100
Message-Id: <20210322121932.960417786@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit b14d72ac731753708a7c1a6b3657b9312b6f0042 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/stm32-timer-cnt.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

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
@@ -75,8 +74,10 @@ static int stm32_count_write(struct coun
 			     const unsigned long val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
+	u32 ceiling;
 
-	if (val > priv->ceiling)
+	regmap_read(priv->regmap, TIM_ARR, &ceiling);
+	if (val > ceiling)
 		return -EINVAL;
 
 	return regmap_write(priv->regmap, TIM_CNT, val);
@@ -138,10 +139,6 @@ static int stm32_count_function_set(stru
 
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
 
-	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
-	regmap_write(priv->regmap, TIM_ARR, priv->ceiling);
-
 	regmap_update_bits(priv->regmap, TIM_SMCR, TIM_SMCR_SMS, sms);
 
 	/* Make sure that registers are updated */
@@ -199,7 +196,6 @@ static ssize_t stm32_count_ceiling_write
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	priv->ceiling = ceiling;
 	return len;
 }
 
@@ -374,7 +370,6 @@ static int stm32_timer_cnt_probe(struct
 
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
-	priv->ceiling = ddata->max_arr;
 	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);


