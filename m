Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82135BD63
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbhDLIvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238160AbhDLIsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:48:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58B706127B;
        Mon, 12 Apr 2021 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217277;
        bh=xhs+SsmSF64uQH9OVphNr1Utkklte6Lv+tSQ+ntyfBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXo0/e9ZIvTo+SzpIvMuFiZ0/Q9hWRYwA19C59801T+vjgsh9P4zmm0R8k2S24sam
         51tx7gS7Xx468G30jSyerZMAqzs3EL0p2K3SKmo/30mNS7fLlvkRkv3on3X/b0QcTN
         etBMeGD9lKvzVdrtMhNfAqYc6OZ5rhFP/x+wE6EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, Bastian Germann <bage@linutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/111] ASoC: sunxi: sun4i-codec: fill ASoC card owner
Date:   Mon, 12 Apr 2021 10:40:46 +0200
Message-Id: <20210412084006.523607018@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
index ee448d5e07a6..c4021d6ac9df 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -1364,6 +1364,7 @@ static struct snd_soc_card *sun4i_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "sun4i-codec";
 	card->dapm_widgets	= sun4i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun4i_codec_card_dapm_widgets);
@@ -1396,6 +1397,7 @@ static struct snd_soc_card *sun6i_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "A31 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1449,6 +1451,7 @@ static struct snd_soc_card *sun8i_a23_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "A23 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1487,6 +1490,7 @@ static struct snd_soc_card *sun8i_h3_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "H3 Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
@@ -1525,6 +1529,7 @@ static struct snd_soc_card *sun8i_v3s_codec_create_card(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	card->dev		= dev;
+	card->owner		= THIS_MODULE;
 	card->name		= "V3s Audio Codec";
 	card->dapm_widgets	= sun6i_codec_card_dapm_widgets;
 	card->num_dapm_widgets	= ARRAY_SIZE(sun6i_codec_card_dapm_widgets);
-- 
2.30.2



