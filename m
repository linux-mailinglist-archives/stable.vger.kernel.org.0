Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A20349054
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhCYLdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhCYLcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4487C61A70;
        Thu, 25 Mar 2021 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671692;
        bh=pvBf/YINN+E8y4O0oiMRslXg0ySwZRGzzI2+yh2S1eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+Ag9xme0uYEfjT32PH+qZZbPnANNaHgu2s7VFhgYjOxHoXTPq7LTiIYChirXp5P0
         K9ZJzfUVckrl+fEVd5qKJyLR7wmdTVHRWWCizxuH0AFK03MAQ2J4v6c81DzvGHEY66
         yO2KNaziG28jbst923rVI0GaHRYwIu/44S52GA1DjysAk4OYHdMQzeP4PEInBs+0k2
         U3iPfK97a5V1fV8+YiBT0W7emud0tGJbPNZ9tk7IA9++pulEbtE+6o3Or3d0YU2eAH
         m4fNP5ES0RgsM7rY7XLNIRqpr16Q4A5VWXMjxFUUtLK6I8YaYmC80k99tUCWaTsoBy
         p4QpfS+Ah1LFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameer Pujar <spujar@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 15/16] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Thu, 25 Mar 2021 07:27:50 -0400
Message-Id: <20210325112751.1928421-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112751.1928421-1-sashal@kernel.org>
References: <20210325112751.1928421-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit dbf54a9534350d6aebbb34f5c1c606b81a4f35dd ]

Simple-card/audio-graph-card drivers do not handle MCLK clock when it
is specified in the codec device node. The expectation here is that,
the codec should actually own up the MCLK clock and do necessary setup
in the driver.

Suggested-by: Mark Brown <broonie@kernel.org>
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1615829492-8972-3-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index fa66b11df8d4..ae626d57c1ad 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3391,12 +3391,17 @@ static int rt5659_set_dai_sysclk(struct snd_soc_dai *dai,
 	struct snd_soc_codec *codec = dai->codec;
 	struct rt5659_priv *rt5659 = snd_soc_codec_get_drvdata(codec);
 	unsigned int reg_val = 0;
+	int ret;
 
 	if (freq == rt5659->sysclk && clk_id == rt5659->sysclk_src)
 		return 0;
 
 	switch (clk_id) {
 	case RT5659_SCLK_S_MCLK:
+		ret = clk_set_rate(rt5659->mclk, freq);
+		if (ret)
+			return ret;
+
 		reg_val |= RT5659_SCLK_SRC_MCLK;
 		break;
 	case RT5659_SCLK_S_PLL1:
-- 
2.30.1

