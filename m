Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA127235
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 00:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfEVWYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 18:24:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:22784 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfEVWYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 18:24:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 15:24:03 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2019 15:24:02 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     zhenyuw@linux.intel.com
Cc:     Tina Zhang <tina.zhang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack
Date:   Thu, 23 May 2019 06:18:36 +0800
Message-Id: <20190522221836.3777-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stack struct intel_gvt_gtt_entry value needs to be initialized before
being used, as the fields may contain garbage values.

W/o this patch, set_ggtt_entry prints:
-------------------------------------
274.046840: set_ggtt_entry: vgpu1:set ggtt entry 0x9bed8000ffffe900
274.046846: set_ggtt_entry: vgpu1:set ggtt entry 0xe55df001
274.046852: set_ggtt_entry: vgpu1:set ggtt entry 0x9bed8000ffffe900

0x9bed8000 is the stack grabage.

W/ this patch, set_ggtt_entry prints:
------------------------------------
274.046840: set_ggtt_entry: vgpu1:set ggtt entry 0xffffe900
274.046846: set_ggtt_entry: vgpu1:set ggtt entry 0xe55df001
274.046852: set_ggtt_entry: vgpu1:set ggtt entry 0xffffe900

v2:
- Initialize during declaration. (Zhenyu)

Fixes: 7598e8700e9a(drm/i915/gvt: Missed to cancel dma map for ggtt entries)
Cc: stable@vger.kernel.org # v4.20+
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 15216c5b40aa..ebc1e5228bf5 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -2179,7 +2179,8 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
 	struct intel_gvt_gtt_pte_ops *ops = gvt->gtt.pte_ops;
 	unsigned long g_gtt_index = off >> info->gtt_entry_size_shift;
 	unsigned long gma, gfn;
-	struct intel_gvt_gtt_entry e, m;
+	struct intel_gvt_gtt_entry e = {.val64 = 0, .type = GTT_TYPE_GGTT_PTE};
+	struct intel_gvt_gtt_entry m = {.val64 = 0, .type = GTT_TYPE_GGTT_PTE};
 	dma_addr_t dma_addr;
 	int ret;
 	struct intel_gvt_partial_pte *partial_pte, *pos, *n;
@@ -2246,7 +2247,8 @@ static int emulate_ggtt_mmio_write(struct intel_vgpu *vgpu, unsigned int off,
 
 	if (!partial_update && (ops->test_present(&e))) {
 		gfn = ops->get_pfn(&e);
-		m = e;
+		m.val64 = e.val64;
+		m.type = e.type;
 
 		/* one PTE update may be issued in multiple writes and the
 		 * first write may not construct a valid gfn
-- 
2.17.1

