Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6216E91B4
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjDTLF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbjDTLEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774E06593;
        Thu, 20 Apr 2023 04:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D56A8647CF;
        Thu, 20 Apr 2023 11:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A62C4339C;
        Thu, 20 Apr 2023 11:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988531;
        bh=q5WtqATHSEDJyHfny5vrSARBb3qcLAUJXK6AMpRQOiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1gZgCZSIsvXR9rnLRt2hV3jpahCX8Vzg0OcDEYM0kKqC0DVHSEDKY0u4oukUfdi5
         9UAds0kCUyTeEc2UQ0dOq61WXxzjkx8dwOCAXEqpfaUVZ75STkyNbQU5lhJj2vUUdK
         wtnxNyQYpFOysU8DpQOdY+LiMuCnfOdl/GPCg0lgjjYuXUFmOTVJvyYrZefRFVpq+0
         gbtTdvzJRHdLUkqUIDSLduvTbwmoZhi+Y74ghQ80eprgngOrCnA0QJ/Ps3FLHSyOKt
         bXYs1w8txQ766E/U55+jlCCACrN4u8+GcRXt51Tp5AvN9OGU9CfKU+gcvRdDygXcsC
         tl6yhbJv46dwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Munehisa Kamata <kamatam@amazon.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 08/17] pwm: Zero-initialize the pwm_state passed to driver's .get_state()
Date:   Thu, 20 Apr 2023 07:01:37 -0400
Message-Id: <20230420110148.505779-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 1271a7b98e7989ba6bb978e14403fc84efe16e13 ]

This is just to ensure that .usage_power is properly initialized and
doesn't contain random stack data. The other members of struct pwm_state
should get a value assigned in a successful call to .get_state(). So in
the absence of bugs in driver implementations, this is only a safe-guard
and no fix.

Reported-by: Munehisa Kamata <kamatam@amazon.com>
Link: https://lore.kernel.org/r/20230310214004.2619480-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index e01147f66e15a..474725714a05b 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -115,7 +115,14 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 	}
 
 	if (pwm->chip->ops->get_state) {
-		struct pwm_state state;
+		/*
+		 * Zero-initialize state because most drivers are unaware of
+		 * .usage_power. The other members of state are supposed to be
+		 * set by lowlevel drivers. We still initialize the whole
+		 * structure for simplicity even though this might paper over
+		 * faulty implementations of .get_state().
+		 */
+		struct pwm_state state = { 0, };
 
 		err = pwm->chip->ops->get_state(pwm->chip, pwm, &state);
 		trace_pwm_get(pwm, &state, err);
@@ -448,7 +455,7 @@ static void pwm_apply_state_debug(struct pwm_device *pwm,
 {
 	struct pwm_state *last = &pwm->last;
 	struct pwm_chip *chip = pwm->chip;
-	struct pwm_state s1, s2;
+	struct pwm_state s1 = { 0 }, s2 = { 0 };
 	int err;
 
 	if (!IS_ENABLED(CONFIG_PWM_DEBUG))
@@ -530,6 +537,7 @@ static void pwm_apply_state_debug(struct pwm_device *pwm,
 		return;
 	}
 
+	*last = (struct pwm_state){ 0 };
 	err = chip->ops->get_state(chip, pwm, last);
 	trace_pwm_get(pwm, last, err);
 	if (err)
-- 
2.39.2

