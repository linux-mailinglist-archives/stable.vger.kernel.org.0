Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397133CE1F3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbhGSP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346593AbhGSP0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C6461002;
        Mon, 19 Jul 2021 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710801;
        bh=pAlfz564xk2BTIyFgBpAxGng8eKBs92lkfvotMxPEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvaghnsj1htbilHARter+DwKupGjP4F4aG+7kToSOHi1h84W5M1H+P1p6Eo+DfPfJ
         S+Oudq3C2ZJdNvTzaYx10ptdV/m6B5VpoV+KHa1IF5yW1+hmocL+IogiycaPQ9qowp
         hC4NzJU7QdAT6/bnDoI4peSlN4NL5D+gf9bzgotU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 113/351] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Mon, 19 Jul 2021 16:50:59 +0200
Message-Id: <20210719144948.221375695@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a76974ccfce1..af0129cf90a2 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2793,7 +2793,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2



