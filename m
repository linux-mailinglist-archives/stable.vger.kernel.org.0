Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECB3F5625
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbfKHTG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391384AbfKHTG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC601222C6;
        Fri,  8 Nov 2019 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240017;
        bh=9gjFkp5kO1oP3E8xCnnU6ER7abXY5+MJTsp64cWYHpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whACLfSnykrVh7NfV/Yi9CDocnH8IdfaT055uU0UuMCzoBaBHHxBnr37dD3IbjhEL
         pvtHV0Zp2eAmjNSYtshsesPtRk8+Iko1RhG58S+W+eEbgTQFJ0K1NgiH8Phqy2wPnS
         zIHD1gR/Ab59pcw/Xh+ayqUB4gb8IdxLKlg35yHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 059/140] ASoC: SOF: control: return true when kcontrol values change
Date:   Fri,  8 Nov 2019 19:49:47 +0100
Message-Id: <20191108174908.995980180@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



