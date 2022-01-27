Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC449E9F9
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245378AbiA0SLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59078 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245072AbiA0SKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94025B821DA;
        Thu, 27 Jan 2022 18:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA87CC340E4;
        Thu, 27 Jan 2022 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307045;
        bh=mCAJxU3jO5M7PSY1plEfvQEcBEGUr0FRugNSXX+uX3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU3JRDi7XDlKRgCk4myXjpo4yHnbCNB0k83C3pKntxym3hawLNQQVV1cKZPkfs/Bj
         mZLtWr7cUxgjOU+VtRaqrf2it5j/pV6lJM6QMxRqVNR9lRetkCLH0XsA+4XRD8zC/E
         rLwPJNoTVImUPXjEkhw1EYNy4oXfT8J0INhq5zKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 11/12] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Date:   Thu, 27 Jan 2022 19:09:35 +0100
Message-Id: <20220127180259.458001336@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b upstream.

For some reason this file isn't using the appropriate register
headers for DCN headers, which means that on DCN2 we're getting
the VIEWPORT_DIMENSION offset wrong.

This means that we're not correctly carving out the framebuffer
memory correctly for a framebuffer allocated by EFI and
therefore see corruption when loading amdgpu before the display
driver takes over control of the framebuffer scanout.

Fix this by checking the DCE_HWIP and picking the correct offset
accordingly.

Long-term we should expose this info from DC as GMC shouldn't
need to know about DCN registers.

Cc: stable@vger.kernel.org
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -72,6 +72,9 @@
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0                                                                  0x049d
 #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0_BASE_IDX                                                         2
 
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2                                                          0x05ea
+#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2_BASE_IDX                                                 2
+
 
 static const char *gfxhub_client_ids[] = {
 	"CB",
@@ -1103,6 +1106,8 @@ static unsigned gmc_v9_0_get_vbios_fb_si
 	u32 d1vga_control = RREG32_SOC15(DCE, 0, mmD1VGA_CONTROL);
 	unsigned size;
 
+	/* TODO move to DC so GMC doesn't need to hard-code DCN registers */
+
 	if (REG_GET_FIELD(d1vga_control, D1VGA_CONTROL, D1VGA_MODE_ENABLE)) {
 		size = AMDGPU_VBIOS_VGA_ALLOCATION;
 	} else {
@@ -1110,11 +1115,18 @@ static unsigned gmc_v9_0_get_vbios_fb_si
 
 		switch (adev->asic_type) {
 		case CHIP_RAVEN:
-		case CHIP_RENOIR:
 			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION);
 			size = (REG_GET_FIELD(viewport,
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
 				REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
+				4);
+			break;
+		case CHIP_RENOIR:
+			viewport = RREG32_SOC15(DCE, 0, mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2);
+			size = (REG_GET_FIELD(viewport,
+					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
+				REG_GET_FIELD(viewport,
 					      HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
 				4);
 			break;


