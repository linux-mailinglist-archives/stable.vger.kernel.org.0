Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BDD295520
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 01:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507137AbgJUXbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 19:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507136AbgJUXbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 19:31:41 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC8EC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 16:31:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id p13so4258149edi.7
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 16:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7tktjmcwk5yXhgNFT9XQCSpahtSlQF+mPeJj6PdoM48=;
        b=HOT6qB15DRbZ27JhtZzYMESygv3hG2umSVUv3PAtql/f+0Kh2M3wxhDuEGz6abThBX
         ay/AlpT34+ZQEW5P2MZIBX0I/9WpBX6DGMI43c3SRzUvAxAmy+D836s02tCvEoKg3eUH
         SWR/H9ijFqVBTggOObzkNF2AFGGRyqKQrfhK00wgMAfLwtT7wMJjopcfEX9oAr/2s1sO
         YFMFgz29QN+Xw1rlsZq8WbZVg6MiSNL9S1zbdugV77EzyEpIEJLswuWZREMrEPq2iihS
         KkNWc73QFe08uAOwI1wsnFRIn91zW5jgRY7jVdF4r73hagBR5/RROyDqxOcyhwCVTzbm
         hagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7tktjmcwk5yXhgNFT9XQCSpahtSlQF+mPeJj6PdoM48=;
        b=tru/zItaEeY/TxVY8ruMnMkJy5ZC/r65bAq7wmlz2kLMDvsGgHqUu1XrU4xUKRe1iw
         kbYtSz4gbbEjflWhCNLiE5pf36tqr47yx5khNYG+8uHpZuvT7lKdncrRwDf/uK40ni0G
         o77lzFpOF0mOZW5+8/TF7dV5F54f/dhCNzjpDDexTPGzOjrth+td7x7Ulys0nlPh2P9w
         udOQERlHIa4O/9Ay99KuGxEEvPFJCIVV7nK9h4uqWPjLL9bdKmOhzj8qUGc0vjlbK6rS
         fDyDruNTTNSd50rEm8J7slkBUSUBI/QwbwhCjDxu/iK4SASX2gSQn5KFBukRLm9J+2r3
         vEKQ==
X-Gm-Message-State: AOAM531xSeiGTDwb8qbPN7Nj9DGFLk5BwUB7tG+GEFsWWl8sKukoXYxo
        urpJ+BYHh+iJCxcoBsaFeD+8sQ==
X-Google-Smtp-Source: ABdhPJwuKdWeP7GaedFgJa7TLi5WpSdqmXyeV4Rf5VwR7bsDGmxUitYEPLBVVMrlxJUpHmeklFW4eQ==
X-Received: by 2002:a05:6402:551:: with SMTP id i17mr5231149edx.384.1603323097686;
        Wed, 21 Oct 2020 16:31:37 -0700 (PDT)
Received: from localhost.localdomain ([2a02:aa12:a77f:2000:4cea:81e7:5fd4:93f7])
        by smtp.gmail.com with ESMTPSA id k23sm2845236ejs.100.2020.10.21.16.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 16:31:37 -0700 (PDT)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     amd-gfx@lists.freedesktop.org
Cc:     harry.wentland@amd.com, daniel@ffwll.ch, alexdeucher@gmail.com,
        maraeo@gmail.com, nicholas.kazlauskas@amd.com, sunpeng.li@amd.com,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        stable@vger.kernel.org
Subject: [PATCH v3 03/11] drm/amd/display: Honor the offset for plane 0.
Date:   Thu, 22 Oct 2020 01:31:22 +0200
Message-Id: <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021233130.874615-1-bas@basnieuwenhuizen.nl>
References: <20201021233130.874615-1-bas@basnieuwenhuizen.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With modifiers I'd like to support non-dedicated buffers for
images.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc: stable@vger.kernel.org # 5.1.0
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 73987fdb6a09..833887b9b0ad 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3894,6 +3894,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 	struct dc *dc = adev->dm.dc;
 	struct dc_dcc_surface_param input;
 	struct dc_surface_dcc_cap output;
+	uint64_t plane_address = afb->address + afb->base.offsets[0];
 	uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
 	uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
 	uint64_t dcc_address;
@@ -3937,7 +3938,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
 		AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
 	dcc->independent_64b_blks = i64b;
 
-	dcc_address = get_dcc_address(afb->address, info);
+	dcc_address = get_dcc_address(plane_address, info);
 	address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
 	address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
 
@@ -3968,6 +3969,8 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 	address->tmz_surface = tmz_surface;
 
 	if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
+		uint64_t addr = afb->address + fb->offsets[0];
+
 		plane_size->surface_size.x = 0;
 		plane_size->surface_size.y = 0;
 		plane_size->surface_size.width = fb->width;
@@ -3976,9 +3979,10 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
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
@@ -3999,9 +4003,9 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 
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

