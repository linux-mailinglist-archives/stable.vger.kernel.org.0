Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7036581B4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiL1QbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiL1Qaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8451CB0B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59525B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE2AC433D2;
        Wed, 28 Dec 2022 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244817;
        bh=ZOJDY+bFvZ1DNZuIJQdi9c3Fo1VNfbpy3RHy5PuQMWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6VaBgjb6RPeewHMRLAVf3WdL5yN2amF/t97FUSOlAnI2GrI8Ze3rf4vu2LU6PC77
         KtuYxkmK4LEo/J/RMrdIiuB054lkbHtBs8O3c3WGbdzeyqhDVBNpgSCgeD+fsuV9u+
         OrqJ809Cdyyqud+iX8+wOMiEdU2QmVXDIrmD90TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jon Hunter <jonathanh@nvidia.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0779/1073] pwm: tegra: Ensure the clock rate is not less than needed
Date:   Wed, 28 Dec 2022 15:39:27 +0100
Message-Id: <20221228144349.170487805@linuxfoundation.org>
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

[ Upstream commit 5eccd0d9fabc4d2ab8d2a0c056fb1d7e2ff892fc ]

When dynamically scaling the PWM clock, the function
dev_pm_opp_set_rate() may set the PWM clock to a rate that is lower than
what is required. The clock rate requested when calling
dev_pm_opp_set_rate() is the minimum clock rate that is needed to drive
the PWM to achieve the required period. Hence, if the actual clock
rate is less than the requested clock rate, then the required period
cannot be achieved and configuring the PWM fails. Fix this by
calling clk_round_rate() to check if the clock rate that will be provided
is sufficient and if not, double the required clock rate to ensure the
required period can be attained.

Fixes: 8c193f4714df ("pwm: tegra: Optimize period calculation")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tegra.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index b05ea2e8accc..6fc4b69a3ba7 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -148,6 +148,17 @@ static int tegra_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
 						     period_ns);
 
+		if (required_clk_rate > clk_round_rate(pc->clk, required_clk_rate))
+			/*
+			 * required_clk_rate is a lower bound for the input
+			 * rate; for lower rates there is no value for PWM_SCALE
+			 * that yields a period less than or equal to the
+			 * requested period. Hence, for lower rates, double the
+			 * required_clk_rate to get a clock rate that can meet
+			 * the requested period.
+			 */
+			required_clk_rate *= 2;
+
 		err = dev_pm_opp_set_rate(pc->dev, required_clk_rate);
 		if (err < 0)
 			return -EINVAL;
-- 
2.35.1



