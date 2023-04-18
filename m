Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFB6E61BB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjDRM1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjDRM1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A10BB95
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 510C563184
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600E6C4339B;
        Tue, 18 Apr 2023 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820804;
        bh=Vau21lWs5g8ri0sto/y0CK9LkEAQjCEyKq9VkIME0hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR7F7XPNFbJrQ5NQxKkeZse9qa/37Y+9xqrej/CGlDbNuX36eNEGotS3vu3WQRHqI
         Ju4GVhfxiwUGvLS0oxHKd2d4y+dP814twxDohAZ67D7Z6n6mfgxLUZEWmy5kaRKb78
         Yn/ALhO+z78KN/00HzfwkNJimHdMS1pew+0RCG6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/57] pwm: cros-ec: Explicitly set .polarity in .get_state()
Date:   Tue, 18 Apr 2023 14:21:08 +0200
Message-Id: <20230418120259.011062755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
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

[ Upstream commit 30006b77c7e130e01d1ab2148cc8abf73dfcc4bf ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Reviewed-by: Guenter Roeck <groeck@chromium.org>
Fixes: 1f0d3bb02785 ("pwm: Add ChromeOS EC PWM driver")
Link: https://lore.kernel.org/r/20230228135508.1798428-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-cros-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-cros-ec.c b/drivers/pwm/pwm-cros-ec.c
index 98f6ac6cf6ab4..bedf6298acfbb 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -125,6 +125,7 @@ static void cros_ec_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	state->enabled = (ret > 0);
 	state->period = EC_PWM_MAX_DUTY;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Note that "disabled" and "duty cycle == 0" are treated the same */
 	state->duty_cycle = ret;
-- 
2.39.2



