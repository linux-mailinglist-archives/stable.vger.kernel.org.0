Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5526D4A3B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjDCOpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjDCOpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B9E280D6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BBEEB81D3D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5FEC433D2;
        Mon,  3 Apr 2023 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533090;
        bh=PyIAoE5TE12w64lhX+6kgpBNu5MU7e5E2YpbPVOcYCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVocEoLs//PYk4duJ+6Gk1zuYsGo8YHdHwyrava6xVVh49R68RRtIxe24XF+YGP0i
         S3FqMxXuMqPP084t0EZHJex9dls1Yj+1kdaJ4F3CFBCPr+F/6bZt7NwCKBhnsC6aD0
         XJ48eSctBm4V/PDyqTBtnzMibauX8a5O2Mcpmj+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 020/187] ASoC: Intel: avs: ssm4567: Remove nau8825 bits
Date:   Mon,  3 Apr 2023 16:07:45 +0200
Message-Id: <20230403140416.689040351@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 933de2d127281731166cf2880fa1e23c5a0f7faa ]

Some of the nau8825 clock control got into the ssm4567, remove it.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230303134854.2277146-5-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/ssm4567.c | 31 ----------------------------
 1 file changed, 31 deletions(-)

diff --git a/sound/soc/intel/avs/boards/ssm4567.c b/sound/soc/intel/avs/boards/ssm4567.c
index c5db696127624..2b7f5ad92aca7 100644
--- a/sound/soc/intel/avs/boards/ssm4567.c
+++ b/sound/soc/intel/avs/boards/ssm4567.c
@@ -15,7 +15,6 @@
 #include <sound/soc-acpi.h>
 #include "../../../codecs/nau8825.h"
 
-#define SKL_NUVOTON_CODEC_DAI	"nau8825-hifi"
 #define SKL_SSM_CODEC_DAI	"ssm4567-hifi"
 
 static struct snd_soc_codec_conf card_codec_conf[] = {
@@ -34,41 +33,11 @@ static const struct snd_kcontrol_new card_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Right Speaker"),
 };
 
-static int
-platform_clock_control(struct snd_soc_dapm_widget *w, struct snd_kcontrol *control, int event)
-{
-	struct snd_soc_dapm_context *dapm = w->dapm;
-	struct snd_soc_card *card = dapm->card;
-	struct snd_soc_dai *codec_dai;
-	int ret;
-
-	codec_dai = snd_soc_card_get_codec_dai(card, SKL_NUVOTON_CODEC_DAI);
-	if (!codec_dai) {
-		dev_err(card->dev, "Codec dai not found\n");
-		return -EINVAL;
-	}
-
-	if (SND_SOC_DAPM_EVENT_ON(event)) {
-		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_MCLK, 24000000,
-					     SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			dev_err(card->dev, "set sysclk err = %d\n", ret);
-	} else {
-		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_INTERNAL, 0, SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			dev_err(card->dev, "set sysclk err = %d\n", ret);
-	}
-
-	return ret;
-}
-
 static const struct snd_soc_dapm_widget card_widgets[] = {
 	SND_SOC_DAPM_SPK("Left Speaker", NULL),
 	SND_SOC_DAPM_SPK("Right Speaker", NULL),
 	SND_SOC_DAPM_SPK("DP1", NULL),
 	SND_SOC_DAPM_SPK("DP2", NULL),
-	SND_SOC_DAPM_SUPPLY("Platform Clock", SND_SOC_NOPM, 0, 0, platform_clock_control,
-			    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 };
 
 static const struct snd_soc_dapm_route card_base_routes[] = {
-- 
2.39.2



