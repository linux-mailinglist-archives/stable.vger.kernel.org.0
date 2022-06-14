Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC37154A553
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353014AbiFNCQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354918AbiFNCPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:15:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F1E3D1C1;
        Mon, 13 Jun 2022 19:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3A560ED5;
        Tue, 14 Jun 2022 02:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477C8C385A2;
        Tue, 14 Jun 2022 02:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172548;
        bh=L4eD9J0MTtWeGzYMeXFppIGyk1FWZFElAdCvuNUix20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4c/KqM7fW+4W2Kd24MPGnaxzFBRvwevHq0fGAGvbx73zi00jH6jYwiBq0V2EnMHN
         U6hs6vd2eMd8G/w9ez16rIWU9gjPWkPUGSJgo7295S0w8WsWhNHXYEJNFYKVfO6yKu
         GV0yzfC9ihfGFeiS8EZ8gxzsPE0W5zzupQfXTXe94ZuXbpQ5y4xgBWEbNPgQqUwmaR
         tKkWUIoJhznnsQhphxwSxZ3MLbJkcaeR3ghFEQ0QRvlp3f3dcL3ADUhq9XK5C8OmnB
         iM6DoFph2+DUar2Vhqfc2Fersj2l2XbqsRPFLA1+W9XCwl83VcyPRwikx0H0p7Of7Z
         7iq4asjbzwS5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 04/23] ASoC: cs42l52: Fix TLV scales for mixer controls
Date:   Mon, 13 Jun 2022 22:08:40 -0400
Message-Id: <20220614020900.1100401-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
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
index 2ea4cba3be2a..0daa3b4c68ca 100644
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

