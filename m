Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2CCE9F9D
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfJ3PuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbfJ3PuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:50:12 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C610520856;
        Wed, 30 Oct 2019 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450611;
        bh=AesfdGlm8YQjMxu4s+FElDE3//jeAMGU3vcsCdV64L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gStvRPr3aGJ/9MTyymnagKeT6R2visvWUGtDB93I4x6veNHikAUTuUg+2fLW26g1m
         tTI/VVk3dgPiaA9lzGO8jcIt2K5Bc0itDx3G5w1PZd0ax4da3VPzWcmGXew4stdPuT
         wayxA9iu6XUXO9LpD+k+Cd8R7r8eS9O8fc8MBQ7Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keyon Jie <yang.jie@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 13/81] ASoC: SOF: topology: fix parse fail issue for byte/bool tuple types
Date:   Wed, 30 Oct 2019 11:48:19 -0400
Message-Id: <20191030154928.9432-13-sashal@kernel.org>
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

From: Keyon Jie <yang.jie@linux.intel.com>

[ Upstream commit 2e305a074061121220a2828f97a57d315cf8efba ]

We are using sof_parse_word_tokens() to parse tokens with
bool/byte/short/word tuple types, here add the missing check, to fix the
parsing failure at byte/bool tuple types.

Signed-off-by: Keyon Jie <yang.jie@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 432ae343f9602..96230329e678f 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -907,7 +907,9 @@ static void sof_parse_word_tokens(struct snd_soc_component *scomp,
 		for (j = 0; j < count; j++) {
 			/* match token type */
 			if (!(tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_WORD ||
-			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_SHORT))
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_SHORT ||
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_BYTE ||
+			      tokens[j].type == SND_SOC_TPLG_TUPLE_TYPE_BOOL))
 				continue;
 
 			/* match token id */
-- 
2.20.1

