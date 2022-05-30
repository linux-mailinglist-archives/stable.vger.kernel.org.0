Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A190538202
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiE3OVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiE3ORe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D59DCEF;
        Mon, 30 May 2022 06:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A1C60F22;
        Mon, 30 May 2022 13:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D85C385B8;
        Mon, 30 May 2022 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918396;
        bh=7XsYRlWM8qmHI/XkqixZ5LiDMS9nt6vg5uZEvzT5rvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m++qONB0A/AEQB+Kf9jv0crPtZJHsXbwmvfEK3ViaSzrubNP1mDzECqNc0VbLVcuQ
         +e63QmtOkW56Mcdtnb1u/TU0dUkLivk5IkDH4I2Q+OvW/fP3Z51HP1jU6q1UMjR62E
         jbn6JllqdfiftYFiy2IIo9bX7ivBzouiax3N4auSNZRAdpntSnS90gkAxQ2Z0B5n5N
         DAZ1WO7ilz1Xv8mO0V5WkLD0eGsOfDMABN87nk7cT6PzLAV5DBhDtxSP19hR7jx5gs
         N9BlK310nAQtsjn1zpoQEAyhJECe9W1R+ua4dIr3uxQ3mUpjmqzloJdW5rs26k36GK
         yGWqTbNIOWVEg==
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
        pbrobinson@gmail.com, hdegoede@redhat.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 66/76] ASoC: rt1015p: remove dependency on GPIOLIB
Date:   Mon, 30 May 2022 09:43:56 -0400
Message-Id: <20220530134406.1934928-66-sashal@kernel.org>
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

[ Upstream commit b390c25c6757b9d56cecdfbf6d55f15fc89a6386 ]

commit dcc2c012c7691 ("ASoC: Fix gpiolib dependencies") removed a
series of unnecessary dependencies on GPIOLIB when the gpio was
optional.

A similar simplification seems valid for rt1015p, so remove the
dependency as well. This will avoid the following warning

  WARNING: unmet direct dependencies detected for SND_SOC_RT1015P

     Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] &&
     GPIOLIB [=n]

     Selected by [y]:

     - SND_SOC_INTEL_SOF_RT5682_MACH [=y] && SOUND [=y] && !UML && SND
       [=y] && SND_SOC [=y] && SND_SOC_INTEL_MACH [=y] &&
       (SND_SOC_SOF_HDA_LINK [=y] || SND_SOC_SOF_BAYTRAIL [=n]) && I2C
       [=y] && ACPI [=y] && (SND_HDA_CODEC_HDMI [=y] &&
       SND_SOC_SOF_HDA_AUDIO_CODEC [=y] && (MFD_INTEL_LPSS [=y] ||
       COMPILE_TEST [=y]) || SND_SOC_SOF_BAYTRAIL [=n] &&
       (X86_INTEL_LPSS [=n] || COMPILE_TEST [=y]))

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220517172647.468244-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 612fd7516666..25f331551f68 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1098,7 +1098,6 @@ config SND_SOC_RT1015
 
 config SND_SOC_RT1015P
 	tristate
-	depends on GPIOLIB
 
 config SND_SOC_RT1305
 	tristate
-- 
2.35.1

