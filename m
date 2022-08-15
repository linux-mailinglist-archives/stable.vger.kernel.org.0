Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FACE593F69
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbiHOU4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245561AbiHOUzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9253AE5E;
        Mon, 15 Aug 2022 12:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21BA160693;
        Mon, 15 Aug 2022 19:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B08C433D6;
        Mon, 15 Aug 2022 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590666;
        bh=tyewOjfDvcMDuNc0n8mcfNqZN/2ho/mbC0GukSH0x9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIrke1DWN1P2PSWw28oqW5/K+s39w3ToeKznsZnT/RmqFtN+LpAMugP/3LJTWxCr/
         5w56ZYECDSCkXlQKYPSc31fw/sWJw3VbOvkPgr54aBBUU2iJXAv1mNbWEWhEdKcQZs
         WRep0pbszTQFTI90M5t7w3AHYNz2fvZ16kh9Mkbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0301/1095] pwm: lpc18xx: Fix period handling
Date:   Mon, 15 Aug 2022 19:55:00 +0200
Message-Id: <20220815180442.224324010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8933d30c5f468d6cc1e4bf9bb535149da35f202e ]

The calculation:

	val = (u64)NSEC_PER_SEC * LPC18XX_PWM_TIMER_MAX;
	do_div(val, lpc18xx_pwm->clk_rate);
	lpc18xx_pwm->max_period_ns = val;

is bogus because with NSEC_PER_SEC = 1000000000,
LPC18XX_PWM_TIMER_MAX = 0xffffffff and clk_rate < NSEC_PER_SEC this
overflows the (on lpc18xx (i.e. ARM32) 32 bit wide) unsigned int
.max_period_ns. This results (dependant of the actual clk rate) in an
arbitrary limitation of the maximal period.  E.g. for clkrate =
333333333 (Hz) we get max_period_ns = 9 instead of 12884901897.

So make .max_period_ns an u64 and pass period and duty as u64 to not
discard relevant digits. And also make use of mul_u64_u64_div_u64()
which prevents all overflows assuming clk_rate < NSEC_PER_SEC.

Fixes: 841e6f90bb78 ("pwm: NXP LPC18xx PWM/SCT driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpc18xx-sct.c | 55 +++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/pwm/pwm-lpc18xx-sct.c b/drivers/pwm/pwm-lpc18xx-sct.c
index b909096dba2f..43b5509dde51 100644
--- a/drivers/pwm/pwm-lpc18xx-sct.c
+++ b/drivers/pwm/pwm-lpc18xx-sct.c
@@ -98,7 +98,7 @@ struct lpc18xx_pwm_chip {
 	unsigned long clk_rate;
 	unsigned int period_ns;
 	unsigned int min_period_ns;
-	unsigned int max_period_ns;
+	u64 max_period_ns;
 	unsigned int period_event;
 	unsigned long event_map;
 	struct mutex res_lock;
@@ -145,40 +145,48 @@ static void lpc18xx_pwm_set_conflict_res(struct lpc18xx_pwm_chip *lpc18xx_pwm,
 	mutex_unlock(&lpc18xx_pwm->res_lock);
 }
 
-static void lpc18xx_pwm_config_period(struct pwm_chip *chip, int period_ns)
+static void lpc18xx_pwm_config_period(struct pwm_chip *chip, u64 period_ns)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	u64 val;
+	u32 val;
 
-	val = (u64)period_ns * lpc18xx_pwm->clk_rate;
-	do_div(val, NSEC_PER_SEC);
+	/*
+	 * With clk_rate < NSEC_PER_SEC this cannot overflow.
+	 * With period_ns < max_period_ns this also fits into an u32.
+	 * As period_ns >= min_period_ns = DIV_ROUND_UP(NSEC_PER_SEC, lpc18xx_pwm->clk_rate);
+	 * we have val >= 1.
+	 */
+	val = mul_u64_u64_div_u64(period_ns, lpc18xx_pwm->clk_rate, NSEC_PER_SEC);
 
 	lpc18xx_pwm_writel(lpc18xx_pwm,
 			   LPC18XX_PWM_MATCH(lpc18xx_pwm->period_event),
-			   (u32)val - 1);
+			   val - 1);
 
 	lpc18xx_pwm_writel(lpc18xx_pwm,
 			   LPC18XX_PWM_MATCHREL(lpc18xx_pwm->period_event),
-			   (u32)val - 1);
+			   val - 1);
 }
 
 static void lpc18xx_pwm_config_duty(struct pwm_chip *chip,
-				    struct pwm_device *pwm, int duty_ns)
+				    struct pwm_device *pwm, u64 duty_ns)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
 	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
-	u64 val;
+	u32 val;
 
-	val = (u64)duty_ns * lpc18xx_pwm->clk_rate;
-	do_div(val, NSEC_PER_SEC);
+	/*
+	 * With clk_rate < NSEC_PER_SEC this cannot overflow.
+	 * With duty_ns <= period_ns < max_period_ns this also fits into an u32.
+	 */
+	val = mul_u64_u64_div_u64(duty_ns, lpc18xx_pwm->clk_rate, NSEC_PER_SEC);
 
 	lpc18xx_pwm_writel(lpc18xx_pwm,
 			   LPC18XX_PWM_MATCH(lpc18xx_data->duty_event),
-			   (u32)val);
+			   val);
 
 	lpc18xx_pwm_writel(lpc18xx_pwm,
 			   LPC18XX_PWM_MATCHREL(lpc18xx_data->duty_event),
-			   (u32)val);
+			   val);
 }
 
 static int lpc18xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -360,12 +368,27 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 		goto disable_pwmclk;
 	}
 
+	/*
+	 * If clkrate is too fast, the calculations in .apply() might overflow.
+	 */
+	if (lpc18xx_pwm->clk_rate > NSEC_PER_SEC) {
+		ret = dev_err_probe(&pdev->dev, -EINVAL, "pwm clock to fast\n");
+		goto disable_pwmclk;
+	}
+
+	/*
+	 * If clkrate is too fast, the calculations in .apply() might overflow.
+	 */
+	if (lpc18xx_pwm->clk_rate > NSEC_PER_SEC) {
+		ret = dev_err_probe(&pdev->dev, -EINVAL, "pwm clock to fast\n");
+		goto disable_pwmclk;
+	}
+
 	mutex_init(&lpc18xx_pwm->res_lock);
 	mutex_init(&lpc18xx_pwm->period_lock);
 
-	val = (u64)NSEC_PER_SEC * LPC18XX_PWM_TIMER_MAX;
-	do_div(val, lpc18xx_pwm->clk_rate);
-	lpc18xx_pwm->max_period_ns = val;
+	lpc18xx_pwm->max_period_ns =
+		mul_u64_u64_div_u64(NSEC_PER_SEC, LPC18XX_PWM_TIMER_MAX, lpc18xx_pwm->clk_rate);
 
 	lpc18xx_pwm->min_period_ns = DIV_ROUND_UP(NSEC_PER_SEC,
 						  lpc18xx_pwm->clk_rate);
-- 
2.35.1



