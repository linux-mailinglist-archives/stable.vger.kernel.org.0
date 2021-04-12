Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD335BCE4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbhDLIqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237678AbhDLIpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FCFE61246;
        Mon, 12 Apr 2021 08:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217115;
        bh=u+MvBkHAwbADG7ZS0dtDFNtJdyAq/JSijQW73IWAtKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLmeGDXmgKuP96AQjFp4WgdEfyBklctii+w0lCIvHW7IBTcOSZ9y59oiYwMeBuK7G
         fkoJKBOJhBAFMCpCtEkv1p7cipXUk4s1qcXi0XeV11uf+VEW1h3wo1xhpkX7hbm9i7
         tMwMo7tqH+hRVdbJ41awU+otcWDwKZPtsP83CW24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 001/111] counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register
Date:   Mon, 12 Apr 2021 10:39:39 +0200
Message-Id: <20210412084004.252319197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit b14d72ac731753708a7c1a6b3657b9312b6f0042 upstream

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
[sudip: adjuct context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/stm32-timer-cnt.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -24,7 +24,6 @@ struct stm32_timer_cnt {
 	struct counter_device counter;
 	struct regmap *regmap;
 	struct clk *clk;
-	u32 ceiling;
 	u32 max_arr;
 };
 
@@ -67,14 +66,15 @@ static int stm32_count_write(struct coun
 			     struct counter_count_write_value *val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	u32 cnt;
+	u32 cnt, ceiling;
 	int err;
 
 	err = counter_count_write_value_get(&cnt, COUNTER_COUNT_POSITION, val);
 	if (err)
 		return err;
 
-	if (cnt > priv->ceiling)
+	regmap_read(priv->regmap, TIM_ARR, &ceiling);
+	if (cnt > ceiling)
 		return -EINVAL;
 
 	return regmap_write(priv->regmap, TIM_CNT, cnt);
@@ -136,10 +136,6 @@ static int stm32_count_function_set(stru
 
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
 
-	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
-	regmap_write(priv->regmap, TIM_ARR, priv->ceiling);
-
 	regmap_update_bits(priv->regmap, TIM_SMCR, TIM_SMCR_SMS, sms);
 
 	/* Make sure that registers are updated */
@@ -197,7 +193,6 @@ static ssize_t stm32_count_ceiling_write
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	priv->ceiling = ceiling;
 	return len;
 }
 
@@ -369,7 +364,6 @@ static int stm32_timer_cnt_probe(struct
 
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
-	priv->ceiling = ddata->max_arr;
 	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);


