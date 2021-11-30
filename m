Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D44463781
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhK3OyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242847AbhK3OxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A546EB81A40;
        Tue, 30 Nov 2021 14:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC81C53FC7;
        Tue, 30 Nov 2021 14:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283797;
        bh=YM1V19lHIjsuquMjNtvdmuRYuuAAXAGQ1W3TUWuVDCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3Z625oHMEtv/wH7+l/zW3vl5DuG/c1Jk8t3Aq0TTZ4zgch8tpUFpN9neulAYPb0u
         ge3SWwM49YwF477IjCyKxsc5YQR2UnzFumfuTEA/7SOutDMRjygymlgAmaPAADF0Xv
         u4fQD8ExYhyl5PWFCTN8ipkxswCzg8/SLDLNgH2GGGtj/0GISaFfzVzNbrZwOBpsYg
         Zh9rJ71caYy2ulvFYGiOfKVoxRbEv/Y6a6p7QfpTT/rjS+XSW/b2ijn//cQ/V8NOq0
         21r7d61mztGc6lSnyrHFGtScxd/s3kYlW+csjFrHilHEESL+951gFKW3Ubibsi6Xco
         Ogbda8o++MvTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Wang <KevinYang.Wang@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        James.Zhu@amd.com, Bokun.Zhang@amd.com, Likun.Gao@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 59/68] drm/amdgpu: fix byteorder error in amdgpu discovery
Date:   Tue, 30 Nov 2021 09:46:55 -0500
Message-Id: <20211130144707.944580-59-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Wang <KevinYang.Wang@amd.com>

[ Upstream commit fd08953b2de911f32c06aedbc8ad111c2fd0168b ]

fix some byteorder issues about amdgpu discovery.
This will result in running errors on the big end system. (e.g:MIPS)

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index ada7bc19118ac..a12272a0c8844 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -190,8 +190,8 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
 
 	offset = offsetof(struct binary_header, binary_checksum) +
 		sizeof(bhdr->binary_checksum);
-	size = bhdr->binary_size - offset;
-	checksum = bhdr->binary_checksum;
+	size = le16_to_cpu(bhdr->binary_size) - offset;
+	checksum = le16_to_cpu(bhdr->binary_checksum);
 
 	if (!amdgpu_discovery_verify_checksum(adev->mman.discovery_bin + offset,
 					      size, checksum)) {
@@ -212,7 +212,7 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
 	}
 
 	if (!amdgpu_discovery_verify_checksum(adev->mman.discovery_bin + offset,
-					      ihdr->size, checksum)) {
+					      le16_to_cpu(ihdr->size), checksum)) {
 		DRM_ERROR("invalid ip discovery data table checksum\n");
 		r = -EINVAL;
 		goto out;
@@ -224,7 +224,7 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
 	ghdr = (struct gpu_info_header *)(adev->mman.discovery_bin + offset);
 
 	if (!amdgpu_discovery_verify_checksum(adev->mman.discovery_bin + offset,
-				              ghdr->size, checksum)) {
+				              le32_to_cpu(ghdr->size), checksum)) {
 		DRM_ERROR("invalid gc data table checksum\n");
 		r = -EINVAL;
 		goto out;
@@ -395,10 +395,10 @@ void amdgpu_discovery_harvest_ip(struct amdgpu_device *adev)
 			le16_to_cpu(bhdr->table_list[HARVEST_INFO].offset));
 
 	for (i = 0; i < 32; i++) {
-		if (le32_to_cpu(harvest_info->list[i].hw_id) == 0)
+		if (le16_to_cpu(harvest_info->list[i].hw_id) == 0)
 			break;
 
-		switch (le32_to_cpu(harvest_info->list[i].hw_id)) {
+		switch (le16_to_cpu(harvest_info->list[i].hw_id)) {
 		case VCN_HWID:
 			vcn_harvest_count++;
 			break;
-- 
2.33.0

