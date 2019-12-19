Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4050F126B83
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfLSS5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730626AbfLSS4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6542624683;
        Thu, 19 Dec 2019 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781795;
        bh=Kl+1FOt4ETt7Kp1G9zYfPSSHPb/+By/0Im49Y1+D0PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HtCluke4PaxJv4D+AbM/On0ERoq4E46PoCK6+FigXV9rZQvDr0KqaHxpi/kknW0i
         9HQsnMv93UF7hrIpO4URuY11tSegSD9KxMw2DZEr8MLR3ss8+5mYkG4RlOmrNnuOcK
         TdfJuhxY6/CK1TNsNYUAyI6qgWK6lmyo51L/Djx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 77/80] drm/amdgpu/gfx10: re-init clear state buffer after gpu reset
Date:   Thu, 19 Dec 2019 19:35:09 +0100
Message-Id: <20191219183146.949139449@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

commit 210b3b3c7563df391bd81d49c51af303b928de4a upstream.

This patch fixes 2nd baco reset failure with gfxoff enabled on navi1x.

clear state buffer (resides in vram) is corrupted after 1st baco reset,
upon gfxoff exit, CPF gets garbage header in CSIB and hangs.

Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   43 ++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -1785,27 +1785,52 @@ static void gfx_v10_0_enable_gui_idle_in
 	WREG32_SOC15(GC, 0, mmCP_INT_CNTL_RING0, tmp);
 }
 
-static void gfx_v10_0_init_csb(struct amdgpu_device *adev)
+static int gfx_v10_0_init_csb(struct amdgpu_device *adev)
 {
+	int r;
+
+	if (adev->in_gpu_reset) {
+		r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
+		if (r)
+			return r;
+
+		r = amdgpu_bo_kmap(adev->gfx.rlc.clear_state_obj,
+				   (void **)&adev->gfx.rlc.cs_ptr);
+		if (!r) {
+			adev->gfx.rlc.funcs->get_csb_buffer(adev,
+					adev->gfx.rlc.cs_ptr);
+			amdgpu_bo_kunmap(adev->gfx.rlc.clear_state_obj);
+		}
+
+		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
+		if (r)
+			return r;
+	}
+
 	/* csib */
 	WREG32_SOC15(GC, 0, mmRLC_CSIB_ADDR_HI,
 		     adev->gfx.rlc.clear_state_gpu_addr >> 32);
 	WREG32_SOC15(GC, 0, mmRLC_CSIB_ADDR_LO,
 		     adev->gfx.rlc.clear_state_gpu_addr & 0xfffffffc);
 	WREG32_SOC15(GC, 0, mmRLC_CSIB_LENGTH, adev->gfx.rlc.clear_state_size);
+
+	return 0;
 }
 
-static void gfx_v10_0_init_pg(struct amdgpu_device *adev)
+static int gfx_v10_0_init_pg(struct amdgpu_device *adev)
 {
 	int i;
+	int r;
 
-	gfx_v10_0_init_csb(adev);
+	r = gfx_v10_0_init_csb(adev);
+	if (r)
+		return r;
 
 	for (i = 0; i < adev->num_vmhubs; i++)
 		amdgpu_gmc_flush_gpu_tlb(adev, 0, i, 0);
 
 	/* TODO: init power gating */
-	return;
+	return 0;
 }
 
 void gfx_v10_0_rlc_stop(struct amdgpu_device *adev)
@@ -1907,7 +1932,10 @@ static int gfx_v10_0_rlc_resume(struct a
 		r = gfx_v10_0_wait_for_rlc_autoload_complete(adev);
 		if (r)
 			return r;
-		gfx_v10_0_init_pg(adev);
+
+		r = gfx_v10_0_init_pg(adev);
+		if (r)
+			return r;
 
 		/* enable RLC SRM */
 		gfx_v10_0_rlc_enable_srm(adev);
@@ -1933,7 +1961,10 @@ static int gfx_v10_0_rlc_resume(struct a
 				return r;
 		}
 
-		gfx_v10_0_init_pg(adev);
+		r = gfx_v10_0_init_pg(adev);
+		if (r)
+			return r;
+
 		adev->gfx.rlc.funcs->start(adev);
 
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_RLC_BACKDOOR_AUTO) {


