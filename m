Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566C9360D4E
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhDOPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234424AbhDOO5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A2726113B;
        Thu, 15 Apr 2021 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498490;
        bh=yZ/1+PDdmK/8qy3NWGvkLT7ZEYhImdVj7J4PbJkz87s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vi/Bki6JLd4G/DeRraJPdvEsSqSMVk1rbYkpfbyFaII9w33b0obtBFXsAVd4DC63E
         LnkGDwv/aoPaLM0MRM2RVyUUQ3223nwgPvYnvZHzGNZgDkptF/7XECwqWDGM7gebpC
         469OQZOerDWufseWGtkEvB0U+nZvs/JOxY9Sggno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, Bastian Germann <bage@linutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/68] ASoC: sunxi: sun4i-codec: fill ASoC card owner
Date:   Thu, 15 Apr 2021 16:47:11 +0200
Message-Id: <20210415144415.449714640@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

[ Upstream commit 7c0d6e482062eb5c06ecccfab340abc523bdca00 ]

card->owner is a required property and since commit 81033c6b584b ("ALSA:
core: Warn on empty module") a warning is issued if it is empty. Add it.
This fixes following warning observed on Lamobo R1:

WARNING: CPU: 1 PID: 190 at sound/core/init.c:207 snd_card_new+0x430/0x480 [snd]
Modules linked in: sun4i_codec(E+) sun4i_backend(E+) snd_soc_core(E) ...
CPU: 1 PID: 190 Comm: systemd-udevd Tainted: G         C  E     5.10.0-1-armmp #1 Debian 5.10.4-1
Hardware name: Allwinner sun7i (A20) Family
Call trace:
 (snd_card_new [snd])
 (snd_soc_bind_card [snd_soc_core])
 (snd_soc_register_card [snd_soc_core])
 (sun4i_codec_probe [sun4i_codec])

Fixes: 45fb6b6f2aa3 ("ASoC: sunxi: add support for the on-chip codec on early Allwinner SoCs")
Related: commit 3c27ea23ffb4 ("ASoC: qcom: Set card->owner to avoid warnings")
Related: commit ec653df2a0cb ("drm/vc4/vc4_hdmi: fill ASoC card owner")
Cc: linux-arm-kernel@lists.infradead.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Bastian Germann <bage@linutronix.de>
Link: https://lore.kernel.org/r/20210331151843.30583-1-bage@linutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-codec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index baa9007464ed..700779ca82d0 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -1199,6 +1199,7 @@ static struct snd_soc_card *sun4i_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "sun4i-codec";
 	card->dapm_widgets	= sun4i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun4i_codec_card_dapm_widgets);
@@ -1231,6 +1232,7 @@ static struct snd_soc_card *sun6i_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "A31 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1284,6 +1286,7 @@ static struct snd_soc_card *sun8i_a23_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "A23 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1322,6 +1325,7 @@ static struct snd_soc_card *sun8i_h3_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "H3 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1360,6 +1364,7 @@ static struct snd_soc_card *sun8i_v3s_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "V3s Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
-- 
2.30.2



