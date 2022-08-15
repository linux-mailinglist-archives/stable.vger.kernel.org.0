Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8550B593995
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbiHOSmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243815AbiHOSl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423123F32A;
        Mon, 15 Aug 2022 11:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEB41B80F99;
        Mon, 15 Aug 2022 18:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CD3C433D6;
        Mon, 15 Aug 2022 18:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587902;
        bh=UF5GPIszFRHwpo/77bs1bWbnNvzx9uno6HUPVgnvNao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPf5cRvjf2EIFMPV7OauN6gY4yCMlT9VclNlyujHy8zAZyt/4Znku91ZoKdinvFQd
         Lcx1A+y6VZ8Mu5TxU1KKYR3d23SmYXhbKc6xYvTh/BRAkYy0nHHPh6O36gcmuZgf66
         edMjZLFwNQcJI5Ra4ZZZ/2lDyPFbFOmTeSXU+fCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/779] pwm: lpc18xx-sct: Simplify driver by not using pwm_[gs]et_chip_data()
Date:   Mon, 15 Aug 2022 19:57:56 +0200
Message-Id: <20220815180347.200305319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 9136a39e6cf69e49803ac6123a4ac4431bc915a2 ]

The per-channel data is available directly in the driver data struct. So
use it without making use of pwm_[gs]et_chip_data().

The relevant change introduced by this patch to lpc18xx_pwm_disable() at
the assembler level (for an arm lpc18xx_defconfig build) is:

	push    {r3, r4, r5, lr}
	mov     r4, r0
	mov     r0, r1
	mov     r5, r1
	bl      0 <pwm_get_chip_data>
	ldr     r3, [r0, #0]

changes to

	ldr     r3, [r1, #8]
	push    {r4, lr}
	add.w   r3, r0, r3, lsl #2
	ldr     r3, [r3, #92]   ; 0x5c

So this reduces stack usage, has an improved runtime behavior because of
better pipeline usage, doesn't branch to an external function and the
generated code is a bit smaller occupying less memory.

The codesize of lpc18xx_pwm_probe() is reduced by 32 bytes.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpc18xx-sct.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/pwm/pwm-lpc18xx-sct.c b/drivers/pwm/pwm-lpc18xx-sct.c
index 6cf02554066c..b909096dba2f 100644
--- a/drivers/pwm/pwm-lpc18xx-sct.c
+++ b/drivers/pwm/pwm-lpc18xx-sct.c
@@ -166,7 +166,7 @@ static void lpc18xx_pwm_config_duty(struct pwm_chip *chip,
 				    struct pwm_device *pwm, int duty_ns)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	struct lpc18xx_pwm_data *lpc18xx_data = pwm_get_chip_data(pwm);
+	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
 	u64 val;
 
 	val = (u64)duty_ns * lpc18xx_pwm->clk_rate;
@@ -236,7 +236,7 @@ static int lpc18xx_pwm_set_polarity(struct pwm_chip *chip,
 static int lpc18xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	struct lpc18xx_pwm_data *lpc18xx_data = pwm_get_chip_data(pwm);
+	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
 	enum lpc18xx_pwm_res_action res_action;
 	unsigned int set_event, clear_event;
 
@@ -271,7 +271,7 @@ static int lpc18xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 static void lpc18xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	struct lpc18xx_pwm_data *lpc18xx_data = pwm_get_chip_data(pwm);
+	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
 
 	lpc18xx_pwm_writel(lpc18xx_pwm,
 			   LPC18XX_PWM_EVCTRL(lpc18xx_data->duty_event), 0);
@@ -282,7 +282,7 @@ static void lpc18xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 static int lpc18xx_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	struct lpc18xx_pwm_data *lpc18xx_data = pwm_get_chip_data(pwm);
+	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
 	unsigned long event;
 
 	event = find_first_zero_bit(&lpc18xx_pwm->event_map,
@@ -303,7 +303,7 @@ static int lpc18xx_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 static void lpc18xx_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm = to_lpc18xx_pwm_chip(chip);
-	struct lpc18xx_pwm_data *lpc18xx_data = pwm_get_chip_data(pwm);
+	struct lpc18xx_pwm_data *lpc18xx_data = &lpc18xx_pwm->channeldata[pwm->hwpwm];
 
 	clear_bit(lpc18xx_data->duty_event, &lpc18xx_pwm->event_map);
 }
@@ -327,8 +327,7 @@ MODULE_DEVICE_TABLE(of, lpc18xx_pwm_of_match);
 static int lpc18xx_pwm_probe(struct platform_device *pdev)
 {
 	struct lpc18xx_pwm_chip *lpc18xx_pwm;
-	struct pwm_device *pwm;
-	int ret, i;
+	int ret;
 	u64 val;
 
 	lpc18xx_pwm = devm_kzalloc(&pdev->dev, sizeof(*lpc18xx_pwm),
@@ -398,16 +397,6 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_LIMIT,
 			   BIT(lpc18xx_pwm->period_event));
 
-	for (i = 0; i < lpc18xx_pwm->chip.npwm; i++) {
-		struct lpc18xx_pwm_data *data;
-
-		pwm = &lpc18xx_pwm->chip.pwms[i];
-
-		data = &lpc18xx_pwm->channeldata[i];
-
-		pwm_set_chip_data(pwm, data);
-	}
-
 	val = lpc18xx_pwm_readl(lpc18xx_pwm, LPC18XX_PWM_CTRL);
 	val &= ~LPC18XX_PWM_BIDIR;
 	val &= ~LPC18XX_PWM_CTRL_HALT;
-- 
2.35.1



