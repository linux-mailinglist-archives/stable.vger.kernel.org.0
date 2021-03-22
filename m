Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCBE344339
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCVMtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhCVMrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C4CC619BD;
        Mon, 22 Mar 2021 12:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416998;
        bh=mPKvOZYrPigyMhFOYXa7eMHDRkDfryfRB9QhISGllk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAXfa1xXmVRDxx++7DSkFnQeCdmw+FfsXWKgpP0nmoA95epuHrCvhVRnXTjxAfL/Z
         RvT66EzKO1+dXuK6fMGBlsvh+F4JK2NragggqUp/FLoNUQO0Q4wneDBLl3ZVAApSpr
         xNnb7T9EiuqS3t/09sFP2r0VFGRhkGY7Wng1eS2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 47/60] counter: stm32-timer-cnt: fix ceiling write max value
Date:   Mon, 22 Mar 2021 13:28:35 +0100
Message-Id: <20210322121923.943439617@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit e4c3e133294c0a292d21073899b05ebf530169bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/stm32-timer-cnt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -25,6 +25,7 @@ struct stm32_timer_cnt {
 	struct regmap *regmap;
 	struct clk *clk;
 	u32 ceiling;
+	u32 max_arr;
 };
 
 /**
@@ -189,6 +190,9 @@ static ssize_t stm32_count_ceiling_write
 	if (ret)
 		return ret;
 
+	if (ceiling > priv->max_arr)
+		return -ERANGE;
+
 	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
@@ -366,6 +370,7 @@ static int stm32_timer_cnt_probe(struct
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
 	priv->ceiling = ddata->max_arr;
+	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);
 	priv->counter.parent = dev;


