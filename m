Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86B57ABAC
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241043AbiGTBPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240894AbiGTBO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFAE66ADB;
        Tue, 19 Jul 2022 18:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6283B81DE2;
        Wed, 20 Jul 2022 01:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C8BC341CB;
        Wed, 20 Jul 2022 01:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279583;
        bh=8xXnKjZyFb32fVK2ioljdra851ab5ksW2y1qzA1F/0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbqWjEFfQ0RU7NA9ujO4uLx7QxOuDPfT32wDhqTejnqx9wTZ+wRsfpVSTWYNToLu7
         94GqbHA58TpWgTqMm9R9sx7oxcf4JgA7fYv62pAxi3ICAymIvPqEXTB84xFuxzKSlC
         fplITcnY2hHNgJupOhYc/CEbka8aHtZHL7Qr/vCsZarVl/frkPBnkoft3/gnqbFD0S
         iYadFWhsQohN4Q9zOaKLn/ukKf9jN9EdgwcsHri/THXACbKGD5v1sgMsu2iPi0ZGT4
         4nyYs4lIOtGz8E0nC/mW0I8kLUzlWnAtZsXRBRZMywBQN84bQj/h40WMT/HYmRWGWF
         LHn5TZByc82BA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, simont@opensource.cirrus.com,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 39/54] ASoC: wm5102: Fix event generation for output compensation
Date:   Tue, 19 Jul 2022 21:10:16 -0400
Message-Id: <20220720011031.1023305-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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

[ Upstream commit 71b5ab96ffe6589abe7a2e302b83f7a426ebe099 ]

The output compensation controls always returns zero regardless of if
the control value was updated. This results in missing notifications
to user-space of the control change. Update the handling to return 1
when the value is changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220628153409.3266932-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5102.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index da2f8998df87..b034df47a5ef 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -680,12 +680,17 @@ static int wm5102_out_comp_coeff_put(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct arizona *arizona = dev_get_drvdata(component->dev->parent);
+	uint16_t dac_comp_coeff = get_unaligned_be16(ucontrol->value.bytes.data);
+	int ret = 0;
 
 	mutex_lock(&arizona->dac_comp_lock);
-	arizona->dac_comp_coeff = get_unaligned_be16(ucontrol->value.bytes.data);
+	if (arizona->dac_comp_coeff != dac_comp_coeff) {
+		arizona->dac_comp_coeff = dac_comp_coeff;
+		ret = 1;
+	}
 	mutex_unlock(&arizona->dac_comp_lock);
 
-	return 0;
+	return ret;
 }
 
 static int wm5102_out_comp_switch_get(struct snd_kcontrol *kcontrol,
@@ -706,12 +711,20 @@ static int wm5102_out_comp_switch_put(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct arizona *arizona = dev_get_drvdata(component->dev->parent);
+	struct soc_mixer_control *mc = (struct soc_mixer_control *)kcontrol->private_value;
+	int ret = 0;
+
+	if (ucontrol->value.integer.value[0] > mc->max)
+		return -EINVAL;
 
 	mutex_lock(&arizona->dac_comp_lock);
-	arizona->dac_comp_enabled = ucontrol->value.integer.value[0];
+	if (arizona->dac_comp_enabled != ucontrol->value.integer.value[0]) {
+		arizona->dac_comp_enabled = ucontrol->value.integer.value[0];
+		ret = 1;
+	}
 	mutex_unlock(&arizona->dac_comp_lock);
 
-	return 0;
+	return ret;
 }
 
 static const char * const wm5102_osr_text[] = {
-- 
2.35.1

