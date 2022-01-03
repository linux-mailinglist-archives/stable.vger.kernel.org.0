Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6296E483361
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiACOgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiACOdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:33:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1391BB80F52;
        Mon,  3 Jan 2022 14:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5867DC36AED;
        Mon,  3 Jan 2022 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220396;
        bh=qlxHfnN1hy+WjW6P2ULz01S9hF795a8OmW4Sd0AlJN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0ZMftFAfBJwV+hJ55dnz2yfMiTkzECNv4fkrHEBHALhmoXov072PcCUFDGnii8AX
         2gqYy0FsPDrWNHfSskiiwf0ntUxDXl487llDHQliK39rynkm4snODjS/LWI9cbcB0w
         s/H53Rr9rymW6uj5vxE6ne/SbcgCr89VxpZk7y6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 56/73] drm/amdgpu: add support for IP discovery gc_info table v2
Date:   Mon,  3 Jan 2022 15:24:17 +0100
Message-Id: <20220103142058.729919623@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 5e713c6afa34c0fd6f113bf7bb1c2847172d7b20 upstream.

Used on gfx9 based systems. Fixes incorrect CU counts reported
in the kernel log.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1833
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   76 ++++++++++++++++++--------
 drivers/gpu/drm/amd/include/discovery.h       |   49 ++++++++++++++++
 2 files changed, 103 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -415,10 +415,15 @@ void amdgpu_discovery_harvest_ip(struct
 	}
 }
 
+union gc_info {
+	struct gc_info_v1_0 v1;
+	struct gc_info_v2_0 v2;
+};
+
 int amdgpu_discovery_get_gfx_info(struct amdgpu_device *adev)
 {
 	struct binary_header *bhdr;
-	struct gc_info_v1_0 *gc_info;
+	union gc_info *gc_info;
 
 	if (!adev->mman.discovery_bin) {
 		DRM_ERROR("ip discovery uninitialized\n");
@@ -426,27 +431,54 @@ int amdgpu_discovery_get_gfx_info(struct
 	}
 
 	bhdr = (struct binary_header *)adev->mman.discovery_bin;
-	gc_info = (struct gc_info_v1_0 *)(adev->mman.discovery_bin +
+	gc_info = (union gc_info *)(adev->mman.discovery_bin +
 			le16_to_cpu(bhdr->table_list[GC].offset));
-
-	adev->gfx.config.max_shader_engines = le32_to_cpu(gc_info->gc_num_se);
-	adev->gfx.config.max_cu_per_sh = 2 * (le32_to_cpu(gc_info->gc_num_wgp0_per_sa) +
-					      le32_to_cpu(gc_info->gc_num_wgp1_per_sa));
-	adev->gfx.config.max_sh_per_se = le32_to_cpu(gc_info->gc_num_sa_per_se);
-	adev->gfx.config.max_backends_per_se = le32_to_cpu(gc_info->gc_num_rb_per_se);
-	adev->gfx.config.max_texture_channel_caches = le32_to_cpu(gc_info->gc_num_gl2c);
-	adev->gfx.config.max_gprs = le32_to_cpu(gc_info->gc_num_gprs);
-	adev->gfx.config.max_gs_threads = le32_to_cpu(gc_info->gc_num_max_gs_thds);
-	adev->gfx.config.gs_vgt_table_depth = le32_to_cpu(gc_info->gc_gs_table_depth);
-	adev->gfx.config.gs_prim_buffer_depth = le32_to_cpu(gc_info->gc_gsprim_buff_depth);
-	adev->gfx.config.double_offchip_lds_buf = le32_to_cpu(gc_info->gc_double_offchip_lds_buffer);
-	adev->gfx.cu_info.wave_front_size = le32_to_cpu(gc_info->gc_wave_size);
-	adev->gfx.cu_info.max_waves_per_simd = le32_to_cpu(gc_info->gc_max_waves_per_simd);
-	adev->gfx.cu_info.max_scratch_slots_per_cu = le32_to_cpu(gc_info->gc_max_scratch_slots_per_cu);
-	adev->gfx.cu_info.lds_size = le32_to_cpu(gc_info->gc_lds_size);
-	adev->gfx.config.num_sc_per_sh = le32_to_cpu(gc_info->gc_num_sc_per_se) /
-					 le32_to_cpu(gc_info->gc_num_sa_per_se);
-	adev->gfx.config.num_packer_per_sc = le32_to_cpu(gc_info->gc_num_packer_per_sc);
-
+	switch (gc_info->v1.header.version_major) {
+	case 1:
+		adev->gfx.config.max_shader_engines = le32_to_cpu(gc_info->v1.gc_num_se);
+		adev->gfx.config.max_cu_per_sh = 2 * (le32_to_cpu(gc_info->v1.gc_num_wgp0_per_sa) +
+						      le32_to_cpu(gc_info->v1.gc_num_wgp1_per_sa));
+		adev->gfx.config.max_sh_per_se = le32_to_cpu(gc_info->v1.gc_num_sa_per_se);
+		adev->gfx.config.max_backends_per_se = le32_to_cpu(gc_info->v1.gc_num_rb_per_se);
+		adev->gfx.config.max_texture_channel_caches = le32_to_cpu(gc_info->v1.gc_num_gl2c);
+		adev->gfx.config.max_gprs = le32_to_cpu(gc_info->v1.gc_num_gprs);
+		adev->gfx.config.max_gs_threads = le32_to_cpu(gc_info->v1.gc_num_max_gs_thds);
+		adev->gfx.config.gs_vgt_table_depth = le32_to_cpu(gc_info->v1.gc_gs_table_depth);
+		adev->gfx.config.gs_prim_buffer_depth = le32_to_cpu(gc_info->v1.gc_gsprim_buff_depth);
+		adev->gfx.config.double_offchip_lds_buf = le32_to_cpu(gc_info->v1.gc_double_offchip_lds_buffer);
+		adev->gfx.cu_info.wave_front_size = le32_to_cpu(gc_info->v1.gc_wave_size);
+		adev->gfx.cu_info.max_waves_per_simd = le32_to_cpu(gc_info->v1.gc_max_waves_per_simd);
+		adev->gfx.cu_info.max_scratch_slots_per_cu = le32_to_cpu(gc_info->v1.gc_max_scratch_slots_per_cu);
+		adev->gfx.cu_info.lds_size = le32_to_cpu(gc_info->v1.gc_lds_size);
+		adev->gfx.config.num_sc_per_sh = le32_to_cpu(gc_info->v1.gc_num_sc_per_se) /
+			le32_to_cpu(gc_info->v1.gc_num_sa_per_se);
+		adev->gfx.config.num_packer_per_sc = le32_to_cpu(gc_info->v1.gc_num_packer_per_sc);
+		break;
+	case 2:
+		adev->gfx.config.max_shader_engines = le32_to_cpu(gc_info->v2.gc_num_se);
+		adev->gfx.config.max_cu_per_sh = le32_to_cpu(gc_info->v2.gc_num_cu_per_sh);
+		adev->gfx.config.max_sh_per_se = le32_to_cpu(gc_info->v2.gc_num_sh_per_se);
+		adev->gfx.config.max_backends_per_se = le32_to_cpu(gc_info->v2.gc_num_rb_per_se);
+		adev->gfx.config.max_texture_channel_caches = le32_to_cpu(gc_info->v2.gc_num_tccs);
+		adev->gfx.config.max_gprs = le32_to_cpu(gc_info->v2.gc_num_gprs);
+		adev->gfx.config.max_gs_threads = le32_to_cpu(gc_info->v2.gc_num_max_gs_thds);
+		adev->gfx.config.gs_vgt_table_depth = le32_to_cpu(gc_info->v2.gc_gs_table_depth);
+		adev->gfx.config.gs_prim_buffer_depth = le32_to_cpu(gc_info->v2.gc_gsprim_buff_depth);
+		adev->gfx.config.double_offchip_lds_buf = le32_to_cpu(gc_info->v2.gc_double_offchip_lds_buffer);
+		adev->gfx.cu_info.wave_front_size = le32_to_cpu(gc_info->v2.gc_wave_size);
+		adev->gfx.cu_info.max_waves_per_simd = le32_to_cpu(gc_info->v2.gc_max_waves_per_simd);
+		adev->gfx.cu_info.max_scratch_slots_per_cu = le32_to_cpu(gc_info->v2.gc_max_scratch_slots_per_cu);
+		adev->gfx.cu_info.lds_size = le32_to_cpu(gc_info->v2.gc_lds_size);
+		adev->gfx.config.num_sc_per_sh = le32_to_cpu(gc_info->v2.gc_num_sc_per_se) /
+			le32_to_cpu(gc_info->v2.gc_num_sh_per_se);
+		adev->gfx.config.num_packer_per_sc = le32_to_cpu(gc_info->v2.gc_num_packer_per_sc);
+		break;
+	default:
+		dev_err(adev->dev,
+			"Unhandled GC info table %d.%d\n",
+			gc_info->v1.header.version_major,
+			gc_info->v1.header.version_minor);
+		return -EINVAL;
+	}
 	return 0;
 }
--- a/drivers/gpu/drm/amd/include/discovery.h
+++ b/drivers/gpu/drm/amd/include/discovery.h
@@ -143,6 +143,55 @@ struct gc_info_v1_0 {
 	uint32_t gc_num_gl2a;
 };
 
+struct gc_info_v1_1 {
+	struct gpu_info_header header;
+
+	uint32_t gc_num_se;
+	uint32_t gc_num_wgp0_per_sa;
+	uint32_t gc_num_wgp1_per_sa;
+	uint32_t gc_num_rb_per_se;
+	uint32_t gc_num_gl2c;
+	uint32_t gc_num_gprs;
+	uint32_t gc_num_max_gs_thds;
+	uint32_t gc_gs_table_depth;
+	uint32_t gc_gsprim_buff_depth;
+	uint32_t gc_parameter_cache_depth;
+	uint32_t gc_double_offchip_lds_buffer;
+	uint32_t gc_wave_size;
+	uint32_t gc_max_waves_per_simd;
+	uint32_t gc_max_scratch_slots_per_cu;
+	uint32_t gc_lds_size;
+	uint32_t gc_num_sc_per_se;
+	uint32_t gc_num_sa_per_se;
+	uint32_t gc_num_packer_per_sc;
+	uint32_t gc_num_gl2a;
+	uint32_t gc_num_tcp_per_sa;
+	uint32_t gc_num_sdp_interface;
+	uint32_t gc_num_tcps;
+};
+
+struct gc_info_v2_0 {
+	struct gpu_info_header header;
+
+	uint32_t gc_num_se;
+	uint32_t gc_num_cu_per_sh;
+	uint32_t gc_num_sh_per_se;
+	uint32_t gc_num_rb_per_se;
+	uint32_t gc_num_tccs;
+	uint32_t gc_num_gprs;
+	uint32_t gc_num_max_gs_thds;
+	uint32_t gc_gs_table_depth;
+	uint32_t gc_gsprim_buff_depth;
+	uint32_t gc_parameter_cache_depth;
+	uint32_t gc_double_offchip_lds_buffer;
+	uint32_t gc_wave_size;
+	uint32_t gc_max_waves_per_simd;
+	uint32_t gc_max_scratch_slots_per_cu;
+	uint32_t gc_lds_size;
+	uint32_t gc_num_sc_per_se;
+	uint32_t gc_num_packer_per_sc;
+};
+
 typedef struct harvest_info_header {
 	uint32_t signature; /* Table Signature */
 	uint32_t version;   /* Table Version */


