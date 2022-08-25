Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905C95A05B3
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiHYBeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiHYBeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D770956A8;
        Wed, 24 Aug 2022 18:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F44FB826E0;
        Thu, 25 Aug 2022 01:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B2AC43470;
        Thu, 25 Aug 2022 01:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391252;
        bh=GC2D4ZYN0TLBECgNcs3E4No50naTem2zZ1+F6mlc+oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqnrzwwfJkSHmcnj4HxdAgrXIZ1I/Ns4lkJY3rm8X3ER4DzbOgveHR24YxeKKO9OA
         XI7/RPuk/2ARPX/1z+IzT1thb7rwzX4vH150Llkbjq/mxT6Yhzp801jOF7aJRu2bXr
         TKeK/75VZbw4hJ+s8j2dEeTln7VtbSU9PCDV8b/ACcBN11uU7LWih85hsA8lefupbF
         Ld5pqi/u06aMUz5EN1nA9bzJ4BX3lwJ9gAWgEcg8oncyaOFQVbOV9Y1m68Cd2GDtIO
         aW5nhsE3cNOeE2Q9dPBYoogDfAteFySm43p8KjyKIWj3SwCoarAULHm6PlpHSr5jeg
         VlaCLsacXYNeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Mohan Kumar D <mkumard@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 03/38] ASoC: rt5640: Fix the JD voltage dropping issue
Date:   Wed, 24 Aug 2022 21:33:26 -0400
Message-Id: <20220825013401.22096-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit afb176d45870048eea540991b082208270824037 ]

The patch fixes the JD voltage dropping issue in the HDA JD using.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Reported-by: Mohan Kumar D <mkumard@nvidia.com>
Link: https://lore.kernel.org/r/20220808052836.25791-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 18b3da9211e3..5ada0d318d0f 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1986,7 +1986,7 @@ static int rt5640_set_bias_level(struct snd_soc_component *component,
 		snd_soc_component_write(component, RT5640_PWR_MIXER, 0x0000);
 		if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER)
 			snd_soc_component_write(component, RT5640_PWR_ANLG1,
-				0x0018);
+				0x2818);
 		else
 			snd_soc_component_write(component, RT5640_PWR_ANLG1,
 				0x0000);
@@ -2592,7 +2592,8 @@ static void rt5640_enable_hda_jack_detect(
 	snd_soc_component_update_bits(component, RT5640_DUMMY1, 0x400, 0x0);
 
 	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
-		RT5640_PWR_VREF2, RT5640_PWR_VREF2);
+		RT5640_PWR_VREF2 | RT5640_PWR_MB | RT5640_PWR_BG,
+		RT5640_PWR_VREF2 | RT5640_PWR_MB | RT5640_PWR_BG);
 	usleep_range(10000, 15000);
 	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
 		RT5640_PWR_FV2, RT5640_PWR_FV2);
-- 
2.35.1

