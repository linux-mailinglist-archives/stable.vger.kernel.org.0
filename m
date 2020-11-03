Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505962A581C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgKCVss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731718AbgKCUtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B7B22404;
        Tue,  3 Nov 2020 20:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436594;
        bh=O7m8mZCUItsngj+/Qawkcunu2asw8Rj1wGCnC6VzQ60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+Ke7UqdQWuHOI9i2cblodH4gH44vK2EUqfoJtRrS+77Oe/yfv98amCrwQTOJ9m3S
         JOkq7uv3BYBq1jad9YvjjUpSwjI+I+PdzvRg2vXYGnMZZoccMJsjTYhYXypl/JRDDU
         WSeScSXap/J0daDmNvMvzykhoZ61YX9Th+d7iryA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 319/391] drm/amdgpu: vcn and jpeg ring synchronization
Date:   Tue,  3 Nov 2020 21:36:10 +0100
Message-Id: <20201103203408.634127129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabadhran G <vegopala@amd.com>

commit 187561dd76531945126b15c9486fec7cfa5f0415 upstream.

Synchronize the ring usage for vcn1 and jpeg1 to workaround a hardware bug.

Signed-off-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |    2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |    1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c  |   24 ++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c   |   28 ++++++++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h   |    3 ++-
 5 files changed, 51 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -68,6 +68,7 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 
 	INIT_DELAYED_WORK(&adev->vcn.idle_work, amdgpu_vcn_idle_work_handler);
 	mutex_init(&adev->vcn.vcn_pg_lock);
+	mutex_init(&adev->vcn.vcn1_jpeg1_workaround);
 	atomic_set(&adev->vcn.total_submission_cnt, 0);
 	for (i = 0; i < adev->vcn.num_vcn_inst; i++)
 		atomic_set(&adev->vcn.inst[i].dpg_enc_submission_cnt, 0);
@@ -237,6 +238,7 @@ int amdgpu_vcn_sw_fini(struct amdgpu_dev
 	}
 
 	release_firmware(adev->vcn.fw);
+	mutex_destroy(&adev->vcn.vcn1_jpeg1_workaround);
 	mutex_destroy(&adev->vcn.vcn_pg_lock);
 
 	return 0;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -220,6 +220,7 @@ struct amdgpu_vcn {
 	struct amdgpu_vcn_inst	 inst[AMDGPU_MAX_VCN_INSTANCES];
 	struct amdgpu_vcn_reg	 internal;
 	struct mutex		 vcn_pg_lock;
+	struct mutex		vcn1_jpeg1_workaround;
 	atomic_t		 total_submission_cnt;
 
 	unsigned	harvest_config;
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c
@@ -33,6 +33,7 @@
 
 static void jpeg_v1_0_set_dec_ring_funcs(struct amdgpu_device *adev);
 static void jpeg_v1_0_set_irq_funcs(struct amdgpu_device *adev);
+static void jpeg_v1_0_ring_begin_use(struct amdgpu_ring *ring);
 
 static void jpeg_v1_0_decode_ring_patch_wreg(struct amdgpu_ring *ring, uint32_t *ptr, uint32_t reg_offset, uint32_t val)
 {
@@ -564,8 +565,8 @@ static const struct amdgpu_ring_funcs jp
 	.insert_start = jpeg_v1_0_decode_ring_insert_start,
 	.insert_end = jpeg_v1_0_decode_ring_insert_end,
 	.pad_ib = amdgpu_ring_generic_pad_ib,
-	.begin_use = vcn_v1_0_ring_begin_use,
-	.end_use = amdgpu_vcn_ring_end_use,
+	.begin_use = jpeg_v1_0_ring_begin_use,
+	.end_use = vcn_v1_0_ring_end_use,
 	.emit_wreg = jpeg_v1_0_decode_ring_emit_wreg,
 	.emit_reg_wait = jpeg_v1_0_decode_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = amdgpu_ring_emit_reg_write_reg_wait_helper,
@@ -586,3 +587,22 @@ static void jpeg_v1_0_set_irq_funcs(stru
 {
 	adev->jpeg.inst->irq.funcs = &jpeg_v1_0_irq_funcs;
 }
+
+static void jpeg_v1_0_ring_begin_use(struct amdgpu_ring *ring)
+{
+	struct	amdgpu_device *adev = ring->adev;
+	bool	set_clocks = !cancel_delayed_work_sync(&adev->vcn.idle_work);
+	int		cnt = 0;
+
+	mutex_lock(&adev->vcn.vcn1_jpeg1_workaround);
+
+	if (amdgpu_fence_wait_empty(&adev->vcn.inst->ring_dec))
+		DRM_ERROR("JPEG dec: vcn dec ring may not be empty\n");
+
+	for (cnt = 0; cnt < adev->vcn.num_enc_rings; cnt++) {
+		if (amdgpu_fence_wait_empty(&adev->vcn.inst->ring_enc[cnt]))
+			DRM_ERROR("JPEG dec: vcn enc ring[%d] may not be empty\n", cnt);
+	}
+
+	vcn_v1_0_set_pg_for_begin_use(ring, set_clocks);
+}
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -54,6 +54,7 @@ static int vcn_v1_0_pause_dpg_mode(struc
 				int inst_idx, struct dpg_pause_state *new_state);
 
 static void vcn_v1_0_idle_work_handler(struct work_struct *work);
+static void vcn_v1_0_ring_begin_use(struct amdgpu_ring *ring);
 
 /**
  * vcn_v1_0_early_init - set function pointers
@@ -1804,11 +1805,24 @@ static void vcn_v1_0_idle_work_handler(s
 	}
 }
 
-void vcn_v1_0_ring_begin_use(struct amdgpu_ring *ring)
+static void vcn_v1_0_ring_begin_use(struct amdgpu_ring *ring)
 {
-	struct amdgpu_device *adev = ring->adev;
+	struct	amdgpu_device *adev = ring->adev;
 	bool set_clocks = !cancel_delayed_work_sync(&adev->vcn.idle_work);
 
+	mutex_lock(&adev->vcn.vcn1_jpeg1_workaround);
+
+	if (amdgpu_fence_wait_empty(&ring->adev->jpeg.inst->ring_dec))
+		DRM_ERROR("VCN dec: jpeg dec ring may not be empty\n");
+
+	vcn_v1_0_set_pg_for_begin_use(ring, set_clocks);
+
+}
+
+void vcn_v1_0_set_pg_for_begin_use(struct amdgpu_ring *ring, bool set_clocks)
+{
+	struct amdgpu_device *adev = ring->adev;
+
 	if (set_clocks) {
 		amdgpu_gfx_off_ctrl(adev, false);
 		if (adev->pm.dpm_enabled)
@@ -1844,6 +1858,12 @@ void vcn_v1_0_ring_begin_use(struct amdg
 	}
 }
 
+void vcn_v1_0_ring_end_use(struct amdgpu_ring *ring)
+{
+	schedule_delayed_work(&ring->adev->vcn.idle_work, VCN_IDLE_TIMEOUT);
+	mutex_unlock(&ring->adev->vcn.vcn1_jpeg1_workaround);
+}
+
 static const struct amd_ip_funcs vcn_v1_0_ip_funcs = {
 	.name = "vcn_v1_0",
 	.early_init = vcn_v1_0_early_init,
@@ -1891,7 +1911,7 @@ static const struct amdgpu_ring_funcs vc
 	.insert_end = vcn_v1_0_dec_ring_insert_end,
 	.pad_ib = amdgpu_ring_generic_pad_ib,
 	.begin_use = vcn_v1_0_ring_begin_use,
-	.end_use = amdgpu_vcn_ring_end_use,
+	.end_use = vcn_v1_0_ring_end_use,
 	.emit_wreg = vcn_v1_0_dec_ring_emit_wreg,
 	.emit_reg_wait = vcn_v1_0_dec_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = amdgpu_ring_emit_reg_write_reg_wait_helper,
@@ -1923,7 +1943,7 @@ static const struct amdgpu_ring_funcs vc
 	.insert_end = vcn_v1_0_enc_ring_insert_end,
 	.pad_ib = amdgpu_ring_generic_pad_ib,
 	.begin_use = vcn_v1_0_ring_begin_use,
-	.end_use = amdgpu_vcn_ring_end_use,
+	.end_use = vcn_v1_0_ring_end_use,
 	.emit_wreg = vcn_v1_0_enc_ring_emit_wreg,
 	.emit_reg_wait = vcn_v1_0_enc_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = amdgpu_ring_emit_reg_write_reg_wait_helper,
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h
@@ -24,7 +24,8 @@
 #ifndef __VCN_V1_0_H__
 #define __VCN_V1_0_H__
 
-void vcn_v1_0_ring_begin_use(struct amdgpu_ring *ring);
+void vcn_v1_0_ring_end_use(struct amdgpu_ring *ring);
+void vcn_v1_0_set_pg_for_begin_use(struct amdgpu_ring *ring, bool set_clocks);
 
 extern const struct amdgpu_ip_block_version vcn_v1_0_ip_block;
 


