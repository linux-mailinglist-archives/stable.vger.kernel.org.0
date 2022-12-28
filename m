Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C1E6581B1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiL1QbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiL1Qah (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:30:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878E61BE94
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519996157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CA8C433D2;
        Wed, 28 Dec 2022 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244811;
        bh=xiA8YweXtP5y68sH9U3r4YWn0jZmWZyVPNXq1vaYWaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tb1vtQ212AiDj+P69RKMptOzql01b2A9SDHpakruLvoPGQ+BmEA+igBX4OA1I1QfA
         emSoQDOXDqdTP8JlGsKAZ7nfoncrP28ltsx3XBrS6Fgalx6Wk8FfJGzICZE8sjKRki
         zt/7FjFVeatHb82fatZy12ocDix0DeOKUO0YEHOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Hunter <jonathanh@nvidia.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0778/1073] pwm: tegra: Improve required rate calculation
Date:   Wed, 28 Dec 2022 15:39:26 +0100
Message-Id: <20221228144349.143730814@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit f271946117dde2ca8741b8138b347b2d68e6ad56 ]

For the case where dev_pm_opp_set_rate() is called to set the PWM clock
rate, the requested rate is calculated as ...

 required_clk_rate = (NSEC_PER_SEC / period_ns) << PWM_DUTY_WIDTH;

The above calculation may lead to rounding errors because the
NSEC_PER_SEC is divided by 'period_ns' before applying the
PWM_DUTY_WIDTH multiplication factor. For example, if the period is
45334ns, the above calculation yields a rate of 5646848Hz instead of
5646976Hz. Fix this by applying the multiplication factor before
dividing and using the DIV_ROUND_UP macro which yields the expected
result of 5646976Hz.

Fixes: 1d7796bdb63a ("pwm: tegra: Support dynamic clock frequency configuration")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index dad9978c9186..b05ea2e8accc 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -145,8 +145,8 @@ static int tegra_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		 * source clock rate as required_clk_rate, PWM controller will
 		 * be able to configure the requested period.
 		 */
-		required_clk_rate =
-			(NSEC_PER_SEC / period_ns) << PWM_DUTY_WIDTH;
+		required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
+						     period_ns);
 
 		err = dev_pm_opp_set_rate(pc->dev, required_clk_rate);
 		if (err < 0)
-- 
2.35.1



