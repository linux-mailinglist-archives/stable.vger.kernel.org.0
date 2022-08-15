Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C225937FE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbiHOSmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243799AbiHOSlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2562657;
        Mon, 15 Aug 2022 11:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E646ACE125C;
        Mon, 15 Aug 2022 18:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1C6C433D6;
        Mon, 15 Aug 2022 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587899;
        bh=XAE+/OLaoY0GXqpevQP/rGZXBm8MGtL2ZRz1sE5nkBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgS+1Q14uEfCUrlF67lidyvpe/f7bYe8iErpqbfuJeIzQCwnO5K/rgZ/UgFYRZNb2
         c8ylAps7RxUYe0dMciKcJktztwtjVufrj4hchhroOPWg1d2EhQm0hJW6VgX3Rlp8je
         uwQZ81T+ceqZa6IFKcjh2lOvA+qM21LTs5S2M9mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/779] pwm: lpc18xx-sct: Reduce number of devm memory allocations
Date:   Mon, 15 Aug 2022 19:57:55 +0200
Message-Id: <20220815180347.162000913@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 20d9de9c4d6642bb40c935233697723b56573cbc ]

Each devm allocations has an overhead of 24 bytes to store the related
struct devres_node additionally to the fragmentation of the allocator.
So allocating 16 struct lpc18xx_pwm_data (which only hold a single int)
adds quite some overhead. Instead put the per-channel data into the
driver data struct and allocate it in one go.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpc18xx-sct.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-lpc18xx-sct.c b/drivers/pwm/pwm-lpc18xx-sct.c
index 8cc8ae16553c..6cf02554066c 100644
--- a/drivers/pwm/pwm-lpc18xx-sct.c
+++ b/drivers/pwm/pwm-lpc18xx-sct.c
@@ -76,6 +76,8 @@
 #define LPC18XX_PWM_EVENT_PERIOD	0
 #define LPC18XX_PWM_EVENT_MAX		16
 
+#define LPC18XX_NUM_PWMS		16
+
 /* SCT conflict resolution */
 enum lpc18xx_pwm_res_action {
 	LPC18XX_PWM_RES_NONE,
@@ -101,6 +103,7 @@ struct lpc18xx_pwm_chip {
 	unsigned long event_map;
 	struct mutex res_lock;
 	struct mutex period_lock;
+	struct lpc18xx_pwm_data channeldata[LPC18XX_NUM_PWMS];
 };
 
 static inline struct lpc18xx_pwm_chip *
@@ -370,7 +373,7 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 
 	lpc18xx_pwm->chip.dev = &pdev->dev;
 	lpc18xx_pwm->chip.ops = &lpc18xx_pwm_ops;
-	lpc18xx_pwm->chip.npwm = 16;
+	lpc18xx_pwm->chip.npwm = LPC18XX_NUM_PWMS;
 
 	/* SCT counter must be in unify (32 bit) mode */
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_CONFIG,
@@ -400,12 +403,7 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 
 		pwm = &lpc18xx_pwm->chip.pwms[i];
 
-		data = devm_kzalloc(lpc18xx_pwm->dev, sizeof(*data),
-				    GFP_KERNEL);
-		if (!data) {
-			ret = -ENOMEM;
-			goto disable_pwmclk;
-		}
+		data = &lpc18xx_pwm->channeldata[i];
 
 		pwm_set_chip_data(pwm, data);
 	}
-- 
2.35.1



