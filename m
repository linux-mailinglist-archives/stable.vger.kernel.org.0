Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0A57AC37
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiGTBUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241767AbiGTBTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:19:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B24A6D9E4;
        Tue, 19 Jul 2022 18:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40DC61729;
        Wed, 20 Jul 2022 01:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFE6C341C6;
        Wed, 20 Jul 2022 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279749;
        bh=zpto+oeNiWjXnod2Q4EhyPbxGSUuEeTxG/WNDLCYAkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJHJnu59Xbj4LOfhpk4QbJ8AYKw2lnNZ7sqFXVQha7RRL8yCFAC1o0sUvD5DjqnYb
         V8UF/f8tIOwtwlg8wVgZFq1iPcUzYyjcKVca37MPbXKiRztVDnwP1+MEezRmgD7qbE
         qjzLmC6Mzhd1U88j/++jNqGVvueCmuSq39wvfcJJHFbFgXw+Zk4hCWjWNP1QbWWprf
         bk4fCJz/U98v/0Iv6+ZwHoNB3Qj4lcl9hr+VkyhQ/S6rpkYtsFWzT7ievW3CDryAcN
         zJX86uoc8/F/UEwM9Da3NZMZD25P92hpU66SXL20zryIwFCl2z97BuIhG+LgX+q/dK
         dLBpwBswXjRSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 31/42] ASoC: wm8998: Fix event generation for input mux
Date:   Tue, 19 Jul 2022 21:13:39 -0400
Message-Id: <20220720011350.1024134-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 15b2e5d10ccf32a1a1ae7c636511e2f51320fdb5 ]

wm8998_inmux_put returns the value of snd_soc_dapm_mux_update_power,
which returns a 1 if a path was found for the kcontrol. This is
obviously different to the expected return a 1 if the control
was updated value. This results in spurious notifications to
user-space. Update the handling to only return a 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220628153409.3266932-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8998.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/wm8998.c b/sound/soc/codecs/wm8998.c
index 00b59fc9b1fe..ab5481187c71 100644
--- a/sound/soc/codecs/wm8998.c
+++ b/sound/soc/codecs/wm8998.c
@@ -108,6 +108,7 @@ static int wm8998_inmux_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mode_reg, mode_index;
 	unsigned int mux, inmode, src_val, mode_val;
+	int change, ret;
 
 	mux = ucontrol->value.enumerated.item[0];
 	if (mux > 1)
@@ -137,14 +138,20 @@ static int wm8998_inmux_put(struct snd_kcontrol *kcontrol,
 	snd_soc_component_update_bits(component, mode_reg,
 				      ARIZONA_IN1_MODE_MASK, mode_val);
 
-	snd_soc_component_update_bits(component, e->reg,
-				      ARIZONA_IN1L_SRC_MASK |
-				      ARIZONA_IN1L_SRC_SE_MASK,
-				      src_val);
+	change = snd_soc_component_update_bits(component, e->reg,
+					       ARIZONA_IN1L_SRC_MASK |
+					       ARIZONA_IN1L_SRC_SE_MASK,
+					       src_val);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol,
-					     ucontrol->value.enumerated.item[0],
-					     e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol,
+					    ucontrol->value.enumerated.item[0],
+					    e, NULL);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 
 static const char * const wm8998_inmux_texts[] = {
-- 
2.35.1

