Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04678259272
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgIAPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgIAPMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F370D2078B;
        Tue,  1 Sep 2020 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973150;
        bh=ngB6DdBiJuvmnLavUkZSbxNw6b3Hq4QduT3Hww3mo2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0/2TFyXwrwsqxTcfmGfrxo7ttvAiWVmgRzBnedTedSlVbWjCunA9Qldhg/v02Fbf
         lw6PMramfToCwMRMw1hetiN0XXXftY318xzefhZdEYHlSN1R7KE7/pquFWhTRFQeGa
         +4m4MhvAOouIflBtxwPl2+67JdyoJtrb6U7MzhBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/62] ASoC: tegra: Fix reference count leaks.
Date:   Tue,  1 Sep 2020 17:09:51 +0200
Message-Id: <20200901150921.131899860@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



