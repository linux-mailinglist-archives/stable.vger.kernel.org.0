Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D086C451F2D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355696AbhKPAii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344407AbhKOTYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036F663485;
        Mon, 15 Nov 2021 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002629;
        bh=xQPaGuNlHURMyO4yzI1Egjz7+iUyliFqHSqrTRTOcpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/Waizlo/yaskdth99mJCfyquDlwncmmna2dnwEizZcQ42J84QJUmeHOVEvsAlKUq
         7Da72J0Rf1f2GRyMNcLu7oNCLvAMjGdHROMjjKVCuM5psg2vTraTrRKlmH/7i6wkZP
         cdt0C6Jsidm+psFXJ6xHElmKPAsLfyHoX6Qzwiaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 640/917] ASoC: cs42l42: Always configure both ASP TX channels
Date:   Mon, 15 Nov 2021 18:02:15 +0100
Message-Id: <20211115165450.534047148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 6e6825801ab926360f7f4f2dbcfd107d5ab8f025 ]

An I2S frame always has two slots (left and right) even when sending
mono. The right channel (channel 2) of ASP TX will always have the
same bit width as the left channel and will always be on the high
phase of LRCLK.

The previous implementation always passed the field masks for both
channels to snd_soc_component_update_bits() but for mono the written value
only contained the settings for channel 1. The result was that for mono
channel 2 was set to 8-bit (which is an invalid configuration) with both
channels on the low phase of LRCLK.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 585e7079de0e ("ASoC: cs42l42: Add Capture Support")
Link: https://lore.kernel.org/r/20211015133619.4698-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 9a463ab54bddc..4548dae7ed834 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -853,11 +853,10 @@ static int cs42l42_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	switch(substream->stream) {
 	case SNDRV_PCM_STREAM_CAPTURE:
-		if (channels == 2) {
-			val |= CS42L42_ASP_TX_CH2_AP_MASK;
-			val |= width << CS42L42_ASP_TX_CH2_RES_SHIFT;
-		}
-		val |= width << CS42L42_ASP_TX_CH1_RES_SHIFT;
+		/* channel 2 on high LRCLK */
+		val = CS42L42_ASP_TX_CH2_AP_MASK |
+		      (width << CS42L42_ASP_TX_CH2_RES_SHIFT) |
+		      (width << CS42L42_ASP_TX_CH1_RES_SHIFT);
 
 		snd_soc_component_update_bits(component, CS42L42_ASP_TX_CH_AP_RES,
 				CS42L42_ASP_TX_CH1_AP_MASK | CS42L42_ASP_TX_CH2_AP_MASK |
-- 
2.33.0



