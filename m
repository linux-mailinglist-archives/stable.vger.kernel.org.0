Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3E71C14F5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgEANof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbgEANof (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8459216FD;
        Fri,  1 May 2020 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340674;
        bh=wMtdi2mSKs8GJKWAFYEXR4EYW0aiS/Rd2QRsf2QSWoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW2UMbqhz0PSxuYP5iMGiJWcmunznopup/1gWz0tPwXXJHLKVtAEwIA/5GRbiBfjj
         oA7XKIq85VY3uxFDbustCc2Gcjmgr/Gu53PXZ4nEcjre3E5wTMbvn77RmVpGQ0FbSy
         uVZOvXezaVkcZfYF2ZM7QmNd1jmMQ5gGoPgSXjng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 077/106] drm/amdgpu: fix wrong vram lost counter increment V2
Date:   Fri,  1 May 2020 15:23:50 +0200
Message-Id: <20200501131553.135630996@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 028cfb2444b94d4f394a6fa4ca46182481236e91 ]

Vram lost counter is wrongly increased by two during baco reset.

V2: assumed vram lost for mode1 reset on all ASICs

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 20 ++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/cik.c           |  2 --
 drivers/gpu/drm/amd/amdgpu/nv.c            |  4 ----
 drivers/gpu/drm/amd/amdgpu/soc15.c         |  4 ----
 drivers/gpu/drm/amd/amdgpu/vi.c            |  2 --
 5 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c8bf9cb3cebf2..f184cdca938de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1953,8 +1953,24 @@ static void amdgpu_device_fill_reset_magic(struct amdgpu_device *adev)
  */
 static bool amdgpu_device_check_vram_lost(struct amdgpu_device *adev)
 {
-	return !!memcmp(adev->gart.ptr, adev->reset_magic,
-			AMDGPU_RESET_MAGIC_NUM);
+	if (memcmp(adev->gart.ptr, adev->reset_magic,
+			AMDGPU_RESET_MAGIC_NUM))
+		return true;
+
+	if (!adev->in_gpu_reset)
+		return false;
+
+	/*
+	 * For all ASICs with baco/mode1 reset, the VRAM is
+	 * always assumed to be lost.
+	 */
+	switch (amdgpu_asic_reset_method(adev)) {
+	case AMD_RESET_METHOD_BACO:
+	case AMD_RESET_METHOD_MODE1:
+		return true;
+	default:
+		return false;
+	}
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index 006f21ef7ddf0..62635e58e45ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1358,8 +1358,6 @@ static int cik_asic_reset(struct amdgpu_device *adev)
 	int r;
 
 	if (cik_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
-		if (!adev->in_suspend)
-			amdgpu_inc_vram_lost(adev);
 		r = amdgpu_dpm_baco_reset(adev);
 	} else {
 		r = cik_asic_pci_config_reset(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 2d1bebdf1603d..cc3a79029376b 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -351,8 +351,6 @@ static int nv_asic_reset(struct amdgpu_device *adev)
 	struct smu_context *smu = &adev->smu;
 
 	if (nv_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
-		if (!adev->in_suspend)
-			amdgpu_inc_vram_lost(adev);
 		ret = smu_baco_enter(smu);
 		if (ret)
 			return ret;
@@ -360,8 +358,6 @@ static int nv_asic_reset(struct amdgpu_device *adev)
 		if (ret)
 			return ret;
 	} else {
-		if (!adev->in_suspend)
-			amdgpu_inc_vram_lost(adev);
 		ret = nv_asic_mode1_reset(adev);
 	}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index d8945c31b622c..132a67a041a24 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -569,14 +569,10 @@ static int soc15_asic_reset(struct amdgpu_device *adev)
 
 	switch (soc15_asic_reset_method(adev)) {
 		case AMD_RESET_METHOD_BACO:
-			if (!adev->in_suspend)
-				amdgpu_inc_vram_lost(adev);
 			return soc15_asic_baco_reset(adev);
 		case AMD_RESET_METHOD_MODE2:
 			return amdgpu_dpm_mode2_reset(adev);
 		default:
-			if (!adev->in_suspend)
-				amdgpu_inc_vram_lost(adev);
 			return soc15_asic_mode1_reset(adev);
 	}
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 78b35901643bc..3ce10e05d0d6b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -765,8 +765,6 @@ static int vi_asic_reset(struct amdgpu_device *adev)
 	int r;
 
 	if (vi_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
-		if (!adev->in_suspend)
-			amdgpu_inc_vram_lost(adev);
 		r = amdgpu_dpm_baco_reset(adev);
 	} else {
 		r = vi_asic_pci_config_reset(adev);
-- 
2.20.1



