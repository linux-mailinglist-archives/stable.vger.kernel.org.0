Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA57E3D08CF
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 08:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhGUFlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 01:41:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:50521 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234994AbhGUFlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 01:41:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="190964242"
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="190964242"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 23:21:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="511385248"
Received: from debian-skl.sh.intel.com ([10.239.160.37])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jul 2021 23:21:25 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: [PATCH] drm/i915/gvt: Fix cached atomics setting for Windows VM
Date:   Wed, 21 Jul 2021 14:26:07 +0800
Message-Id: <20210721062607.512307-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.32.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've seen recent regression with host and windows VM running
simultaneously that cause gpu hang or even crash. Finally bisect to
58586680ffad ("drm/i915: Disable atomics in L3 for gen9"), which seems
cached atomics behavior difference caused regression issue.

This trys to add new scratch register handler and add those in mmio
save/restore list for context switch. No gpu hang produced with this one.

Cc: stable@vger.kernel.org # 5.12+
Cc: "Xu, Terrence" <terrence.xu@intel.com>
Fixes: 58586680ffad ("drm/i915: Disable atomics in L3 for gen9")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/handlers.c     | 1 +
 drivers/gpu/drm/i915/gvt/mmio_context.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 98eb48c24c46..345b4be5ebad 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3134,6 +3134,7 @@ static int init_bdw_mmio_info(struct intel_gvt *gvt)
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

