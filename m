Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6720D990
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgF2Tsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387769AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA95F248B9;
        Mon, 29 Jun 2020 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444408;
        bh=oCoaaWGr5MOoT2sXVLSno5YS0mBX7CG2YT0Ne6tRkVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKs90qGUph2zbxXTg/jSXA/J3LbdjKvINSvxNlZ3vPZN+9VAJ0Exxw/Z663vChwEW
         W8BjVO+6enTXVb3Tm025EeM4STbBoBr4ZqsbDxcJovy69vr+2DXWHfIrRnWDwod2lq
         Y4Qfv5c5/K2nMfoz2SWOtzNKsk3MOvWIld/PZytI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Heiko Stuebner <heiko@sntech.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/178] ASoC: rockchip: Fix a reference count leak.
Date:   Mon, 29 Jun 2020 11:23:51 -0400
Message-Id: <20200629152523.2494198-87-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit f141a422159a199f4c8dedb7e0df55b3b2cf16cd ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count if pm_runtime_put is not called in
error handling paths. Call pm_runtime_put if pm_runtime_get_sync fails.

Fixes: fc05a5b22253 ("ASoC: rockchip: add support for pdm controller")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20200613205158.27296-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 7cd42fcfcf38a..1707414cfa921 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -590,8 +590,10 @@ static int rockchip_pdm_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(dev);
 		return ret;
+	}
 
 	ret = regcache_sync(pdm->regmap);
 
-- 
2.25.1

