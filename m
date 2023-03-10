Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23576B4646
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjCJOlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbjCJOlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:41:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB63122CD4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D161B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BEDC4339E;
        Fri, 10 Mar 2023 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459296;
        bh=9Wd3+A7H74RVfJiZ95w/ViiZImUKdM+UsNe/rGiW5IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA2XuBys4EbgtVsV/zDco33LhzDFqJYjpXRWU0ZJddM2TSnKkHNPPMXms/EV6rd7S
         Cu/FrUBn1UK5eRpJE1uczSEvqKQF+do377qhFyq1cEE31KioIOebDNihntXHYhPQMM
         IO2BSWfyIDtcpkQ2MvBm6VbvuNnBkNYFbCEaYHXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 287/357] pwm: stm32-lp: fix the check on arr and cmp registers update
Date:   Fri, 10 Mar 2023 14:39:36 +0100
Message-Id: <20230310133747.424753491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 3066bc2d58be31275afb51a589668f265e419c37 ]

The ARR (auto reload register) and CMP (compare) registers are
successively written. The status bits to check the update of these
registers are polled together with regmap_read_poll_timeout().
The condition to end the loop may become true, even if one of the
register isn't correctly updated.
So ensure both status bits are set before clearing them.

Fixes: e70a540b4e02 ("pwm: Add STM32 LPTimer PWM driver")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32-lp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 05bb1f95a7739..20657c649c65e 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -127,7 +127,7 @@ static int stm32_pwm_lp_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
-				       (val & STM32_LPTIM_CMPOK_ARROK),
+				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret) {
 		dev_err(priv->chip.dev, "ARR/CMP registers write issue\n");
-- 
2.39.2



