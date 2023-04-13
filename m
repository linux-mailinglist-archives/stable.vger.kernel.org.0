Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3166E0432
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjDMCgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjDMCgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:36:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27FD83FC;
        Wed, 12 Apr 2023 19:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155CA63A9C;
        Thu, 13 Apr 2023 02:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4BBC433D2;
        Thu, 13 Apr 2023 02:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353382;
        bh=q5WtqATHSEDJyHfny5vrSARBb3qcLAUJXK6AMpRQOiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFCByTVyWJf7QFKRUaP6SlIUkNV+Wt1obvHTWcH2hDTVdGWlYtCazIxsvYtDg+rdA
         3EzlUtYSeMeo4BNDH1PUQ1YdnGjXich3k+qeElqQ3oE35sokOUjGw8bJIIqX5W/fAU
         zkpWClgqhQqKrdHx3cADlZAakqmmvq0avEWtTGvnKOX2SEr2ItKBHnF0cVBKSaNACG
         QMSanAcLFrYKS7LBwOPTQ1ZCZLATRXCwd8c9q5RFo4K+mEszUAg5oXg2Pmn79t/Ac3
         +d8o/jnwHSB4WC1ftbsFMkSB6NgQUTZPfl2KiCS0xe+WWPFEF+NoeI5oTsjR4MNeaG
         bcEL9e8ORxYIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Munehisa Kamata <kamatam@amazon.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 08/20] pwm: Zero-initialize the pwm_state passed to driver's .get_state()
Date:   Wed, 12 Apr 2023 22:35:46 -0400
Message-Id: <20230413023601.74410-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

