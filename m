Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAA2328D32
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241012AbhCATHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240836AbhCATBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5606465060;
        Mon,  1 Mar 2021 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619407;
        bh=8SHH06qCYKkTODRXIYuyLJaQQAs1q9MZMNiaMMhVXcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KX7blFqvSOzlDXB70iFQ7rPvYevfByX9GKOY5upnE9H0QCUj/G5zj17Pqx7jxZEbY
         rV/rw1foNw+ECBznTllUAfKmCCa3ehRz9N/GR8Q3ZfEk1wn3fkHAL4RMaViZ3l3qK5
         WB0n3flvZrCDFYPN+0zuws7eT+70/f54DZ46V1LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/663] pwm: iqs620a: Fix overflow and optimize calculations
Date:   Mon,  1 Mar 2021 17:11:31 +0100
Message-Id: <20210301161203.817772234@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 7d33e36464360..3e967a12458c6 100644
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



