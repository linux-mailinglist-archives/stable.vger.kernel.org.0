Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871A654A584
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352572AbiFNCTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354744AbiFNCTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26A3F30F;
        Mon, 13 Jun 2022 19:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3046112F;
        Tue, 14 Jun 2022 02:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A62C34114;
        Tue, 14 Jun 2022 02:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172600;
        bh=JCx7/IyEdd6Ij0vX/viGyNtj1HbeC0/aQeu4/QO3Frc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVECwEY8+ehZXZPn503KXi4kUC0I/af3ivRYugbg/qUqMoKyyTienRVwnTEFCOoyQ
         VpvKTX03rIx4PQ6Ngvcjtp6XwYMT6heW7yTF5JWDMrVOji1E++BJzeF+8R2lY/SvBv
         BCk+S924Xuj4D47Gregjg4zXj5Q7ROlQVzfAFMxlJLap8ZzQ9RwFyJyxmk6rRsV7fi
         XkLroXKzJmzDya/LbZFdajO2+YpIgY7NulF0tE3c7apUFoNQFzlFy80tS52NPOPGbG
         dFIeEvB8CgSywzuVptQ/Ncy/YtOoE6WIPnhZKl9BK3bC0BYqnIk9IV02JYDDtKrNBQ
         pJWO96HYi7D0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 05/18] ASoC: cs42l56: Correct typo in minimum level for SX volume controls
Date:   Mon, 13 Jun 2022 22:09:28 -0400
Message-Id: <20220614020941.1100702-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020941.1100702-1-sashal@kernel.org>
References: <20220614020941.1100702-1-sashal@kernel.org>
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

[ Upstream commit a8928ada9b96944cadd8b65d191e33199fd38782 ]

A couple of the SX volume controls specify 0x84 as the lowest volume
value, however the correct value from the datasheet is 0x44. The
datasheet don't include spaces in the value it displays as binary so
this was almost certainly just a typo reading 1000100.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220602162119.3393857-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 04f89b751304..deaad703a7db 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -403,9 +403,9 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-			      CS42L56_HPB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_HPB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 	SOC_DOUBLE_R_SX_TLV("LineOut Volume", CS42L56_LOA_VOLUME,
-			      CS42L56_LOB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_LOB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 
 	SOC_SINGLE_TLV("Bass Shelving Volume", CS42L56_TONE_CTL,
 			0, 0x00, 1, tone_tlv),
-- 
2.35.1

