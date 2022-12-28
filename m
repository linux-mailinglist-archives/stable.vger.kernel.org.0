Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E6F658300
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiL1Qn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiL1Qn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DC8BF2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5AB61572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20458C433D2;
        Wed, 28 Dec 2022 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245471;
        bh=XgXKQ4lJt3xgbn4wnwUGVj4qQSLeGJDxzzr5jcmLDYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eXjrOb/pnyMWYVsSF700vit2tYGSU+fTeWGpL8ytXlqki0fygQiiL2SBXTAbUBfq
         mxIliuyN/WF56PHZf4zWq8VdDwzn6KUeoL4B1aHYc7HHfcgREQ1Rx1StWQvKwXgaOo
         4wEseXACwh6I6+XI7UH8UXbvf5M3K/G5sT+x/yf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, xinlei lee <xinlei.lee@mediatek.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0867/1146] pwm: mtk-disp: Fix the parameters calculated by the enabled flag of disp_pwm
Date:   Wed, 28 Dec 2022 15:40:06 +0100
Message-Id: <20221228144353.718909018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: xinlei lee <xinlei.lee@mediatek.com>

[ Upstream commit 0b5ef3429d8f78427558ab0dcbfd862098ba2a63 ]

In the original mtk_disp_pwm_get_state() function wrongly uses bit 0 of
CON0 to judge if the PWM is enabled.
However that is indicated by a bit (at a machine dependent position) in
the DISP_PWM_EN register. Fix this accordingly.

Fixes: 3f2b16734914 ("pwm: mtk-disp: Implement atomic API .get_state()")
Signed-off-by: xinlei lee <xinlei.lee@mediatek.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/1666172538-11652-1-git-send-email-xinlei.lee@mediatek.com
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index c605013e4114..3fbb4bae93a4 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -178,7 +178,7 @@ static void mtk_disp_pwm_get_state(struct pwm_chip *chip,
 {
 	struct mtk_disp_pwm *mdp = to_mtk_disp_pwm(chip);
 	u64 rate, period, high_width;
-	u32 clk_div, con0, con1;
+	u32 clk_div, pwm_en, con0, con1;
 	int err;
 
 	err = clk_prepare_enable(mdp->clk_main);
@@ -197,7 +197,8 @@ static void mtk_disp_pwm_get_state(struct pwm_chip *chip,
 	rate = clk_get_rate(mdp->clk_main);
 	con0 = readl(mdp->base + mdp->data->con0);
 	con1 = readl(mdp->base + mdp->data->con1);
-	state->enabled = !!(con0 & BIT(0));
+	pwm_en = readl(mdp->base + DISP_PWM_EN);
+	state->enabled = !!(pwm_en & mdp->data->enable_mask);
 	clk_div = FIELD_GET(PWM_CLKDIV_MASK, con0);
 	period = FIELD_GET(PWM_PERIOD_MASK, con1);
 	/*
-- 
2.35.1



