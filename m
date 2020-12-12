Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CBA2D881A
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439454AbgLLQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439442AbgLLQKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:21 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/14] drm/tegra: sor: Disable clocks on error in tegra_sor_init()
Date:   Sat, 12 Dec 2020 11:08:20 -0500
Message-Id: <20201212160831.2335172-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160831.2335172-1-sashal@kernel.org>
References: <20201212160831.2335172-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit bf3a3cdcad40e5928a22ea0fd200d17fd6d6308d ]

Fix the missing clk_disable_unprepare() before return from
tegra_sor_init() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 75e65d9536d54..6c3d221652393 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2899,6 +2899,7 @@ static int tegra_sor_init(struct host1x_client *client)
 		if (err < 0) {
 			dev_err(sor->dev, "failed to deassert SOR reset: %d\n",
 				err);
+			clk_disable_unprepare(sor->clk);
 			return err;
 		}
 
@@ -2906,12 +2907,17 @@ static int tegra_sor_init(struct host1x_client *client)
 	}
 
 	err = clk_prepare_enable(sor->clk_safe);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(sor->clk);
 		return err;
+	}
 
 	err = clk_prepare_enable(sor->clk_dp);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(sor->clk_safe);
+		clk_disable_unprepare(sor->clk);
 		return err;
+	}
 
 	/*
 	 * Enable and unmask the HDA codec SCRATCH0 register interrupt. This
-- 
2.27.0

