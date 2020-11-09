Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ABD2ABA81
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbgKINTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387837AbgKINTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2BD206D8;
        Mon,  9 Nov 2020 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927992;
        bh=b0eCXXOYlWea9J1dwydjTKHXDHkvRvMGeOlAfWZn63o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByC963ZG1NjP7nUrduoQS9OV6cMJL9QvDtdAlYEUaR/2hZqQiqFJAWVK2+gLdcMq7
         xpvuPWwhwrT5HvJveVhdTHtK5cU5U1+OrT6+DvbDSRv+DVs92A7X6Nm2u/kgswZTaF
         DF2ZeRPzbAQuevvl9I8vfWr8WRmDTWeReL+e+02U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 090/133] drm/amdgpu: disable DCN and VCN for navi10 blockchain SKU(v3)
Date:   Mon,  9 Nov 2020 13:55:52 +0100
Message-Id: <20201109125035.031882716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianci.Yin <tianci.yin@amd.com>

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



