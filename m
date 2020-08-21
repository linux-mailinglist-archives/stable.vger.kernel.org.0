Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBE24DB47
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgHUQhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728439AbgHUQVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D3D22D0B;
        Fri, 21 Aug 2020 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026817;
        bh=ngB6DdBiJuvmnLavUkZSbxNw6b3Hq4QduT3Hww3mo2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg72yDFgwmWnY4Zp9s7alwKqO7JyIeVZF1tAm64j/1igICfQHg4tiT0Xasv5ZShY/
         505Te5gJS99DCsRJxwCj8y4RXyRtDkMd4Km38wwsFWYOAJkh0QapTmMaZjeC7qd4aG
         uBFgHYl08Udx13B5sY+TBPPvH9WP6GD3XfVbiMq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/22] ASoC: tegra: Fix reference count leaks.
Date:   Fri, 21 Aug 2020 12:19:54 -0400
Message-Id: <20200821162014.349506-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit deca195383a6085be62cb453079e03e04d618d6e ]

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count if pm_runtime_put is not called in
error handling paths. Call pm_runtime_put if pm_runtime_get_sync fails.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20200613204422.24484-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra30_ahub.c | 4 +++-
 sound/soc/tegra/tegra30_i2s.c  | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index fef3b9a21a667..e441e23a37e4f 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -656,8 +656,10 @@ static int tegra30_ahub_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(dev);
 		return ret;
+	}
 	ret = regcache_sync(ahub->regmap_ahub);
 	ret |= regcache_sync(ahub->regmap_apbif);
 	pm_runtime_put(dev);
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 8e55583aa104e..516f37896092c 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -552,8 +552,10 @@ static int tegra30_i2s_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(dev);
 		return ret;
+	}
 	ret = regcache_sync(i2s->regmap);
 	pm_runtime_put(dev);
 
-- 
2.25.1

