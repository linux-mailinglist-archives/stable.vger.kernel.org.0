Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29363C2E65
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhGJC07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhGJC03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE7F61402;
        Sat, 10 Jul 2021 02:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883822;
        bh=7wFhkZ0IlNgtCAhPr5ZrgV3HSP2CLK9OONDhD4XycyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwRvFa9jS1tzZENhCVvzN6nyu6BYvHIMDdTgXMMrXcnDdZ8R1SncPjSKHLSoWxlO7
         hDNiNxSR10EBQcwhPaX4fEkGNsZYSk+AgmhwN2epn+kEqnsSkYxIs+mJSy5///7Fav
         J8f5o0Yzm3w2NQL3aG5s7HAOonKUHw5LyM7GpbsSfiYpy3U7VyM3Wp2BM/RC7lBsUD
         LTJvzuAFc4fd/L38pksOkF24ny9VpTLOLcgEd4ZhD4KhgZEjwO+P+TwV1GsgGztGAD
         PQrqQGVWTNzl2VzoCNXbIWXRha0qLwZOYyPIwd0NWUbL3To+/SI8wxoBQ1qFZ40NcW
         DgHiIicvO6TzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 071/104] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:21:23 -0400
Message-Id: <20210710022156.3168825-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 6680c12716d4..6d4b08e918de 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2796,7 +2796,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

