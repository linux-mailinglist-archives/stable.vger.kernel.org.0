Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4C4AF9FB
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbiBISdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbiBISdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:33:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9414C0613C9;
        Wed,  9 Feb 2022 10:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48EF461C16;
        Wed,  9 Feb 2022 18:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEC4C340E7;
        Wed,  9 Feb 2022 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431620;
        bh=bFy7XXY2ACITulTCUKRC7dk/O8gBIpyeMZ3F7CKr/7s=;
        h=From:To:Cc:Subject:Date:From;
        b=LM5akZrXHkGfyoqM4hv2SRCV7HhZHvzf62xiVBHchXCZqPnwd5f8o8ngdOUFo7y88
         rg4zM9YfQoDMw/+7X2C23aKSqHqst6wtIg+XPRrvsdOmLdqMLzZiLQHK3s2RD/v7tq
         /GhGKf+poi2xoCSBkSdbJ+Q0apl3UgnEQL5s0H14SM85FvDuL0Ucyxfl2ybMNGmmP1
         2tDKdAsQAVlYEgDKlBmmYOQpLI/mqYtZ4FArNoIFEuwMsK8PQFjx1lyAi264/YrsWq
         vR7XI8J5QEAyLlkrF2xPOOkJWHPEihsW+8vbjckFSuSUwNSks9/9adyJjflhZZkuq9
         Kzy5DS6QS3S1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Braha <julianbraha@gmail.com>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        trevor.wu@mediatek.com, rdunlap@infradead.org,
        geert+renesas@glider.be, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 01/42] ASoC: mediatek: fix unmet dependency on GPIOLIB for SND_SOC_DMIC
Date:   Wed,  9 Feb 2022 13:32:33 -0500
Message-Id: <20220209183335.46545-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 579b2c8f72d974f27d85bbd53846f34675ee3b01 ]

When SND_SOC_MT8195_MT6359_RT1011_RT5682 is selected,
and GPIOLIB is not selected,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for SND_SOC_DMIC
  Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && GPIOLIB [=n]
  Selected by [y]:
  - SND_SOC_MT8195_MT6359_RT1011_RT5682 [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && I2C [=y] && SND_SOC_MT8195 [=y] && MTK_PMIC_WRAP [=y]

This is because SND_SOC_MT8195_MT6359_RT1011_RT5682
selects SND_SOC_DMIC without selecting or depending on
GPIOLIB, depsite SND_SOC_DMIC depending on GPIOLIB.

This unmet dependency bug was detected by Kismet,
a static analysis tool for Kconfig. Please advise
if this is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20220117050324.68371-1-julianbraha@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 3b1ddea26a9ef..76f191ec7bf84 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -215,7 +215,7 @@ config SND_SOC_MT8195_MT6359_RT1019_RT5682
 
 config SND_SOC_MT8195_MT6359_RT1011_RT5682
 	tristate "ASoC Audio driver for MT8195 with MT6359 RT1011 RT5682 codec"
-	depends on I2C
+	depends on I2C && GPIOLIB
 	depends on SND_SOC_MT8195 && MTK_PMIC_WRAP
 	select SND_SOC_MT6359
 	select SND_SOC_RT1011
-- 
2.34.1

