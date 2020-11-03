Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62822A4B74
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCQ3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:13 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034E3C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:13 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id s14so15157702qkg.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4o3K+SXk1EZriNkflBZWyIPiJPUVnsfHwzI5+HZSis=;
        b=Ws16bs5qHA+wRdZlLBmsaco6AEAFeNrQvEKstV99yhhhN6JUM3FGQ05tZgnsIb7yKm
         q711Hs+XrKHeN4oVtwma/IcMSP7Csxg0ABCFT88EnOtNqXJZnSKGf5/0jBF6vAXKMJtW
         CW2t/siGskKIyVRh81loAICW1v189FxdanqOHNjxh6uu5pBAuRJOj03myjc6JT7H2Id5
         FD9GaGpEaB3XAH+xUQox6fDPjD0ZLmeNroccKqD4rdf3X4dqqM9N7pHiTwPjO058vmmW
         Q7yUhmky8jrci9bw4h/hJu92/bpgUpzijMishxxZyY1gCZZ8tU1O0y8P56kBr4JmlLl6
         gT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4o3K+SXk1EZriNkflBZWyIPiJPUVnsfHwzI5+HZSis=;
        b=amhWRBQ5rSXaheSEDtSknJCt+VHOh7+AmEMKJkAHRO3Q4/RHnFoXUIqWWyToH/FbLh
         JlaYn5Rfi5T/kvjgJ/eZ0OLRexwyl6M08e/aUV133UavhRxTVXrBF7GB4uqqIyDaZeUx
         hCH7MreFmo+wULLoeQL83tj1Zn7r1NrR+hEMoEtwZ53h4ev/SgiNMf+VU6xlF1tALwtL
         tcoBhi96GsqkmMz37eZgKGsTlOeyUm+0yXb34LW3kUSurHDrfy/iOeIHm+S/ampH+jiS
         ZIcDit+RfngZWaZFcQbRja2+1/xLsEMy2MALGxgdqMg+sTnT3upVX60ZIqy3qjGCNc2Y
         7fDg==
X-Gm-Message-State: AOAM530PpbJO9fDz9s+VOaBN5sK8fMC9tm+2w6ksLHwqi7HkMaSh2/fV
        1VVR9xEvZeVRWUD4liTeTxClcryFlhw=
X-Google-Smtp-Source: ABdhPJwMNXSWE6jpNL6zAh5dJ0q9BVlo4xkvLewL6q0YfQmXdnjVvdDmXBit5y4iacsKK+eEZxblyg==
X-Received: by 2002:a37:65d1:: with SMTP id z200mr20184887qkb.103.1604420952018;
        Tue, 03 Nov 2020 08:29:12 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:11 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 1/7] drm/amdgpu/swsmu: drop smu i2c bus on navi1x
Date:   Tue,  3 Nov 2020 11:28:56 -0500
Message-Id: <20201103162903.687752-2-alexander.deucher@amd.com>
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

