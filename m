Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7005604E
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfFZDqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfFZDqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:46:45 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-90.mobile.att.net [107.77.172.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6C2208CB;
        Wed, 26 Jun 2019 03:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520804;
        bh=GY7/yu4d1WzxAMavxNuN6csP7JVMuMxs5fYitBhD/do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIw70lleqMzNLhTSEAmlwnvhD2mB7WF3GKYuSatrCT9P2Bux48fHiSrXhYqlEbhe4
         9OClKh2mDfsKr8dUv1sJK1BrG7syh+tpTwTuoAKoROSy4eqnXsm1iMkbhqOZCNRjOP
         tfzTW+Qa0HGNmu3q9nML1IeXWkOTBPcoKxMrWNr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu-Hsuan Hsu <yuhsuan@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 3/6] ASoC: max98090: remove 24-bit format support if RJ is 0
Date:   Tue, 25 Jun 2019 23:46:34 -0400
Message-Id: <20190626034637.24515-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034637.24515-1-sashal@kernel.org>
References: <20190626034637.24515-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu-Hsuan Hsu <yuhsuan@chromium.org>

[ Upstream commit 5628c8979642a076f91ee86c3bae5ad251639af0 ]

The supported formats are S16_LE and S24_LE now. However, by datasheet
of max98090, S24_LE is only supported when it is in the right justified
mode. We should remove 24-bit format if it is not in that mode to avoid
triggering error.

Signed-off-by: Yu-Hsuan Hsu <yuhsuan@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 3e65dc74eb33..e7aef841f87d 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1924,6 +1924,21 @@ static int max98090_configure_dmic(struct max98090_priv *max98090,
 	return 0;
 }
 
+static int max98090_dai_startup(struct snd_pcm_substream *substream,
+				struct snd_soc_dai *dai)
+{
+	struct snd_soc_component *component = dai->component;
+	struct max98090_priv *max98090 = snd_soc_component_get_drvdata(component);
+	unsigned int fmt = max98090->dai_fmt;
+
+	/* Remove 24-bit format support if it is not in right justified mode. */
+	if ((fmt & SND_SOC_DAIFMT_FORMAT_MASK) != SND_SOC_DAIFMT_RIGHT_J) {
+		substream->runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
+		snd_pcm_hw_constraint_msbits(substream->runtime, 0, 16, 16);
+	}
+	return 0;
+}
+
 static int max98090_dai_hw_params(struct snd_pcm_substream *substream,
 				   struct snd_pcm_hw_params *params,
 				   struct snd_soc_dai *dai)
@@ -2331,6 +2346,7 @@ EXPORT_SYMBOL_GPL(max98090_mic_detect);
 #define MAX98090_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE)
 
 static const struct snd_soc_dai_ops max98090_dai_ops = {
+	.startup = max98090_dai_startup,
 	.set_sysclk = max98090_dai_set_sysclk,
 	.set_fmt = max98090_dai_set_fmt,
 	.set_tdm_slot = max98090_set_tdm_slot,
-- 
2.20.1

