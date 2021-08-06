Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C48A3E22A5
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 06:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhHFEgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 00:36:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:8257 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242793AbhHFEgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 00:36:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="201490643"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="201490643"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 21:35:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="481146089"
Received: from debian-skl.sh.intel.com ([10.239.160.37])
  by fmsmga008.fm.intel.com with ESMTP; 05 Aug 2021 21:35:39 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        "Ekstrand, Jason" <jason.ekstrand@intel.com>
Subject: [PATCH v2] drm/i915/gvt: Fix cached atomics setting for Windows VM
Date:   Fri,  6 Aug 2021 12:40:56 +0800
Message-Id: <20210806044056.648016-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.32.0.rc2
In-Reply-To: <20210721062607.512307-1-zhenyuw@linux.intel.com>
References: <20210721062607.512307-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've seen recent regression with host and windows VM running
simultaneously that cause gpu hang or even crash. Finally bisect to
commit 58586680ffad ("drm/i915: Disable atomics in L3 for gen9"),
which seems cached atomics behavior difference caused regression
issue.

This tries to add new scratch register handler and add those in mmio
save/restore list for context switch. No gpu hang produced with this one.

Cc: stable@vger.kernel.org # 5.12+
Cc: "Xu, Terrence" <terrence.xu@intel.com>
Cc: "Bloomfield, Jon" <jon.bloomfield@intel.com>
Cc: "Ekstrand, Jason" <jason.ekstrand@intel.com>
Fixes: 58586680ffad ("drm/i915: Disable atomics in L3 for gen9")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/handlers.c     | 1 +
 drivers/gpu/drm/i915/gvt/mmio_context.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 06024d321a1a..cde0a477fb49 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3149,6 +3149,7 @@ static int init_bdw_mmio_info(struct intel_gvt *gvt)
 	MMIO_DFH(_MMIO(0xb100), D_BDW, F_CMD_ACCESS, NULL, NULL);
 	MMIO_DFH(_MMIO(0xb10c), D_BDW, F_CMD_ACCESS, NULL, NULL);
 	MMIO_D(_MMIO(0xb110), D_BDW);
+	MMIO_D(GEN9_SCRATCH_LNCF1, D_BDW_PLUS);
 
 	MMIO_F(_MMIO(0x24d0), 48, F_CMD_ACCESS | F_CMD_WRITE_PATCH, 0, 0,
 		D_BDW_PLUS, NULL, force_nonpriv_write);
diff --git a/drivers/gpu/drm/i915/gvt/mmio_context.c b/drivers/gpu/drm/i915/gvt/mmio_context.c
index b8ac80765461..f776c470914d 100644
--- a/drivers/gpu/drm/i915/gvt/mmio_context.c
+++ b/drivers/gpu/drm/i915/gvt/mmio_context.c
@@ -105,6 +105,8 @@ static struct engine_mmio gen9_engine_mmio_list[] __cacheline_aligned = {
 	{RCS0, COMMON_SLICE_CHICKEN2, 0xffff, true}, /* 0x7014 */
 	{RCS0, GEN9_CS_DEBUG_MODE1, 0xffff, false}, /* 0x20ec */
 	{RCS0, GEN8_L3SQCREG4, 0, false}, /* 0xb118 */
+	{RCS0, GEN9_SCRATCH1, 0, false}, /* 0xb11c */
+	{RCS0, GEN9_SCRATCH_LNCF1, 0, false}, /* 0xb008 */
 	{RCS0, GEN7_HALF_SLICE_CHICKEN1, 0xffff, true}, /* 0xe100 */
 	{RCS0, HALF_SLICE_CHICKEN2, 0xffff, true}, /* 0xe180 */
 	{RCS0, HALF_SLICE_CHICKEN3, 0xffff, true}, /* 0xe184 */
-- 
2.32.0.rc2

