Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB35469E0D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388574AbhLFPeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46578 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349495AbhLFP3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D25F361358;
        Mon,  6 Dec 2021 15:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AF4C34902;
        Mon,  6 Dec 2021 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804347;
        bh=9velEWGf7XRota4AW/ofgutwRM87Lj20P6uIf/1mCbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya5k22QtVgH7gOTboI9mcm0ivTKNhEbS73KmDBMOgjYOq6yCftzd9A7venid+vC6V
         eKf6l7Wj9XGEl/gE4sgxpEcNG01NsR8xAnoV9IOvj0REDkXv4cNoJP7XLjkQJMoQHw
         M/mtG1WqxBBys6GCdWp+MIHj/uby+fzaHdWCX9xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 115/207] ASoC: tegra: Fix wrong value type in ADMAIF
Date:   Mon,  6 Dec 2021 15:56:09 +0100
Message-Id: <20211206145614.236014494@linuxfoundation.org>
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

commit 884c6cb3b7030f75c46e55b9e625d2372708c306 upstream.

The enum controls are expected to use enumerated value type.
Update relevant references in control get/put callbacks.

Fixes: f74028e159bb ("ASoC: tegra: Add Tegra210 based ADMAIF driver")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-2-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_admaif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/tegra/tegra210_admaif.c
+++ b/sound/soc/tegra/tegra210_admaif.c
@@ -430,7 +430,7 @@ static int tegra_admaif_get_control(stru
 	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
 	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
-	long *uctl_val = &ucontrol->value.integer.value[0];
+	unsigned int *uctl_val = &ucontrol->value.enumerated.item[0];
 
 	if (strstr(kcontrol->id.name, "Playback Mono To Stereo"))
 		*uctl_val = admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg];
@@ -450,7 +450,7 @@ static int tegra_admaif_put_control(stru
 	struct snd_soc_component *cmpnt = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *ec = (struct soc_enum *)kcontrol->private_value;
 	struct tegra_admaif *admaif = snd_soc_component_get_drvdata(cmpnt);
-	int value = ucontrol->value.integer.value[0];
+	unsigned int value = ucontrol->value.enumerated.item[0];
 
 	if (strstr(kcontrol->id.name, "Playback Mono To Stereo"))
 		admaif->mono_to_stereo[ADMAIF_TX_PATH][ec->reg] = value;


