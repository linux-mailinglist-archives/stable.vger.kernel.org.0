Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98C04999D9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456202AbiAXViE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40736 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449381AbiAXV2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:28:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B3AB811FB;
        Mon, 24 Jan 2022 21:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5509BC340E4;
        Mon, 24 Jan 2022 21:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059694;
        bh=Evjdvma7DpXHpludweJifTmE2JUT8KCAToNGDJW3x2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgvY4r24ag3Y72DPmVku1cg4JeRGEOFz2mc20JSx0vKdGGM+Vj4fkxX5yCiI+h3Sw
         oUTuBRrGH3RmgxtQ47WoSMPlhXiJSScODSsDpbHzRs7xF+YoyP4FLk0OsinHl+fl2R
         1q1mZ8z0XX9bgjbSJ2M4Dssam+ge1FDvCn6I+3wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zongmin Zhou <zhouzongmin@kylinos.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0703/1039] drm/amdgpu: fixup bad vram size on gmc v8
Date:   Mon, 24 Jan 2022 19:41:32 +0100
Message-Id: <20220124184148.962296625@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit 11544d77e3974924c5a9c8a8320b996a3e9b2f8b ]

Some boards(like RX550) seem to have garbage in the upper
16 bits of the vram size register.  Check for
this and clamp the size properly.  Fixes
boards reporting bogus amounts of vram.

after add this patch,the maximum GPU VRAM size is 64GB,
otherwise only 64GB vram size will be used.

Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
index 492ebed2915be..63b890f1e8afb 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -515,10 +515,10 @@ static void gmc_v8_0_mc_program(struct amdgpu_device *adev)
 static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
 {
 	int r;
+	u32 tmp;
 
 	adev->gmc.vram_width = amdgpu_atombios_get_vram_width(adev);
 	if (!adev->gmc.vram_width) {
-		u32 tmp;
 		int chansize, numchan;
 
 		/* Get VRAM informations */
@@ -562,8 +562,15 @@ static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
 		adev->gmc.vram_width = numchan * chansize;
 	}
 	/* size in MB on si */
-	adev->gmc.mc_vram_size = RREG32(mmCONFIG_MEMSIZE) * 1024ULL * 1024ULL;
-	adev->gmc.real_vram_size = RREG32(mmCONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	tmp = RREG32(mmCONFIG_MEMSIZE);
+	/* some boards may have garbage in the upper 16 bits */
+	if (tmp & 0xffff0000) {
+		DRM_INFO("Probable bad vram size: 0x%08x\n", tmp);
+		if (tmp & 0xffff)
+			tmp &= 0xffff;
+	}
+	adev->gmc.mc_vram_size = tmp * 1024ULL * 1024ULL;
+	adev->gmc.real_vram_size = adev->gmc.mc_vram_size;
 
 	if (!(adev->flags & AMD_IS_APU)) {
 		r = amdgpu_device_resize_fb_bar(adev);
-- 
2.34.1



