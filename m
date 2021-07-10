Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972E3C3072
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhGJCfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234855AbhGJCeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A07613C8;
        Sat, 10 Jul 2021 02:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884296;
        bh=gQzsgDPXcbcYollQuPdz1JDbABIJHDdOb+hjNlPbhik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpNN2G/bLEfrpAJVP2lT4hoJ26y4JUU7l8kbN/XOIZ51J2a4uZti4d4UmZak9nhVV
         NjaGJh5thSlT7hebKcgTNzVLDxC790T4syU7Iio7iFwkHJffKMh2R5+JKnMZqUCamL
         ar47f1D7+RR3xFBsHHPG3xvk8uk6SOQXswVI1kI2mon6W79j37yChQFhmqfGgQvoR8
         2XlxnTjsIHtV3RB0Hk/TSgUrDz6N19is5vgh9wemZ/cKRcy5DB2ANecz+LM2iwQznV
         lhn4foncnl+LXu2A6LpgZmVYLHccqzTZohvsx3ZoYLhDK+D9lpxRfHIF8G0T9RdKNE
         RQBuyIJ8h9TyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 42/63] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:26:48 -0400
Message-Id: <20210710022709.3170675-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 7d3865a10b9ff2669c531d5ddd60bf46b3d48f1e ]

When devm_kcalloc() fails, the error code -ENOMEM should be returned
instead of -EINVAL.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210617103729.1918-1-thunder.leizhen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9df20768a8f2..c0e03cc8ea82 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3178,7 +3178,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

