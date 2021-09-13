Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E14093B5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345709AbhIMO0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346545AbhIMOYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E6461529;
        Mon, 13 Sep 2021 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540914;
        bh=9ymwU4vLYalZSXSEX8SEiMq4+zWT1ftuULs5rsYQnP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A57nOcDSKS7i9qR5IFoblwrW+UBjhE0f4NXfoHU5XMTRs+BI+pdc2HTTVayN/3hQa
         rSf2v7oSABF0953j8L2mVVDWKLbyggMBEclHoI9dw80ahjTxkqeqOVN3HzXaUk4Lxt
         /JtUPJSWZVAKZmx8g37Nw2Nx8ZVc0qyPdKV1BgQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Claudius Heine <ch@denx.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 086/334] ASoC: tlv320aic32x4: Fix TAS2505/TAS2521 channel count
Date:   Mon, 13 Sep 2021 15:12:20 +0200
Message-Id: <20210913131116.292595180@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3694f996be5cb8374bd224f4e5462c945d359843 ]

The TAS2505/TAS2521 does support up to two channels, LEFT and RIGHT,
which are being alternated on the audio data bus by Word Clock, WCLK.
This is documented in TI slau472 2.7.1 Digital Audio Interface. Note
that both the LEFT and RIGHT channels are only used for audio INPUT,
while only the LEFT channel is used for audio OUTPUT.

Fixes: b4525b6196cd7 ("ASoC: tlv320aic32x4: add support for TAS2505")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Claudius Heine <ch@denx.de>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210708091229.56443-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 2e9175b37dc9..254a016cb1f3 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1131,7 +1131,7 @@ static struct snd_soc_dai_driver aic32x4_tas2505_dai = {
 	.playback = {
 			 .stream_name = "Playback",
 			 .channels_min = 1,
-			 .channels_max = 1,
+			 .channels_max = 2,
 			 .rates = SNDRV_PCM_RATE_8000_96000,
 			 .formats = AIC32X4_FORMATS,},
 	.ops = &aic32x4_ops,
-- 
2.30.2



