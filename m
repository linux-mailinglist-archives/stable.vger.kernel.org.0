Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0FE6E61EC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjDRM2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjDRM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FE8B758
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 142896319F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABD9C433EF;
        Tue, 18 Apr 2023 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820886;
        bh=mHDeLuATb0Edfl2VAZmaSajd0/sEp9bfXCq8VOWtcOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayBrXLDfN1t5y2FxPsP71dE2WojHsLjwrY7p0JNGJg6t3/mWQ1cqME++ReUqJOsf9
         5JL/eXDQ53YSwokj4zebSQ24qFfBR9oXw+KdOPTadUPsrhHmj9gHOre8M9R6nvLUt6
         iSxfuCikP5vJVesXzy6+NP5O9sTZ//4OIprG9WEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/92] pwm: sprd: Explicitly set .polarity in .get_state()
Date:   Tue, 18 Apr 2023 14:20:46 +0200
Message-Id: <20230418120305.157467859@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2be4dcf6627e1bcbbef8e6ba1811f5127d39202c ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Fixes: 8aae4b02e8a6 ("pwm: sprd: Add Spreadtrum PWM support")
Link: https://lore.kernel.org/r/20230228135508.1798428-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-sprd.c b/drivers/pwm/pwm-sprd.c
index 892d853d48a1a..b30d664bf7d57 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -109,6 +109,7 @@ static void sprd_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = val & SPRD_PWM_DUTY_MSK;
 	tmp = (prescale + 1) * NSEC_PER_SEC * duty;
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, chn->clk_rate);
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Disable PWM clocks if the PWM channel is not in enable state. */
 	if (!state->enabled)
-- 
2.39.2



