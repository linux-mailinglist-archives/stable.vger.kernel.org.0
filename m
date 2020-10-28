Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72DF29DB6A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgJ1XyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgJ1Xwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:52:44 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF4FC0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:52:43 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id x1so1332786eds.1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DGSEKASS/bd8TuE/KrHjD98p0JJoKSSs8WsMzHa7qJg=;
        b=gQfm91glFvnLHCE77A7mxjK94GjUmr1p6ovSPgN2UOvOBqDxTpNbF3gQHGsbVkph+y
         xzRteosujQg2MYEqILin4sjdlXhEikOdqxovvyAxmY2S50JP4D+tGL/vBiEGeHjiiPh/
         JtE0bqKY9iXhO1UMYGKYpEJF5rfG+Tirfnn8PKnZv/gXyhz1EKiyNBrfI3iUpICH2ma6
         7cpkHiFM5mDUysJkx1ew0ynCxXrAXiX2bQOPUGEL/CxBGaHcjnV5xWo6VRCaCDLNjrK3
         lJNHPdyWMcYISX9tTh105Ex+4C/VDT4xUrw1SRCsI9wsFzr70AYeCHOKkFpOb4/gS6ub
         NSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DGSEKASS/bd8TuE/KrHjD98p0JJoKSSs8WsMzHa7qJg=;
        b=MghCBIW/BPu5rvKthn8wSsTFU8xk54X9F1ulWjJgdVUdIp9VPYUEsTQLJ0ANvGBIIu
         ItbGOEx6qUV2E0TDbqd//O3uHofifVEkj9R3SAfkRxGgB6YdNFsOMUslg1A+J0F89Btb
         nITlRI3tanw/bQkUNr1GJMMFJegKlCnzv1EpQEO+ESt4PaLKmMG8wdM5b8r9+jY5LpMw
         C4ArfzuwJKdTaI2dUTj3ZSvg8/ZMg5l2LRPmyiCKMiWadBG3uUOMh1dGJqeKdNcBhZ8p
         nMrHnB9/JFeic174Wc3MCclRUZ9NNCVYHeZ1PxXj3MSV6CNqG4+sQohSOcnu+jdXtoWd
         O/Aw==
X-Gm-Message-State: AOAM532UF7rANSi43/+TNhnpNWUrG91rwYbe6+I/4uvhqM/gAYit2EFp
        L2y9lsCuCknfIj436CCeuK7CoQ==
X-Google-Smtp-Source: ABdhPJyJ9WG/DfcFLhThKPqpbAG2IQWkS6UMWpOU7x8oVaRhOcjFrvFo6JK40wMy8fRNhlp+Wec2eg==
X-Received: by 2002:aa7:c98f:: with SMTP id c15mr1455564edt.200.1603929162684;
        Wed, 28 Oct 2020 16:52:42 -0700 (PDT)
Received: from localhost.localdomain ([2a02:aa12:a77f:2000:4cea:81e7:5fd4:93f7])
        by smtp.gmail.com with ESMTPSA id o13sm479174ejr.120.2020.10.28.16.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 16:52:41 -0700 (PDT)
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
To:     amd-gfx@lists.freedesktop.org
Cc:     harry.wentland@amd.com, alexdeucher@gmail.com,
        nicholas.kazlauskas@amd.com,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 03/11] drm/amd/display: Honor the offset for plane 0.
Date:   Thu, 29 Oct 2020 00:52:33 +0100
Message-Id: <20201028235241.3299-4-bas@basnieuwenhuizen.nl>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201028235241.3299-1-bas@basnieuwenhuizen.nl>
References: <20201028235241.3299-1-bas@basnieuwenhuizen.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With modifiers I'd like to support non-dedicated buffers for
images.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
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

