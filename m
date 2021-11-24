Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09A345BDF5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344778AbhKXMmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343594AbhKXMke (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:40:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0A761108;
        Wed, 24 Nov 2021 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756653;
        bh=RhUe3Z3K507WXCYyd0IF+vWIPOjBvl1LDXH9JIf+mHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfBooNyVH+riO4Ll/7/LGjh70kvjy76vpvs9aAP/pk6ZHYrJsLhOQ9qNb9E4oNmiS
         FVqBkFwK4bt1DdQFUy+q6Ob/oe16dydukffifrbZqKcfmFtkfcEFsxxRll1wGe7DYx
         0Z76nibXdZbFM9UGydG9IjIxd7ztE/euzkU7mlDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/251] mips: cm: Convert to bitfield API to fix out-of-bounds access
Date:   Wed, 24 Nov 2021 12:56:40 +0100
Message-Id: <20211124115715.761906108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 18b8f5b6fc53d097cadb94a93d8d6566ba88e389 ]

mips_cm_error_report() extracts the cause and other cause from the error
register using shifts.  This works fine for the former, as it is stored
in the top bits, and the shift will thus remove all non-related bits.
However, the latter is stored in the bottom bits, hence thus needs masking
to get rid of non-related bits.  Without such masking, using it as an
index into the cm2_causes[] array will lead to an out-of-bounds access,
probably causing a crash.

Fix this by using FIELD_GET() instead.  Bite the bullet and convert all
MIPS CM handling to the bitfield API, to improve readability and safety.

Fixes: 3885c2b463f6a236 ("MIPS: CM: Add support for reporting CM cache errors")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mips-cm.h | 12 ++++++------
 arch/mips/kernel/mips-cm.c      | 21 ++++++++++-----------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/mips/include/asm/mips-cm.h b/arch/mips/include/asm/mips-cm.h
index 8bc5df49b0e1d..890e51b159e06 100644
--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -15,6 +15,7 @@
 #ifndef __MIPS_ASM_MIPS_CM_H__
 #define __MIPS_ASM_MIPS_CM_H__
 
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
 
@@ -157,8 +158,8 @@ GCR_ACCESSOR_RO(32, 0x030, rev)
 #define CM_GCR_REV_MINOR			GENMASK(7, 0)
 
 #define CM_ENCODE_REV(major, minor) \
-		(((major) << __ffs(CM_GCR_REV_MAJOR)) | \
-		 ((minor) << __ffs(CM_GCR_REV_MINOR)))
+		(FIELD_PREP(CM_GCR_REV_MAJOR, major) | \
+		 FIELD_PREP(CM_GCR_REV_MINOR, minor))
 
 #define CM_REV_CM2				CM_ENCODE_REV(6, 0)
 #define CM_REV_CM2_5				CM_ENCODE_REV(7, 0)
@@ -366,10 +367,10 @@ static inline int mips_cm_revision(void)
 static inline unsigned int mips_cm_max_vp_width(void)
 {
 	extern int smp_num_siblings;
-	uint32_t cfg;
 
 	if (mips_cm_revision() >= CM_REV_CM3)
-		return read_gcr_sys_config2() & CM_GCR_SYS_CONFIG2_MAXVPW;
+		return FIELD_GET(CM_GCR_SYS_CONFIG2_MAXVPW,
+				 read_gcr_sys_config2());
 
 	if (mips_cm_present()) {
 		/*
@@ -377,8 +378,7 @@ static inline unsigned int mips_cm_max_vp_width(void)
 		 * number of VP(E)s, and if that ever changes then this will
 		 * need revisiting.
 		 */
-		cfg = read_gcr_cl_config() & CM_GCR_Cx_CONFIG_PVPE;
-		return (cfg >> __ffs(CM_GCR_Cx_CONFIG_PVPE)) + 1;
+		return FIELD_GET(CM_GCR_Cx_CONFIG_PVPE, read_gcr_cl_config()) + 1;
 	}
 
 	if (IS_ENABLED(CONFIG_SMP))
diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index 50d3d74001cbe..51cfcb44e6703 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -183,8 +183,7 @@ static void mips_cm_probe_l2sync(void)
 	phys_addr_t addr;
 
 	/* L2-only sync was introduced with CM major revision 6 */
-	major_rev = (read_gcr_rev() & CM_GCR_REV_MAJOR) >>
-		__ffs(CM_GCR_REV_MAJOR);
+	major_rev = FIELD_GET(CM_GCR_REV_MAJOR, read_gcr_rev());
 	if (major_rev < 6)
 		return;
 
@@ -267,13 +266,13 @@ void mips_cm_lock_other(unsigned int cluster, unsigned int core,
 	preempt_disable();
 
 	if (cm_rev >= CM_REV_CM3) {
-		val = core << __ffs(CM3_GCR_Cx_OTHER_CORE);
-		val |= vp << __ffs(CM3_GCR_Cx_OTHER_VP);
+		val = FIELD_PREP(CM3_GCR_Cx_OTHER_CORE, core) |
+		      FIELD_PREP(CM3_GCR_Cx_OTHER_VP, vp);
 
 		if (cm_rev >= CM_REV_CM3_5) {
 			val |= CM_GCR_Cx_OTHER_CLUSTER_EN;
-			val |= cluster << __ffs(CM_GCR_Cx_OTHER_CLUSTER);
-			val |= block << __ffs(CM_GCR_Cx_OTHER_BLOCK);
+			val |= FIELD_PREP(CM_GCR_Cx_OTHER_CLUSTER, cluster);
+			val |= FIELD_PREP(CM_GCR_Cx_OTHER_BLOCK, block);
 		} else {
 			WARN_ON(cluster != 0);
 			WARN_ON(block != CM_GCR_Cx_OTHER_BLOCK_LOCAL);
@@ -303,7 +302,7 @@ void mips_cm_lock_other(unsigned int cluster, unsigned int core,
 		spin_lock_irqsave(&per_cpu(cm_core_lock, curr_core),
 				  per_cpu(cm_core_lock_flags, curr_core));
 
-		val = core << __ffs(CM_GCR_Cx_OTHER_CORENUM);
+		val = FIELD_PREP(CM_GCR_Cx_OTHER_CORENUM, core);
 	}
 
 	write_gcr_cl_other(val);
@@ -347,8 +346,8 @@ void mips_cm_error_report(void)
 	cm_other = read_gcr_error_mult();
 
 	if (revision < CM_REV_CM3) { /* CM2 */
-		cause = cm_error >> __ffs(CM_GCR_ERROR_CAUSE_ERRTYPE);
-		ocause = cm_other >> __ffs(CM_GCR_ERROR_MULT_ERR2ND);
+		cause = FIELD_GET(CM_GCR_ERROR_CAUSE_ERRTYPE, cm_error);
+		ocause = FIELD_GET(CM_GCR_ERROR_MULT_ERR2ND, cm_other);
 
 		if (!cause)
 			return;
@@ -390,8 +389,8 @@ void mips_cm_error_report(void)
 		ulong core_id_bits, vp_id_bits, cmd_bits, cmd_group_bits;
 		ulong cm3_cca_bits, mcp_bits, cm3_tr_bits, sched_bit;
 
-		cause = cm_error >> __ffs64(CM3_GCR_ERROR_CAUSE_ERRTYPE);
-		ocause = cm_other >> __ffs(CM_GCR_ERROR_MULT_ERR2ND);
+		cause = FIELD_GET(CM3_GCR_ERROR_CAUSE_ERRTYPE, cm_error);
+		ocause = FIELD_GET(CM_GCR_ERROR_MULT_ERR2ND, cm_other);
 
 		if (!cause)
 			return;
-- 
2.33.0



