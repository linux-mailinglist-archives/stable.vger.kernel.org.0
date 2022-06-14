Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D54A54A4A3
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352515AbiFNCJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352478AbiFNCI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E135DCB;
        Mon, 13 Jun 2022 19:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC1F60AEC;
        Tue, 14 Jun 2022 02:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC80C385A2;
        Tue, 14 Jun 2022 02:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172377;
        bh=OeVBfzjrN+Okk5tVPGJUb3SZYwRtI0f6xEJ5aPPDBug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d51V+hi4wM9AKEfEO6j/WoTLWlY+6c/dF0n1DF/a/kBZczKWgHi+uD4XVNJKD4Hsk
         /i90SdqWiP8Y9MM0eZTKrFEFcG5gRNdO/2nQxqYFYDb/PhDmIWn/IhsQk0WDQaC38r
         4TPyeMWf8KwmzJPxTSOq5+h9ag83ISZ1YbV+dkrRFK7DdHweLCYudoWspKOoZraTOf
         WkACigRDx/d0yIbCsp+a9QotCw8oluvkJpBEOomyXv8q9MYTSL8F+3J2cDbWzuH5/4
         A2waLFDn91QRRAVwnO4oE5rdrj3v1v2xAU/thBT7hyDlxKOz/nb3PMBSQ9/YaHD+Hg
         +z4jP5iuVh2dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        David Rhodes <david.rhodes@cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 09/43] ASoC: cs53l30: Correct number of volume levels on SX controls
Date:   Mon, 13 Jun 2022 22:05:28 -0400
Message-Id: <20220614020602.1098943-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
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

[ Upstream commit 7fbd6dd68127927e844912a16741016d432a0737 ]

This driver specified the maximum value rather than the number of volume
levels on the SX controls, this is incorrect, so correct them.

Reported-by: David Rhodes <david.rhodes@cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs53l30.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/cs53l30.c b/sound/soc/codecs/cs53l30.c
index f2087bd38dbc..c2912ad3851b 100644
--- a/sound/soc/codecs/cs53l30.c
+++ b/sound/soc/codecs/cs53l30.c
@@ -348,22 +348,22 @@ static const struct snd_kcontrol_new cs53l30_snd_controls[] = {
 	SOC_ENUM("ADC2 NG Delay", adc2_ng_delay_enum),
 
 	SOC_SINGLE_SX_TLV("ADC1A PGA Volume",
-		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B PGA Volume",
-		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A PGA Volume",
-		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B PGA Volume",
-		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 
 	SOC_SINGLE_SX_TLV("ADC1A Digital Volume",
-		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B Digital Volume",
-		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A Digital Volume",
-		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B Digital Volume",
-		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 };
 
 static const struct snd_soc_dapm_widget cs53l30_dapm_widgets[] = {
-- 
2.35.1

