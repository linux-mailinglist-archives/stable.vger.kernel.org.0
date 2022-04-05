Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875DB4F33E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiDEJxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245431AbiDEJLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50472DA98;
        Tue,  5 Apr 2022 02:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A42EB81BBF;
        Tue,  5 Apr 2022 09:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AD7C385A1;
        Tue,  5 Apr 2022 09:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149205;
        bh=K42QkayVvGfoqUO3AMD2fmm46tyYo/VhVx5kCxI5O6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgEeJxrrZIMg05Xw/GTuYpdq4LEZOYsWv7rMnVlOAETVZ7GJMCsJ/2EkKNOis6YwX
         LlCopsMzzeUUfSvNIdrZ7Oe66sBpndEJqrIGBVLShuRSYKDZRsHLvsVp9DmZRzXpeC
         ybP6y77YWTk95s7gRIdsxFOBKy2bAOWzaHMSi32k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0595/1017] power: ab8500_chargalg: Use CLOCK_MONOTONIC
Date:   Tue,  5 Apr 2022 09:25:08 +0200
Message-Id: <20220405070411.939121688@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index ff4b26b1ceca..b809fa5abbba 100644
--- a/drivers/power/supply/ab8500_chargalg.c
+++ b/drivers/power/supply/ab8500_chargalg.c
@@ -2019,11 +2019,11 @@ static int ab8500_chargalg_probe(struct platform_device *pdev)
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



