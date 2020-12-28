Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49542E3BEC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404512AbgL1N4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407832AbgL1N4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDCC320715;
        Mon, 28 Dec 2020 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163760;
        bh=FBtaa9l9LkMTd1n7ZWk4EDD84qDTDEWS/2veV9Q2BaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjPNqXCH6Fhfqj3UzqBwKhhsft9x4Ih1HZOG+An/n5LLU53ntTx3PPSSBPePpO6xl
         80jJ76G9SlLPqSLVQfSxgUpifhIrVCzB7K5dOYz23AY266ojBNhqVXUfTALl3oYTxr
         /qcZ6zulyOv5sFL8T9LYPJyi6+4ck3/l+hqmB3do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH 5.4 397/453] drm/amd/display: Honor the offset for plane 0.
Date:   Mon, 28 Dec 2020 13:50:33 +0100
Message-Id: <20201228124956.308196192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit be7b9b327e79cd2db07b659af599867b629b2f66 upstream.

With modifiers I'd like to support non-dedicated buffers for
images.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: stable@vger.kernel.org # 5.1.0
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2720,6 +2720,7 @@ fill_plane_dcc_attributes(struct amdgpu_
 	struct dc *dc = adev->dm.dc;
 	struct dc_dcc_surface_param input;
 	struct dc_surface_dcc_cap output;
+	uint64_t plane_address = afb->address + afb->base.offsets[0];
 	uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
 	uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
 	uint64_t dcc_address;
@@ -2763,7 +2764,7 @@ fill_plane_dcc_attributes(struct amdgpu_
 		AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
 	dcc->independent_64b_blks = i64b;
 
-	dcc_address = get_dcc_address(afb->address, info);
+	dcc_address = get_dcc_address(plane_address, info);
 	address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
 	address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
 
@@ -2791,6 +2792,8 @@ fill_plane_buffer_attributes(struct amdg
 	memset(address, 0, sizeof(*address));
 
 	if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
+		uint64_t addr = afb->address + fb->offsets[0];
+
 		plane_size->surface_size.x = 0;
 		plane_size->surface_size.y = 0;
 		plane_size->surface_size.width = fb->width;
@@ -2799,9 +2802,10 @@ fill_plane_buffer_attributes(struct amdg
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
@@ -2822,9 +2826,9 @@ fill_plane_buffer_attributes(struct amdg
 
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


