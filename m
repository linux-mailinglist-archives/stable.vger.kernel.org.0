Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFBA23A4EF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgHCMbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgHCMbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296BC2054F;
        Mon,  3 Aug 2020 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457902;
        bh=v59zLHBmW/XwYl5cKPZsp7mFkI4UETwDCboivwR1CZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6u0jQsc29vImYlivawux9eHNVHYwSOsPJyaC63ZEXtzp1fUOvfmewejSv51UqcYO
         dAzOPVgKuO1Lr2hUqeQBwZUHrjo3eq187+/BixAn4xy+uC/gL0PhUie2Pfe2NVTs5o
         HneuMZlFIvIaMFVrFNk4EERUx1beqYw8f1G5VEOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/56] drm/amdgpu: fix multiple memory leaks in acp_hw_init
Date:   Mon,  3 Aug 2020 14:19:19 +0200
Message-Id: <20200803121850.526781250@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 57be09c6e8747bf48704136d9e3f92bfb93f5725 ]

In acp_hw_init there are some allocations that needs to be released in
case of failure:

1- adev->acp.acp_genpd should be released if any allocation attemp for
adev->acp.acp_cell, adev->acp.acp_res or i2s_pdata fails.
2- all of those allocations should be released if
mfd_add_hotplug_devices or pm_genpd_add_device fail.
3- Release is needed in case of time out values expire.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c | 34 ++++++++++++++++---------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
index 71efcf38f11be..94cd8a2610912 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -276,7 +276,7 @@ static int acp_hw_init(void *handle)
 	u32 val = 0;
 	u32 count = 0;
 	struct device *dev;
-	struct i2s_platform_data *i2s_pdata;
+	struct i2s_platform_data *i2s_pdata = NULL;
 
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
@@ -317,20 +317,21 @@ static int acp_hw_init(void *handle)
 	adev->acp.acp_cell = kcalloc(ACP_DEVS, sizeof(struct mfd_cell),
 							GFP_KERNEL);
 
-	if (adev->acp.acp_cell == NULL)
-		return -ENOMEM;
+	if (adev->acp.acp_cell == NULL) {
+		r = -ENOMEM;
+		goto failure;
+	}
 
 	adev->acp.acp_res = kcalloc(5, sizeof(struct resource), GFP_KERNEL);
 	if (adev->acp.acp_res == NULL) {
-		kfree(adev->acp.acp_cell);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto failure;
 	}
 
 	i2s_pdata = kcalloc(3, sizeof(struct i2s_platform_data), GFP_KERNEL);
 	if (i2s_pdata == NULL) {
-		kfree(adev->acp.acp_res);
-		kfree(adev->acp.acp_cell);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto failure;
 	}
 
 	switch (adev->asic_type) {
@@ -427,7 +428,7 @@ static int acp_hw_init(void *handle)
 	r = mfd_add_hotplug_devices(adev->acp.parent, adev->acp.acp_cell,
 								ACP_DEVS);
 	if (r)
-		return r;
+		goto failure;
 
 	if (adev->asic_type != CHIP_STONEY) {
 		for (i = 0; i < ACP_DEVS ; i++) {
@@ -435,7 +436,7 @@ static int acp_hw_init(void *handle)
 			r = pm_genpd_add_device(&adev->acp.acp_genpd->gpd, dev);
 			if (r) {
 				dev_err(dev, "Failed to add dev to genpd\n");
-				return r;
+				goto failure;
 			}
 		}
 	}
@@ -454,7 +455,8 @@ static int acp_hw_init(void *handle)
 			break;
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
-			return -ETIMEDOUT;
+			r = -ETIMEDOUT;
+			goto failure;
 		}
 		udelay(100);
 	}
@@ -471,7 +473,8 @@ static int acp_hw_init(void *handle)
 			break;
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
-			return -ETIMEDOUT;
+			r = -ETIMEDOUT;
+			goto failure;
 		}
 		udelay(100);
 	}
@@ -480,6 +483,13 @@ static int acp_hw_init(void *handle)
 	val &= ~ACP_SOFT_RESET__SoftResetAud_MASK;
 	cgs_write_register(adev->acp.cgs_device, mmACP_SOFT_RESET, val);
 	return 0;
+
+failure:
+	kfree(i2s_pdata);
+	kfree(adev->acp.acp_res);
+	kfree(adev->acp.acp_cell);
+	kfree(adev->acp.acp_genpd);
+	return r;
 }
 
 /**
-- 
2.25.1



