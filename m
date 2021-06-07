Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D127339E236
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhFGQPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhFGQPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6A16613C5;
        Mon,  7 Jun 2021 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082387;
        bh=fA/354/L+S/ZajiGO7SQs/tFxlMSF58jI9v+vBeDN9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsJb5z51pzUyXBx9QMPxgMn833GreUR2n1AJKlcj1ypOa1aX809kGHqXnWm9VRlSy
         YCvPHDkDX1sRRIxU7Bp9Z2OMOkggfGNjUbdzCoDMcam1wjY9XMDQefF/DQ/MVJ/UeU
         xBr6y0l+TdEJd7Yl083hSqZkACEs8d9Mjw6g+9PlCgjWFjhFyLTcfF0DBnSZ8G0Mf1
         MR7TrkeZYbsrBUyKRzN2w+xeQuAZPZ3qumgoknrJcxssoGZIjrQJBEtx0c4aucJpqF
         2JviJPou1MqmMqHhxH6as+y85CzjAihc/sY5Fav4E1z9QEMrc44eXuWFZAKSD4DWlo
         tMdyAHNkqmIlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiansong Chen <Jiansong.Chen@amd.com>, Jack Gui <Jack.Gui@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 42/49] drm/amdgpu: refine amdgpu_fru_get_product_info
Date:   Mon,  7 Jun 2021 12:12:08 -0400
Message-Id: <20210607161215.3583176-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiansong Chen <Jiansong.Chen@amd.com>

[ Upstream commit 5cfc912582e13b05d71fb7acc4ec69ddfa9af320 ]

1. eliminate potential array index out of bounds.
2. return meaningful value for failure.

Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
Reviewed-by: Jack Gui <Jack.Gui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c    | 42 ++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index 8f4a8f8d8146..39b6c6bfab45 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -101,7 +101,8 @@ static int amdgpu_fru_read_eeprom(struct amdgpu_device *adev, uint32_t addrptr,
 int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 {
 	unsigned char buff[34];
-	int addrptr = 0, size = 0;
+	int addrptr, size;
+	int len;
 
 	if (!is_fru_eeprom_supported(adev))
 		return 0;
@@ -109,7 +110,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	/* If algo exists, it means that the i2c_adapter's initialized */
 	if (!adev->pm.smu_i2c.algo) {
 		DRM_WARN("Cannot access FRU, EEPROM accessor not initialized");
-		return 0;
+		return -ENODEV;
 	}
 
 	/* There's a lot of repetition here. This is due to the FRU having
@@ -128,7 +129,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	size = amdgpu_fru_read_eeprom(adev, addrptr, buff);
 	if (size < 1) {
 		DRM_ERROR("Failed to read FRU Manufacturer, ret:%d", size);
-		return size;
+		return -EINVAL;
 	}
 
 	/* Increment the addrptr by the size of the field, and 1 due to the
@@ -138,43 +139,45 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	size = amdgpu_fru_read_eeprom(adev, addrptr, buff);
 	if (size < 1) {
 		DRM_ERROR("Failed to read FRU product name, ret:%d", size);
-		return size;
+		return -EINVAL;
 	}
 
+	len = size;
 	/* Product name should only be 32 characters. Any more,
 	 * and something could be wrong. Cap it at 32 to be safe
 	 */
-	if (size > 32) {
+	if (len >= sizeof(adev->product_name)) {
 		DRM_WARN("FRU Product Number is larger than 32 characters. This is likely a mistake");
-		size = 32;
+		len = sizeof(adev->product_name) - 1;
 	}
 	/* Start at 2 due to buff using fields 0 and 1 for the address */
-	memcpy(adev->product_name, &buff[2], size);
-	adev->product_name[size] = '\0';
+	memcpy(adev->product_name, &buff[2], len);
+	adev->product_name[len] = '\0';
 
 	addrptr += size + 1;
 	size = amdgpu_fru_read_eeprom(adev, addrptr, buff);
 	if (size < 1) {
 		DRM_ERROR("Failed to read FRU product number, ret:%d", size);
-		return size;
+		return -EINVAL;
 	}
 
+	len = size;
 	/* Product number should only be 16 characters. Any more,
 	 * and something could be wrong. Cap it at 16 to be safe
 	 */
-	if (size > 16) {
+	if (len >= sizeof(adev->product_number)) {
 		DRM_WARN("FRU Product Number is larger than 16 characters. This is likely a mistake");
-		size = 16;
+		len = sizeof(adev->product_number) - 1;
 	}
-	memcpy(adev->product_number, &buff[2], size);
-	adev->product_number[size] = '\0';
+	memcpy(adev->product_number, &buff[2], len);
+	adev->product_number[len] = '\0';
 
 	addrptr += size + 1;
 	size = amdgpu_fru_read_eeprom(adev, addrptr, buff);
 
 	if (size < 1) {
 		DRM_ERROR("Failed to read FRU product version, ret:%d", size);
-		return size;
+		return -EINVAL;
 	}
 
 	addrptr += size + 1;
@@ -182,18 +185,19 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 
 	if (size < 1) {
 		DRM_ERROR("Failed to read FRU serial number, ret:%d", size);
-		return size;
+		return -EINVAL;
 	}
 
+	len = size;
 	/* Serial number should only be 16 characters. Any more,
 	 * and something could be wrong. Cap it at 16 to be safe
 	 */
-	if (size > 16) {
+	if (len >= sizeof(adev->serial)) {
 		DRM_WARN("FRU Serial Number is larger than 16 characters. This is likely a mistake");
-		size = 16;
+		len = sizeof(adev->serial) - 1;
 	}
-	memcpy(adev->serial, &buff[2], size);
-	adev->serial[size] = '\0';
+	memcpy(adev->serial, &buff[2], len);
+	adev->serial[len] = '\0';
 
 	return 0;
 }
-- 
2.30.2

