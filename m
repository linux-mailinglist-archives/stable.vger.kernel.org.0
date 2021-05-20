Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF6538A704
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbhETKd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237033AbhETKb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BFFA61C3F;
        Thu, 20 May 2021 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504321;
        bh=C0Yj/x5LcoC+9D2E/O8akq6StoQeb79AVtvrABAlnfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5/DLCI0Vrl4+3eo0QYR1iUe4CqLJAm3wiVTRgm7pwN4w6W1mVqACrjB6xdR/a6gV
         CuxBa1dBNHPTgw9r6ZPxxEi9T18gE0xKMF2NzYyOtv0X4+URxcVET5WijT4nduSmpz
         Tne+FiMl6peaOAxIQp/HEE2i/OdR9z7jgCCmZOWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 192/323] mfd: stm32-timers: Avoid clearing auto reload register
Date:   Thu, 20 May 2021 11:21:24 +0200
Message-Id: <20210520092126.698771682@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 4917e498c6894ba077867aff78f82cffd5ffbb5c ]

The ARR register is cleared unconditionally upon probing, after the maximum
value has been read. This initial condition is rather not intuitive, when
considering the counter child driver. It rather expects the maximum value
by default:
- The counter interface shows a zero value by default for 'ceiling'
  attribute.
- Enabling the counter without any prior configuration makes it doesn't
  count.

The reset value of ARR register is the maximum. So Choice here
is to backup it, and restore it then, instead of clearing its value.
It also fixes the initial condition seen by the counter driver.

Fixes: d0f949e220fd ("mfd: Add STM32 Timers driver")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stm32-timers.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stm32-timers.c b/drivers/mfd/stm32-timers.c
index a6675a449409..e280e0ff2dcc 100644
--- a/drivers/mfd/stm32-timers.c
+++ b/drivers/mfd/stm32-timers.c
@@ -20,13 +20,18 @@ static const struct regmap_config stm32_timers_regmap_cfg = {
 
 static void stm32_timers_get_arr_size(struct stm32_timers *ddata)
 {
+	u32 arr;
+
+	/* Backup ARR to restore it after getting the maximum value */
+	regmap_read(ddata->regmap, TIM_ARR, &arr);
+
 	/*
 	 * Only the available bits will be written so when readback
 	 * we get the maximum value of auto reload register
 	 */
 	regmap_write(ddata->regmap, TIM_ARR, ~0L);
 	regmap_read(ddata->regmap, TIM_ARR, &ddata->max_arr);
-	regmap_write(ddata->regmap, TIM_ARR, 0x0);
+	regmap_write(ddata->regmap, TIM_ARR, arr);
 }
 
 static int stm32_timers_probe(struct platform_device *pdev)
-- 
2.30.2



