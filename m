Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D83D6151
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhGZPal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237538AbhGZP3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 140566103B;
        Mon, 26 Jul 2021 16:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315688;
        bh=DprK3JZiE7ucwwm9RnXjSotyCkhGH7cFygpQE3pQyKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkY/MTG7EKsDtoEV8hKvgAthKR3TyhbbLf7sfcmGwROPoUnVY8QqMR680dFyZfk8O
         uu+jgiTfbFslM8oNHLKDMEDe27t7vUiFgfY/RbeIm4S/jwB35igh6tcgDnJC2k0y8u
         kqCpR08aphx3+ppNn+EkLAzRY1rGWsI3CZJOoSqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 027/223] pwm: sprd: Ensure configuring period and duty_cycle isnt wrongly skipped
Date:   Mon, 26 Jul 2021 17:36:59 +0200
Message-Id: <20210726153847.133487852@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index 98c479dfae31..3041f0b3bbb6 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -183,13 +183,10 @@ static int sprd_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
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



