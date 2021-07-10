Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BA13C3137
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhGJCk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233970AbhGJChn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:37:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 091FA613D9;
        Sat, 10 Jul 2021 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884498;
        bh=8Q3uEpjy477WheXpk2ubs8evkJ+OhUEsTaZIHEwoyiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+Utj5s0lNCCjm2A1pAS7F/t/QF5KitvomspzfVJR/EzZz99Mki/TRujIVReGyOPA
         ngQIhZOnBYja3tsWBxuqHJn6nnnyvWcduAjsjQrjcByonislRO/rOFcJjuZwkr2wcu
         dVqep9ja/h287xvwqOYcQRzwq0ObwOqnIWc4UcVOzkuc0CYCWRST+IFhh9jiU+ty4X
         exA46QeDXLgwWFLmF4eCSgns3Antda07qslRZsJElwf1fQSe/dKnhzizUf+zHmmrzh
         OGUF4eJAAFJHJLRpTbpyauif21bvtNpy94upDZJtnwc8XlvSXrj67l8buMJYR4Su+5
         rzSo0YTM/mpcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 27/39] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:31:52 -0400
Message-Id: <20210710023204.3171428-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index 595fe20bbc6d..8531b490f6f6 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3510,7 +3510,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

