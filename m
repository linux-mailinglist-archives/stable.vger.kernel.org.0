Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5443A9F97
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhFPPjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235036AbhFPPiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAAE361076;
        Wed, 16 Jun 2021 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857763;
        bh=fA/354/L+S/ZajiGO7SQs/tFxlMSF58jI9v+vBeDN9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFWmI37uwhjAMBUlpPj4HnWHRIIe4fsdfYnpiLWvJD/kYfiGwWqAkxJMn6hZwANLz
         Fxhypr4AOMxkCWcAbRQL0hDRSOh/tnPRFkpKpRvGv9YDTctZGV3Q3dK/kyMZWK8NVH
         7GsCCxaZNS5U8rWpb9pnY9tLSpoZQt7c8Pvm8r2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiansong Chen <Jiansong.Chen@amd.com>,
        Jack Gui <Jack.Gui@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/38] drm/amdgpu: refine amdgpu_fru_get_product_info
Date:   Wed, 16 Jun 2021 17:33:40 +0200
Message-Id: <20210616152836.380022501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



