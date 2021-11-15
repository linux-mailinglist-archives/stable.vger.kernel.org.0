Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897AB450302
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhKOLER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:04:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237744AbhKOLD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:03:59 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAXEmV029413;
        Mon, 15 Nov 2021 11:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Sa1iesFvF6QruRW0mPj77LEK4G566ljltlmBHbQHeII=;
 b=DiPopcfZdDiedN3+unmZ0mC1NBlDGphHtSTWG3rY+QXG+yYgxc2/3+B0chNXbs2byWBi
 xWgR6WtWsGZyFdmsOld9Z50Asx756RqRRkqNpbPJ6VybcOx18N9JWRCDZ5P6bVsVN5E0
 5HPbxpA2UVH9EzOXS6/QVTc0duW0GLUMl5ElN0ERXzXfKOz5jCwIs5Cq1qb6RDKzB2lS
 0oUV1A40zV8+bHYuUm5blY0+SsvZHV/pLdIxvgDmR6w7UmksEzddk55P+v5+Kz3AGK/I
 Qt8nBiSa+tcjwBz1sUXwRdWnEJjYDRERUmdSjQDaEP4BemDJoQWwV6t7jynzCFxEOyki Hw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbkd4uqw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAw2pw023986;
        Mon, 15 Nov 2021 11:00:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ca509kv6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB0itc38601040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:00:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30C645207B;
        Mon, 15 Nov 2021 11:00:44 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0CFF352054;
        Mon, 15 Nov 2021 11:00:42 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.9 1/2] powerpc/bpf: Validate branch ranges
Date:   Mon, 15 Nov 2021 16:30:36 +0530
Message-Id: <a3eff0df543b26ce416086b0a893cc729a94799b.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: thxHV5y3So-lUdJ4FFP_VlrqVd8xvXRE
X-Proofpoint-GUID: thxHV5y3So-lUdJ4FFP_VlrqVd8xvXRE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150057
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 3832ba4e283d7052b783dab8311df7e3590fed93

Add checks to ensure that we never emit branch instructions with
truncated branch offsets.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/71d33a6b7603ec1013c9734dd8bdd4ff5e929142.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[expand is_offset_in_[cond_]branch_range() helpers, drop ppc32 changes]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/net/bpf_jit.h        | 25 +++++++++++++++++++------
 arch/powerpc/net/bpf_jit_comp64.c | 10 +++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 83e5b255d1423e..89e61b109c17fa 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -177,13 +177,26 @@
 #define PPC_NEG(d, a)		EMIT(PPC_INST_NEG | ___PPC_RT(d) | ___PPC_RA(a))
 
 /* Long jump; (unconditional 'branch') */
-#define PPC_JMP(dest)		EMIT(PPC_INST_BRANCH |			      \
-				     (((dest) - (ctx->idx * 4)) & 0x03fffffc))
+#define PPC_JMP(dest)							      \
+	do {								      \
+		long offset = (long)(dest) - (ctx->idx * 4);		      \
+		if (offset < -0x2000000 || offset > 0x1fffffc || offset & 0x3) {						\
+			pr_err_ratelimited("Branch offset 0x%lx (@%u) out of range\n", offset, ctx->idx);			\
+			return -ERANGE;					      \
+		}							      \
+		EMIT(PPC_INST_BRANCH | (offset & 0x03fffffc));		      \
+	} while (0)
 /* "cond" here covers BO:BI fields. */
-#define PPC_BCC_SHORT(cond, dest)	EMIT(PPC_INST_BRANCH_COND |	      \
-					     (((cond) & 0x3ff) << 16) |	      \
-					     (((dest) - (ctx->idx * 4)) &     \
-					      0xfffc))
+#define PPC_BCC_SHORT(cond, dest)					      \
+	do {								      \
+		long offset = (long)(dest) - (ctx->idx * 4);		      \
+		if (offset < -0x8000 || offset > 0x7fff || offset & 0x3) {							\
+			pr_err_ratelimited("Conditional branch offset 0x%lx (@%u) out of range\n", offset, ctx->idx);		\
+			return -ERANGE;					      \
+		}							      \
+		EMIT(PPC_INST_BRANCH_COND | (((cond) & 0x3ff) << 16) | (offset & 0xfffc));					\
+	} while (0)
+
 /* Sign-extended 32-bit immediate load */
 #define PPC_LI32(d, i)		do {					      \
 		if ((int)(uintptr_t)(i) >= -32768 &&			      \
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index e08e55cd98e6f5..3f867e79dfaa75 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -239,7 +239,7 @@ static void bpf_jit_emit_func_call(u32 *image, struct codegen_context *ctx, u64
 	PPC_BLRL();
 }
 
-static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
+static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
 {
 	/*
 	 * By now, the eBPF program has already setup parameters in r3, r4 and r5
@@ -300,7 +300,9 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	bpf_jit_emit_common_epilogue(image, ctx);
 
 	PPC_BCTR();
+
 	/* out: */
+	return 0;
 }
 
 /* Assemble the body code between the prologue & epilogue */
@@ -310,7 +312,7 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
-	int i;
+	int i, ret;
 
 	/* Start of epilogue code - will only be valid 2nd pass onwards */
 	u32 exit_addr = addrs[flen];
@@ -938,7 +940,9 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 */
 		case BPF_JMP | BPF_CALL | BPF_X:
 			ctx->seen |= SEEN_TAILCALL;
-			bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			ret = bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			if (ret < 0)
+				return ret;
 			break;
 
 		default:
-- 
2.33.1

