Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E47D3C2F5B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGJCbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234426AbhGJC31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C57613FC;
        Sat, 10 Jul 2021 02:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883990;
        bh=BAx2GDapydcayVPgmDKTjmO6TJRsJq0/Tnd8ZZI9me8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZza1hxT/M2aHwibrc6VBQ0I7Ts292cms7mgQQYFYNt4I0WIv42lf7wGib8oxNGwN
         +tp+1AlYcrUt7/A1zI8UtW2zbsGiMnnd44XHe3EP6GvlWqMHhU85X5VTdJjW17gstU
         2RCZU5WvlDPXuScmfZbv3kz1A3hJkl6ZB8pntNcIZk5jOq3GTBrdMwIyvY6+6nlhMC
         E1u2WCJtR63DwzH/7O+3UH3mCtECGj8dsB1vYSU09l3O1Ph0XsTF+y8VLg36oI487B
         P/8VRMQ3EUfx0Km5ABiy5MeXYEKClvE4yOCbKvBjx4QTua0QNaJhjGsivfldTZd1jN
         WVD3xD2e4vYtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 66/93] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:24:00 -0400
Message-Id: <20210710022428.3169839-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index b22674e3a89c..e677422c1058 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2804,7 +2804,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

