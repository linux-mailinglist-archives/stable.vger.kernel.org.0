Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807AE604811
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiJSNsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiJSNq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:46:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553C450514;
        Wed, 19 Oct 2022 06:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84E4DCE2100;
        Wed, 19 Oct 2022 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83368C433D6;
        Wed, 19 Oct 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169415;
        bh=oyGyxWJUXiy5R6FcVcV6T7cfpWGfVqEQbstwhBlVSqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTv9l4x126g/Q0yfxj8jONoZe4S3tFs2/qwehXhZx0RpaEs0f9PTxsgI56szSbaPo
         aosxKolWjsF9uI+xL7+4D5MxXzNmNw+QIUm1xUdOHiKQ1h5EL5BMbW1CKCqg0po750
         eCsrHbIfvzCPLmOnmBhAqa5gdWuVhceKf2LApmCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 234/862] leds: lm3601x: Dont use mutex after it was destroyed
Date:   Wed, 19 Oct 2022 10:25:21 +0200
Message-Id: <20221019083300.374919732@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 32f7eed0c763a9b89f6b357ec54b48398fc7b99e ]

The mutex might still be in use until the devm cleanup callback
devm_led_classdev_flash_release() is called. This only happens some time
after lm3601x_remove() completed.

Fixes: e63a744871a3 ("leds: lm3601x: Convert class registration to device managed")
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-lm3601x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/leds/flash/leds-lm3601x.c b/drivers/leds/flash/leds-lm3601x.c
index d0e1d4814042..3d1272748201 100644
--- a/drivers/leds/flash/leds-lm3601x.c
+++ b/drivers/leds/flash/leds-lm3601x.c
@@ -444,8 +444,6 @@ static int lm3601x_remove(struct i2c_client *client)
 {
 	struct lm3601x_led *led = i2c_get_clientdata(client);
 
-	mutex_destroy(&led->lock);
-
 	return regmap_update_bits(led->regmap, LM3601X_ENABLE_REG,
 			   LM3601X_ENABLE_MASK,
 			   LM3601X_MODE_STANDBY);
-- 
2.35.1



