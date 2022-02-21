Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C534BE2DD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348007AbiBUJ11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349811AbiBUJ0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:26:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A436E56;
        Mon, 21 Feb 2022 01:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3BD608C1;
        Mon, 21 Feb 2022 09:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4B6C340E9;
        Mon, 21 Feb 2022 09:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434648;
        bh=YPIKNeWP4LvdjCmgHEJIMVSzq4SvMRf396pU/VyCCxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcNYIxW550kzglnoTkk3lXvTbaWZDTXtC5VVUKnvfeTF+sxuBjTI4as3Wd+Wn3bOP
         Ji55jBSGlx/v63XrEMWJsEjMjPHHKJfdA79VcupVINXVMre4jvAPzgeiSghnY4XAu8
         GThxPmgj7hj8JMqI22iealR/otSnaMlmgAkDKq5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/196] drm/amd: Only run s3 or s0ix if system is configured properly
Date:   Mon, 21 Feb 2022 09:48:01 +0100
Message-Id: <20220221084932.572173092@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 30059b7db0b25..b7509d3f7c1c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1499,6 +1499,7 @@ static void amdgpu_drv_delayed_reset_work_handler(struct work_struct *work)
 static int amdgpu_pmops_prepare(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
 	/* Return a positive number here so
 	 * DPM_FLAG_SMART_SUSPEND works properly
@@ -1506,6 +1507,13 @@ static int amdgpu_pmops_prepare(struct device *dev)
 	if (amdgpu_device_supports_boco(drm_dev))
 		return pm_runtime_suspended(dev);
 
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



