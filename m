Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4B93ED5E2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbhHPNPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239754AbhHPNOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87BCD632C6;
        Mon, 16 Aug 2021 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119488;
        bh=ytSOdjvMoHCvvmXSDtw8YN6Tm1fNm25S8bOTjIG/qRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/DdvyHdJzSHe6T7j1SG8uj/4JTxrK7Z+WirS6YbwxiEs//HsB2AmOniCuAJZXKAi
         P1DAoZX9U0K944Gb4AGcEcEC0IB83SoEKMaTRf0BLx0C7MgWM7ntaYUX+DQB/pPKNw
         LeemaRMwrojw28SA7H/4utcBDaw11s1qR1dMB2L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 045/151] ASoC: cs42l42: Fix bclk calculation for mono
Date:   Mon, 16 Aug 2021 15:01:15 +0200
Message-Id: <20210816125445.559665412@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 926ef1a4c245c093acc07807e466ad2ef0ff6ccb ]

An I2S frame always has a left and right channel slot even if mono
data is being sent. So if channels==1 the actual bitclock frequency
is 2 * snd_soc_params_to_bclk(params).

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2cdba9b045c7 ("ASoC: cs42l42: Use bclk from hw_params if set_sysclk was not called")
Link: https://lore.kernel.org/r/20210729170929.6589-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 0d31c84b0445..fe73a5c70bdd 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -820,6 +820,10 @@ static int cs42l42_pcm_hw_params(struct snd_pcm_substream *substream,
 	cs42l42->srate = params_rate(params);
 	cs42l42->bclk = snd_soc_params_to_bclk(params);
 
+	/* I2S frame always has 2 channels even for mono audio */
+	if (channels == 1)
+		cs42l42->bclk *= 2;
+
 	switch(substream->stream) {
 	case SNDRV_PCM_STREAM_CAPTURE:
 		if (channels == 2) {
-- 
2.30.2



