Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B61053162E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbiEWRKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiEWRJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:09:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510156BFF9;
        Mon, 23 May 2022 10:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A820B81204;
        Mon, 23 May 2022 17:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A38C385A9;
        Mon, 23 May 2022 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325731;
        bh=Iz1rFFV2zMZoyT84NHl2an8DW4gPUQsmz3WeEuVpS74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmE8cE8XqeywmwTM6plmw5U+kWZbNlfeiofS3T5K5YcUAMpPtNQYiPPn+ypocn7J2
         W0C/Z4omV/7QTT7sulNBFcx0hZc24RDFi8kYAIpa0QMtMrQ7bw1uwJyqfVCUlISgOP
         5I1x3h/L+JXw+aec0YsFWUwdGAsJyKlrpwIVsLnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/33] gpio: mvebu/pwm: Refuse requests with inverted polarity
Date:   Mon, 23 May 2022 19:05:14 +0200
Message-Id: <20220523165752.546367189@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
References: <20220523165746.957506211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3ecb10175b1f776f076553c24e2689e42953fef5 ]

The driver doesn't take struct pwm_state::polarity into account when
configuring the hardware, so refuse requests for inverted polarity.

Fixes: 757642f9a584 ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index b14d481ab7db..cbad11029c67 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -694,6 +694,9 @@ static int mvebu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long flags;
 	unsigned int on, off;
 
+	if (state->polarity != PWM_POLARITY_NORMAL)
+		return -EINVAL;
+
 	val = (unsigned long long) mvpwm->clk_rate * state->duty_cycle;
 	do_div(val, NSEC_PER_SEC);
 	if (val > UINT_MAX)
-- 
2.35.1



