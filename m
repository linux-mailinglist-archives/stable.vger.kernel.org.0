Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B163DE41
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiK3SfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiK3SfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBE293A5B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E96CB81CA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF320C433D6;
        Wed, 30 Nov 2022 18:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833306;
        bh=njObzzihETDEyRFwwlBVKg3ZyPlZClxXNh1sTuzSlOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRK/z0FzSntURLI0wKkJa0g7Uqwvz2yV6zm9YSGrcYnul1OiDAA86iEThSblm32V7
         YwjNLoo3+Q+YdGy0FAsKW1bjWhd73FemzqBpbMBfwzwCZOX473qbPLjKk3mzg8UXqo
         k7VW+mZ0jLrjgj4hM6fy8r8Jfgi2KzkjlCk8FuRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Detlev Casanova <detlev.casanova@collabora.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/206] ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove
Date:   Wed, 30 Nov 2022 19:21:52 +0100
Message-Id: <20221130180534.530369200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 0bb8e9b36b5b7f2e77892981ff6c27ee831d8026 ]

Since commit bf2aebccddef ("ASoC: sgtl5000: Fix noise on shutdown/remove"),
the device power control registers are reset when the driver is
removed/shutdown.

This is an issue when the device is configured to use the PLL clock. The
device will stop responding if it is still configured to use the PLL
clock but the PLL clock is powered down.

When rebooting linux, the probe function will show:
sgtl5000 0-000a: Error reading chip id -11

Make sure that the CHIP_CLK_CTRL is reset to its default value before
powering down the device.

Fixes: bf2aebccddef ("ASoC: sgtl5000: Fix noise on shutdown/remove")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20221110190612.1341469-1-detlev.casanova@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index dc56e6c6b668..3c5a4fe2fad6 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1797,6 +1797,7 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_CLK_CTRL, SGTL5000_CHIP_CLK_CTRL_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
 
-- 
2.35.1



