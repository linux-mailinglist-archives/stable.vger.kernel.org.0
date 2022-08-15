Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE187593FCB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346577AbiHOUzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346668AbiHOUyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF82B194;
        Mon, 15 Aug 2022 12:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 493AC6069E;
        Mon, 15 Aug 2022 19:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7CFC433C1;
        Mon, 15 Aug 2022 19:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590663;
        bh=phN+qSxQHO3xHdsp0Cmw0hMbLrUCSsjAQLXTncAvUFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnQAPmum1MN7kLtjOPgzsN5NYJwPtu+1nO5uS850+Ghtgfp372YCd0wqg3tPZgFs4
         UPUVpZmCPEHPDanDHTeDURtHlJL7Ac13jIau/bzbgfZaCiEyFJ1AecHdrnAIK7aRaL
         03RrVzlATk6rhFq54fvpFgjCyRSJeDoWDZowxq4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0300/1095] pwm: sifive: Shut down hardware only after pwmchip_remove() completed
Date:   Mon, 15 Aug 2022 19:54:59 +0200
Message-Id: <20220815180442.192147527@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2375e964d541bb09158cd2dff67b5d74e8de61cd ]

The PWMs are expected to be functional until pwmchip_remove() is called.
So disable the clks only afterwards.

Fixes: 9e37a53eb051 ("pwm: sifive: Add a driver for SiFive SoC PWM")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 3936fda53366..58347fcd4812 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -321,6 +321,9 @@ static int pwm_sifive_remove(struct platform_device *dev)
 	struct pwm_device *pwm;
 	int ch;
 
+	pwmchip_remove(&ddata->chip);
+	clk_notifier_unregister(ddata->clk, &ddata->notifier);
+
 	for (ch = 0; ch < ddata->chip.npwm; ch++) {
 		pwm = &ddata->chip.pwms[ch];
 		if (pwm->state.enabled)
@@ -328,8 +331,6 @@ static int pwm_sifive_remove(struct platform_device *dev)
 	}
 
 	clk_unprepare(ddata->clk);
-	pwmchip_remove(&ddata->chip);
-	clk_notifier_unregister(ddata->clk, &ddata->notifier);
 
 	return 0;
 }
-- 
2.35.1



