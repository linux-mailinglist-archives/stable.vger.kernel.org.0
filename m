Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33D64991D0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350751AbiAXUOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355446AbiAXUNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F54C06177C;
        Mon, 24 Jan 2022 11:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D0ABB81247;
        Mon, 24 Jan 2022 19:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F3C340E5;
        Mon, 24 Jan 2022 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052998;
        bh=f6NAM56Og1Yrc6Od3Am5rH5imViISDUzVvr7k4kzIP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBCabPR4cWINd44h1jRLTDQyVcgo6EOGG/r+m1vZgF8MXMAfffGL/JzYNn1PwqcUB
         DW1Fed3jHfiWxISQf1UpKBZdr3O6dPZD9rVTAdUMPSBwuU6/KSnKdgkuucxNcw2SM1
         zZXtQKjSddxiolWqAR4cGYd34SEnf++KBNkvqGSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zongmin Zhou <zhouzongmin@kylinos.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/320] drm/amdgpu: fixup bad vram size on gmc v8
Date:   Mon, 24 Jan 2022 19:43:13 +0100
Message-Id: <20220124184000.737133591@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index ea764dd9245db..2975331a7b867 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -524,10 +524,10 @@ static void gmc_v8_0_mc_program(struct amdgpu_device *adev)
 static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
 {
 	int r;
+	u32 tmp;
 
 	adev->gmc.vram_width = amdgpu_atombios_get_vram_width(adev);
 	if (!adev->gmc.vram_width) {
-		u32 tmp;
 		int chansize, numchan;
 
 		/* Get VRAM informations */
@@ -571,8 +571,15 @@ static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
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



