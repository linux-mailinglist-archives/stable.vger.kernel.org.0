Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5F5316B4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbiEWRoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242302AbiEWRhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0806344C1;
        Mon, 23 May 2022 10:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E364261148;
        Mon, 23 May 2022 17:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA945C36AE3;
        Mon, 23 May 2022 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326906;
        bh=uve6lQG0Rs3spEl1DAnzTI4/k9kptoBOUPHVS5a98SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LR6xZwlRFcOEYFCS9+sHfqD7tl6TGV6QRYcCKEIvzOsY1tY4l7TLMl2BEu9JroU1W
         7BHs1QuVlvGeXxx/YHbz8LvFc7cIFlGRt4XUd8rLIJpVR88QD3C+sE6nzoWdNwHDCk
         cwRat+uEoHC9RTxzLhQpjc4N7DVJESmQp4lzQ0K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.17 063/158] drm/amd: Dont reset dGPUs if the system is going to s2idle
Date:   Mon, 23 May 2022 19:03:40 +0200
Message-Id: <20220523165841.302682275@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7123d39dc24dcd21ff23d75f46f926b15269b9da upstream.

An A+A configuration on ASUS ROG Strix G513QY proves that the ASIC
reset for handling aborted suspend can't work with s2idle.

This functionality was introduced in commit daf8de0874ab5b ("drm/amdgpu:
always reset the asic in suspend (v2)").  A few other commits have
gone on top of the ASIC reset, but this still doesn't work on the A+A
configuration in s2idle.

Avoid doing the reset on dGPUs specifically when using s2idle.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2008
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h      |    2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |   14 ++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c  |    2 +-
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1422,9 +1422,11 @@ static inline int amdgpu_acpi_smart_shif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
+static inline bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
 #endif
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1046,6 +1046,20 @@ bool amdgpu_acpi_is_s3_active(struct amd
 }
 
 /**
+ * amdgpu_acpi_should_gpu_reset
+ *
+ * @adev: amdgpu_device_pointer
+ *
+ * returns true if should reset GPU, false if not
+ */
+bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
+{
+	if (adev->flags & AMD_IS_APU)
+		return false;
+	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
+}
+
+/**
  * amdgpu_acpi_is_s0ix_active
  *
  * @adev: amdgpu_device_pointer
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2289,7 +2289,7 @@ static int amdgpu_pmops_suspend_noirq(st
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
-	if (!adev->in_s0ix)
+	if (amdgpu_acpi_should_gpu_reset(adev))
 		return amdgpu_asic_reset(adev);
 
 	return 0;


