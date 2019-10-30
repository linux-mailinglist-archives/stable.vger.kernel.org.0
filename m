Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3AE9FAE
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfJ3PvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfJ3PvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:01 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532A02087E;
        Wed, 30 Oct 2019 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450660;
        bh=4py+xzrfM5ohrANP39y//v96cgpB4cx/K0n1sj51s2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkTsKneTphSUVJqfy92Dx2bNeofNJSfUfjdN/aOjvZK/kNUmt2tB0atcDFDIc6sJc
         DCDsiGvPQrMpJV1Q4j0WUC1p/DyVLLp3+HGBOzFGk4kyWIDskUe0kndouMc/sh7rl6
         XSuTpAt54fn4MQXSeo+Th/o+rpiaB2GSE9wpE7ns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaska Uimonen <jaska.uimonen@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 17/81] ASoC: rt5682: add NULL handler to set_jack function
Date:   Wed, 30 Oct 2019 11:48:23 -0400
Message-Id: <20191030154928.9432-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@intel.com>

[ Upstream commit a315e76fc544f09daf619530a7b2f85865e6b25e ]

Implement NULL handler in set_jack function to disable
irq's.

Signed-off-by: Jaska Uimonen <jaska.uimonen@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927201408.925-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 1ef470700ed5f..c50b75ce82e0b 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -995,6 +995,16 @@ static int rt5682_set_jack_detect(struct snd_soc_component *component,
 {
 	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
+	rt5682->hs_jack = hs_jack;
+
+	if (!hs_jack) {
+		regmap_update_bits(rt5682->regmap, RT5682_IRQ_CTRL_2,
+				   RT5682_JD1_EN_MASK, RT5682_JD1_DIS);
+		regmap_update_bits(rt5682->regmap, RT5682_RC_CLK_CTRL,
+				   RT5682_POW_JDH | RT5682_POW_JDL, 0);
+		return 0;
+	}
+
 	switch (rt5682->pdata.jd_src) {
 	case RT5682_JD1:
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_2,
@@ -1032,8 +1042,6 @@ static int rt5682_set_jack_detect(struct snd_soc_component *component,
 		break;
 	}
 
-	rt5682->hs_jack = hs_jack;
-
 	return 0;
 }
 
-- 
2.20.1

