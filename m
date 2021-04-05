Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B208353D18
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhDEI6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhDEI6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8919860238;
        Mon,  5 Apr 2021 08:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613094;
        bh=pvBf/YINN+E8y4O0oiMRslXg0ySwZRGzzI2+yh2S1eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQ+TumKwWAywwi2CcPY+gqIE0dWiGsSlNIqRKLllGKyMqjeghzJIshiDQ8+MHP9Q3
         oCmNxb3fvZbNBb+P1EOyGQeC8VgLg+y4naj1wJyip+ff0jrFsb2VW2v1KIPLm4Fasg
         91RznS9e8oQv0bvkx1z0NO5D1TUO/vwHYjleyoqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sameer Pujar <spujar@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/52] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Mon,  5 Apr 2021 10:53:43 +0200
Message-Id: <20210405085022.565860015@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



