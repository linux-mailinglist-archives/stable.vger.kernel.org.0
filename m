Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DCF811DB
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfHEF6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:58:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46205 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727161AbfHEF6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:58:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 133AA20F44;
        Mon,  5 Aug 2019 01:58:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OzwnWJ
        oubGkDtAStsxLnP61MSRosi+wIvN+544MBIIg=; b=tVHiW/wyh/WQyW9t6KxOaY
        itfdmJBEJXFUxcwTqq89CUA5IdYu6JA78IDp6fMuPJ7VPF3eLCIVFHa/GWVXkYp4
        DIeCXJAabz2LzJ2mbf2VNzVUOIS0anzoWNngWNX1f7opUmmhF6MgKdrzGTeX+KTW
        y36ITyok8xOiVRhkpowhdNKjHW/chSUux17Og0eOXhLymufkiBrxOE77SKbUt1JC
        4BD2lfQjt5wggrtuU0KvLowSCJEsqGiGFv/PsGPUZOva1DNqqZHZ4oIQZrroRppP
        9jotJ9vKlP245eZzRgV3uAUL3ztI6jgzB0Do6oWN0z0GIntu7JrOHlpo1kZ1N6ow
        ==
X-ME-Sender: <xms:mcVHXd00OYiJ2zfIOFeJNYhlgdEgSWMo2CLTI0qnWGh8Vf6r_iBn4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mcVHXbBtedzjGzPSMyZdEKS9d-NY0YB2IEKb7L0PvseB1EK1T1AC-w>
    <xmx:mcVHXS8mb2isgk25GjN0WJ9le8BO6YPEMG3nzp8Sfz5Kck6G1ONfxQ>
    <xmx:mcVHXR-0q213mEEr43FDbwInBGvGjvsaeFrpwfaeLccXSkPpXbuV5g>
    <xmx:msVHXQ7rtGd5iycUC8g3T5p-b7FobPG7CZqHGN4OVMxioDmrT2e3pg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 881B98005C;
        Mon,  5 Aug 2019 01:58:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow" failed to apply to 5.2-stable tree
To:     colin.xu@intel.com, zhenyuw@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:58:48 +0200
Message-ID: <15649847280142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4187414808095f645ca0661f8dde77617e2e7cb3 Mon Sep 17 00:00:00 2001
From: Colin Xu <colin.xu@intel.com>
Date: Thu, 4 Jul 2019 16:45:06 +0800
Subject: [PATCH] drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow
 pdps settled.

Windows guest can't run after force-TDR with host log:
...
gvt: vgpu 1: workload shadow ppgtt isn't ready
gvt: vgpu 1: fail to dispatch workload, skip
...

The error is raised by set_context_ppgtt_from_shadow(), when it checks
and found the shadow_mm isn't marked as shadowed.

In work thread before each submission, a shadow_mm is set to shadowed in:
shadow_ppgtt_mm()
<-intel_vgpu_pin_mm()
<-prepare_workload()
<-dispatch_workload()
<-workload_thread()
However checking whether or not shadow_mm is shadowed is prior to it:
set_context_ppgtt_from_shadow()
<-dispatch_workload()
<-workload_thread()

In normal case, create workload will check the existence of shadow_mm,
if not it will create a new one and marked as shadowed. If already exist
it will reuse the old one. Since shadow_mm is reused, checking of shadowed
in set_context_ppgtt_from_shadow() actually always see the state set in
creation, but not the state set in intel_vgpu_pin_mm().

When force-TDR, all engines are reset, since it's not dmlr level, all
ppgtt_mm are invalidated but not destroyed. Invalidation will mark all
reused shadow_mm as not shadowed but still keeps in ppgtt_mm_list_head.
If workload submission phase those shadow_mm are reused with shadowed
not set, then set_context_ppgtt_from_shadow() will report error.

Pin for context after shadow_mm pinned and shadow pdps settled.

v2:
Move set_context_ppgtt_from_shadow() after prepare_workload(). (zhenyu)
v3:
Move set_context_ppgtt_from_shadow() after shadow pdps updated.(zhenyu)

Fixes: 4f15665ccbba ("drm/i915: Add ppgtt to GVT GEM context")
Cc: stable@vger.kernel.org
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 196b4155a309..9f3fd7d96a69 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -364,16 +364,13 @@ static void release_shadow_wa_ctx(struct intel_shadow_wa_ctx *wa_ctx)
 	wa_ctx->indirect_ctx.shadow_va = NULL;
 }
 
-static int set_context_ppgtt_from_shadow(struct intel_vgpu_workload *workload,
-					 struct i915_gem_context *ctx)
+static void set_context_ppgtt_from_shadow(struct intel_vgpu_workload *workload,
+					  struct i915_gem_context *ctx)
 {
 	struct intel_vgpu_mm *mm = workload->shadow_mm;
 	struct i915_ppgtt *ppgtt = i915_vm_to_ppgtt(ctx->vm);
 	int i = 0;
 
-	if (mm->type != INTEL_GVT_MM_PPGTT || !mm->ppgtt_mm.shadowed)
-		return -EINVAL;
-
 	if (mm->ppgtt_mm.root_entry_type == GTT_TYPE_PPGTT_ROOT_L4_ENTRY) {
 		px_dma(ppgtt->pd) = mm->ppgtt_mm.shadow_pdps[0];
 	} else {
@@ -384,8 +381,6 @@ static int set_context_ppgtt_from_shadow(struct intel_vgpu_workload *workload,
 			px_dma(pd) = mm->ppgtt_mm.shadow_pdps[i];
 		}
 	}
-
-	return 0;
 }
 
 static int
@@ -614,6 +609,8 @@ static void release_shadow_batch_buffer(struct intel_vgpu_workload *workload)
 static int prepare_workload(struct intel_vgpu_workload *workload)
 {
 	struct intel_vgpu *vgpu = workload->vgpu;
+	struct intel_vgpu_submission *s = &vgpu->submission;
+	int ring = workload->ring_id;
 	int ret = 0;
 
 	ret = intel_vgpu_pin_mm(workload->shadow_mm);
@@ -622,8 +619,16 @@ static int prepare_workload(struct intel_vgpu_workload *workload)
 		return ret;
 	}
 
+	if (workload->shadow_mm->type != INTEL_GVT_MM_PPGTT ||
+	    !workload->shadow_mm->ppgtt_mm.shadowed) {
+		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
+		return -EINVAL;
+	}
+
 	update_shadow_pdps(workload);
 
+	set_context_ppgtt_from_shadow(workload, s->shadow[ring]->gem_context);
+
 	ret = intel_vgpu_sync_oos_pages(workload->vgpu);
 	if (ret) {
 		gvt_vgpu_err("fail to vgpu sync oos pages\n");
@@ -674,7 +679,6 @@ static int dispatch_workload(struct intel_vgpu_workload *workload)
 {
 	struct intel_vgpu *vgpu = workload->vgpu;
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
-	struct intel_vgpu_submission *s = &vgpu->submission;
 	struct i915_request *rq;
 	int ring_id = workload->ring_id;
 	int ret;
@@ -685,13 +689,6 @@ static int dispatch_workload(struct intel_vgpu_workload *workload)
 	mutex_lock(&vgpu->vgpu_lock);
 	mutex_lock(&dev_priv->drm.struct_mutex);
 
-	ret = set_context_ppgtt_from_shadow(workload,
-					    s->shadow[ring_id]->gem_context);
-	if (ret < 0) {
-		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
-		goto err_req;
-	}
-
 	ret = intel_gvt_workload_req_alloc(workload);
 	if (ret)
 		goto err_req;

