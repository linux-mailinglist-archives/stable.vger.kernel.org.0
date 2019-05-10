Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206CD19948
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEJIG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 04:06:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:10762 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbfEJIG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 04:06:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 May 2019 01:06:27 -0700
X-ExtLoop1: 1
Received: from vgt-optiplex-9020.sh.intel.com ([10.239.160.51])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2019 01:06:26 -0700
From:   Weinan <weinan.z.li@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Weinan <weinan.z.li@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/gvt: emit init breadcrumb for gvt request
Date:   Fri, 10 May 2019 15:57:20 +0800
Message-Id: <20190510075720.8206-1-weinan.z.li@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"To track whether a request has started on HW, we can emit a breadcrumb at
the beginning of the request and check its timeline's HWSP to see if the
breadcrumb has advanced past the start of this request." It means all the
request which timeline's has_init_breadcrumb is true, then the
emit_init_breadcrumb process must have before emitting the real commands,
otherwise, the scheduler might get a wrong state of this request during
reset. If the request is exactly the guilty one, the scheduler won't
terminate it with the wrong state. To avoid this, do emit_init_breadcrumb
for all the requests from gvt.

v2: cc to stable kernel

Fixes: 8547444137ec ("drm/i915: Identify active requests")
Cc: stable@vger.kernel.org
Signed-off-by: Weinan <weinan.z.li@intel.com>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 7c99bbc3e2b8..ccd71152c9bc 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -298,12 +298,31 @@ static int copy_workload_to_ring_buffer(struct intel_vgpu_workload *workload)
 	struct i915_request *req = workload->req;
 	void *shadow_ring_buffer_va;
 	u32 *cs;
+	int err;
 
 	if ((IS_KABYLAKE(req->i915) || IS_BROXTON(req->i915)
 		|| IS_COFFEELAKE(req->i915))
 		&& is_inhibit_context(req->hw_context))
 		intel_vgpu_restore_inhibit_context(vgpu, req);
 
+	/*
+	 * To track whether a request has started on HW, we can emit a
+	 * breadcrumb at the beginning of the request and check its
+	 * timeline's HWSP to see if the breadcrumb has advanced past the
+	 * start of this request. Actually, the request must have the
+	 * init_breadcrumb if its timeline set has_init_bread_crumb, or the
+	 * scheduler might get a wrong state of it during reset. Since the
+	 * requests from gvt always set the has_init_breadcrumb flag, here
+	 * need to do the emit_init_breadcrumb for all the requests.
+	 */
+	if (req->engine->emit_init_breadcrumb) {
+		err = req->engine->emit_init_breadcrumb(req);
+		if (err) {
+			gvt_vgpu_err("fail to emit init breadcrumb\n");
+			return err;
+		}
+	}
+
 	/* allocate shadow ring buffer */
 	cs = intel_ring_begin(workload->req, workload->rb_len / sizeof(u32));
 	if (IS_ERR(cs)) {
-- 
2.17.1

