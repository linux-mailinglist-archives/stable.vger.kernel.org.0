Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D59E2D8
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfH0Ij3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:39:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:47153 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfH0Ij2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:39:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 01:39:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="182713561"
Received: from xzhan34-mobl3.bj.intel.com ([10.238.154.72])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 01:39:26 -0700
From:   Xiaolin Zhang <xiaolin.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Xiaolin Zhang <xiaolin.zhang@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/gvt: update vgpu workload head pointer correctly
Date:   Tue, 27 Aug 2019 16:39:23 +0800
Message-Id: <1566895163-3772-1-git-send-email-xiaolin.zhang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

when creating a vGPU workload, the guest context head pointer should
be updated correctly by comparing with the exsiting workload in the
guest worklod queue including the current running context.

in some situation, there is a running context A and then received 2 new
vGPU workload context B and A. in the new workload context A, it's head
pointer should be updated with the running context A's tail.

Fixes: 09975b861aa0 ("drm/i915/execlists: Disable preemption under GVT")
Fixes: 22b7a426bbe1 ("drm/i915/execlists: Preempt-to-busy")

v2: walk through guest workload list in backward way.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 8940fa8..166b998 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -1438,9 +1438,6 @@ static int prepare_mm(struct intel_vgpu_workload *workload)
 #define same_context(a, b) (((a)->context_id == (b)->context_id) && \
 		((a)->lrca == (b)->lrca))
 
-#define get_last_workload(q) \
-	(list_empty(q) ? NULL : container_of(q->prev, \
-	struct intel_vgpu_workload, list))
 /**
  * intel_vgpu_create_workload - create a vGPU workload
  * @vgpu: a vGPU
@@ -1460,7 +1457,7 @@ intel_vgpu_create_workload(struct intel_vgpu *vgpu, int ring_id,
 {
 	struct intel_vgpu_submission *s = &vgpu->submission;
 	struct list_head *q = workload_q_head(vgpu, ring_id);
-	struct intel_vgpu_workload *last_workload = get_last_workload(q);
+	struct intel_vgpu_workload *last_workload = NULL;
 	struct intel_vgpu_workload *workload = NULL;
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
 	u64 ring_context_gpa;
@@ -1486,15 +1483,20 @@ intel_vgpu_create_workload(struct intel_vgpu *vgpu, int ring_id,
 	head &= RB_HEAD_OFF_MASK;
 	tail &= RB_TAIL_OFF_MASK;
 
-	if (last_workload && same_context(&last_workload->ctx_desc, desc)) {
-		gvt_dbg_el("ring id %d cur workload == last\n", ring_id);
-		gvt_dbg_el("ctx head %x real head %lx\n", head,
-				last_workload->rb_tail);
-		/*
-		 * cannot use guest context head pointer here,
-		 * as it might not be updated at this time
-		 */
-		head = last_workload->rb_tail;
+	list_for_each_entry_reverse(last_workload, q, list) {
+
+		if (same_context(&last_workload->ctx_desc, desc)) {
+			gvt_dbg_el("ring id %d cur workload == last\n",
+					ring_id);
+			gvt_dbg_el("ctx head %x real head %lx\n", head,
+					last_workload->rb_tail);
+			/*
+			 * cannot use guest context head pointer here,
+			 * as it might not be updated at this time
+			 */
+			head = last_workload->rb_tail;
+			break;
+		}
 	}
 
 	gvt_dbg_el("ring id %d begin a new workload\n", ring_id);
-- 
2.7.4

