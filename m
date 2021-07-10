Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434CB3C31C8
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhGJCpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhGJCnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A224261418;
        Sat, 10 Jul 2021 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884776;
        bh=18h5QgI/2WUOpyySkBczK5t5R7/zMrYxEkMhhzuJCBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBk6d4G5IaxWiOJfQMGawpMJ1ahHUnoLZFO6j8IpGonAbVoFN8i6nmGGE8LSn4QxN
         0LBCgDu8zLJ8luxTVXQmDg7v3LGeww2d6BNMFL1h5xq3sd1HX7L6eLBgTGNkRuZhr+
         qh+F8F+AOaeW4Cp2v4thZoU9GcNykx4SyyCjrGgBQNtnn++gsbGnX+Ejdc0UwSMyJr
         OAv4WJ8WAjVYnncrdTikeY+w/tdZRyq7JODtR/xllZd5g99NwtARbYVqPjglNvwq7i
         wlO9TwDW5QBABpBTWfonOrQr3zOSXd61KtkiGJZBJu+B8zIYqkw5xWrnDMwHTbXpuQ
         lAGPgIgwLxyQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 15/23] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:39:04 -0400
Message-Id: <20210710023912.3172972-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023912.3172972-1-sashal@kernel.org>
References: <20210710023912.3172972-1-sashal@kernel.org>
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
index b927f9c81d92..e69a7f8b6163 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3394,7 +3394,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

