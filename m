Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531BB349025
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCYLdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231638AbhCYLap (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EC2661A59;
        Thu, 25 Mar 2021 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671667;
        bh=s5OWk1cjPt8bU+1Vjn70hDX3t7XOAuZ7lzsGmHtrdtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvYKapQM2ReQIstxd9Q0N5tsKlBxslAvWDVGrg/QyvbuFh4GPa/zL9HvxjOz7p+p2
         LH+eRsVbTM0hhmtHwU18lA9nssF1sNaxMfriybA4X1Ha2gW9mlPK6i5gJTTC+UaZEB
         9PbgINAPo6eF6CF6A7ZaSPvHkBstQ2Aqz8ypSO/JAb4fc0UJySkZzII0CGs3eGDXKI
         S5WLVk3lyBZ6tzhs79+AO4a2W3uiAHpK20cSw5VRkypyO5VWuXN85PKz8WnoDtbvgq
         /BZMpQP34OHob+g2kseTuKqxo2kkhHKqM30CS8F747Qx8nZvwgGE2e1hk3A6uQmj+i
         0LOwRgSDoBvDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameer Pujar <spujar@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 17/20] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Thu, 25 Mar 2021 07:27:21 -0400
Message-Id: <20210325112724.1928174-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112724.1928174-1-sashal@kernel.org>
References: <20210325112724.1928174-1-sashal@kernel.org>
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
index 1c1a521c73cb..b331b3ba61a9 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3466,12 +3466,17 @@ static int rt5659_set_component_sysclk(struct snd_soc_component *component, int
 {
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
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

