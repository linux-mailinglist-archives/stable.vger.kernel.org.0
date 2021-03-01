Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C879A32913A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhCAUWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39925 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243052AbhCAUNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD28A653CD;
        Mon,  1 Mar 2021 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621715;
        bh=uuImSf6y0vMMSj/b6+GiflltUnH/Jqw+IWtZk9vm8qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvHHr7vzwYr6ZMoEkp/e6S7d9++H5/232nTiiWmgoOiC/WMfSfITBKlvsQGgXnN4Y
         TwClou0f7/tOWW//KN7kJYnpkxTAdOYUSMomcf54ZVMh4EniKO+e29Nv9GKyk6hcBx
         PVCnqM5L+w+udRSfpRRHAhXHBub2EUPQWSAQmTDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 617/775] drm/amdgpu: fix CGTS_TCC_DISABLE register offset on gfx10.3
Date:   Mon,  1 Mar 2021 17:13:05 +0100
Message-Id: <20210301161231.890137912@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

commit 4112c00354004cbb1bf56f0114fa9951bf6b13ed upstream.

This fixes incorrect TCC harvesting info reported to userspace.
The impact was a very very tiny performance degradation (unnecessary
GL2 cache flushes).

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -71,6 +71,11 @@
 #define GB_ADDR_CONFIG__NUM_PKRS__SHIFT                                                                       0x8
 #define GB_ADDR_CONFIG__NUM_PKRS_MASK                                                                         0x00000700L
 
+#define mmCGTS_TCC_DISABLE_gc_10_3                 0x5006
+#define mmCGTS_TCC_DISABLE_gc_10_3_BASE_IDX        1
+#define mmCGTS_USER_TCC_DISABLE_gc_10_3            0x5007
+#define mmCGTS_USER_TCC_DISABLE_gc_10_3_BASE_IDX   1
+
 #define mmCP_MEC_CNTL_Sienna_Cichlid                      0x0f55
 #define mmCP_MEC_CNTL_Sienna_Cichlid_BASE_IDX             0
 #define mmRLC_SAFE_MODE_Sienna_Cichlid			0x4ca0
@@ -99,10 +104,6 @@
 #define mmGCR_GENERAL_CNTL_Sienna_Cichlid			0x1580
 #define mmGCR_GENERAL_CNTL_Sienna_Cichlid_BASE_IDX	0
 
-#define mmCGTS_TCC_DISABLE_Vangogh                0x5006
-#define mmCGTS_TCC_DISABLE_Vangogh_BASE_IDX       1
-#define mmCGTS_USER_TCC_DISABLE_Vangogh                0x5007
-#define mmCGTS_USER_TCC_DISABLE_Vangogh_BASE_IDX       1
 #define mmGOLDEN_TSC_COUNT_UPPER_Vangogh                0x0025
 #define mmGOLDEN_TSC_COUNT_UPPER_Vangogh_BASE_IDX       1
 #define mmGOLDEN_TSC_COUNT_LOWER_Vangogh                0x0026
@@ -4942,15 +4943,12 @@ static void gfx_v10_0_get_tcc_info(struc
 	/* TCCs are global (not instanced). */
 	uint32_t tcc_disable;
 
-	switch (adev->asic_type) {
-	case CHIP_VANGOGH:
-		tcc_disable = RREG32_SOC15(GC, 0, mmCGTS_TCC_DISABLE_Vangogh) |
-				RREG32_SOC15(GC, 0, mmCGTS_USER_TCC_DISABLE_Vangogh);
-		break;
-	default:
+	if (adev->asic_type >= CHIP_SIENNA_CICHLID) {
+		tcc_disable = RREG32_SOC15(GC, 0, mmCGTS_TCC_DISABLE_gc_10_3) |
+			      RREG32_SOC15(GC, 0, mmCGTS_USER_TCC_DISABLE_gc_10_3);
+	} else {
 		tcc_disable = RREG32_SOC15(GC, 0, mmCGTS_TCC_DISABLE) |
-				RREG32_SOC15(GC, 0, mmCGTS_USER_TCC_DISABLE);
-		break;
+			      RREG32_SOC15(GC, 0, mmCGTS_USER_TCC_DISABLE);
 	}
 
 	adev->gfx.config.tcc_disabled_mask =


