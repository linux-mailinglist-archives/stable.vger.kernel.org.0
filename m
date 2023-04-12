Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616956DEE7A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjDLIly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjDLIlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4148355A6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 932FA62F83
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A434CC4339B;
        Wed, 12 Apr 2023 08:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288826;
        bh=ejybGv4NS3pYwTMmRgSSfn/5KKsdTb1SBzecpRHGcrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycxC1B37+2mPGVBEmmRCUa/lc+VHPa3qhcPFV1vi9DU2LWglYgfa532Av6Lj6Uur1
         T77QUfGkPM96GpPZVnpOIY1ka0i8gHCT/Xf4u6rjeZRkjubjMAma/uP11tKHcOWg3N
         rQa3nx0o4cvnOvVuhhmhJIG33ZhQzqgm7Xilxlfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/164] pwm: cros-ec: Explicitly set .polarity in .get_state()
Date:   Wed, 12 Apr 2023 10:32:16 +0200
Message-Id: <20230412082837.451363791@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 11684edc06207..e55bc36ed4972 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -198,6 +198,7 @@ static int cros_ec_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	state->enabled = (ret > 0);
 	state->period = EC_PWM_MAX_DUTY;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/*
 	 * Note that "disabled" and "duty cycle == 0" are treated the same. If
-- 
2.39.2



