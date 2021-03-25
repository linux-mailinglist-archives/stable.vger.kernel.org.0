Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F1348FF0
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhCYLav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231699AbhCYL3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C797661A49;
        Thu, 25 Mar 2021 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671639;
        bh=A4B6XbbT7KvxAU19tiURSpZujePNokG7twiWWsRMR8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRhY5nF6TqbzR7lbQo9Our3TvV4ZLWKyRPWcBj7H/jyS8v9mm3HD6HKRtQczMIYvP
         1O9CtcIJoyPJoBGdDHwNTTRZbtzlkIQBumPBUGC2QxtPQ+q0PfaPbmD8QJ5utD4BrU
         kVSmwr0zJGVXz2TPB+WcvQcH12DS8UpnU2rhUOPB+L5IW+9PyXLaR4zyIdBtO4qmkX
         SqjRQWHxhst6d3WpgyHmuOc1vw0ENC+f0WMh+WdMFV07vdwHwN27ywUkQINggJlc8z
         q3RveRb6w1IpokxxlW6JaGh/x7cw15niZPqoEUp5KObk9GC4ys0OO+rZ0GdcJtM/p1
         zll0VMmTmtQtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameer Pujar <spujar@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 21/24] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Thu, 25 Mar 2021 07:26:47 -0400
Message-Id: <20210325112651.1927828-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
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
index e66d08398f74..afd61599d94c 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3463,12 +3463,17 @@ static int rt5659_set_component_sysclk(struct snd_soc_component *component, int
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

