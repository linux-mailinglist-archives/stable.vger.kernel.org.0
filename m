Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6003D5F3A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhGZPRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237433AbhGZPPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5C96103C;
        Mon, 26 Jul 2021 15:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314912;
        bh=sW7SGcGUK+wi0VMcl567g8So86fyoV8sLU5MilePZZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tm/LUI73xAPzjur3rSGXlX2ws7teY7LQmhQhkpjjthdF0/Tvzmv8sbJ12h9786NOu
         Pe/QOuOpirNg5LbAHtW6k9Ncceddgt7+F8hdjF465pAcUHPJIVim8PihVeNWwe4zM8
         z2ZVbn7dip3+uyXIjB4UC74twGV4AUb8Opi5XdD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/108] pwm: sprd: Ensure configuring period and duty_cycle isnt wrongly skipped
Date:   Mon, 26 Jul 2021 17:38:18 +0200
Message-Id: <20210726153832.248287847@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 65e2e6c1c20104ed19060a38f4edbf14e9f9a9a5 ]

As the last call to sprd_pwm_apply() might have exited early if
state->enabled was false, the values for period and duty_cycle stored in
pwm->state might not have been written to hardware and it must be
ensured that they are configured before enabling the PWM.

Fixes: 8aae4b02e8a6 ("pwm: sprd: Add Spreadtrum PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sprd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-sprd.c b/drivers/pwm/pwm-sprd.c
index be2394227423..892d853d48a1 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -180,13 +180,10 @@ static int sprd_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			}
 		}
 
-		if (state->period != cstate->period ||
-		    state->duty_cycle != cstate->duty_cycle) {
-			ret = sprd_pwm_config(spc, pwm, state->duty_cycle,
-					      state->period);
-			if (ret)
-				return ret;
-		}
+		ret = sprd_pwm_config(spc, pwm, state->duty_cycle,
+				      state->period);
+		if (ret)
+			return ret;
 
 		sprd_pwm_write(spc, pwm->hwpwm, SPRD_PWM_ENABLE, 1);
 	} else if (cstate->enabled) {
-- 
2.30.2



