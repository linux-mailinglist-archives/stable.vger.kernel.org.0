Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF91A469C84
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358280AbhLFPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54388 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348468AbhLFPVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5474CB8111F;
        Mon,  6 Dec 2021 15:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F7DC341CA;
        Mon,  6 Dec 2021 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803866;
        bh=9k/wmdh+QryMKYR7/AfSxFGhRzyTRsW/XlBFVILplNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pfs9ZwwmeWy19b653A59tLZ7cQUd20+1Eu+3NWZhknIoItlhn1+4EWzFjlOfX+6rm
         B4zKq7xWV3MkQetMjD1Q/JmKBzAacIvcK/DCQsFVYdHPRKUdX/1rgZLzB7iDdqYQTw
         IQLseRvQw4qL4EGYXajgSjV4oTjXqGyFihuZ75JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 075/130] ASoC: tegra: Fix wrong value type in I2S
Date:   Mon,  6 Dec 2021 15:56:32 +0100
Message-Id: <20211206145602.266063962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 8a2c2fa0c5331445c801e9241f2bb4e0e2a895a8 upstream.

The enum controls are expected to use enumerated value type.
Update relevant references in control get/put callbacks.

Fixes: c0bfa98349d1 ("ASoC: tegra: Add Tegra210 based I2S driver")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-3-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_i2s.c |   42 +++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/sound/soc/tegra/tegra210_i2s.c
+++ b/sound/soc/tegra/tegra210_i2s.c
@@ -317,24 +317,27 @@ static int tegra210_i2s_get_control(stru
 {
 	struct snd_soc_component *compnt = snd_soc_kcontrol_component(kcontrol);
 	struct tegra210_i2s *i2s = snd_soc_component_get_drvdata(compnt);
-	long *uctl_val = &ucontrol->value.integer.value[0];
 
 	if (strstr(kcontrol->id.name, "Loopback"))
-		*uctl_val = i2s->loopback;
+		ucontrol->value.integer.value[0] = i2s->loopback;
 	else if (strstr(kcontrol->id.name, "FSYNC Width"))
-		*uctl_val = i2s->fsync_width;
+		ucontrol->value.integer.value[0] = i2s->fsync_width;
 	else if (strstr(kcontrol->id.name, "Capture Stereo To Mono"))
-		*uctl_val = i2s->stereo_to_mono[I2S_TX_PATH];
+		ucontrol->value.enumerated.item[0] =
+			i2s->stereo_to_mono[I2S_TX_PATH];
 	else if (strstr(kcontrol->id.name, "Capture Mono To Stereo"))
-		*uctl_val = i2s->mono_to_stereo[I2S_TX_PATH];
+		ucontrol->value.enumerated.item[0] =
+			i2s->mono_to_stereo[I2S_TX_PATH];
 	else if (strstr(kcontrol->id.name, "Playback Stereo To Mono"))
-		*uctl_val = i2s->stereo_to_mono[I2S_RX_PATH];
+		ucontrol->value.enumerated.item[0] =
+			i2s->stereo_to_mono[I2S_RX_PATH];
 	else if (strstr(kcontrol->id.name, "Playback Mono To Stereo"))
-		*uctl_val = i2s->mono_to_stereo[I2S_RX_PATH];
+		ucontrol->value.enumerated.item[0] =
+			i2s->mono_to_stereo[I2S_RX_PATH];
 	else if (strstr(kcontrol->id.name, "Playback FIFO Threshold"))
-		*uctl_val = i2s->rx_fifo_th;
+		ucontrol->value.integer.value[0] = i2s->rx_fifo_th;
 	else if (strstr(kcontrol->id.name, "BCLK Ratio"))
-		*uctl_val = i2s->bclk_ratio;
+		ucontrol->value.integer.value[0] = i2s->bclk_ratio;
 
 	return 0;
 }
@@ -344,10 +347,9 @@ static int tegra210_i2s_put_control(stru
 {
 	struct snd_soc_component *compnt = snd_soc_kcontrol_component(kcontrol);
 	struct tegra210_i2s *i2s = snd_soc_component_get_drvdata(compnt);
-	int value = ucontrol->value.integer.value[0];
 
 	if (strstr(kcontrol->id.name, "Loopback")) {
-		i2s->loopback = value;
+		i2s->loopback = ucontrol->value.integer.value[0];
 
 		regmap_update_bits(i2s->regmap, TEGRA210_I2S_CTRL,
 				   I2S_CTRL_LPBK_MASK,
@@ -362,24 +364,28 @@ static int tegra210_i2s_put_control(stru
 		 * cases mixer control is used to update custom values. A value
 		 * of "N" here means, width is "N + 1" bit clock wide.
 		 */
-		i2s->fsync_width = value;
+		i2s->fsync_width = ucontrol->value.integer.value[0];
 
 		regmap_update_bits(i2s->regmap, TEGRA210_I2S_CTRL,
 				   I2S_CTRL_FSYNC_WIDTH_MASK,
 				   i2s->fsync_width << I2S_FSYNC_WIDTH_SHIFT);
 
 	} else if (strstr(kcontrol->id.name, "Capture Stereo To Mono")) {
-		i2s->stereo_to_mono[I2S_TX_PATH] = value;
+		i2s->stereo_to_mono[I2S_TX_PATH] =
+			ucontrol->value.enumerated.item[0];
 	} else if (strstr(kcontrol->id.name, "Capture Mono To Stereo")) {
-		i2s->mono_to_stereo[I2S_TX_PATH] = value;
+		i2s->mono_to_stereo[I2S_TX_PATH] =
+			ucontrol->value.enumerated.item[0];
 	} else if (strstr(kcontrol->id.name, "Playback Stereo To Mono")) {
-		i2s->stereo_to_mono[I2S_RX_PATH] = value;
+		i2s->stereo_to_mono[I2S_RX_PATH] =
+			ucontrol->value.enumerated.item[0];
 	} else if (strstr(kcontrol->id.name, "Playback Mono To Stereo")) {
-		i2s->mono_to_stereo[I2S_RX_PATH] = value;
+		i2s->mono_to_stereo[I2S_RX_PATH] =
+			ucontrol->value.enumerated.item[0];
 	} else if (strstr(kcontrol->id.name, "Playback FIFO Threshold")) {
-		i2s->rx_fifo_th = value;
+		i2s->rx_fifo_th = ucontrol->value.integer.value[0];
 	} else if (strstr(kcontrol->id.name, "BCLK Ratio")) {
-		i2s->bclk_ratio = value;
+		i2s->bclk_ratio = ucontrol->value.integer.value[0];
 	}
 
 	return 0;


