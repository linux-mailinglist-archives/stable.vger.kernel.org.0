Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0145032E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKOLLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:11:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237731AbhKOLJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:09:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFATZAN023870;
        Mon, 15 Nov 2021 11:06:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=5WVTLPsYaSjoTDXxjFEKRx7htfVF7ZLLRODLAUs7pM0=;
 b=s3JS+2fy+a2eDn2dTHUVdbzYC2WlQ03yoJoRu9Bqt7PceLo30g4Mzz/iU9TaNhMegwID
 2h14+nODlDAnBazx91NwsJSCQgyeoPdLI0fLkosW/GLB0XY3CXc4T3YRkrnvhrTrpG3P
 2r2zv3pmTNiKievNMe688mZvV9+ohiH2mZX3vfEfD/+85OLYCTo63EfJFkUj18PiWbC2
 p2rDrKbv2smpTMj4xZ5Z7fbJ5Y/ZTKlUSu4t07CKl4SmKpCpt0f842pxDy5whPzGEpvc
 00AM/1sDyq5yLePxw3p9mAaycf1L1fzql7fnPJisiKkm9nHgweQI26Pq0ZFbDpA3DUJo vQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbnujrq85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB32b8002677;
        Mon, 15 Nov 2021 11:06:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3ca4mjcn4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB6fb765143194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:06:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E06CA406F;
        Mon, 15 Nov 2021 11:06:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 360D5A4080;
        Mon, 15 Nov 2021 11:06:40 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:06:39 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 4/4] powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC
Date:   Mon, 15 Nov 2021 16:36:30 +0530
Message-Id: <652222f2afd7dd5876a87e079c1c4b2530c3572c.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mKasWCFQ4ed7omwz2U_LSFul1SjO5B8o
X-Proofpoint-GUID: mKasWCFQ4ed7omwz2U_LSFul1SjO5B8o
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit b7540d62509453263604a155bf2d5f0ed450cba2

Emit similar instruction sequences to commit a048a07d7f4535
("powerpc/64s: Add support for a store forwarding barrier at kernel
entry/exit") when encountering BPF_NOSPEC.

Mitigations are enabled depending on what the firmware advertises. In
particular, we do not gate these mitigations based on current settings,
just like in x86. Due to this, we don't need to take any action if
mitigations are enabled or disabled at runtime.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/956570cbc191cd41f8274bed48ee757a86dac62a.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[adjust macros to account for commits 1c9debbc2eb539 and ef909ba954145e.
adjust security feature checks to account for commit 84ed26fd00c514]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/net/bpf_jit64.h      |  8 ++---
 arch/powerpc/net/bpf_jit_comp64.c | 56 ++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit64.h b/arch/powerpc/net/bpf_jit64.h
index 2e33c6673ff957..4d164e865b392e 100644
--- a/arch/powerpc/net/bpf_jit64.h
+++ b/arch/powerpc/net/bpf_jit64.h
@@ -16,18 +16,18 @@
  * with our redzone usage.
  *
  *		[	prev sp		] <-------------
- *		[   nv gpr save area	] 6*8		|
+ *		[   nv gpr save area	] 5*8		|
  *		[    tail_call_cnt	] 8		|
- *		[    local_tmp_var	] 8		|
+ *		[    local_tmp_var	] 16		|
  * fp (r31) -->	[   ebpf stack space	] upto 512	|
  *		[     frame header	] 32/112	|
  * sp (r1) --->	[    stack pointer	] --------------
  */
 
 /* for gpr non volatile registers BPG_REG_6 to 10 */
-#define BPF_PPC_STACK_SAVE	(6*8)
+#define BPF_PPC_STACK_SAVE	(5*8)
 /* for bpf JIT code internal usage */
-#define BPF_PPC_STACK_LOCALS	16
+#define BPF_PPC_STACK_LOCALS	24
 /* stack frame excluding BPF stack, ensure this is quadword aligned */
 #define BPF_PPC_STACKFRAME	(STACK_FRAME_MIN_SIZE + \
 				 BPF_PPC_STACK_LOCALS + BPF_PPC_STACK_SAVE)
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 803d95af275534..8936090acb5796 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -15,6 +15,7 @@
 #include <linux/if_vlan.h>
 #include <asm/kprobes.h>
 #include <linux/bpf.h>
+#include <asm/security_features.h>
 
 #include "bpf_jit64.h"
 
@@ -56,9 +57,9 @@ static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
  *		[	prev sp		] <-------------
  *		[	  ...       	] 		|
  * sp (r1) --->	[    stack pointer	] --------------
- *		[   nv gpr save area	] 6*8
+ *		[   nv gpr save area	] 5*8
  *		[    tail_call_cnt	] 8
- *		[    local_tmp_var	] 8
+ *		[    local_tmp_var	] 16
  *		[   unused red zone	] 208 bytes protected
  */
 static int bpf_jit_stack_local(struct codegen_context *ctx)
@@ -66,12 +67,12 @@ static int bpf_jit_stack_local(struct codegen_context *ctx)
 	if (bpf_has_stack_frame(ctx))
 		return STACK_FRAME_MIN_SIZE + ctx->stack_size;
 	else
-		return -(BPF_PPC_STACK_SAVE + 16);
+		return -(BPF_PPC_STACK_SAVE + 24);
 }
 
 static int bpf_jit_stack_tailcallcnt(struct codegen_context *ctx)
 {
-	return bpf_jit_stack_local(ctx) + 8;
+	return bpf_jit_stack_local(ctx) + 16;
 }
 
 static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
@@ -290,11 +291,34 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	return 0;
 }
 
+/*
+ * We spill into the redzone always, even if the bpf program has its own stackframe.
+ * Offsets hardcoded based on BPF_PPC_STACK_SAVE -- see bpf_jit_stack_local()
+ */
+void bpf_stf_barrier(void);
+
+asm (
+"		.global bpf_stf_barrier		;"
+"	bpf_stf_barrier:			;"
+"		std	21,-64(1)		;"
+"		std	22,-56(1)		;"
+"		sync				;"
+"		ld	21,-64(1)		;"
+"		ld	22,-56(1)		;"
+"		ori	31,31,0			;"
+"		.rept 14			;"
+"		b	1f			;"
+"	1:					;"
+"		.endr				;"
+"		blr				;"
+);
+
 /* Assemble the body code between the prologue & epilogue */
 static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			      struct codegen_context *ctx,
 			      u32 *addrs, bool extra_pass)
 {
+	enum stf_barrier_type stf_barrier = stf_barrier_type_get();
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
 	int i, ret;
@@ -665,6 +689,30 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 * BPF_ST NOSPEC (speculation barrier)
 		 */
 		case BPF_ST | BPF_NOSPEC:
+			if (!security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) ||
+					(!security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR) &&
+					 (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) || !cpu_has_feature(CPU_FTR_HVMODE))))
+				break;
+
+			switch (stf_barrier) {
+			case STF_BARRIER_EIEIO:
+				EMIT(0x7c0006ac | 0x02000000);
+				break;
+			case STF_BARRIER_SYNC_ORI:
+				EMIT(PPC_INST_SYNC);
+				EMIT(PPC_RAW_LD(b2p[TMP_REG_1], 13, 0));
+				EMIT(PPC_RAW_ORI(31, 31, 0));
+				break;
+			case STF_BARRIER_FALLBACK:
+				EMIT(PPC_INST_MFLR | ___PPC_RT(b2p[TMP_REG_1]));
+				PPC_LI64(12, dereference_kernel_function_descriptor(bpf_stf_barrier));
+				EMIT(PPC_RAW_MTCTR(12));
+				EMIT(PPC_INST_BCTR | 0x1);
+				EMIT(PPC_RAW_MTLR(b2p[TMP_REG_1]));
+				break;
+			case STF_BARRIER_NONE:
+				break;
+			}
 			break;
 
 		/*
-- 
2.33.1

