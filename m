Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7542D3CDF65
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344769AbhGSPKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344174AbhGSPHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:07:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B74E611C1;
        Mon, 19 Jul 2021 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709663;
        bh=gQzsgDPXcbcYollQuPdz1JDbABIJHDdOb+hjNlPbhik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcAFxUdiyUxS6G3oYgVOOE7a49cY6vc9T9mNxdWyNoEBJHSjENoP1FDbVzJwDFANv
         v6hg8+NCwPmr30WttrmhDxax1TucbGnk5y6NyzjyWcXYc3y+BCn7NOEVGP6oI4QPCt
         WIuSGTJtPUKit+isy7B2uJ+TY++SZ2uZCZ4y03nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/149] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Mon, 19 Jul 2021 16:52:36 +0200
Message-Id: <20210719144912.842967055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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



