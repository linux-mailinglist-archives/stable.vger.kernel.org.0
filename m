Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5039E268
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhFGQQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhFGQPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108C961432;
        Mon,  7 Jun 2021 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082414;
        bh=SP954mOtF6wkMfdgsDZjIet5/ajxzQPhDm8AHQkgWKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dp9s2q11B2PedS3ifVyRxaa1mp0aEramDjm8vgzP9s7pLwYqtMvoJD9fEo2fyQTpf
         eXfA+u+MVLdqbUvARRNf28VV2HoZVJ6+a10+QIejqhLjsViBKNSTbj8yL5wNYiKlXr
         4bneilO5+6KMnoF0roijUTl7HSxFtBCvgI4kvzm5G6tTuLYDYAlGK7NdqkCmfmuBBn
         sMVAzjsZDxwh7+q2W3c5n+vvUXg8UJOXE4YvXIS0SjrNFBZ7i0VGEaqNVngWCoNWKW
         ZL0dPFA4ue/ivEICk+AeviGeg8YcqIv/ZpSIkgsP2ikgLDI/vD/old/sNLbHmPv8l6
         DzdKLCjukNL2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/39] drm/tegra: sor: Fully initialize SOR before registration
Date:   Mon,  7 Jun 2021 12:12:51 -0400
Message-Id: <20210607161318.3583636-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

