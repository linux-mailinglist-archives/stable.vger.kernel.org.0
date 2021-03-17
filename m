Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198F133E73F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhCQCzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:55:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:29195 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQCzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 22:55:32 -0400
IronPort-SDR: uGBP24eIFwKzfhiGyIKgZN1E/y+iSfIyM8bh+mE6rp3hbMonTFMbHc+e2QDRh5IIqAtQxJPjnT
 oR6/9ARdqDIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187002413"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="187002413"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 19:55:32 -0700
IronPort-SDR: 8D7UJpYIARieE+nVrxSDf2UmGR80LGSYJCHZV5bXctiRzpbD+gdHTDMEv/qM+zFKv8aOiy6hEj
 EKvUK29qNNjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="590888255"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.25])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 19:55:30 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 1/5] drm/i915/gvt: Set SNOOP for PAT3 on BXT/APL to workaround GPU BB hang
Date:   Wed, 17 Mar 2021 10:55:00 +0800
Message-Id: <cfc85d94d1d2005fba3e5813b0c4c2df080b8aed.1615946755.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615946755.git.colin.xu@intel.com>
References: <cover.1615946755.git.colin.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8fe105679765700378eb328495fcfe1566cdbbd0 upstream

If guest fills non-priv bb on ApolloLake/Broxton as Mesa i965 does in:
717e7539124d (i965: Use a WC map and memcpy for the batch instead of pw-)
Due to the missing flush of bb filled by VM vCPU, host GPU hangs on
executing these MI_BATCH_BUFFER.

Temporarily workaround this by setting SNOOP bit for PAT3 used by PPGTT
PML4 PTE: PAT(0) PCD(1) PWT(1).

The performance is still expected to be low, will need further improvement.

Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20201012045231.226748-1-colin.xu@intel.com
(cherry picked from commit 8fe105679765700378eb328495fcfe1566cdbbd0)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
---
 drivers/gpu/drm/i915/gvt/handlers.c | 32 ++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 689b07bc91c4..f14aefcb5b7b 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -1632,6 +1632,34 @@ static int edp_psr_imr_iir_write(struct intel_vgpu *vgpu,
 	return 0;
 }
 
+/**
+ * FixMe:
+ * If guest fills non-priv batch buffer on ApolloLake/Broxton as Mesa i965 did:
+ * 717e7539124d (i965: Use a WC map and memcpy for the batch instead of pwrite.)
+ * Due to the missing flush of bb filled by VM vCPU, host GPU hangs on executing
+ * these MI_BATCH_BUFFER.
+ * Temporarily workaround this by setting SNOOP bit for PAT3 used by PPGTT
+ * PML4 PTE: PAT(0) PCD(1) PWT(1).
+ * The performance is still expected to be low, will need further improvement.
+ */
+static int bxt_ppat_low_write(struct intel_vgpu *vgpu, unsigned int offset,
+			      void *p_data, unsigned int bytes)
+{
+	u64 pat =
+		GEN8_PPAT(0, CHV_PPAT_SNOOP) |
+		GEN8_PPAT(1, 0) |
+		GEN8_PPAT(2, 0) |
+		GEN8_PPAT(3, CHV_PPAT_SNOOP) |
+		GEN8_PPAT(4, CHV_PPAT_SNOOP) |
+		GEN8_PPAT(5, CHV_PPAT_SNOOP) |
+		GEN8_PPAT(6, CHV_PPAT_SNOOP) |
+		GEN8_PPAT(7, CHV_PPAT_SNOOP);
+
+	vgpu_vreg(vgpu, offset) = lower_32_bits(pat);
+
+	return 0;
+}
+
 static int mmio_read_from_hw(struct intel_vgpu *vgpu,
 		unsigned int offset, void *p_data, unsigned int bytes)
 {
@@ -2778,7 +2806,7 @@ static int init_broadwell_mmio_info(struct intel_gvt *gvt)
 
 	MMIO_DH(GEN6_PCODE_MAILBOX, D_BDW_PLUS, NULL, mailbox_write);
 
-	MMIO_D(GEN8_PRIVATE_PAT_LO, D_BDW_PLUS);
+	MMIO_D(GEN8_PRIVATE_PAT_LO, D_BDW_PLUS & ~D_BXT);
 	MMIO_D(GEN8_PRIVATE_PAT_HI, D_BDW_PLUS);
 
 	MMIO_D(GAMTARBMODE, D_BDW_PLUS);
@@ -3281,6 +3309,8 @@ static int init_bxt_mmio_info(struct intel_gvt *gvt)
 
 	MMIO_DFH(GEN9_CTX_PREEMPT_REG, D_BXT, F_CMD_ACCESS, NULL, NULL);
 
+	MMIO_DH(GEN8_PRIVATE_PAT_LO, D_BXT, NULL, bxt_ppat_low_write);
+
 	return 0;
 }
 
-- 
2.30.2

