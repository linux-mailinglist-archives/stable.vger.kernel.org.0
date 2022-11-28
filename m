Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC563AFB4
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiK1Rol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiK1RoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:44:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7F32C11A;
        Mon, 28 Nov 2022 09:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634AE61301;
        Mon, 28 Nov 2022 17:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8020BC433D6;
        Mon, 28 Nov 2022 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657254;
        bh=yPuuE2yFfuu9aNXxBzF1mCdVxBx8P9ULw0taPUNbgcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wg56GCaB/ftf8fQn43YxwIPpGnNDhQUSFok+ZTO2xHEH/L0NmCXY2OSwsaitHU0yw
         ie9p+10+8qXk+Dd8L4UsJu0+CRjop64iNLiYzw/gKOTGCsbWE6F8stU7Iktw+6bBbD
         nQdc8f4FUyr2tjBIsRkWp+RbHcibDjfvDCshmHvbgwTcZf6Sa8cpIODHqypm25SFl5
         KGlGf4i138mUz5h2J76vXvw5+HIUq4FeK9RRXSd2MkkQZVIbUbQxuL+jPQiG//eAxK
         DvwkWBHA2LLI4NdhQ7Tje5Vd0CobMtV5phOv07p1WxoJ+Pn7WibpWhDDUMXFzPaoRt
         QMhVgwUG6DzBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chancel Liu <chancel.liu@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, aford173@gmail.com,
        chi.minghao@zte.com.cn, steve@sk2.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 10/24] ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register
Date:   Mon, 28 Nov 2022 12:40:10 -0500
Message-Id: <20221128174027.1441921-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174027.1441921-1-sashal@kernel.org>
References: <20221128174027.1441921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 3ca507bf99611c82dafced73e921c1b10ee12869 ]

DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
correct frequency of LRCLK and BCLK. Sometimes the read-only value
can't be updated timely after enabling SYSCLK. This results in wrong
calculation values. Delay is introduced here to wait for newest value
from register. The time of the delay should be at least 500~1000us
according to test.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221109121354.123958-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 09a73b854964..779f7097d336 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2490,6 +2490,14 @@ static void wm8962_configure_bclk(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, WM8962_CLOCKING2,
 				WM8962_SYSCLK_ENA_MASK, WM8962_SYSCLK_ENA);
 
+	/* DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
+	 * correct frequency of LRCLK and BCLK. Sometimes the read-only value
+	 * can't be updated timely after enabling SYSCLK. This results in wrong
+	 * calculation values. Delay is introduced here to wait for newest
+	 * value from register. The time of the delay should be at least
+	 * 500~1000us according to test.
+	 */
+	usleep_range(500, 1000);
 	dspclk = snd_soc_component_read(component, WM8962_CLOCKING1);
 
 	if (snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON)
-- 
2.35.1

