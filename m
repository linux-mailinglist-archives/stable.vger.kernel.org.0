Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4622C31E53
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfFANfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbfFANXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA11240F2;
        Sat,  1 Jun 2019 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395390;
        bh=Abv9GsTyntkTHWoXQ9xFksd//sO3na6syWyCUco9TYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPzK1xSXCcmV7hK0NssgjaZUcpSnwUJX5GtmJcKDl7UXDBuIB2zwMTut6m3ORb2G5
         9ez2VvSkuiZdz2TqyWr8bIG9v/fw2YcxxDXjq8To/547xoJOMhBHkOrOy4xVYsetQh
         eaNMaapKD1TrRau4sIwuURJzm3igHTqyZlxIuFN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 031/141] pwm: meson: Use the spin-lock only to protect register modifications
Date:   Sat,  1 Jun 2019 09:20:07 -0400
Message-Id: <20190601132158.25821-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
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

[ Upstream commit f173747fffdf037c791405ab4f1ec0eb392fc48e ]

Holding the spin-lock for all of the code in meson_pwm_apply() can
result in a "BUG: scheduling while atomic". This can happen because
clk_get_rate() (which is called from meson_pwm_calc()) may sleep.
Only hold the spin-lock when modifying registers to solve this.

The reason why we need a spin-lock in the driver is because the
REG_MISC_AB register is shared between the two channels provided by one
PWM controller. The only functions where REG_MISC_AB is modified are
meson_pwm_enable() and meson_pwm_disable() so the register reads/writes
in there need to be protected by the spin-lock.

The original code also used the spin-lock to protect the values in
struct meson_pwm_channel. This could be necessary if two consumers can
use the same PWM channel. However, PWM core doesn't allow this so we
don't need to protect the values in struct meson_pwm_channel with a
lock.

Fixes: 211ed630753d2f ("pwm: Add support for Meson PWM Controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index c1ed641b3e266..f6e738ad7bd92 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -111,6 +111,10 @@ struct meson_pwm {
 	const struct meson_pwm_data *data;
 	void __iomem *base;
 	u8 inverter_mask;
+	/*
+	 * Protects register (write) access to the REG_MISC_AB register
+	 * that is shared between the two PWMs.
+	 */
 	spinlock_t lock;
 };
 
@@ -235,6 +239,7 @@ static void meson_pwm_enable(struct meson_pwm *meson,
 {
 	u32 value, clk_shift, clk_enable, enable;
 	unsigned int offset;
+	unsigned long flags;
 
 	switch (id) {
 	case 0:
@@ -255,6 +260,8 @@ static void meson_pwm_enable(struct meson_pwm *meson,
 		return;
 	}
 
+	spin_lock_irqsave(&meson->lock, flags);
+
 	value = readl(meson->base + REG_MISC_AB);
 	value &= ~(MISC_CLK_DIV_MASK << clk_shift);
 	value |= channel->pre_div << clk_shift;
@@ -267,11 +274,14 @@ static void meson_pwm_enable(struct meson_pwm *meson,
 	value = readl(meson->base + REG_MISC_AB);
 	value |= enable;
 	writel(value, meson->base + REG_MISC_AB);
+
+	spin_unlock_irqrestore(&meson->lock, flags);
 }
 
 static void meson_pwm_disable(struct meson_pwm *meson, unsigned int id)
 {
 	u32 value, enable;
+	unsigned long flags;
 
 	switch (id) {
 	case 0:
@@ -286,9 +296,13 @@ static void meson_pwm_disable(struct meson_pwm *meson, unsigned int id)
 		return;
 	}
 
+	spin_lock_irqsave(&meson->lock, flags);
+
 	value = readl(meson->base + REG_MISC_AB);
 	value &= ~enable;
 	writel(value, meson->base + REG_MISC_AB);
+
+	spin_unlock_irqrestore(&meson->lock, flags);
 }
 
 static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -296,19 +310,16 @@ static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 {
 	struct meson_pwm_channel *channel = pwm_get_chip_data(pwm);
 	struct meson_pwm *meson = to_meson_pwm(chip);
-	unsigned long flags;
 	int err = 0;
 
 	if (!state)
 		return -EINVAL;
 
-	spin_lock_irqsave(&meson->lock, flags);
-
 	if (!state->enabled) {
 		meson_pwm_disable(meson, pwm->hwpwm);
 		channel->state.enabled = false;
 
-		goto unlock;
+		return 0;
 	}
 
 	if (state->period != channel->state.period ||
@@ -329,7 +340,7 @@ static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		err = meson_pwm_calc(meson, channel, pwm->hwpwm,
 				     state->duty_cycle, state->period);
 		if (err < 0)
-			goto unlock;
+			return err;
 
 		channel->state.polarity = state->polarity;
 		channel->state.period = state->period;
@@ -341,9 +352,7 @@ static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		channel->state.enabled = true;
 	}
 
-unlock:
-	spin_unlock_irqrestore(&meson->lock, flags);
-	return err;
+	return 0;
 }
 
 static void meson_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
-- 
2.20.1

