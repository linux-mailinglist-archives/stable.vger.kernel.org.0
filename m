Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60AE2A4B75
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgKCQ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:14 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DAC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:14 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 12so11289378qkl.8
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4o3K+SXk1EZriNkflBZWyIPiJPUVnsfHwzI5+HZSis=;
        b=ob76AkpqORoGe5bzPp69+AHoOQiIe0ZA1QTopdWiv8NaadbWWqgwjoVnB8NHNRdmcu
         etvvWs14opZZWKTHFvWQfS48ugqovlvNTZZtvpq2qJEsGCMufdFWnZ2DgHOyAkaTXyN3
         Tz8OjY6kogQFwwwRcr2lbs53SqwmAAASBBz9NQ+jiljrndcK+tRD8zxWMAXU7n0c0GSv
         Vy7e5C9IMb1RxUMx8Vj4I+Khn3pMbfH1PxOmDaC5sNU6UG8PWub/baWHYEr12mePOL0y
         BfhOYHPVFuxolvY+mkb4sr+jk3KSvq1ad0+vz0hJSlNUpLqBYREkVWSa/GxX1i4iHy1u
         LKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4o3K+SXk1EZriNkflBZWyIPiJPUVnsfHwzI5+HZSis=;
        b=XpQ3sA6dtKWK0dw6WvWWRXA+uq7bPzdzlWt3jE6uKC9AMSNBGlNt2KdjkXactjnlXF
         DC/CwVHBPTaRnujhQq5lYTwSdgNKVehSdXgHFvsFWOF3Glqgz2qHPuaEN5/gVOEQQqZu
         jXhp0R6XPP2S1NkovJQKRF2+X5vHR+ePNgQMJwolUHBBS8nageKt/bOSOhsbvHeRIgRS
         NOgd3QLZ4P7DX5PmSFVh1L/lWjuNA5H1lSFts/sNoWNZVEz6K7B3ruuUS6s47OGmVHYs
         169Y7/N4K3n9lybAG+JJB5aQIdn2I96npy5t+1YlkjOd1xIaAZdgBXlEqU1g/cFor5/W
         5DmQ==
X-Gm-Message-State: AOAM5306tUBOuP4zPHh/2LBp4LkBSLShGck17wzye2CU/27A4d7hyOvp
        EoLuu+nAWo6HSBi4BhmyoyqCdzenpVA=
X-Google-Smtp-Source: ABdhPJx7srLkjmmbBWeIglraiCbbzVRpaZYC834dp9tCiXDrCrp3d59P3i3Cr9Fe0KWa+CIFpe631w==
X-Received: by 2002:a37:617:: with SMTP id 23mr19974272qkg.256.1604420953434;
        Tue, 03 Nov 2020 08:29:13 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:12 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 1/7] drm/amdgpu/swsmu: drop smu i2c bus on navi1x
Date:   Tue,  3 Nov 2020 11:28:57 -0500
Message-Id: <20201103162903.687752-3-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stop registering the SMU i2c bus on navi1x.  This leads to instability
issues when userspace processes mess with the bus and also seems to
cause display stability issues in some cases.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1314
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1341
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 10105d0c9763f058f6a9a09f78397d5bf94dc94c)
---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c | 26 ----------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
index b1547a83e721..e0992cd7914e 100644
--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -2463,37 +2463,11 @@ static const struct i2c_algorithm navi10_i2c_algo = {
 	.functionality = navi10_i2c_func,
 };
 
-static int navi10_i2c_control_init(struct smu_context *smu, struct i2c_adapter *control)
-{
-	struct amdgpu_device *adev = to_amdgpu_device(control);
-	int res;
-
-	control->owner = THIS_MODULE;
-	control->class = I2C_CLASS_SPD;
-	control->dev.parent = &adev->pdev->dev;
-	control->algo = &navi10_i2c_algo;
-	snprintf(control->name, sizeof(control->name), "AMDGPU SMU");
-
-	res = i2c_add_adapter(control);
-	if (res)
-		DRM_ERROR("Failed to register hw i2c, err: %d\n", res);
-
-	return res;
-}
-
-static void navi10_i2c_control_fini(struct smu_context *smu, struct i2c_adapter *control)
-{
-	i2c_del_adapter(control);
-}
-
-
 static const struct pptable_funcs navi10_ppt_funcs = {
 	.get_allowed_feature_mask = navi10_get_allowed_feature_mask,
 	.set_default_dpm_table = navi10_set_default_dpm_table,
 	.dpm_set_vcn_enable = navi10_dpm_set_vcn_enable,
 	.dpm_set_jpeg_enable = navi10_dpm_set_jpeg_enable,
-	.i2c_init = navi10_i2c_control_init,
-	.i2c_fini = navi10_i2c_control_fini,
 	.print_clk_levels = navi10_print_clk_levels,
 	.force_clk_levels = navi10_force_clk_levels,
 	.populate_umd_state_clk = navi10_populate_umd_state_clk,
-- 
2.25.4

