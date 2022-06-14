Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEA54A58E
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353440AbiFNCP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354029AbiFNCOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348A23B2B0;
        Mon, 13 Jun 2022 19:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC22CB816C5;
        Tue, 14 Jun 2022 02:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58828C36AFF;
        Tue, 14 Jun 2022 02:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172503;
        bh=M/PmLiYH0Ua9Bu5eF2irbzC7kPy33zqk/fv4eFKMCWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItwVK1WnDfmeIPj/AxFm2a48d7GBza7vrIR02Krn07NDrHIZ/vJMkS+paNAZx/xrF
         ai16u2ylLNrWbdfgfg+IHzLClbkNU/Jtj86zj3MjhDQFcRY7MteY8PmG48rkv6KBbw
         7GulVeQsCxDd6dN/ivVgqyNqfFKl5b97fTcH5CTViWBmObPEpjw01Hk0vUnKBigS8h
         7uMYqEVBmlClC7toW/1R4Te1+Fq94RjFBR7sYSByamLqqsExRrcUUCKqAnWo0LfFku
         HjYdmrSV3xrJldAd4t7GIl/qXz9aKqTg8ELVlRX4+OtqkraZIgODJ/GiN9i+YJY/Rb
         vkqS6gF17iKCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 04/29] ASoC: cs42l52: Fix TLV scales for mixer controls
Date:   Mon, 13 Jun 2022 22:07:50 -0400
Message-Id: <20220614020815.1099999-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 8bf5aabf524eec61013e506f764a0b2652dc5665 ]

The datasheet specifies the range of the mixer volumes as between
-51.5dB and 12dB with a 0.5dB step. Update the TLVs for this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index f772628f233e..750e6c923512 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -137,7 +137,7 @@ static DECLARE_TLV_DB_SCALE(mic_tlv, 1600, 100, 0);
 
 static DECLARE_TLV_DB_SCALE(pga_tlv, -600, 50, 0);
 
-static DECLARE_TLV_DB_SCALE(mix_tlv, -50, 50, 0);
+static DECLARE_TLV_DB_SCALE(mix_tlv, -5150, 50, 0);
 
 static DECLARE_TLV_DB_SCALE(beep_tlv, -56, 200, 0);
 
@@ -364,7 +364,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_ADCB_VOL, 0, 0xA0, 0x78, ipd_tlv),
 	SOC_DOUBLE_R_SX_TLV("ADC Mixer Volume",
 			     CS42L52_ADCA_MIXER_VOL, CS42L52_ADCB_MIXER_VOL,
-				0, 0x19, 0x7F, ipd_tlv),
+				0, 0x19, 0x7F, mix_tlv),
 
 	SOC_DOUBLE("ADC Switch", CS42L52_ADC_MISC_CTL, 0, 1, 1, 0),
 
-- 
2.35.1

