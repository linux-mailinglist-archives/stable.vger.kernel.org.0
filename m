Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E14469DDD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388477AbhLFPdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378451AbhLFP30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81A746130D;
        Mon,  6 Dec 2021 15:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6616FC34901;
        Mon,  6 Dec 2021 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804352;
        bh=i+jgwPIrm0lnwRxNLGX7q2jp31+Kqd9MHs7MUO9ZOfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acxvJ6TXtp6Xh+bCK49SIF1AjDCEpkOJI8yXVD9gouJ4lYFuJwM9hpzSvLwO5V9bi
         PUSGNhbd8IwBwYibFgm7K2/JGYQXrZZT2ETchJrpd35juGbKFUU/1BQd7TdJG/COe8
         bR+g/8Uf914V/UG3WbGztuGtgpbPGwj5oNDMTVmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 117/207] ASoC: tegra: Fix wrong value type in DMIC
Date:   Mon,  6 Dec 2021 15:56:11 +0100
Message-Id: <20211206145614.297179727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 559d234569a998a4004de1bd1f12da5487fb826e upstream.

The enum controls are expected to use enumerated value type.
Update relevant references in control get/put callbacks.

Fixes: 8c8ff982e9e2 ("ASoC: tegra: Add Tegra210 based DMIC driver")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-4-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_dmic.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/sound/soc/tegra/tegra210_dmic.c
+++ b/sound/soc/tegra/tegra210_dmic.c
@@ -165,15 +165,15 @@ static int tegra210_dmic_get_control(str
 	if (strstr(kcontrol->id.name, "Boost Gain Volume"))
 		ucontrol->value.integer.value[0] = dmic->boost_gain;
 	else if (strstr(kcontrol->id.name, "Channel Select"))
-		ucontrol->value.integer.value[0] = dmic->ch_select;
+		ucontrol->value.enumerated.item[0] = dmic->ch_select;
 	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		ucontrol->value.integer.value[0] = dmic->mono_to_stereo;
+		ucontrol->value.enumerated.item[0] = dmic->mono_to_stereo;
 	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		ucontrol->value.integer.value[0] = dmic->stereo_to_mono;
+		ucontrol->value.enumerated.item[0] = dmic->stereo_to_mono;
 	else if (strstr(kcontrol->id.name, "OSR Value"))
-		ucontrol->value.integer.value[0] = dmic->osr_val;
+		ucontrol->value.enumerated.item[0] = dmic->osr_val;
 	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		ucontrol->value.integer.value[0] = dmic->lrsel;
+		ucontrol->value.enumerated.item[0] = dmic->lrsel;
 
 	return 0;
 }
@@ -183,20 +183,19 @@ static int tegra210_dmic_put_control(str
 {
 	struct snd_soc_component *comp = snd_soc_kcontrol_component(kcontrol);
 	struct tegra210_dmic *dmic = snd_soc_component_get_drvdata(comp);
-	int value = ucontrol->value.integer.value[0];
 
 	if (strstr(kcontrol->id.name, "Boost Gain Volume"))
-		dmic->boost_gain = value;
+		dmic->boost_gain = ucontrol->value.integer.value[0];
 	else if (strstr(kcontrol->id.name, "Channel Select"))
-		dmic->ch_select = ucontrol->value.integer.value[0];
+		dmic->ch_select = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		dmic->mono_to_stereo = value;
+		dmic->mono_to_stereo = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		dmic->stereo_to_mono = value;
+		dmic->stereo_to_mono = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "OSR Value"))
-		dmic->osr_val = value;
+		dmic->osr_val = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		dmic->lrsel = value;
+		dmic->lrsel = ucontrol->value.enumerated.item[0];
 
 	return 0;
 }


