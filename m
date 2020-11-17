Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D8E2B64F5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbgKQNvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731474AbgKQNbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7676620781;
        Tue, 17 Nov 2020 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619873;
        bh=UICNO9Y31Lhk/Lk46mkr+31/8pW7+nHiX0aUDE9I5XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZ043lKFk7SeEU1jDhfSAg8bNn683+ZTvLxr/auHqg8dHEZ8ZuhmOhDFto/VCHnc4
         p+CQkRN6kp8yjE5Myj7BFHjkFrS3LfgBK3xT5+F+pbMbXdzEEsftntHxs1DZ10ND8E
         waslq9gTGqMATn+Bl73AouNAeqCeQ80Dc5MotFak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 033/255] drm/panfrost: rename error labels in device_init
Date:   Tue, 17 Nov 2020 14:02:53 +0100
Message-Id: <20201117122140.553551213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit d3c335da0200be9287cdf5755d19f62ce1670a8d ]

Rename goto labels in device_init it will be easier to maintain.

Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200710095409.407087-8-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index b172087eee6ae..9f89984f652a6 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -216,56 +216,56 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 
 	err = panfrost_regulator_init(pfdev);
 	if (err)
-		goto err_out0;
+		goto out_clk;
 
 	err = panfrost_reset_init(pfdev);
 	if (err) {
 		dev_err(pfdev->dev, "reset init failed %d\n", err);
-		goto err_out1;
+		goto out_regulator;
 	}
 
 	err = panfrost_pm_domain_init(pfdev);
 	if (err)
-		goto err_out2;
+		goto out_reset;
 
 	res = platform_get_resource(pfdev->pdev, IORESOURCE_MEM, 0);
 	pfdev->iomem = devm_ioremap_resource(pfdev->dev, res);
 	if (IS_ERR(pfdev->iomem)) {
 		dev_err(pfdev->dev, "failed to ioremap iomem\n");
 		err = PTR_ERR(pfdev->iomem);
-		goto err_out3;
+		goto out_pm_domain;
 	}
 
 	err = panfrost_gpu_init(pfdev);
 	if (err)
-		goto err_out3;
+		goto out_pm_domain;
 
 	err = panfrost_mmu_init(pfdev);
 	if (err)
-		goto err_out4;
+		goto out_gpu;
 
 	err = panfrost_job_init(pfdev);
 	if (err)
-		goto err_out5;
+		goto out_mmu;
 
 	err = panfrost_perfcnt_init(pfdev);
 	if (err)
-		goto err_out6;
+		goto out_job;
 
 	return 0;
-err_out6:
+out_job:
 	panfrost_job_fini(pfdev);
-err_out5:
+out_mmu:
 	panfrost_mmu_fini(pfdev);
-err_out4:
+out_gpu:
 	panfrost_gpu_fini(pfdev);
-err_out3:
+out_pm_domain:
 	panfrost_pm_domain_fini(pfdev);
-err_out2:
+out_reset:
 	panfrost_reset_fini(pfdev);
-err_out1:
+out_regulator:
 	panfrost_regulator_fini(pfdev);
-err_out0:
+out_clk:
 	panfrost_clk_fini(pfdev);
 	return err;
 }
-- 
2.27.0



