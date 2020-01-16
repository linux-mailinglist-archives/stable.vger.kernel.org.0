Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881DC13F573
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389138AbgAPRHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgAPRHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDCCD20663;
        Thu, 16 Jan 2020 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194437;
        bh=C7GWMH4e8A+00KK7ertF2ir/PvFAXPbJTUdWcrjSCdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTiYYdLO4saJtXbaXGO1UcOG28/HiZNQFl+im+BBBcSR+FJNkvr141s/IjK+4SB9Q
         x+RP72Ss86l10Fn5PZf5gQl/eOd7jVGHVWN8Tem9tBAxyi+gBTEsXViWvFJzXRlQ4y
         CMaW4eJeGxaVLR4bD4+zSyt2sqppyg3Xlx8bbWZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bichao Zheng <bichao.zheng@amlogic.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 351/671] pwm: meson: Don't disable PWM when setting duty repeatedly
Date:   Thu, 16 Jan 2020 11:59:49 -0500
Message-Id: <20200116170509.12787-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bichao Zheng <bichao.zheng@amlogic.com>

[ Upstream commit a279345807e1e0ae79567a52cfdd9d30c9174a3c ]

There is an abnormally low about 20ms,when setting duty repeatedly.
Because setting the duty will disable PWM and then enable. Delete
this operation now.

Fixes: 211ed630753d2f ("pwm: Add support for Meson PWM Controller")
Signed-off-by: Bichao Zheng <bichao.zheng@amlogic.com>
[ Dropped code instead of hiding it behind a comment ]
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 4b708c1fcb1d..e247ab632530 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -325,11 +325,6 @@ static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (state->period != channel->state.period ||
 	    state->duty_cycle != channel->state.duty_cycle ||
 	    state->polarity != channel->state.polarity) {
-		if (channel->state.enabled) {
-			meson_pwm_disable(meson, pwm->hwpwm);
-			channel->state.enabled = false;
-		}
-
 		if (state->polarity != channel->state.polarity) {
 			if (state->polarity == PWM_POLARITY_NORMAL)
 				meson->inverter_mask |= BIT(pwm->hwpwm);
-- 
2.20.1

