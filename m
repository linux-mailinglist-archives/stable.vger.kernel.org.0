Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB553290EA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbhCAURU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242360AbhCAUHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65084653A9;
        Mon,  1 Mar 2021 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621565;
        bh=Ph39ukhHNn64Qp+Lp14z1tuqyChN+Y7Q8EkecGp+96U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ngn969lN0Tz/Y0bBG74duwYSCdwxYdasTg3XGdYe5nIJWz03GkCobAM6B+0QoQZQu
         mmvhtM8FXpY7SA6/PDXetiBuQSapIt92NozW2QUkmgUy+D9479rthOYLu9AvOwAipR
         gYD1MmQ/ytmjmJfyuzNgyEQTgrCuy1uJIJX0kJnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 533/775] pwm: iqs620a: Fix overflow and optimize calculations
Date:   Mon,  1 Mar 2021 17:11:41 +0100
Message-Id: <20210301161227.829507175@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 72d6b2459dbd539c1369149e501fdc3dc8ddef16 ]

If state->duty_cycle is 0x100000000000000, the previous calculation of
duty_scale overflows and yields a duty cycle ratio of 0% instead of
100%. Fix this by clamping the requested duty cycle to the maximal
possible duty cycle first. This way it is possible to use a native
integer division instead of a (depending on the architecture) more
expensive 64bit division.

With this change in place duty_scale cannot be bigger than 256 which
allows to simplify the calculation of duty_val.

Fixes: 6f0841a8197b ("pwm: Add support for Azoteq IQS620A PWM generator")
Tested-by: Jeff LaBundy <jeff@labundy.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-iqs620a.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-iqs620a.c b/drivers/pwm/pwm-iqs620a.c
index 5ede8255926ef..14b18fb4f5274 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -46,7 +46,8 @@ static int iqs620_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 {
 	struct iqs620_pwm_private *iqs620_pwm;
 	struct iqs62x_core *iqs62x;
-	u64 duty_scale;
+	unsigned int duty_cycle;
+	unsigned int duty_scale;
 	int ret;
 
 	if (state->polarity != PWM_POLARITY_NORMAL)
@@ -70,7 +71,8 @@ static int iqs620_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	 * For lower duty cycles (e.g. 0), the PWM output is simply disabled to
 	 * allow an external pull-down resistor to hold the GPIO3/LTX pin low.
 	 */
-	duty_scale = div_u64(state->duty_cycle * 256, IQS620_PWM_PERIOD_NS);
+	duty_cycle = min_t(u64, state->duty_cycle, IQS620_PWM_PERIOD_NS);
+	duty_scale = duty_cycle * 256 / IQS620_PWM_PERIOD_NS;
 
 	mutex_lock(&iqs620_pwm->lock);
 
@@ -82,7 +84,7 @@ static int iqs620_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	}
 
 	if (duty_scale) {
-		u8 duty_val = min_t(u64, duty_scale - 1, 0xff);
+		u8 duty_val = duty_scale - 1;
 
 		ret = regmap_write(iqs62x->regmap, IQS620_PWM_DUTY_CYCLE,
 				   duty_val);
-- 
2.27.0



