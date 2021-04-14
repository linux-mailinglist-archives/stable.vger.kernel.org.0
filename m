Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5DF35F020
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 10:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbhDNIrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 04:47:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:1871 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhDNIrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 04:47:32 -0400
IronPort-SDR: KIYEpErP5RtqVShZuKgF95BTpo2Vzvz8Wll0ujbBMmhkfkZYtMCRYqmW6pNkLDP7fdgRNVs6o4
 7Ln9GBv57UPw==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="191412762"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="191412762"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 01:47:11 -0700
IronPort-SDR: uEdT/HUJP9UTAtjpkt0iJDUKjtuXRkAsemqgOvWYm4Vk6St1V4I0OLAq1a3hmvi8Gf7/yPTwVP
 15bcv4zNbMCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="532706954"
Received: from debian-skl.sh.intel.com ([10.239.160.37])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2021 01:47:09 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/gvt: Fix BDW command parser regression
Date:   Wed, 14 Apr 2021 16:48:12 +0800
Message-Id: <20210414084813.3763353-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On BDW new Windows driver has brought extra registers to handle for
LRM/LRR command in WA ctx. Add allowed registers in cmd parser for BDW.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: stable@vger.kernel.org
Fixes: 73a37a43d1b0 ("drm/i915/gvt: filter cmds "lrr-src" and "lrr-dst" in cmd_handler")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index fef1e857cefc..01c1d1b36acd 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -916,19 +916,26 @@ static int cmd_reg_handler(struct parser_exec_state *s,
 
 	if (!strncmp(cmd, "srm", 3) ||
 			!strncmp(cmd, "lrm", 3)) {
-		if (offset != i915_mmio_reg_offset(GEN8_L3SQCREG4) &&
-				offset != 0x21f0) {
+		if (offset == i915_mmio_reg_offset(GEN8_L3SQCREG4) ||
+		    offset == 0x21f0 ||
+		    (IS_BROADWELL(gvt->gt->i915) &&
+		     offset == i915_mmio_reg_offset(INSTPM)))
+			return 0;
+		else {
 			gvt_vgpu_err("%s access to register (%x)\n",
 					cmd, offset);
 			return -EPERM;
-		} else
-			return 0;
+		}
 	}
 
 	if (!strncmp(cmd, "lrr-src", 7) ||
 			!strncmp(cmd, "lrr-dst", 7)) {
-		gvt_vgpu_err("not allowed cmd %s\n", cmd);
-		return -EPERM;
+		if (IS_BROADWELL(gvt->gt->i915) && offset == 0x215c)
+			return 0;
+		else {
+			gvt_vgpu_err("not allowed cmd %s reg (%x)\n", cmd, offset);
+			return -EPERM;
+		}
 	}
 
 	if (!strncmp(cmd, "pipe_ctrl", 9)) {
-- 
2.31.0

