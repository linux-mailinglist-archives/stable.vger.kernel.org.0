Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D50213DFFF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgAPQYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:24:45 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:35523 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAPQYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:24:45 -0500
Received: by mail-qv1-f68.google.com with SMTP id u10so9319618qvi.2
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 08:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u83XTh5Bu5vTkoCrzK0uwfFV5ZJdreHctd4pSjT2LDA=;
        b=P+uHxw/BbnwIsVPDcNLnDMsp3VmE9V0hFE58UAiRI7R+/oNfOXK3Na0u2r1w/qWCQt
         jGNc1U8g3AnTkH0ukMgUAEihaQonTl4cNF3bwVQ7SFVVqSydlmoUaITGT/Rp1k17qvWk
         IBZ9+KkIMXrnJ+WUQnnxwxrpbWndSdv/sxOFWGw/gOjDHxOzFKAJ9FCFCW2RxLuOwgEf
         jUnxTHB4uWJ/25H8fcpl4eFUzlgsPGUKs909c/DER4qh64SJqbeNGsawEyOn1Q5pNYrk
         ll3pY2e88SVpeO/cdu1/qLRZj3RltZ29+JW5GQwd0HOMR6udRNvbEwkaZ51LHr4e7XhE
         rgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u83XTh5Bu5vTkoCrzK0uwfFV5ZJdreHctd4pSjT2LDA=;
        b=VsAuLIMT8vEeMnW7dKY4E+5dc+YDKY2h+twMEeodHp3hDh2tJfV5/y1Nm0hULKA0st
         LziRmOPN3H3Mxdf/9RUyQqL8rFMeqzGOB5mmAdazsqYbyiSXufey3/tlaeXJVTrgnjHx
         NqiO+OrpwendxSX2i1mo8sQF7sc8/XZGhuOsiVfyUN62L/pg4eAbAxwMzrYK474iGKMz
         YCd445FXb1kpGbqblaU3VwRp/gJylU92DF4pRxo7O01vWxp+uad+EGmwMOJixPDDgNZB
         qVmba7OnqIgZuat9Q6EFlcM129ixdx1YJUmso4T4ctuDMGqYJTPNQ4LO7BkfI2Sh9lhm
         LVVQ==
X-Gm-Message-State: APjAAAUA5gmK2nqXju3+9nfG+xK2Ol20iNXv9phjPfQgk1cM6TzUhGDU
        rAgs4l7qEXLHu6aLY7v45gS37Qym
X-Google-Smtp-Source: APXvYqxQr/e69vtdPn014E74A5TvicebgKEveU9aWmOT0K0Y1GjOWSERD0AOxVD9duDzBJYoUb5IKQ==
X-Received: by 2002:a0c:fa43:: with SMTP id k3mr3294125qvo.229.1579191884107;
        Thu, 16 Jan 2020 08:24:44 -0800 (PST)
Received: from localhost.localdomain ([71.219.59.120])
        by smtp.gmail.com with ESMTPSA id 4sm10241850qki.51.2020.01.16.08.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:24:43 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 1/2] drm/amdgpu: cleanup creating BOs at fixed location (v2)
Date:   Thu, 16 Jan 2020 11:24:28 -0500
Message-Id: <20200116162429.4000-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200116162429.4000-1-alexander.deucher@amd.com>
References: <20200116162429.4000-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

The placement is something TTM/BO internal and the RAS code should
avoid touching that directly.

Add a helper to create a BO at a fixed location and use that instead.

v2: squash in fixes (Alex)

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit de7b45babd9be25138ff5e4a0c34eefffbb226ff)
Cc: <stable@vger.kernel.org> # 5.4.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 61 ++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h |  3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c    | 85 ++--------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    | 82 ++++-----------------
 4 files changed, 83 insertions(+), 148 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 7289e1b4fb60..28361a9c5add 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -342,6 +342,67 @@ int amdgpu_bo_create_kernel(struct amdgpu_device *adev,
 	return 0;
 }
 
+/**
+ * amdgpu_bo_create_kernel_at - create BO for kernel use at specific location
+ *
+ * @adev: amdgpu device object
+ * @offset: offset of the BO
+ * @size: size of the BO
+ * @domain: where to place it
+ * @bo_ptr:  used to initialize BOs in structures
+ * @cpu_addr: optional CPU address mapping
+ *
+ * Creates a kernel BO at a specific offset in the address space of the domain.
+ *
+ * Returns:
+ * 0 on success, negative error code otherwise.
+ */
+int amdgpu_bo_create_kernel_at(struct amdgpu_device *adev,
+			       uint64_t offset, uint64_t size, uint32_t domain,
+			       struct amdgpu_bo **bo_ptr, void **cpu_addr)
+{
+	struct ttm_operation_ctx ctx = { false, false };
+	unsigned int i;
+	int r;
+
+	offset &= PAGE_MASK;
+	size = ALIGN(size, PAGE_SIZE);
+
+	r = amdgpu_bo_create_reserved(adev, size, PAGE_SIZE, domain, bo_ptr,
+				      NULL, NULL);
+	if (r)
+		return r;
+
+	/*
+	 * Remove the original mem node and create a new one at the request
+	 * position.
+	 */
+	for (i = 0; i < (*bo_ptr)->placement.num_placement; ++i) {
+		(*bo_ptr)->placements[i].fpfn = offset >> PAGE_SHIFT;
+		(*bo_ptr)->placements[i].lpfn = (offset + size) >> PAGE_SHIFT;
+	}
+
+	ttm_bo_mem_put(&(*bo_ptr)->tbo, &(*bo_ptr)->tbo.mem);
+	r = ttm_bo_mem_space(&(*bo_ptr)->tbo, &(*bo_ptr)->placement,
+			     &(*bo_ptr)->tbo.mem, &ctx);
+	if (r)
+		goto error;
+
+	if (cpu_addr) {
+		r = amdgpu_bo_kmap(*bo_ptr, cpu_addr);
+		if (r)
+			goto error;
+	}
+
+	amdgpu_bo_unreserve(*bo_ptr);
+	return 0;
+
+error:
+	amdgpu_bo_unreserve(*bo_ptr);
+	amdgpu_bo_unref(bo_ptr);
+	return r;
+}
+
 /**
  * amdgpu_bo_free_kernel - free BO for kernel use
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
index 658f4c9779b7..4fcea23ee516 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -237,6 +237,9 @@ int amdgpu_bo_create_kernel(struct amdgpu_device *adev,
 			    unsigned long size, int align,
 			    u32 domain, struct amdgpu_bo **bo_ptr,
 			    u64 *gpu_addr, void **cpu_addr);
+int amdgpu_bo_create_kernel_at(struct amdgpu_device *adev,
+			       uint64_t offset, uint64_t size, uint32_t domain,
+			       struct amdgpu_bo **bo_ptr, void **cpu_addr);
 void amdgpu_bo_free_kernel(struct amdgpu_bo **bo, u64 *gpu_addr,
 			   void **cpu_addr);
 int amdgpu_bo_kmap(struct amdgpu_bo *bo, void **ptr);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 016ea274b955..9c5cbc47edf1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -65,12 +65,6 @@ const char *ras_block_string[] = {
 /* inject address is 52 bits */
 #define	RAS_UMC_INJECT_ADDR_LIMIT	(0x1ULL << 52)
 
-static int amdgpu_ras_reserve_vram(struct amdgpu_device *adev,
-		uint64_t offset, uint64_t size,
-		struct amdgpu_bo **bo_ptr);
-static int amdgpu_ras_release_vram(struct amdgpu_device *adev,
-		struct amdgpu_bo **bo_ptr);
-
 static ssize_t amdgpu_ras_debugfs_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
@@ -1214,75 +1208,6 @@ static void amdgpu_ras_do_recovery(struct work_struct *work)
 	atomic_set(&ras->in_recovery, 0);
 }
 
-static int amdgpu_ras_release_vram(struct amdgpu_device *adev,
-		struct amdgpu_bo **bo_ptr)
-{
-	/* no need to free it actually. */
-	amdgpu_bo_free_kernel(bo_ptr, NULL, NULL);
-	return 0;
-}
-
-/* reserve vram with size@offset */
-static int amdgpu_ras_reserve_vram(struct amdgpu_device *adev,
-		uint64_t offset, uint64_t size,
-		struct amdgpu_bo **bo_ptr)
-{
-	struct ttm_operation_ctx ctx = { false, false };
-	struct amdgpu_bo_param bp;
-	int r = 0;
-	int i;
-	struct amdgpu_bo *bo;
-
-	if (bo_ptr)
-		*bo_ptr = NULL;
-	memset(&bp, 0, sizeof(bp));
-	bp.size = size;
-	bp.byte_align = PAGE_SIZE;
-	bp.domain = AMDGPU_GEM_DOMAIN_VRAM;
-	bp.flags = AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS |
-		AMDGPU_GEM_CREATE_NO_CPU_ACCESS;
-	bp.type = ttm_bo_type_kernel;
-	bp.resv = NULL;
-
-	r = amdgpu_bo_create(adev, &bp, &bo);
-	if (r)
-		return -EINVAL;
-
-	r = amdgpu_bo_reserve(bo, false);
-	if (r)
-		goto error_reserve;
-
-	offset = ALIGN(offset, PAGE_SIZE);
-	for (i = 0; i < bo->placement.num_placement; ++i) {
-		bo->placements[i].fpfn = offset >> PAGE_SHIFT;
-		bo->placements[i].lpfn = (offset + size) >> PAGE_SHIFT;
-	}
-
-	ttm_bo_mem_put(&bo->tbo, &bo->tbo.mem);
-	r = ttm_bo_mem_space(&bo->tbo, &bo->placement, &bo->tbo.mem, &ctx);
-	if (r)
-		goto error_pin;
-
-	r = amdgpu_bo_pin_restricted(bo,
-			AMDGPU_GEM_DOMAIN_VRAM,
-			offset,
-			offset + size);
-	if (r)
-		goto error_pin;
-
-	if (bo_ptr)
-		*bo_ptr = bo;
-
-	amdgpu_bo_unreserve(bo);
-	return r;
-
-error_pin:
-	amdgpu_bo_unreserve(bo);
-error_reserve:
-	amdgpu_bo_unref(&bo);
-	return r;
-}
-
 /* alloc/realloc bps array */
 static int amdgpu_ras_realloc_eh_data_space(struct amdgpu_device *adev,
 		struct ras_err_handler_data *data, int pages)
@@ -1345,7 +1270,7 @@ int amdgpu_ras_reserve_bad_pages(struct amdgpu_device *adev)
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
 	struct ras_err_handler_data *data;
 	uint64_t bp;
-	struct amdgpu_bo *bo;
+	struct amdgpu_bo *bo = NULL;
 	int i;
 
 	if (!con || !con->eh_data)
@@ -1359,12 +1284,14 @@ int amdgpu_ras_reserve_bad_pages(struct amdgpu_device *adev)
 	for (i = data->last_reserved; i < data->count; i++) {
 		bp = data->bps[i].bp;
 
-		if (amdgpu_ras_reserve_vram(adev, bp << PAGE_SHIFT,
-					PAGE_SIZE, &bo))
+		if (amdgpu_bo_create_kernel_at(adev, bp << PAGE_SHIFT, PAGE_SIZE,
+					       AMDGPU_GEM_DOMAIN_VRAM,
+					       &bo, NULL))
 			DRM_ERROR("RAS ERROR: reserve vram %llx fail\n", bp);
 
 		data->bps[i].bo = bo;
 		data->last_reserved = i + 1;
+		bo = NULL;
 	}
 out:
 	mutex_unlock(&con->recovery_lock);
@@ -1390,7 +1317,7 @@ static int amdgpu_ras_release_bad_pages(struct amdgpu_device *adev)
 	for (i = data->last_reserved - 1; i >= 0; i--) {
 		bo = data->bps[i].bo;
 
-		amdgpu_ras_release_vram(adev, &bo);
+		amdgpu_bo_free_kernel(&bo, NULL, NULL);
 
 		data->bps[i].bo = bo;
 		data->last_reserved = i;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index c0e41f1f0c23..3faa1be437e9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1639,81 +1639,25 @@ static void amdgpu_ttm_fw_reserve_vram_fini(struct amdgpu_device *adev)
  */
 static int amdgpu_ttm_fw_reserve_vram_init(struct amdgpu_device *adev)
 {
-	struct ttm_operation_ctx ctx = { false, false };
-	struct amdgpu_bo_param bp;
-	int r = 0;
-	int i;
-	u64 vram_size = adev->gmc.visible_vram_size;
-	u64 offset = adev->fw_vram_usage.start_offset;
-	u64 size = adev->fw_vram_usage.size;
-	struct amdgpu_bo *bo;
-
-	memset(&bp, 0, sizeof(bp));
-	bp.size = adev->fw_vram_usage.size;
-	bp.byte_align = PAGE_SIZE;
-	bp.domain = AMDGPU_GEM_DOMAIN_VRAM;
-	bp.flags = AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED |
-		AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS;
-	bp.type = ttm_bo_type_kernel;
-	bp.resv = NULL;
+	uint64_t vram_size = adev->gmc.visible_vram_size;
+	int r;
+
 	adev->fw_vram_usage.va = NULL;
 	adev->fw_vram_usage.reserved_bo = NULL;
 
-	if (adev->fw_vram_usage.size > 0 &&
-		adev->fw_vram_usage.size <= vram_size) {
-
-		r = amdgpu_bo_create(adev, &bp,
-				     &adev->fw_vram_usage.reserved_bo);
-		if (r)
-			goto error_create;
-
-		r = amdgpu_bo_reserve(adev->fw_vram_usage.reserved_bo, false);
-		if (r)
-			goto error_reserve;
-
-		/* remove the original mem node and create a new one at the
-		 * request position
-		 */
-		bo = adev->fw_vram_usage.reserved_bo;
-		offset = ALIGN(offset, PAGE_SIZE);
-		for (i = 0; i < bo->placement.num_placement; ++i) {
-			bo->placements[i].fpfn = offset >> PAGE_SHIFT;
-			bo->placements[i].lpfn = (offset + size) >> PAGE_SHIFT;
-		}
-
-		ttm_bo_mem_put(&bo->tbo, &bo->tbo.mem);
-		r = ttm_bo_mem_space(&bo->tbo, &bo->placement,
-				     &bo->tbo.mem, &ctx);
-		if (r)
-			goto error_pin;
-
-		r = amdgpu_bo_pin_restricted(adev->fw_vram_usage.reserved_bo,
-			AMDGPU_GEM_DOMAIN_VRAM,
-			adev->fw_vram_usage.start_offset,
-			(adev->fw_vram_usage.start_offset +
-			adev->fw_vram_usage.size));
-		if (r)
-			goto error_pin;
-		r = amdgpu_bo_kmap(adev->fw_vram_usage.reserved_bo,
-			&adev->fw_vram_usage.va);
-		if (r)
-			goto error_kmap;
-
-		amdgpu_bo_unreserve(adev->fw_vram_usage.reserved_bo);
-	}
-	return r;
+	if (adev->fw_vram_usage.size == 0 ||
+	    adev->fw_vram_usage.size > vram_size)
+		return 0;
 
-error_kmap:
-	amdgpu_bo_unpin(adev->fw_vram_usage.reserved_bo);
-error_pin:
-	amdgpu_bo_unreserve(adev->fw_vram_usage.reserved_bo);
-error_reserve:
-	amdgpu_bo_unref(&adev->fw_vram_usage.reserved_bo);
-error_create:
-	adev->fw_vram_usage.va = NULL;
-	adev->fw_vram_usage.reserved_bo = NULL;
+	return amdgpu_bo_create_kernel_at(adev,
+					  adev->fw_vram_usage.start_offset,
+					  adev->fw_vram_usage.size,
+					  AMDGPU_GEM_DOMAIN_VRAM,
+					  &adev->fw_vram_usage.reserved_bo,
+					  &adev->fw_vram_usage.va);
 	return r;
 }
+
 /**
  * amdgpu_ttm_init - Init the memory management (ttm) as well as various
  * gtt/vram related fields.
-- 
2.24.1

