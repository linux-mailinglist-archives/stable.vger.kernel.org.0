Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93BD23F8
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbfJJIrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387775AbfJJIrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A32224BD;
        Thu, 10 Oct 2019 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697261;
        bh=X4xLrAkXyRmsntZUR3zLVRvy/Ws925/vFkVLcH1FPww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7PLzsIJ91oijFLSciaGO7vz8jj4vKvIu5c1+nSMZwB9u4MS0j9+EYlSt2SzuxNbC
         FUC4dkl08zIL2kpqDPfhqkoaujh51aO2DjRdirxmLatmHsXpYUISFWc/beBYqLErcr
         UG+mab2PHQR1gPM8iY5KRtX0pf/N+2CfMZwimUgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 4.19 040/114] drm/i915/gvt: update vgpu workload head pointer correctly
Date:   Thu, 10 Oct 2019 10:35:47 +0200
Message-Id: <20191010083605.378337441@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolin Zhang <xiaolin.zhang@intel.com>

commit 0a3242bdb47713e09cb004a0ba4947d3edf82d8a upstream.

when creating a vGPU workload, the guest context head pointer should
be updated correctly by comparing with the exsiting workload in the
guest worklod queue including the current running context.

in some situation, there is a running context A and then received 2 new
vGPU workload context B and A. in the new workload context A, it's head
pointer should be updated with the running context A's tail.

v2: walk through guest workload list in backward way.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/scheduler.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -1276,9 +1276,6 @@ static int prepare_mm(struct intel_vgpu_
 #define same_context(a, b) (((a)->context_id == (b)->context_id) && \
 		((a)->lrca == (b)->lrca))
 
-#define get_last_workload(q) \
-	(list_empty(q) ? NULL : container_of(q->prev, \
-	struct intel_vgpu_workload, list))
 /**
  * intel_vgpu_create_workload - create a vGPU workload
  * @vgpu: a vGPU
@@ -1297,7 +1294,7 @@ intel_vgpu_create_workload(struct intel_
 {
 	struct intel_vgpu_submission *s = &vgpu->submission;
 	struct list_head *q = workload_q_head(vgpu, ring_id);
-	struct intel_vgpu_workload *last_workload = get_last_workload(q);
+	struct intel_vgpu_workload *last_workload = NULL;
 	struct intel_vgpu_workload *workload = NULL;
 	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
 	u64 ring_context_gpa;
@@ -1320,15 +1317,20 @@ intel_vgpu_create_workload(struct intel_
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


