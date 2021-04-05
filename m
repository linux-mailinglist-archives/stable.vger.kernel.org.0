Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D3B353F71
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhDEJMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239088AbhDEJMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A031761393;
        Mon,  5 Apr 2021 09:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613915;
        bh=ms20fgAjE4ZdsIu+BDxgwfLClmgujadJWc2NWvyUMm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvuRN+7rAE372zOjtH7ulwPNjcHosfWCQ0qKFgQC5EYr+27zCG6R3X6B0kqTEnvw9
         nJoJWKOBx/NdB9e6TP7WDW/FT33fsuWTmAsY4AHzQ65F9FQ5yjTtZPCw4zYiHnrSKh
         M4XNB9G8W4f5qSJ6yAa7pGTpXfc8Cgf0kzW6/LMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 014/152] ASoC: cs42l42: Fix Bitclock polarity inversion
Date:   Mon,  5 Apr 2021 10:52:43 +0200
Message-Id: <20210405085034.685390531@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit e793c965519b8b7f2fea51a48398405e2a501729 ]

The driver was setting bit clock polarity opposite to intended polarity.
Also simplify the code by grouping ADC and DAC clock configurations into
a single field.

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210305173442.195740-2-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 20 ++++++++------------
 sound/soc/codecs/cs42l42.h | 11 ++++++-----
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 210fcbedf241..df0d5fec0287 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -797,27 +797,23 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* Bitclock/frame inversion */
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
+		asp_cfg_val |= CS42L42_ASP_SCPOL_NOR << CS42L42_ASP_SCPOL_SHIFT;
 		break;
 	case SND_SOC_DAIFMT_NB_IF:
-		asp_cfg_val |= CS42L42_ASP_POL_INV <<
-				CS42L42_ASP_LCPOL_IN_SHIFT;
+		asp_cfg_val |= CS42L42_ASP_SCPOL_NOR << CS42L42_ASP_SCPOL_SHIFT;
+		asp_cfg_val |= CS42L42_ASP_LCPOL_INV << CS42L42_ASP_LCPOL_SHIFT;
 		break;
 	case SND_SOC_DAIFMT_IB_NF:
-		asp_cfg_val |= CS42L42_ASP_POL_INV <<
-				CS42L42_ASP_SCPOL_IN_DAC_SHIFT;
 		break;
 	case SND_SOC_DAIFMT_IB_IF:
-		asp_cfg_val |= CS42L42_ASP_POL_INV <<
-				CS42L42_ASP_LCPOL_IN_SHIFT;
-		asp_cfg_val |= CS42L42_ASP_POL_INV <<
-				CS42L42_ASP_SCPOL_IN_DAC_SHIFT;
+		asp_cfg_val |= CS42L42_ASP_LCPOL_INV << CS42L42_ASP_LCPOL_SHIFT;
 		break;
 	}
 
-	snd_soc_component_update_bits(component, CS42L42_ASP_CLK_CFG,
-				CS42L42_ASP_MODE_MASK |
-				CS42L42_ASP_SCPOL_IN_DAC_MASK |
-				CS42L42_ASP_LCPOL_IN_MASK, asp_cfg_val);
+	snd_soc_component_update_bits(component, CS42L42_ASP_CLK_CFG, CS42L42_ASP_MODE_MASK |
+								      CS42L42_ASP_SCPOL_MASK |
+								      CS42L42_ASP_LCPOL_MASK,
+								      asp_cfg_val);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 9e3cc528dcff..1f0d67c95a9a 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -258,11 +258,12 @@
 #define CS42L42_ASP_SLAVE_MODE		0x00
 #define CS42L42_ASP_MODE_SHIFT		4
 #define CS42L42_ASP_MODE_MASK		(1 << CS42L42_ASP_MODE_SHIFT)
-#define CS42L42_ASP_SCPOL_IN_DAC_SHIFT	2
-#define CS42L42_ASP_SCPOL_IN_DAC_MASK	(1 << CS42L42_ASP_SCPOL_IN_DAC_SHIFT)
-#define CS42L42_ASP_LCPOL_IN_SHIFT	0
-#define CS42L42_ASP_LCPOL_IN_MASK	(1 << CS42L42_ASP_LCPOL_IN_SHIFT)
-#define CS42L42_ASP_POL_INV		1
+#define CS42L42_ASP_SCPOL_SHIFT		2
+#define CS42L42_ASP_SCPOL_MASK		(3 << CS42L42_ASP_SCPOL_SHIFT)
+#define CS42L42_ASP_SCPOL_NOR		3
+#define CS42L42_ASP_LCPOL_SHIFT		0
+#define CS42L42_ASP_LCPOL_MASK		(3 << CS42L42_ASP_LCPOL_SHIFT)
+#define CS42L42_ASP_LCPOL_INV		3
 
 #define CS42L42_ASP_FRM_CFG		(CS42L42_PAGE_12 + 0x08)
 #define CS42L42_ASP_STP_SHIFT		4
-- 
2.30.1



