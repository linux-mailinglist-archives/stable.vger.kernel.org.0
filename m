Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE42352198E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbiEJNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245052AbiEJNrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42CA5B3F4;
        Tue, 10 May 2022 06:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8320F6165A;
        Tue, 10 May 2022 13:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E53C385C2;
        Tue, 10 May 2022 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189673;
        bh=rahknHBdjH4CipcDdIevuxQSjmiTkFWBaiwIaya1CfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAu2wsERomYiU9/cLKQJXTrhfhWf0D751lVQivkGm8fovvViZdBvV4iwzjvzavf/j
         mi8FEEof6wWQ20ZqwQucWhZwK8DGrvGrLybeNJngCHPAN9BwmNVyT38+9sM+G2K7HI
         Dv3BiI4dtNp6LCDih0Jn7WPpx8X3ycPnTxaIb1Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/135] gpio: mvebu: drop pwm base assignment
Date:   Tue, 10 May 2022 15:07:48 +0200
Message-Id: <20220510130742.878194301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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
index 8f429d9f3661..ad8822da7c27 100644
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



