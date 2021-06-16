Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C3C3A9F72
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhFPPiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234819AbhFPPhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F85561166;
        Wed, 16 Jun 2021 15:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857719;
        bh=SP954mOtF6wkMfdgsDZjIet5/ajxzQPhDm8AHQkgWKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=janWd2MKSW098iWvE07k29Hw3DQHTsCwbH0e58pWbKitzQpBsdE1uXoKjfu0cE587
         bl5wjueJ3HcUsFDSdBAlY5xXqewNVpj1rv8FMuSrP1b27jejaG3Pecr7M2luCfJVo7
         f2zm9Cl8ZEKmsyB6upPA1CvCp7XJM8FVsy69k670=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/38] drm/tegra: sor: Fully initialize SOR before registration
Date:   Wed, 16 Jun 2021 17:33:21 +0200
Message-Id: <20210616152835.787542808@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 5dea42759bcef74b0802ea64b904409bc37f9045 ]

Before registering the SOR host1x client, make sure that it is fully
initialized. This avoids a potential race condition between the SOR's
probe and the host1x device initialization in cases where the SOR is
the final sub-device to register to a host1x instance.

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 67a80dae1c00..32c83f2e386c 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -3922,17 +3922,10 @@ static int tegra_sor_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, sor);
 	pm_runtime_enable(&pdev->dev);
 
-	INIT_LIST_HEAD(&sor->client.list);
+	host1x_client_init(&sor->client);
 	sor->client.ops = &sor_client_ops;
 	sor->client.dev = &pdev->dev;
 
-	err = host1x_client_register(&sor->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
-		goto rpm_disable;
-	}
-
 	/*
 	 * On Tegra210 and earlier, provide our own implementation for the
 	 * pad output clock.
@@ -3944,13 +3937,13 @@ static int tegra_sor_probe(struct platform_device *pdev)
 				      sor->index);
 		if (!name) {
 			err = -ENOMEM;
-			goto unregister;
+			goto uninit;
 		}
 
 		err = host1x_client_resume(&sor->client);
 		if (err < 0) {
 			dev_err(sor->dev, "failed to resume: %d\n", err);
-			goto unregister;
+			goto uninit;
 		}
 
 		sor->clk_pad = tegra_clk_sor_pad_register(sor, name);
@@ -3961,14 +3954,20 @@ static int tegra_sor_probe(struct platform_device *pdev)
 		err = PTR_ERR(sor->clk_pad);
 		dev_err(sor->dev, "failed to register SOR pad clock: %d\n",
 			err);
-		goto unregister;
+		goto uninit;
+	}
+
+	err = __host1x_client_register(&sor->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+			err);
+		goto uninit;
 	}
 
 	return 0;
 
-unregister:
-	host1x_client_unregister(&sor->client);
-rpm_disable:
+uninit:
+	host1x_client_exit(&sor->client);
 	pm_runtime_disable(&pdev->dev);
 remove:
 	tegra_output_remove(&sor->output);
-- 
2.30.2



