Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD52469DED
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388645AbhLFPe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46686 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385597AbhLFP30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE8F61348;
        Mon,  6 Dec 2021 15:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B84C34900;
        Mon,  6 Dec 2021 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804355;
        bh=HGJ4r0DMn362nLGtyubdq7Vjo+ARI5pMwZG3rn1LoBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ho0OBG7xB9maFnpbR4xu08G2Cf4gTeTvBTdTN0u8tEuwVsPfIPvARxtb4qlNhPGM/
         XVaebO/u9ZQt5uOFu3vw+OSzet8CZVRRm4gfgD0/qM0L6rLm+uv5CxwpalQ4SH3Q3J
         acHPo3R8OTyNtCyBZN295dHzUIrWvro2mGpkujco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 118/207] ASoC: tegra: Fix wrong value type in DSPK
Date:   Mon,  6 Dec 2021 15:56:12 +0100
Message-Id: <20211206145614.330229481@linuxfoundation.org>
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

commit 3aa0d5c8bb3f5ef622ec2764823f551a1f630711 upstream.

The enum controls are expected to use enumerated value type.
Update relevant references in control get/put callbacks.

Fixes: 327ef6470266 ("ASoC: tegra: Add Tegra186 based DSPK driver")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-5-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra186_dspk.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/sound/soc/tegra/tegra186_dspk.c
+++ b/sound/soc/tegra/tegra186_dspk.c
@@ -35,15 +35,15 @@ static int tegra186_dspk_get_control(str
 	if (strstr(kcontrol->id.name, "FIFO Threshold"))
 		ucontrol->value.integer.value[0] = dspk->rx_fifo_th;
 	else if (strstr(kcontrol->id.name, "OSR Value"))
-		ucontrol->value.integer.value[0] = dspk->osr_val;
+		ucontrol->value.enumerated.item[0] = dspk->osr_val;
 	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		ucontrol->value.integer.value[0] = dspk->lrsel;
+		ucontrol->value.enumerated.item[0] = dspk->lrsel;
 	else if (strstr(kcontrol->id.name, "Channel Select"))
-		ucontrol->value.integer.value[0] = dspk->ch_sel;
+		ucontrol->value.enumerated.item[0] = dspk->ch_sel;
 	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		ucontrol->value.integer.value[0] = dspk->mono_to_stereo;
+		ucontrol->value.enumerated.item[0] = dspk->mono_to_stereo;
 	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		ucontrol->value.integer.value[0] = dspk->stereo_to_mono;
+		ucontrol->value.enumerated.item[0] = dspk->stereo_to_mono;
 
 	return 0;
 }
@@ -53,20 +53,19 @@ static int tegra186_dspk_put_control(str
 {
 	struct snd_soc_component *codec = snd_soc_kcontrol_component(kcontrol);
 	struct tegra186_dspk *dspk = snd_soc_component_get_drvdata(codec);
-	int val = ucontrol->value.integer.value[0];
 
 	if (strstr(kcontrol->id.name, "FIFO Threshold"))
-		dspk->rx_fifo_th = val;
+		dspk->rx_fifo_th = ucontrol->value.integer.value[0];
 	else if (strstr(kcontrol->id.name, "OSR Value"))
-		dspk->osr_val = val;
+		dspk->osr_val = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "LR Polarity Select"))
-		dspk->lrsel = val;
+		dspk->lrsel = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "Channel Select"))
-		dspk->ch_sel = val;
+		dspk->ch_sel = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "Mono To Stereo"))
-		dspk->mono_to_stereo = val;
+		dspk->mono_to_stereo = ucontrol->value.enumerated.item[0];
 	else if (strstr(kcontrol->id.name, "Stereo To Mono"))
-		dspk->stereo_to_mono = val;
+		dspk->stereo_to_mono = ucontrol->value.enumerated.item[0];
 
 	return 0;
 }


