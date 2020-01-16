Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5863313E000
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAPQYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:24:47 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43145 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgAPQYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:24:46 -0500
Received: by mail-qk1-f195.google.com with SMTP id t129so19622004qke.10
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 08:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5L3gCrtnOZ2RHqehx1LX16SW24jCrYlzWJSQdZw5o7A=;
        b=QZT+Yw0eceQRXIo2WcGdK8XEtTrU7dvjprH4ndFs2Ux0jk/tm8hoyWj4+tNR73F5Z9
         Puj5ayL6c/PpKpLlxH6N/MrLgZxTYi/uI2pIeFYzXiHuN+c3YNXIkOtMwMsgT+74FgKS
         cBHbefqwERpohIZV8sx/8rt+P7fPA65RKXzqqXlJAj4BBdPuoW5m6/DteGA9eCAx9pUS
         Igsw7rWqKOw3TlS9oAWbBRF3gFpaJAiWFA/VTTYiWRrA6F8ePo1r8mzhJUHbw5peMu9O
         QdOBJ175g/dzKLyWoVdNvG1BMt8qSclRASrTUxTa54wgXjvCCPoIPrPEkrE30uJv7+41
         fAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5L3gCrtnOZ2RHqehx1LX16SW24jCrYlzWJSQdZw5o7A=;
        b=S6F2nv8tA/7cfWBpR1SVHyEtlFbM2oL6CLKT/x6UhXwHDR0fKRl63nvH+lgwLcD2IW
         uQL6mjtlXyMJr58jzUHfBhq0Hmc8h8mXH2EMOcnJOPPTkSe9BebQpvfjW/v2Zqlw3/R6
         yNZLj3UzklLkpOyB/pR7xWXKIBp7xUJrxsN2W53HhykMO7T4OtEdfOHiG0R9FdnHr13N
         kCRYDZH3xq6S+Y4+U2FCZV5HaMwEacoZ1wp/daYDvB1hio8SITvYsrtFqYGGA/Z2cd0c
         vFp9ik+KhcgCjI48qX1IzLrsWqmKSfK/5HD76un2xkJIxE8q/gHRx562I9dwyqH3AUwc
         7E9g==
X-Gm-Message-State: APjAAAV80ebFpAV7t04C4mM0fl91QCAIFajoJwVYhP7pis2Aj0nH5SBg
        RL+/w0rtue0rNoQepXrvt3JGnt67
X-Google-Smtp-Source: APXvYqxW6pBndV/YMvaeS9xrlg6AqgzVpp8rMtwGG9D0TwCsGAHE+AnHF/o/ebSpsnJruUq+GI+K4g==
X-Received: by 2002:ae9:edc8:: with SMTP id c191mr30780161qkg.78.1579191885114;
        Thu, 16 Jan 2020 08:24:45 -0800 (PST)
Received: from localhost.localdomain ([71.219.59.120])
        by smtp.gmail.com with ESMTPSA id 4sm10241850qki.51.2020.01.16.08.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:24:44 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 2/2] drm/amdgpu/discovery: reserve discovery data at the top of VRAM
Date:   Thu, 16 Jan 2020 11:24:29 -0500
Message-Id: <20200116162429.4000-3-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200116162429.4000-1-alexander.deucher@amd.com>
References: <20200116162429.4000-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

IP Discovery data is TMR fenced by the latest PSP BL,
so we need to reserve this region.

Tested on navi10/12/14 with VBIOS integrated with latest PSP BL.

v2: use DISCOVERY_TMR_SIZE macro as bo size
    use amdgpu_bo_create_kernel_at() to allocate bo

Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5f6a556f98de425fcb7928456839a06f02156633)
Cc: <stable@vger.kernel.org> # 5.4.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       | 17 +++++++++++++++++
 drivers/gpu/drm/amd/include/discovery.h       |  1 -
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index bd37df5dd6d0..d1e278e999ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -813,6 +813,7 @@ struct amdgpu_device {
 	uint8_t				*bios;
 	uint32_t			bios_size;
 	struct amdgpu_bo		*stolen_vga_memory;
+	struct amdgpu_bo		*discovery_memory;
 	uint32_t			bios_scratch_reg_offset;
 	uint32_t			bios_scratch[AMDGPU_BIOS_NUM_SCRATCH];
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 1481899f86c1..71198c5318e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -136,7 +136,7 @@ static int amdgpu_discovery_read_binary(struct amdgpu_device *adev, uint8_t *bin
 {
 	uint32_t *p = (uint32_t *)binary;
 	uint64_t vram_size = (uint64_t)RREG32(mmRCC_CONFIG_MEMSIZE) << 20;
-	uint64_t pos = vram_size - BINARY_MAX_SIZE;
+	uint64_t pos = vram_size - DISCOVERY_TMR_SIZE;
 	unsigned long flags;
 
 	while (pos < vram_size) {
@@ -179,7 +179,7 @@ int amdgpu_discovery_init(struct amdgpu_device *adev)
 	uint16_t checksum;
 	int r;
 
-	adev->discovery = kzalloc(BINARY_MAX_SIZE, GFP_KERNEL);
+	adev->discovery = kzalloc(DISCOVERY_TMR_SIZE, GFP_KERNEL);
 	if (!adev->discovery)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h
index 85b8c4d4d576..5a6693d7d269 100644
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 3faa1be437e9..f15ded1ce905 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1730,6 +1730,20 @@ int amdgpu_ttm_init(struct amdgpu_device *adev)
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
 
@@ -1794,6 +1808,9 @@ void amdgpu_ttm_late_init(struct amdgpu_device *adev)
 	void *stolen_vga_buf;
 	/* return the VGA stolen memory (if any) back to VRAM */
 	amdgpu_bo_free_kernel(&adev->stolen_vga_memory, NULL, &stolen_vga_buf);
+
+	/* return the IP Discovery TMR memory back to VRAM */
+	amdgpu_bo_free_kernel(&adev->discovery_memory, NULL, NULL);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/include/discovery.h b/drivers/gpu/drm/amd/include/discovery.h
index 5dcb776548d8..7ec4331e67f2 100644
--- a/drivers/gpu/drm/amd/include/discovery.h
+++ b/drivers/gpu/drm/amd/include/discovery.h
@@ -25,7 +25,6 @@
 #define _DISCOVERY_H_
 
 #define PSP_HEADER_SIZE                 256
-#define BINARY_MAX_SIZE                 (64 << 10)
 #define BINARY_SIGNATURE                0x28211407
 #define DISCOVERY_TABLE_SIGNATURE       0x53445049
 
-- 
2.24.1

