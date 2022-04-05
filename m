Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281434F2EA3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiDEIZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbiDEITI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9246DDF0B;
        Tue,  5 Apr 2022 01:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2B0EB81A37;
        Tue,  5 Apr 2022 08:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D37C385A2;
        Tue,  5 Apr 2022 08:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146137;
        bh=Mrz80BjJ2Jh+RPjc7Mig+slCavA5b7jhX6T0oLaoi4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mbU8ruuAhLaNIk1dBLpXVCzJC2rKkhV2tIfyf21nn/Z0p9RtmT9xm0Jj/BKR8+xn
         7YCWP9RGQ18x+ZL+oWkwNP8T/lN43VDoNN4Dkoq/fAxVFhQXCOCSERnQ5CibfhAPG/
         wtjj1dJyLRbV8vVzYnSzvuoG5v19QCXQuOxbECho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0656/1126] power: ab8500_chargalg: Use CLOCK_MONOTONIC
Date:   Tue,  5 Apr 2022 09:23:23 +0200
Message-Id: <20220405070426.885662479@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit c22fca40522e2be8af168f3087d87d85e404ea72 ]

The HRTimer in the AB8500 charging code is using CLOCK_REALTIME
to set an alarm some hours forward in time +/- 5 min for a safety
timer.

I have observed that this will sometimes fire sporadically
early when charging a battery with the result that
charging stops.

As CLOCK_REALTIME can be subject to adjustments of time from
sources such as NTP, this cannot be trusted and will likely
for example fire events if the clock is set forward some hours
by say NTP.

Use CLOCK_MONOTONIC as indicated in other instances and the
problem goes away. Also initialize the timer to REL mode
as this is what will be used later.

Fixes: 257107ae6b9b ("ab8500-chargalg: Use hrtimer")
Cc: Lee Jones <lee.jones@linaro.org>
Suggested-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_chargalg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_chargalg.c b/drivers/power/supply/ab8500_chargalg.c
index bcf85ae6828e..da490e090ce4 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -2020,11 +2020,11 @@ static int ab8500_chargalg_probe(struct platform_device *pdev)
 	psy_cfg.drv_data = di;
 
 	/* Initilialize safety timer */
-	hrtimer_init(&di->safety_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	hrtimer_init(&di->safety_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	di->safety_timer.function = ab8500_chargalg_safety_timer_expired;
 
 	/* Initilialize maintenance timer */
-	hrtimer_init(&di->maintenance_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	hrtimer_init(&di->maintenance_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	di->maintenance_timer.function =
 		ab8500_chargalg_maintenance_timer_expired;
 
-- 
2.34.1



