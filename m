Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF97D521AE4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242839AbiEJOEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244708AbiEJODa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BED2E07EB;
        Tue, 10 May 2022 06:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2723F6195F;
        Tue, 10 May 2022 13:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD8BC385C9;
        Tue, 10 May 2022 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190031;
        bh=tFBjLhkyPHG2we+mnumSh33pt05zBmr0pMSY5dq+rXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPQMyBv247qjbgth9TO3d18sP5U3q71EI4HPZ2GMiehKOeHdEdea/2leDgqU6+drT
         cS3QJcqyCuQ88ztYwDCjeAuY/JwESTds3jHmfoI7Qe5CFznxl3TDtBdezM4mut+sAl
         mfOsYtVyxFSSHW268E6jYKQHr1mlJxnFzVIiGiHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 106/140] gpio: mvebu: drop pwm base assignment
Date:   Tue, 10 May 2022 15:08:16 +0200
Message-Id: <20220510130744.635445874@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit e5f6e5d554ac274f9c8ba60078103d0425b93c19 ]

pwmchip_add() unconditionally assigns the base ID dynamically. Commit
f9a8ee8c8bcd1 ("pwm: Always allocate PWM chip base ID dynamically")
dropped all base assignment from drivers under drivers/pwm/. It missed
this driver. Fix that.

Fixes: f9a8ee8c8bcd1 ("pwm: Always allocate PWM chip base ID dynamically")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 4c1f9e1091b7..a2c8dd329b31 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -871,13 +871,6 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 	mvpwm->chip.dev = dev;
 	mvpwm->chip.ops = &mvebu_pwm_ops;
 	mvpwm->chip.npwm = mvchip->chip.ngpio;
-	/*
-	 * There may already be some PWM allocated, so we can't force
-	 * mvpwm->chip.base to a fixed point like mvchip->chip.base.
-	 * So, we let pwmchip_add() do the numbering and take the next free
-	 * region.
-	 */
-	mvpwm->chip.base = -1;
 
 	spin_lock_init(&mvpwm->lock);
 
-- 
2.35.1



