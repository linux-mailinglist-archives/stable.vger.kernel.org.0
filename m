Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3F53CDE88
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343823AbhGSPDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245694AbhGSPBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FDCC61221;
        Mon, 19 Jul 2021 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709347;
        bh=8Q3uEpjy477WheXpk2ubs8evkJ+OhUEsTaZIHEwoyiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl3//SUPXQoySSEFUhUGPrD68LYj+bz7P5iSeEfgy9O/umhc3vI7ML6oYiIHSY35f
         Geuarlf/wk4xYN7uEAFRx1Cl2fNhdWOGx+m+bKC+xv7h+Pn/vckIOfx7S5k70ovCNu
         vfsq931mdl3VbgWkf/POgwtuF5iIorsPpYJXaW0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 347/421] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Mon, 19 Jul 2021 16:52:38 +0200
Message-Id: <20210719144958.313681688@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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



