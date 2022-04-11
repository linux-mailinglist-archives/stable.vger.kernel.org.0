Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B044FB74D
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiDKJ0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343779AbiDKJ0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D913FDA7
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA516B8118D
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D9C385A5;
        Mon, 11 Apr 2022 09:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669027;
        bh=X5N3ajZ3wh1nNyhcKQe0Xj6AWkTx68mGS+MUBZTE58A=;
        h=Subject:To:Cc:From:Date:From;
        b=eK4xFXT1/TnLi5KmptYmC8oL19n0RGlT57+WasUBrphtA+Y5V3wi+CdpIllGWpCsM
         8NLVPlkWpyoEMiD2xisqVHw9+mvO/1nv37OsZQG3pAhZ0IrqRG43ELRfOBaWdQ1Uj9
         VN3+GXtrkw8vQt4yRqOJesllUJFqo3CHioVnyqX4=
Subject: FAILED: patch "[PATCH] drm/amdgpu: add workarounds for VCN TMZ issue on CHIP_RAVEN" failed to apply to 4.14-stable tree
To:     Lang.Yu@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 11:23:44 +0200
Message-ID: <16496690248194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0d8e4eb337644cab528ff3844675d58496ec22db Mon Sep 17 00:00:00 2001
From: Lang Yu <Lang.Yu@amd.com>
Date: Tue, 8 Mar 2022 11:26:41 +0800
Subject: [PATCH] drm/amdgpu: add workarounds for VCN TMZ issue on CHIP_RAVEN
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It is a hardware issue that VCN can't handle a GTT
backing stored TMZ buffer on CHIP_RAVEN series ASIC.

Move such a TMZ buffer to VRAM domain before command
submission as a workaround.

v2:
 - Use patch_cs_in_place callback.

v3:
 - Bail out early if unsecure IBs.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
index dff54190b96c..f0fbcda76f5e 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -24,6 +24,7 @@
 #include <linux/firmware.h>
 
 #include "amdgpu.h"
+#include "amdgpu_cs.h"
 #include "amdgpu_vcn.h"
 #include "amdgpu_pm.h"
 #include "soc15.h"
@@ -1900,6 +1901,75 @@ static const struct amd_ip_funcs vcn_v1_0_ip_funcs = {
 	.set_powergating_state = vcn_v1_0_set_powergating_state,
 };
 
+/*
+ * It is a hardware issue that VCN can't handle a GTT TMZ buffer on
+ * CHIP_RAVEN series ASIC. Move such a GTT TMZ buffer to VRAM domain
+ * before command submission as a workaround.
+ */
+static int vcn_v1_0_validate_bo(struct amdgpu_cs_parser *parser,
+				struct amdgpu_job *job,
+				uint64_t addr)
+{
+	struct ttm_operation_ctx ctx = { false, false };
+	struct amdgpu_fpriv *fpriv = parser->filp->driver_priv;
+	struct amdgpu_vm *vm = &fpriv->vm;
+	struct amdgpu_bo_va_mapping *mapping;
+	struct amdgpu_bo *bo;
+	int r;
+
+	addr &= AMDGPU_GMC_HOLE_MASK;
+	if (addr & 0x7) {
+		DRM_ERROR("VCN messages must be 8 byte aligned!\n");
+		return -EINVAL;
+	}
+
+	mapping = amdgpu_vm_bo_lookup_mapping(vm, addr/AMDGPU_GPU_PAGE_SIZE);
+	if (!mapping || !mapping->bo_va || !mapping->bo_va->base.bo)
+		return -EINVAL;
+
+	bo = mapping->bo_va->base.bo;
+	if (!(bo->flags & AMDGPU_GEM_CREATE_ENCRYPTED))
+		return 0;
+
+	amdgpu_bo_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_VRAM);
+	r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	if (r) {
+		DRM_ERROR("Failed to validate the VCN message BO (%d)!\n", r);
+		return r;
+	}
+
+	return r;
+}
+
+static int vcn_v1_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
+					   struct amdgpu_job *job,
+					   struct amdgpu_ib *ib)
+{
+	uint32_t msg_lo = 0, msg_hi = 0;
+	int i, r;
+
+	if (!(ib->flags & AMDGPU_IB_FLAGS_SECURE))
+		return 0;
+
+	for (i = 0; i < ib->length_dw; i += 2) {
+		uint32_t reg = amdgpu_ib_get_value(ib, i);
+		uint32_t val = amdgpu_ib_get_value(ib, i + 1);
+
+		if (reg == PACKET0(p->adev->vcn.internal.data0, 0)) {
+			msg_lo = val;
+		} else if (reg == PACKET0(p->adev->vcn.internal.data1, 0)) {
+			msg_hi = val;
+		} else if (reg == PACKET0(p->adev->vcn.internal.cmd, 0)) {
+			r = vcn_v1_0_validate_bo(p, job,
+						 ((u64)msg_hi) << 32 | msg_lo);
+			if (r)
+				return r;
+		}
+	}
+
+	return 0;
+}
+
 static const struct amdgpu_ring_funcs vcn_v1_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
@@ -1910,6 +1980,7 @@ static const struct amdgpu_ring_funcs vcn_v1_0_dec_ring_vm_funcs = {
 	.get_rptr = vcn_v1_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v1_0_dec_ring_get_wptr,
 	.set_wptr = vcn_v1_0_dec_ring_set_wptr,
+	.patch_cs_in_place = vcn_v1_0_ring_patch_cs_in_place,
 	.emit_frame_size =
 		6 + 6 + /* hdp invalidate / flush */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 6 +

