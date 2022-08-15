Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94362594DDD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242116AbiHPArq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347607AbiHPAp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F7DCCE2B;
        Mon, 15 Aug 2022 13:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A0B61233;
        Mon, 15 Aug 2022 20:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165DBC433C1;
        Mon, 15 Aug 2022 20:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596072;
        bh=j/BFoTsk82o3gdJ5J8f/QcpIjyfX3s+y4+Ck4YqHTms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdjFe1DiliM57nKowYR44A68LtnL2WASYgEPvuob2qR4K89Iikoo8PSkM9YiIZykE
         zOM/pwvoqzcuw1IAJc1GWddUtnYassIZrB19NL7NFJJ3QnvB64gAE7Vp3nmPvwiAwG
         hcdGf7M3MqTmBiDVgGWD3i6GMTpEEjrSuaNbxj7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0963/1157] leds: pwm-multicolor: Dont show -EPROBE_DEFER as errors
Date:   Mon, 15 Aug 2022 20:05:19 +0200
Message-Id: <20220815180518.176425275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Emil Renner Berthing <emil.renner.berthing@canonical.com>

[ Upstream commit 399e7aa82105ea46d8998fa535b047541c48030f ]

When requesting a PWM it might return -EPROBE_DEFER if it hasn't probed
yet. This is not an error, so just propagate the -EPROBE_DEFER without
logging anything. There is already dev_err_probe for exactly this
situation.

Fixes: 9fa2762110dd ("leds: Add PWM multicolor driver")
Signed-off-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-pwm-multicolor.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/rgb/leds-pwm-multicolor.c b/drivers/leds/rgb/leds-pwm-multicolor.c
index 45e38708ecb1..eb67b89d28e9 100644
--- a/drivers/leds/rgb/leds-pwm-multicolor.c
+++ b/drivers/leds/rgb/leds-pwm-multicolor.c
@@ -72,8 +72,7 @@ static int iterate_subleds(struct device *dev, struct pwm_mc_led *priv,
 		pwmled = &priv->leds[priv->mc_cdev.num_colors];
 		pwmled->pwm = devm_fwnode_pwm_get(dev, fwnode, NULL);
 		if (IS_ERR(pwmled->pwm)) {
-			ret = PTR_ERR(pwmled->pwm);
-			dev_err(dev, "unable to request PWM: %d\n", ret);
+			ret = dev_err_probe(dev, PTR_ERR(pwmled->pwm), "unable to request PWM\n");
 			goto release_fwnode;
 		}
 		pwm_init_state(pwmled->pwm, &pwmled->state);
-- 
2.35.1



