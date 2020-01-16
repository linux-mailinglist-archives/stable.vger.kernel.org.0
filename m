Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0896813F0D5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392421AbgAPR1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392417AbgAPR1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14059246D3;
        Thu, 16 Jan 2020 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195630;
        bh=PFQWB6yhTiykWY+nO5wBabV+FH2+zy+I/JKuaKCtjec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0YzvyhaJFjLqtLm8YZrzczSOtjXijCMiyt/9T61eo0k39YLGB1YGOh7MVSru++Sw
         KsqW9SvIFVFoeotndmgtxdzodiTvqAHt9PtlOJSs2tHhRdQssT+VnFLSMEdvrcZHO/
         lBH+9+5CYmm+IxK+1wwy7Td7BrH5WEnMJRzbLi00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 198/371] pwm: meson: Consider 128 a valid pre-divider
Date:   Thu, 16 Jan 2020 12:21:10 -0500
Message-Id: <20200116172403.18149-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 51496e4446875726d50a5617a6e0e0dabbc2e6da ]

The pre-divider allows configuring longer PWM periods compared to using
the input clock directly. The pre-divider is 7 bit wide, meaning it's
maximum value is 128 (the register value is off-by-one: 0x7f or 127).

Change the loop to also allow for the maximum possible value to be
considered valid.

Fixes: 211ed630753d2f ("pwm: Add support for Meson PWM Controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 9b79cbc7a715..9551f896dd6f 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -188,7 +188,7 @@ static int meson_pwm_calc(struct meson_pwm *meson,
 	do_div(fin_ps, fin_freq);
 
 	/* Calc pre_div with the period */
-	for (pre_div = 0; pre_div < MISC_CLK_DIV_MASK; pre_div++) {
+	for (pre_div = 0; pre_div <= MISC_CLK_DIV_MASK; pre_div++) {
 		cnt = DIV_ROUND_CLOSEST_ULL((u64)period * 1000,
 					    fin_ps * (pre_div + 1));
 		dev_dbg(meson->chip.dev, "fin_ps=%llu pre_div=%u cnt=%u\n",
@@ -197,7 +197,7 @@ static int meson_pwm_calc(struct meson_pwm *meson,
 			break;
 	}
 
-	if (pre_div == MISC_CLK_DIV_MASK) {
+	if (pre_div > MISC_CLK_DIV_MASK) {
 		dev_err(meson->chip.dev, "unable to get period pre_div\n");
 		return -EINVAL;
 	}
-- 
2.20.1

