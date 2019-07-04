Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1555F4BB
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 10:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGDIpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 04:45:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:43337 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfGDIpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 04:45:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 01:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,450,1557212400"; 
   d="scan'208";a="158228792"
Received: from coxu-arch-shz.sh.intel.com ([10.239.160.21])
  by orsmga008.jf.intel.com with ESMTP; 04 Jul 2019 01:45:12 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     colin.xu@intel.com, stable@vger.kernel.org, zhenyuw@linux.intel.com
Subject: [PATCH v3] drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow pdps settled.
Date:   Thu,  4 Jul 2019 16:45:06 +0800
Message-Id: <20190704084506.28360-1-colin.xu@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 4f15665ccbba (drm/i915: Add ppgtt to GVT GEM context)

v2:
Move set_context_ppgtt_from_shadow() after prepare_workload(). (zhenyu)
v3:
Move set_context_ppgtt_from_shadow() after shadow pdps updated.(zhenyu)

Cc: stable@vger.kernel.org
Signed-off-by: Colin Xu <colin.xu@intel.com>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

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
-- 
2.22.0

