Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84508EA025
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfJ3Pxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbfJ3Pxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:53 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D8A2208C0;
        Wed, 30 Oct 2019 15:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450832;
        bh=9gjFkp5kO1oP3E8xCnnU6ER7abXY5+MJTsp64cWYHpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htF0YjXcw9yAYM0WWlBWmPOPKksQ3EUulV98sM60y4f8OZYX5XwlCdnvsTkadKDvA
         sCeBAoZqGXCdxms68/yPzaoYT64JjuYJBd7yAImvjPYHFOhfUJo01APsgsPw8yWNwQ
         KxyG42j4iuIVArk8C4wG4Oa8sk62YfiXFRxUokN8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 60/81] ASoC: SOF: control: return true when kcontrol values change
Date:   Wed, 30 Oct 2019 11:49:06 -0400
Message-Id: <20191030154928.9432-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tarcatu <dragos_tarcatu@mentor.com>

[ Upstream commit 95a32c98055f664f9b3f34c41e153d4dcedd0eff ]

All the kcontrol put() functions are currently returning 0 when
successful. This does not go well with alsamixer as it does
not seem to get notified on SND_CTL_EVENT_MASK_VALUE callbacks
when values change for (some of) the sof kcontrols.
This patch fixes that by returning true for volume, switch
and enum type kcontrols when values do change in put().

Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191018123806.18063-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/control.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/control.c b/sound/soc/sof/control.c
index a4983f90ff5b3..2b8711eda362b 100644
--- a/sound/soc/sof/control.c
+++ b/sound/soc/sof/control.c
@@ -60,13 +60,16 @@ int snd_sof_volume_put(struct snd_kcontrol *kcontrol,
 	struct snd_sof_dev *sdev = scontrol->sdev;
 	struct sof_ipc_ctrl_data *cdata = scontrol->control_data;
 	unsigned int i, channels = scontrol->num_channels;
+	bool change = false;
+	u32 value;
 
 	/* update each channel */
 	for (i = 0; i < channels; i++) {
-		cdata->chanv[i].value =
-			mixer_to_ipc(ucontrol->value.integer.value[i],
+		value = mixer_to_ipc(ucontrol->value.integer.value[i],
 				     scontrol->volume_table, sm->max + 1);
+		change = change || (value != cdata->chanv[i].value);
 		cdata->chanv[i].channel = i;
+		cdata->chanv[i].value = value;
 	}
 
 	/* notify DSP of mixer updates */
@@ -76,8 +79,7 @@ int snd_sof_volume_put(struct snd_kcontrol *kcontrol,
 					      SOF_CTRL_TYPE_VALUE_CHAN_GET,
 					      SOF_CTRL_CMD_VOLUME,
 					      true);
-
-	return 0;
+	return change;
 }
 
 int snd_sof_switch_get(struct snd_kcontrol *kcontrol,
@@ -105,11 +107,15 @@ int snd_sof_switch_put(struct snd_kcontrol *kcontrol,
 	struct snd_sof_dev *sdev = scontrol->sdev;
 	struct sof_ipc_ctrl_data *cdata = scontrol->control_data;
 	unsigned int i, channels = scontrol->num_channels;
+	bool change = false;
+	u32 value;
 
 	/* update each channel */
 	for (i = 0; i < channels; i++) {
-		cdata->chanv[i].value = ucontrol->value.integer.value[i];
+		value = ucontrol->value.integer.value[i];
+		change = change || (value != cdata->chanv[i].value);
 		cdata->chanv[i].channel = i;
+		cdata->chanv[i].value = value;
 	}
 
 	/* notify DSP of mixer updates */
@@ -120,7 +126,7 @@ int snd_sof_switch_put(struct snd_kcontrol *kcontrol,
 					      SOF_CTRL_CMD_SWITCH,
 					      true);
 
-	return 0;
+	return change;
 }
 
 int snd_sof_enum_get(struct snd_kcontrol *kcontrol,
@@ -148,11 +154,15 @@ int snd_sof_enum_put(struct snd_kcontrol *kcontrol,
 	struct snd_sof_dev *sdev = scontrol->sdev;
 	struct sof_ipc_ctrl_data *cdata = scontrol->control_data;
 	unsigned int i, channels = scontrol->num_channels;
+	bool change = false;
+	u32 value;
 
 	/* update each channel */
 	for (i = 0; i < channels; i++) {
-		cdata->chanv[i].value = ucontrol->value.enumerated.item[i];
+		value = ucontrol->value.enumerated.item[i];
+		change = change || (value != cdata->chanv[i].value);
 		cdata->chanv[i].channel = i;
+		cdata->chanv[i].value = value;
 	}
 
 	/* notify DSP of enum updates */
@@ -163,7 +173,7 @@ int snd_sof_enum_put(struct snd_kcontrol *kcontrol,
 					      SOF_CTRL_CMD_ENUM,
 					      true);
 
-	return 0;
+	return change;
 }
 
 int snd_sof_bytes_get(struct snd_kcontrol *kcontrol,
-- 
2.20.1

