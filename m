Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05863C3194
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhGJCmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235239AbhGJCln (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4998F613D3;
        Sat, 10 Jul 2021 02:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884738;
        bh=0qHn9VaHBqd6Gx7tq3pjOXAu9w80RSUBs+m5shv83k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr2eEt1fauIcxzsihfBx0FSUyGKwNM9JLH39EiSbNTr/6tkYASWluQqd7sC94S3WE
         8cchwjCFVA5FqS4B40r86dwR3yMELbAULxx3eG49WWnOXrmnwHPe/Tw8Z1msz+wb2T
         gkwcGf1P/gtDRMGZlTBDPTFdRitWdfSSY4PCthjnR9X8dWvoHOaUI2MuTjD01XlU4+
         S2cI9CEUkt80XxqBM6Ed/8JrI52wTnBJDK+1gVneNgrJ6KPYF8x+ZBQjLgTOPiAh7g
         fTsfp3Wk+VHiC30jh8aD1XnKZlYttFPmyi593/hHfPRqCrkoY6r5m28NogbLGXPzvp
         XLGQHdh9ZRt+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 17/26] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:35:55 -0400
Message-Id: <20210710023604.3172486-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
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
index 168559b5e9f3..0344d4423167 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3644,7 +3644,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

