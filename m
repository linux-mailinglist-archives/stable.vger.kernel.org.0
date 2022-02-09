Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D04AFAF4
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbiBISlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240476AbiBISlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:41:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A90C05CB87;
        Wed,  9 Feb 2022 10:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0313F6006F;
        Wed,  9 Feb 2022 18:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD310C340E7;
        Wed,  9 Feb 2022 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432031;
        bh=SUV0sQS/PjrAEiqU1+IwNp58SrzXlY55YbhJgIcd5Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBuUhbMajWJl1YfJoVdAzBCxZnXa7u6sSeC1x9Fwi47cKfKEYYh7UHc6w7MjoUArx
         b91nReHGmrQkz/T95EdE5Hk88J7wdpYaz45H9/nG6txeln7IFXIrfN+0AECP9ZQSjb
         BDs31taFheKoSU5CBmLR/l8Fo1iAfnXIqt6C1pPJjhgQnJ1KbCgOCgormC8II0WTzE
         rsmwmXhHY698ew4VRkPNq+JtNzVOpNulGRpEtMTYmJTr39hVKxKf3/mglYRSyxXP2q
         rzYV2FEgdA34wsU0vCrNCaSRWRF2TdpCL0A9DBbKsYjsvRK8uwjxvEFVJ3nIUtyswc
         p+AqQkVyfFm6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        evan.quan@amd.com, Hawking.Zhang@amd.com,
        andrey.grodzovsky@amd.com, shaoyun.liu@amd.com,
        aurabindo.pillai@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 31/36] drm/amd: Only run s3 or s0ix if system is configured properly
Date:   Wed,  9 Feb 2022 13:37:54 -0500
Message-Id: <20220209183759.47134-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 04ef860469fda6a646dc841190d05b31fae68e8c ]

This will cause misconfigured systems to not run the GPU suspend
routines.

* In APUs that are properly configured system will go into s2idle.
* In APUs that are intended to be S3 but user selects
  s2idle the GPU will stay fully powered for the suspend.
* In APUs that are intended to be s2idle and system misconfigured
  the GPU will stay fully powered for the suspend.
* In systems that are intended to be s2idle, but AMD dGPU is also
  present, the dGPU will go through S3

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 41677f99c67b1..f5852bda59349 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1499,6 +1499,7 @@ static void amdgpu_drv_delayed_reset_work_handler(struct work_struct *work)
 static int amdgpu_pmops_prepare(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
 	/* Return a positive number here so
 	 * DPM_FLAG_SMART_SUSPEND works properly
@@ -1507,6 +1508,13 @@ static int amdgpu_pmops_prepare(struct device *dev)
 		return pm_runtime_suspended(dev) &&
 			pm_suspend_via_firmware();
 
+	/* if we will not support s3 or s2i for the device
+	 *  then skip suspend
+	 */
+	if (!amdgpu_acpi_is_s0ix_active(adev) &&
+	    !amdgpu_acpi_is_s3_active(adev))
+		return 1;
+
 	return 0;
 }
 
-- 
2.34.1

