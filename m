Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9082A39AA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgKCBTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgKCBTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437A5223AC;
        Tue,  3 Nov 2020 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366349;
        bh=vjXUIYLDe4pfWuTDYI0QT5kTiVtf5FanAE2LJ8LQA6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F01kTDG3HhPlM0K5psqcreirM9h1WWvvjaoQQgoOgtIYnfo0VakLD9lansJoRCVhf
         fcpulk1+OtUTnEtdlctOzCTZ4ykeDXEgZhihASUQLzSbgXmPPvrbTQi059hH5CTioo
         z1nOGU2JKY7BHCAPSf4qqRqW5kF2zfyrUaEoq2LA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tianci.Yin" <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 21/35] drm/amdgpu: disable DCN and VCN for navi10 blockchain SKU(v3)
Date:   Mon,  2 Nov 2020 20:18:26 -0500
Message-Id: <20201103011840.182814-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tianci.Yin" <tianci.yin@amd.com>

[ Upstream commit a305e7dc5fa86ff9cf6cd2da30215a92d43c9285 ]

The blockchain SKU has no display and video support, remove them.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Tianci.Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index ca11253e787ca..8254f42146890 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -488,6 +488,14 @@ void nv_set_virt_ops(struct amdgpu_device *adev)
 	adev->virt.ops = &xgpu_nv_virt_ops;
 }
 
+static bool nv_is_blockchain_sku(struct pci_dev *pdev)
+{
+	if (pdev->device == 0x731E &&
+	    (pdev->revision == 0xC6 || pdev->revision == 0xC7))
+		return true;
+	return false;
+}
+
 int nv_set_ip_blocks(struct amdgpu_device *adev)
 {
 	int r;
@@ -516,7 +524,8 @@ int nv_set_ip_blocks(struct amdgpu_device *adev)
 		if (adev->enable_virtual_display || amdgpu_sriov_vf(adev))
 			amdgpu_device_ip_block_add(adev, &dce_virtual_ip_block);
 #if defined(CONFIG_DRM_AMD_DC)
-		else if (amdgpu_device_has_dc_support(adev))
+		else if (amdgpu_device_has_dc_support(adev) &&
+			 !nv_is_blockchain_sku(adev->pdev))
 			amdgpu_device_ip_block_add(adev, &dm_ip_block);
 #endif
 		amdgpu_device_ip_block_add(adev, &gfx_v10_0_ip_block);
@@ -524,7 +533,8 @@ int nv_set_ip_blocks(struct amdgpu_device *adev)
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT &&
 		    !amdgpu_sriov_vf(adev))
 			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
-		amdgpu_device_ip_block_add(adev, &vcn_v2_0_ip_block);
+		if (!nv_is_blockchain_sku(adev->pdev))
+			amdgpu_device_ip_block_add(adev, &vcn_v2_0_ip_block);
 		amdgpu_device_ip_block_add(adev, &jpeg_v2_0_ip_block);
 		if (adev->enable_mes)
 			amdgpu_device_ip_block_add(adev, &mes_v10_1_ip_block);
-- 
2.27.0

