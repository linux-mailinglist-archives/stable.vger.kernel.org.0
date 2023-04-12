Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CC6DEF19
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDLIr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjDLIrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE97876BB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E364630FE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64111C433D2;
        Wed, 12 Apr 2023 08:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289210;
        bh=4ME93WdH8k7QmOTHF00sHBhSAAQzBvK1cDJ8QTHypkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmfpPSfP1QlgqurcpcDSOvVOZfksq90qLaeL9mreIKvYpHQp8AVryvPF5MmKIaLbW
         w3gH2SlwjhLLmRqNSl2crR9BldR/M0q8JK60iip/rAf1uCp4ovWHs0YjirzeVAtdtO
         NSjukYrvbK+D4ODHbmMHqbfQEGjH/537mCEiI5Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 013/173] pwm: sprd: Explicitly set .polarity in .get_state()
Date:   Wed, 12 Apr 2023 10:32:19 +0200
Message-Id: <20230412082838.638064340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index d866ce345f977..bde579a338c27 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -109,6 +109,7 @@ static int sprd_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = val & SPRD_PWM_DUTY_MSK;
 	tmp = (prescale + 1) * NSEC_PER_SEC * duty;
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, chn->clk_rate);
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Disable PWM clocks if the PWM channel is not in enable state. */
 	if (!state->enabled)
-- 
2.39.2



