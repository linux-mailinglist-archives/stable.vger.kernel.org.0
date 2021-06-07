Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6430539E2F9
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhFGQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhFGQS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD6B56147D;
        Mon,  7 Jun 2021 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082462;
        bh=EoTNmkIv+BtWajlT5rFMTZnF88Sm8j3UhB6yO/D6bOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJlJXHOuP/fOjQ43iqNC0vbEyOxPeMFISRSyo6dk09fWqkhvkJlVGHw3EcJxpekKH
         akAQZloS5sKdmLJRlt462m5z1hXa9EKgUN6i1h04KOMaGE3C0615qq5BspWkPpnjiz
         yrYi4TXm9Y1BC31JFfl7c+bWg49rfYavs9Ctnby73hL/4VSVxTjbgMCwNC/+mNjc9z
         IpUwE3gFdtV0ooKexoFcqrlGKmXrK2MPlWNt+6cldN/3O+bhq92EcM9vzOeh9Mx9Ex
         Imnr4d8stLkWW8Nla67tes/qCUgNOmCLpsOsKhLes4TiY0UGiXvI92/Gin/43Vt4sF
         UlFYXq2rUeiGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Pavel Machek (CIP)" <pavel@denx.de>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/29] drm/tegra: sor: Do not leak runtime PM reference
Date:   Mon,  7 Jun 2021 12:13:50 -0400
Message-Id: <20210607161410.3584036-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Pavel Machek (CIP)" <pavel@denx.de>

[ Upstream commit 73a395c46704304b96bc5e2ee19be31124025c0c ]

It's theoretically possible for the runtime PM reference to leak if the
code fails anywhere between the pm_runtime_resume_and_get() and
pm_runtime_put() calls, so make sure to release the runtime PM reference
in that case.

Practically this will never happen because none of the functions will
fail on Tegra, but it's better for the code to be pedantic in case these
assumptions will ever become wrong.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
[treding@nvidia.com: add commit message]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 6c3d22165239..0419b6105c8a 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2875,21 +2875,21 @@ static int tegra_sor_init(struct host1x_client *client)
 		if (err < 0) {
 			dev_err(sor->dev, "failed to acquire SOR reset: %d\n",
 				err);
-			return err;
+			goto rpm_put;
 		}
 
 		err = reset_control_assert(sor->rst);
 		if (err < 0) {
 			dev_err(sor->dev, "failed to assert SOR reset: %d\n",
 				err);
-			return err;
+			goto rpm_put;
 		}
 	}
 
 	err = clk_prepare_enable(sor->clk);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable clock: %d\n", err);
-		return err;
+		goto rpm_put;
 	}
 
 	usleep_range(1000, 3000);
@@ -2900,7 +2900,7 @@ static int tegra_sor_init(struct host1x_client *client)
 			dev_err(sor->dev, "failed to deassert SOR reset: %d\n",
 				err);
 			clk_disable_unprepare(sor->clk);
-			return err;
+			goto rpm_put;
 		}
 
 		reset_control_release(sor->rst);
@@ -2929,6 +2929,12 @@ static int tegra_sor_init(struct host1x_client *client)
 	tegra_sor_writel(sor, value, SOR_INT_MASK);
 
 	return 0;
+
+rpm_put:
+	if (sor->rst)
+		pm_runtime_put(sor->dev);
+
+	return err;
 }
 
 static int tegra_sor_exit(struct host1x_client *client)
-- 
2.30.2

