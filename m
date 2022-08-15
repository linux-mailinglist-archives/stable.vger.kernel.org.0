Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF75938AF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242408AbiHOSof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242444AbiHOSmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F287B2B634;
        Mon, 15 Aug 2022 11:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F21460FA2;
        Mon, 15 Aug 2022 18:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA21C433C1;
        Mon, 15 Aug 2022 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587987;
        bh=vrIzN52GEEHh/T0R5cqvOZOYcnv5hQLjIKksDxnlmEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFT4n5HIyD1iEfXfdW7qihANasROOk9E2lZIaV0fxDawrn5DH2XLHQ3RF61050N0X
         AMrKqUoBRRl4ZpriIJSlaXdhvD9dC3iKTRjJOivUjjqbyfTN4q+gkmm+V/nw+XJqrS
         YfsL4qiIrTMpnz+XE3XWuI2T9vHV0v5AOtFbzOlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/779] pwm: sifive: Simplify offset calculation for PWMCMP registers
Date:   Mon, 15 Aug 2022 19:57:52 +0200
Message-Id: <20220815180347.042370561@linuxfoundation.org>
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

[ Upstream commit 20550a61880fc55e68a0d290ad195b74729c0e7b ]

Instead of explicitly using PWM_SIFIVE_PWMCMP0 + pwm->hwpwm *
PWM_SIFIVE_SIZE_PWMCMP for each access to one of the PWMCMP registers,
introduce a macro that takes the hwpwm id as parameter.

For the register definition using a plain 4 instead of the cpp constant
PWM_SIFIVE_SIZE_PWMCMP is easier to read, so define the offset macro
without the constant. The latter can then be dropped as there are no
users left.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 253c4a17d255..a55f7345dc87 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -23,7 +23,7 @@
 #define PWM_SIFIVE_PWMCFG		0x0
 #define PWM_SIFIVE_PWMCOUNT		0x8
 #define PWM_SIFIVE_PWMS			0x10
-#define PWM_SIFIVE_PWMCMP0		0x20
+#define PWM_SIFIVE_PWMCMP(i)		(0x20 + 4 * (i))
 
 /* PWMCFG fields */
 #define PWM_SIFIVE_PWMCFG_SCALE		GENMASK(3, 0)
@@ -36,8 +36,6 @@
 #define PWM_SIFIVE_PWMCFG_GANG		BIT(24)
 #define PWM_SIFIVE_PWMCFG_IP		BIT(28)
 
-/* PWM_SIFIVE_SIZE_PWMCMP is used to calculate offset for pwmcmpX registers */
-#define PWM_SIFIVE_SIZE_PWMCMP		4
 #define PWM_SIFIVE_CMPWIDTH		16
 #define PWM_SIFIVE_DEFAULT_PERIOD	10000000
 
@@ -112,8 +110,7 @@ static void pwm_sifive_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_sifive_ddata *ddata = pwm_sifive_chip_to_ddata(chip);
 	u32 duty, val;
 
-	duty = readl(ddata->regs + PWM_SIFIVE_PWMCMP0 +
-		     pwm->hwpwm * PWM_SIFIVE_SIZE_PWMCMP);
+	duty = readl(ddata->regs + PWM_SIFIVE_PWMCMP(pwm->hwpwm));
 
 	state->enabled = duty > 0;
 
@@ -194,8 +191,7 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		pwm_sifive_update_clock(ddata, clk_get_rate(ddata->clk));
 	}
 
-	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP0 +
-	       pwm->hwpwm * PWM_SIFIVE_SIZE_PWMCMP);
+	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP(pwm->hwpwm));
 
 	if (state->enabled != enabled)
 		pwm_sifive_enable(chip, state->enabled);
-- 
2.35.1



