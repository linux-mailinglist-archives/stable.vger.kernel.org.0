Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51A5381B5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbiE3OUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbiE3ORe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3464C180;
        Mon, 30 May 2022 06:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD4F9B80D6B;
        Mon, 30 May 2022 13:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E441DC3411C;
        Mon, 30 May 2022 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918392;
        bh=T3K49EzgFQoroZgGLydsYozObStO/D4Gzmz7Ic0mvUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1TScBseZrd131Xdds0Kniiv/g621BAopM1IChCcxmzSdItLTU5mhcEq5OZg3XbDZ
         ntq70mpKeabgM05bKQISaLMtrk8ufYN5VRx/GIh7kBwgEZ4Z0JOfR3QvPD3/zCr9GT
         oGCX5DxRpQPgBLLqiWdw4Me2i4wP6P12lThIaLZmB/DOx8JxYvwjjmiOi48C5Yry6O
         elhB9fgZSK4X7TS+B3JN6lB3nFnWJJCZsLQbO5U2QViBExwBW2ZI4MF857sAp34fkv
         PhopRUPzTK74OCOaEKNOlH+2dv/5l4LiTPP4+KFmov362Qi5Lo3pI98ixH7XRjiAfO
         8IPmAU5TVzCig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        kernel test robot <yujie.liu@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, srinivas.kandagatla@linaro.org,
        ckeepax@opensource.cirrus.com, tanureal@opensource.cirrus.com,
        james.schulman@cirrus.com, cy_huang@richtek.com,
        hdegoede@redhat.com, pbrobinson@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 65/76] ASoC: max98357a: remove dependency on GPIOLIB
Date:   Mon, 30 May 2022 09:43:55 -0400
Message-Id: <20220530134406.1934928-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 21ca3274333f5c1cbbf9d91e5b33f4f2463859b2 ]

commit dcc2c012c7691 ("ASoC: Fix gpiolib dependencies") removed a
series of unnecessary dependencies on GPIOLIB when the gpio was
optional.

A similar simplification seems valid for max98357a, so remove the
dependency as well. This will avoid the following warning

   WARNING: unmet direct dependencies detected for SND_SOC_MAX98357A
     Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && GPIOLIB [=n]
     Selected by [y]:
     - SND_SOC_INTEL_SOF_CS42L42_MACH [=y] && SOUND [=y] && !UML &&
       SND [=y] && SND_SOC [=y] && SND_SOC_INTEL_MACH [=y] &&
       (SND_SOC_SOF_HDA_LINK [=y] || SND_SOC_SOF_BAYTRAIL [=n]) && I2C
       [=y] && ACPI [=y] && SND_HDA_CODEC_HDMI [=y] &&
       SND_SOC_SOF_HDA_AUDIO_CODEC [=y] && (MFD_INTEL_LPSS [=y] ||
       COMPILE_TEST [=n])

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220517172647.468244-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 52c89a6f54e9..612fd7516666 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -857,7 +857,6 @@ config SND_SOC_MAX98095
 
 config SND_SOC_MAX98357A
 	tristate "Maxim MAX98357A CODEC"
-	depends on GPIOLIB
 
 config SND_SOC_MAX98371
 	tristate
-- 
2.35.1

