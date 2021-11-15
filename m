Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42E450315
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhKOLJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52688 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237752AbhKOLIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:53 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAK8br040263;
        Mon, 15 Nov 2021 11:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Ee+4RAjkV0wACdhS07BvIAeNfPqYKJtQaU7zSkmYxTE=;
 b=h5FSWhcGHlir+2RgHxf+uCERG3XRQeqDlPv9KPKxbTD394IvEJ1JKzCWIkFnnvqdOSvL
 Fx68UCtGyVKpI26H8Xgujh0FvG7JTVYAsexNVYw5gMcgTKPY/KaAjO+73PV/flScfZRd
 j5yyiCA+qCsma1enQ01MvD1FhQYqZMESPO1UTdzJWVxbB/Jb6qw7zFM2hhbdXY6fjlNS
 Lpq0amtCA+xun2ZvXQPYAIAzItH3BaPuj37TaV3CN+X0LR0XPJwqiDVQMz02HSNvmhAQ
 mzMHypJU07LvoXgC6zBVt7LmUJN2MMm2oqg2aVpUP9/37u/A6dvmwYjdisQY3S/XagZA tw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbggkfncu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:44 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB3gNL024546;
        Mon, 15 Nov 2021 11:05:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ca50buvy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5epl62128548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B94BCA407C;
        Mon, 15 Nov 2021 11:05:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88E24A406F;
        Mon, 15 Nov 2021 11:05:39 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:39 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 2/5] powerpc/bpf: Validate branch ranges
Date:   Mon, 15 Nov 2021 16:35:29 +0530
Message-Id: <cc064b884ea7bb5f2f07147589c8a46addd6ed0d.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C8XI1qa6iXWnkKeLvh6ZJoqDnEGTnXMO
X-Proofpoint-ORIG-GUID: C8XI1qa6iXWnkKeLvh6ZJoqDnEGTnXMO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
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
[include header, drop ppc32 changes]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/net/bpf_jit.h        | 26 ++++++++++++++++++++------
 arch/powerpc/net/bpf_jit_comp64.c | 10 +++++++---
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index d2bf99183aab86..5a0af7d8d22422 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -15,6 +15,7 @@
 #ifndef __ASSEMBLY__
 
 #include <asm/types.h>
+#include <asm/code-patching.h>
 
 #ifdef PPC64_ELF_ABI_v1
 #define FUNCTION_DESCR_SIZE	24
@@ -176,13 +177,26 @@
 #define PPC_NEG(d, a)		EMIT(PPC_INST_NEG | ___PPC_RT(d) | ___PPC_RA(a))
 
 /* Long jump; (unconditional 'branch') */
-#define PPC_JMP(dest)		EMIT(PPC_INST_BRANCH |			      \
-				     (((dest) - (ctx->idx * 4)) & 0x03fffffc))
+#define PPC_JMP(dest)							      \
+	do {								      \
+		long offset = (long)(dest) - (ctx->idx * 4);		      \
+		if (!is_offset_in_branch_range(offset)) {		      \
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
+		if (!is_offset_in_cond_branch_range(offset)) {		      \
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
index 87213a1bb14cac..b0abf59cc6a27d 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -202,7 +202,7 @@ static void bpf_jit_emit_func_call(u32 *image, struct codegen_context *ctx, u64
 	PPC_BLRL();
 }
 
-static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
+static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
 {
 	/*
 	 * By now, the eBPF program has already setup parameters in r3, r4 and r5
@@ -263,7 +263,9 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	bpf_jit_emit_common_epilogue(image, ctx);
 
 	PPC_BCTR();
+
 	/* out: */
+	return 0;
 }
 
 /* Assemble the body code between the prologue & epilogue */
@@ -273,7 +275,7 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
-	int i;
+	int i, ret;
 
 	/* Start of epilogue code - will only be valid 2nd pass onwards */
 	u32 exit_addr = addrs[flen];
@@ -863,7 +865,9 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 */
 		case BPF_JMP | BPF_TAIL_CALL:
 			ctx->seen |= SEEN_TAILCALL;
-			bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			ret = bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			if (ret < 0)
+				return ret;
 			break;
 
 		default:
-- 
2.33.1

