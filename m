Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D325DF40
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgIDQHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 12:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgIDQHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 12:07:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D065C061247
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 09:07:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c19so7814770wmd.1
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen-nl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kr/Ld5h52IOIov2uSAm4w19sR9mrXrGTncuRTiQgYl4=;
        b=SbvVHDbpzMc4yt0LCwyoalLSZs1dHUnNey4F906nkirwqepE6q25gWg0j2EHRj3vmd
         JwZY7iH6fLB23+qX7cGq9m1I28rZiC0m5FbnKH++yCaMtdSMTzfZO0w/sfbAsA2N1V+j
         NArhgTwPUE3z4+pLLZARXceGxrFN/9mbIIp6oRllQ/lhq59+muguAQquQkGXdUU/CM+i
         NGvodP9G7Q08rNPeAA9/OP1/dJBraCT5RyQ7t6nPSGwV/j3pOhLWrftvW7mzh7VnWFiY
         B1wtc87khnBXeEbLu+AGwb5rH10AJJd5gGH0rnsI17mc0aoH2WAw0wxOwwYrf9rnzqKp
         RZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kr/Ld5h52IOIov2uSAm4w19sR9mrXrGTncuRTiQgYl4=;
        b=X6o/WEwMS/Gxq5L09NQsZYKIfaa91W5Snt29sfqPPGJCuJb65TrwfZ8tOhMvCYzRRy
         ho2B9slgZpjKaCa+8RhhNVJ4tu0ZWY6Sp0wbkxgsmeMKz2lYxxzJ4gEe3DMl2MKcGXT8
         JoOUJvD0wETcAtziMoIltghTlSZ99aOcuu4N8dVCjZloDY5mOUcY0q3x+AO+4tfZOVii
         4v4TCd4t6vlWbPRhOzl9qoDkVDygTsdB4ungWlyCLnhCzhT2wH5x5OGIshoncwyqBg1W
         vbfh6fXNACQR+5BA1qfkda/5iARU4bA3AOr0CFYJeJlosyhrRLkq1Zo08M/Ca5RD8sP7
         AHjg==
X-Gm-Message-State: AOAM530mYEYs4SmIyopVZCCKvfbNdktlgZgiSZVaC8sgNuSfkFNf13SR
        cBUGUvKIYCLUEsiXLsdv5CCjcw==
X-Google-Smtp-Source: ABdhPJw8y/kBAAtOKgEaNcdCTuTcZ3uDxUOajqVtRNDE/1npwTNRXfusb6AHz+u8E+a935X3sAlUFA==
X-Received: by 2002:a05:600c:22d1:: with SMTP id 17mr4283632wmg.58.1599235632118;
        Fri, 04 Sep 2020 09:07:12 -0700 (PDT)
Received: from localhost.localdomain ([2a02:aa12:a77f:2000:4cea:81e7:5fd4:93f7])
        by smtp.gmail.com with ESMTPSA id h185sm12467609wme.25.2020.09.04.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:07:11 -0700 (PDT)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, harry.wentland@amd.com,
        daniel@ffwll.ch, daniel@fooishbar.org, maraeo@gmail.com,
        alexdeucher@gmail.com, Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        stable@vger.kernel.org
Subject: [PATCH v2 03/11] drm/amd/display: Honor the offset for plane 0.
Date:   Fri,  4 Sep 2020 18:07:01 +0200
Message-Id: <20200904160709.123970-4-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904160709.123970-1-bas@basnieuwenhuizen.nl>
References: <20200904160709.123970-1-bas@basnieuwenhuizen.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With modifiers I'd like to support non-dedicated buffers for
images.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index cb31b5ed19f7..d06acaea16e8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3742,6 +3742,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 	struct dc *dc = adev->dm.dc;
 	struct dc_dcc_surface_param input;
 	struct dc_surface_dcc_cap output;
+	uint64_t plane_address = afb->address + afb->base.offsets[0];
 	uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
 	uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
 	uint64_t dcc_address;
@@ -3785,7 +3786,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 		AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
 	dcc->independent_64b_blks = i64b;
 
-	dcc_address = get_dcc_address(afb->address, info);
+	dcc_address = get_dcc_address(plane_address, info);
 	address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
 	address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
 
@@ -3816,6 +3817,8 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 	address->tmz_surface = tmz_surface;
 
 	if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
+		uint64_t addr = afb->address + fb->offsets[0];
+
 		plane_size->surface_size.x = 0;
 		plane_size->surface_size.y = 0;
 		plane_size->surface_size.width = fb->width;
@@ -3824,9 +3827,10 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 			fb->pitches[0] / fb->format->cpp[0];
 
 		address->type = PLN_ADDR_TYPE_GRAPHICS;
-		address->grph.addr.low_part = lower_32_bits(afb->address);
-		address->grph.addr.high_part = upper_32_bits(afb->address);
+		address->grph.addr.low_part = lower_32_bits(addr);
+		address->grph.addr.high_part = upper_32_bits(addr);
 	} else if (format < SURFACE_PIXEL_FORMAT_INVALID) {
+		uint64_t luma_addr = afb->address + fb->offsets[0];
 		uint64_t chroma_addr = afb->address + fb->offsets[1];
 
 		plane_size->surface_size.x = 0;
@@ -3847,9 +3851,9 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 
 		address->type = PLN_ADDR_TYPE_VIDEO_PROGRESSIVE;
 		address->video_progressive.luma_addr.low_part =
-			lower_32_bits(afb->address);
+			lower_32_bits(luma_addr);
 		address->video_progressive.luma_addr.high_part =
-			upper_32_bits(afb->address);
+			upper_32_bits(luma_addr);
 		address->video_progressive.chroma_addr.low_part =
 			lower_32_bits(chroma_addr);
 		address->video_progressive.chroma_addr.high_part =
-- 
2.28.0

