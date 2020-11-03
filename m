Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B706E2A5298
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgKCUvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbgKCUvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0848D2053B;
        Tue,  3 Nov 2020 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436678;
        bh=bm52BDMSfPZiN5lPyEDL7IsEW9Njy8zDk84FpC/hdNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEdaLdAICfx8mZ8iBf21NVvBvrKOW2lhVfs5jpbvG9uY09jOpyJ+CA/wCV37CGk7h
         ZjW4qkRHf/5GubcAafwX7DboaXU9Lgdre4h5Ek8PgyrSBkOf/XYm8jpCVmvV/k3ksG
         EjT1Nf6MN7zVMiIecUYG2CKwZOkGgbn4Cyjz6HD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 356/391] drm/amdgpu/swsmu: drop smu i2c bus on navi1x
Date:   Tue,  3 Nov 2020 21:36:47 +0100
Message-Id: <20201103203411.156608458@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 10105d0c9763f058f6a9a09f78397d5bf94dc94c upstream.

Stop registering the SMU i2c bus on navi1x.  This leads to instability
issues when userspace processes mess with the bus and also seems to
cause display stability issues in some cases.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1314
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1341
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -2463,37 +2463,11 @@ static const struct i2c_algorithm navi10
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


