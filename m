Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7113FD58
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388973AbgAPXYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388667AbgAPXYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0947E2072B;
        Thu, 16 Jan 2020 23:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217086;
        bh=qMB28diCAzSFUtPOZijghXqt0dH6fNQmDLWrq0PeClw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwR5cIieijALdDyIMnGDSGK5P12Xn8m/0nlDU5L0BTMrEf9xfdTNmRt1jycQAWwwY
         CTzD4JmtmD9b2rzkdwAAPgnxuyvLKF37Z5gL8T/2bLFHPVT18mZX5liwE6vkY10OKK
         zqLnF0hqGGgFGuvRxALLlhQohWd+ReXZXJE4SsbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 126/203] drm/amdgpu/discovery: reserve discovery data at the top of VRAM
Date:   Fri, 17 Jan 2020 00:17:23 +0100
Message-Id: <20200116231756.243240407@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

commit 5f6a556f98de425fcb7928456839a06f02156633 upstream.

IP Discovery data is TMR fenced by the latest PSP BL,
so we need to reserve this region.

Tested on navi10/12/14 with VBIOS integrated with latest PSP BL.

v2: use DISCOVERY_TMR_SIZE macro as bo size
    use amdgpu_bo_create_kernel_at() to allocate bo

Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h |    2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |   17 +++++++++++++++++
 drivers/gpu/drm/amd/include/discovery.h       |    1 -
 5 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -813,6 +813,7 @@ struct amdgpu_device {
 	uint8_t				*bios;
 	uint32_t			bios_size;
 	struct amdgpu_bo		*stolen_vga_memory;
+	struct amdgpu_bo		*discovery_memory;
 	uint32_t			bios_scratch_reg_offset;
 	uint32_t			bios_scratch[AMDGPU_BIOS_NUM_SCRATCH];
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -136,7 +136,7 @@ static int amdgpu_discovery_read_binary(
 {
 	uint32_t *p = (uint32_t *)binary;
 	uint64_t vram_size = (uint64_t)RREG32(mmRCC_CONFIG_MEMSIZE) << 20;
-	uint64_t pos = vram_size - BINARY_MAX_SIZE;
+	uint64_t pos = vram_size - DISCOVERY_TMR_SIZE;
 	unsigned long flags;
 
 	while (pos < vram_size) {
@@ -179,7 +179,7 @@ int amdgpu_discovery_init(struct amdgpu_
 	uint16_t checksum;
 	int r;
 
-	adev->discovery = kzalloc(BINARY_MAX_SIZE, GFP_KERNEL);
+	adev->discovery = kzalloc(DISCOVERY_TMR_SIZE, GFP_KERNEL);
 	if (!adev->discovery)
 		return -ENOMEM;
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h
@@ -24,6 +24,8 @@
 #ifndef __AMDGPU_DISCOVERY__
 #define __AMDGPU_DISCOVERY__
 
+#define DISCOVERY_TMR_SIZE  (64 << 10)
+
 int amdgpu_discovery_init(struct amdgpu_device *adev);
 void amdgpu_discovery_fini(struct amdgpu_device *adev);
 int amdgpu_discovery_reg_base_init(struct amdgpu_device *adev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1730,6 +1730,20 @@ int amdgpu_ttm_init(struct amdgpu_device
 				    NULL, &stolen_vga_buf);
 	if (r)
 		return r;
+
+	/*
+	 * reserve one TMR (64K) memory at the top of VRAM which holds
+	 * IP Discovery data and is protected by PSP.
+	 */
+	r = amdgpu_bo_create_kernel_at(adev,
+				       adev->gmc.real_vram_size - DISCOVERY_TMR_SIZE,
+				       DISCOVERY_TMR_SIZE,
+				       AMDGPU_GEM_DOMAIN_VRAM,
+				       &adev->discovery_memory,
+				       NULL);
+	if (r)
+		return r;
+
 	DRM_INFO("amdgpu: %uM of VRAM memory ready\n",
 		 (unsigned) (adev->gmc.real_vram_size / (1024 * 1024)));
 
@@ -1794,6 +1808,9 @@ void amdgpu_ttm_late_init(struct amdgpu_
 	void *stolen_vga_buf;
 	/* return the VGA stolen memory (if any) back to VRAM */
 	amdgpu_bo_free_kernel(&adev->stolen_vga_memory, NULL, &stolen_vga_buf);
+
+	/* return the IP Discovery TMR memory back to VRAM */
+	amdgpu_bo_free_kernel(&adev->discovery_memory, NULL, NULL);
 }
 
 /**
--- a/drivers/gpu/drm/amd/include/discovery.h
+++ b/drivers/gpu/drm/amd/include/discovery.h
@@ -25,7 +25,6 @@
 #define _DISCOVERY_H_
 
 #define PSP_HEADER_SIZE                 256
-#define BINARY_MAX_SIZE                 (64 << 10)
 #define BINARY_SIGNATURE                0x28211407
 #define DISCOVERY_TABLE_SIGNATURE       0x53445049
 


