Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FED4341C3C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCSMTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhCSMTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E33364E6B;
        Fri, 19 Mar 2021 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156363;
        bh=Dk2akdAyehQzLPtvPO7ohpc+uPI1Copa/D5oJnk0Mxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHCNOws9axN2oNE2Gjuqf5rbY1buFHmh41qv1lcG3TFGUA5WQ9cA+e7uPxNwakhdl
         qTTy7VkQjpCyWISs9LxQirGYBD2TxLHfb89GmumOgCGWt4NQk9WfW8W6EqpovS+fti
         3SHRJoYorXDTNdIvMickO4XAr2K8RfW5E2Me7H4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.4 08/18] drm/i915/gvt: Set SNOOP for PAT3 on BXT/APL to workaround GPU BB hang
Date:   Fri, 19 Mar 2021 13:18:46 +0100
Message-Id: <20210319121745.739135496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -1632,6 +1632,34 @@ static int edp_psr_imr_iir_write(struct
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
@@ -2778,7 +2806,7 @@ static int init_broadwell_mmio_info(stru
 
 	MMIO_DH(GEN6_PCODE_MAILBOX, D_BDW_PLUS, NULL, mailbox_write);
 
-	MMIO_D(GEN8_PRIVATE_PAT_LO, D_BDW_PLUS);
+	MMIO_D(GEN8_PRIVATE_PAT_LO, D_BDW_PLUS & ~D_BXT);
 	MMIO_D(GEN8_PRIVATE_PAT_HI, D_BDW_PLUS);
 
 	MMIO_D(GAMTARBMODE, D_BDW_PLUS);
@@ -3281,6 +3309,8 @@ static int init_bxt_mmio_info(struct int
 
 	MMIO_DFH(GEN9_CTX_PREEMPT_REG, D_BXT, F_CMD_ACCESS, NULL, NULL);
 
+	MMIO_DH(GEN8_PRIVATE_PAT_LO, D_BXT, NULL, bxt_ppat_low_write);
+
 	return 0;
 }
 


