Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F966C47B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjAPPzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjAPPzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9C523115
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E69CDB81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F80BC433EF;
        Mon, 16 Jan 2023 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884508;
        bh=0liuWZit8huyfLXXRMHCr4ELX+fgnfDFNmx5Rx4BqC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTRS4CQbU8ttw4GGpkJrOLL4yHcZXFSzcvXZrYGPaYA9ymPmrCnGfybDq9QGCcI+I
         tImQwtyrVeA204CFeqp1fshhNmtHRqpwUdiDvuuIMTPK0olNfIn/YcXDh1uD5+5lUP
         X9PgTt/lVTyaEFlfENOo/ybOHWEGW9RrFnfi9U7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 032/183] drm/amd: Delay removal of the firmware framebuffer
Date:   Mon, 16 Jan 2023 16:49:15 +0100
Message-Id: <20230116154804.716975523@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1923bc5a56daeeabd7e9093bad2febcd6af2416a upstream.

Removing the firmware framebuffer from the driver means that even
if the driver doesn't support the IP blocks in a GPU it will no
longer be functional after the driver fails to initialize.

This change will ensure that unsupported IP blocks at least cause
the driver to work with the EFI framebuffer.

Cc: stable@vger.kernel.org
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |    6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -36,6 +36,7 @@
 #include <generated/utsrelease.h>
 #include <linux/pci-p2pdma.h>
 
+#include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/amdgpu_drm.h>
@@ -89,6 +90,8 @@ MODULE_FIRMWARE("amdgpu/navi12_gpu_info.
 #define AMDGPU_MAX_RETRY_LIMIT		2
 #define AMDGPU_RETRY_SRIOV_RESET(r) ((r) == -EBUSY || (r) == -ETIMEDOUT || (r) == -EINVAL)
 
+static const struct drm_driver amdgpu_kms_driver;
+
 const char *amdgpu_asic_name[] = {
 	"TAHITI",
 	"PITCAIRN",
@@ -3677,6 +3680,11 @@ int amdgpu_device_init(struct amdgpu_dev
 	if (r)
 		return r;
 
+	/* Get rid of things like offb */
+	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
+	if (r)
+		return r;
+
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -23,7 +23,6 @@
  */
 
 #include <drm/amdgpu_drm.h>
-#include <drm/drm_aperture.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_vblank.h>
@@ -2123,11 +2122,6 @@ static int amdgpu_pci_probe(struct pci_d
 	}
 #endif
 
-	/* Get rid of things like offb */
-	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &amdgpu_kms_driver);
-	if (ret)
-		return ret;
-
 	adev = devm_drm_dev_alloc(&pdev->dev, &amdgpu_kms_driver, typeof(*adev), ddev);
 	if (IS_ERR(adev))
 		return PTR_ERR(adev);


