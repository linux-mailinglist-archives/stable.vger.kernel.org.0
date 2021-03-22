Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7EF34419A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhCVMem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231585AbhCVMde (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42F3C619A8;
        Mon, 22 Mar 2021 12:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416413;
        bh=b74qLjD1/EZPdXSgHwDphB8Yysweg1zXejONvSucxuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFc6OvIJDp2S88B0KgNQ2ldVmN1CSnc0B9pQahwq9HqHelNAPctODDET/K2Aju5r6
         6T8lE7dMQ0IJ5xiJ+WbLSPpq34Inlhjk2DBRRb67mklRlhhiUeMLKNgSmrTXFhl9vH
         Nt497vy2vFWpAVksTeyRcIhShuqNvoZKqHdewYTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 097/120] counter: stm32-timer-cnt: fix ceiling write max value
Date:   Mon, 22 Mar 2021 13:28:00 +0100
Message-Id: <20210322121932.924568605@linuxfoundation.org>
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
@@ -32,6 +32,7 @@ struct stm32_timer_cnt {
 	struct regmap *regmap;
 	struct clk *clk;
 	u32 ceiling;
+	u32 max_arr;
 	bool enabled;
 	struct stm32_timer_regs bak;
 };
@@ -191,6 +192,9 @@ static ssize_t stm32_count_ceiling_write
 	if (ret)
 		return ret;
 
+	if (ceiling > priv->max_arr)
+		return -ERANGE;
+
 	/* TIMx_ARR register shouldn't be buffered (ARPE=0) */
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
@@ -371,6 +375,7 @@ static int stm32_timer_cnt_probe(struct
 	priv->regmap = ddata->regmap;
 	priv->clk = ddata->clk;
 	priv->ceiling = ddata->max_arr;
+	priv->max_arr = ddata->max_arr;
 
 	priv->counter.name = dev_name(dev);
 	priv->counter.parent = dev;


