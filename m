Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6C59496D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbiHOXN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352800AbiHOXMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8C274CEB;
        Mon, 15 Aug 2022 13:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68355B80EB1;
        Mon, 15 Aug 2022 20:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB6C433C1;
        Mon, 15 Aug 2022 20:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593645;
        bh=y3f1Ezg+rUCk+EdK3CnTflc75Nt5LJa0SLevHviZC8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hw67W5LkDVomEipsOU1J2M+u26KsWzYhx7HMEUrcm/exrvPcPa2jlv4udyF4Y7DC3
         JQitL5aN6a97BTqvgEtYPM2oFd9Ujyo149pJjtP2XF1L1ji6/FHHjLhud72lEe9Yzx
         zz2iDTQQ8gSN0pbTmLCpNIK9XW5Z+bWUknL0gwqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0301/1157] pwm: sifive: Ensure the clk is enabled exactly once per running PWM
Date:   Mon, 15 Aug 2022 19:54:17 +0200
Message-Id: <20220815180451.693166637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit ace41d7564e655c39f709a78c035188a460c7cbd ]

.apply() assumes the clk to be for a given PWM iff the PWM is enabled.
So make sure this is the case when .probe() completes. And in .remove()
disable the according number of times.

This fixes a clk enable/disable imbalance, if some PWMs are already running
at probe time.

Fixes: 9e37a53eb051 (pwm: sifive: Add a driver for SiFive SoC PWM)
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 46 ++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index b7fc33b08d82..3fbc1d96fcb6 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -228,6 +228,8 @@ static int pwm_sifive_probe(struct platform_device *pdev)
 	struct pwm_sifive_ddata *ddata;
 	struct pwm_chip *chip;
 	int ret;
+	u32 val;
+	unsigned int enabled_pwms = 0, enabled_clks = 1;
 
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
@@ -254,6 +256,33 @@ static int pwm_sifive_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	val = readl(ddata->regs + PWM_SIFIVE_PWMCFG);
+	if (val & PWM_SIFIVE_PWMCFG_EN_ALWAYS) {
+		unsigned int i;
+
+		for (i = 0; i < chip->npwm; ++i) {
+			val = readl(ddata->regs + PWM_SIFIVE_PWMCMP(i));
+			if (val > 0)
+				++enabled_pwms;
+		}
+	}
+
+	/* The clk should be on once for each running PWM. */
+	if (enabled_pwms) {
+		while (enabled_clks < enabled_pwms) {
+			/* This is not expected to fail as the clk is already on */
+			ret = clk_enable(ddata->clk);
+			if (unlikely(ret)) {
+				dev_err_probe(dev, ret, "Failed to enable clk\n");
+				goto disable_clk;
+			}
+			++enabled_clks;
+		}
+	} else {
+		clk_disable(ddata->clk);
+		enabled_clks = 0;
+	}
+
 	/* Watch for changes to underlying clock frequency */
 	ddata->notifier.notifier_call = pwm_sifive_clock_notifier;
 	ret = clk_notifier_register(ddata->clk, &ddata->notifier);
@@ -276,7 +305,11 @@ static int pwm_sifive_probe(struct platform_device *pdev)
 unregister_clk:
 	clk_notifier_unregister(ddata->clk, &ddata->notifier);
 disable_clk:
-	clk_disable_unprepare(ddata->clk);
+	while (enabled_clks) {
+		clk_disable(ddata->clk);
+		--enabled_clks;
+	}
+	clk_unprepare(ddata->clk);
 
 	return ret;
 }
@@ -284,21 +317,16 @@ static int pwm_sifive_probe(struct platform_device *pdev)
 static int pwm_sifive_remove(struct platform_device *dev)
 {
 	struct pwm_sifive_ddata *ddata = platform_get_drvdata(dev);
-	bool is_enabled = false;
 	struct pwm_device *pwm;
 	int ch;
 
 	for (ch = 0; ch < ddata->chip.npwm; ch++) {
 		pwm = &ddata->chip.pwms[ch];
-		if (pwm->state.enabled) {
-			is_enabled = true;
-			break;
-		}
+		if (pwm->state.enabled)
+			clk_disable(ddata->clk);
 	}
-	if (is_enabled)
-		clk_disable(ddata->clk);
 
-	clk_disable_unprepare(ddata->clk);
+	clk_unprepare(ddata->clk);
 	pwmchip_remove(&ddata->chip);
 	clk_notifier_unregister(ddata->clk, &ddata->notifier);
 
-- 
2.35.1



