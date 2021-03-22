Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9934416F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhCVMdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhCVMcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 428E5619A2;
        Mon, 22 Mar 2021 12:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416361;
        bh=70DLq73q6UI4LCgVXa81q17CNFdeyeVDpQpHZ4G/API=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVkQCLWMlsal6JelsS63+KUGrmm3veYgTyz95eDZ2n/J8VZQ0qFgHB+3jt6CuAoVM
         fbzIHJHW2f0voBBHb+/P1oUdo+ilUmr5Vwt9nwXMHM5bft7CdyQwlInQFTICfBa0F7
         wKOQdwZ6pb45bljYQBbkiJbS4PgG7OL/mKDyxhHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 070/120] ASoC: codecs: lpass-va-macro: mute/unmute all active decimators
Date:   Mon, 22 Mar 2021 13:27:33 +0100
Message-Id: <20210322121932.019509347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 5346f0e80b7160c91fb599d4545fd12560c286ed ]

An interface can have multiple decimators enabled, so loop over all active
decimators. Otherwise only one channel will be unmuted, and other channels
will be zero. This fixes recording from dual DMIC as a single two channel
stream.

Also remove the now unused "active_decimator" field.

Fixes: 908e6b1df26e ("ASoC: codecs: lpass-va-macro: Add support to VA Macro")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210304215646.17956-1-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 91e6890d6efc..3d6976a3d9e4 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -189,7 +189,6 @@ struct va_macro {
 	struct device *dev;
 	unsigned long active_ch_mask[VA_MACRO_MAX_DAIS];
 	unsigned long active_ch_cnt[VA_MACRO_MAX_DAIS];
-	unsigned long active_decimator[VA_MACRO_MAX_DAIS];
 	u16 dmic_clk_div;
 
 	int dec_mode[VA_MACRO_NUM_DECIMATORS];
@@ -549,11 +548,9 @@ static int va_macro_tx_mixer_put(struct snd_kcontrol *kcontrol,
 	if (enable) {
 		set_bit(dec_id, &va->active_ch_mask[dai_id]);
 		va->active_ch_cnt[dai_id]++;
-		va->active_decimator[dai_id] = dec_id;
 	} else {
 		clear_bit(dec_id, &va->active_ch_mask[dai_id]);
 		va->active_ch_cnt[dai_id]--;
-		va->active_decimator[dai_id] = -1;
 	}
 
 	snd_soc_dapm_mixer_update_power(widget->dapm, kcontrol, enable, update);
@@ -880,18 +877,19 @@ static int va_macro_digital_mute(struct snd_soc_dai *dai, int mute, int stream)
 	struct va_macro *va = snd_soc_component_get_drvdata(component);
 	u16 tx_vol_ctl_reg, decimator;
 
-	decimator = va->active_decimator[dai->id];
-
-	tx_vol_ctl_reg = CDC_VA_TX0_TX_PATH_CTL +
-				VA_MACRO_TX_PATH_OFFSET * decimator;
-	if (mute)
-		snd_soc_component_update_bits(component, tx_vol_ctl_reg,
-					      CDC_VA_TX_PATH_PGA_MUTE_EN_MASK,
-					      CDC_VA_TX_PATH_PGA_MUTE_EN);
-	else
-		snd_soc_component_update_bits(component, tx_vol_ctl_reg,
-					      CDC_VA_TX_PATH_PGA_MUTE_EN_MASK,
-					      CDC_VA_TX_PATH_PGA_MUTE_DISABLE);
+	for_each_set_bit(decimator, &va->active_ch_mask[dai->id],
+			 VA_MACRO_DEC_MAX) {
+		tx_vol_ctl_reg = CDC_VA_TX0_TX_PATH_CTL +
+					VA_MACRO_TX_PATH_OFFSET * decimator;
+		if (mute)
+			snd_soc_component_update_bits(component, tx_vol_ctl_reg,
+					CDC_VA_TX_PATH_PGA_MUTE_EN_MASK,
+					CDC_VA_TX_PATH_PGA_MUTE_EN);
+		else
+			snd_soc_component_update_bits(component, tx_vol_ctl_reg,
+					CDC_VA_TX_PATH_PGA_MUTE_EN_MASK,
+					CDC_VA_TX_PATH_PGA_MUTE_DISABLE);
+	}
 
 	return 0;
 }
-- 
2.30.1



