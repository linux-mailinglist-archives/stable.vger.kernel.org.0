Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F4566B72
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiGEMGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiGEMF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C505418E3E;
        Tue,  5 Jul 2022 05:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56CF461806;
        Tue,  5 Jul 2022 12:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EC2C341C7;
        Tue,  5 Jul 2022 12:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022714;
        bh=XqE9c5jeIO8PhFmnmhzW9vcEqEU/9Q+JgXFOCaQYJAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yG/4VHjj84qKbP4AJE0TfK5+PCPURSmc3/kCohHCjPmW+6zj5AZQHZe9pGzFdljJB
         ojjhiA+Wip67FrLHHF4YSNzV2VPfdruUdYGMRhu1fdMfUWF/iE2PEgVzymegZxwLFY
         UylG4WLOOpw5BrwDstnA6u1t72e1ROd9rjcSPQRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 43/58] selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store
Date:   Tue,  5 Jul 2022 13:58:19 +0200
Message-Id: <20220705115611.510013146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit de6b52a21420a18dc8a36438d581efd1313d5fe3 upstream.

Building the rseq basic test  with
gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.12)
Target: powerpc-linux-gnu

leads to these errors:

/tmp/ccieEWxU.s: Assembler messages:
/tmp/ccieEWxU.s:118: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:118: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:121: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:121: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:626: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:626: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:629: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:629: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:735: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:735: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:738: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:738: Error: junk at end of line: `,8'
/tmp/ccieEWxU.s:741: Error: syntax error; found `,', expected `('
/tmp/ccieEWxU.s:741: Error: junk at end of line: `,8'
Makefile:581: recipe for target 'basic_percpu_ops_test.o' failed

Based on discussion with Linux powerpc maintainers and review of
the use of the "m" operand in powerpc kernel code, add the missing
%Un%Xn (where n is operand number) to the lwz, stw, ld, and std
instructions when used with "m" operands.

Using "WORD" to mean either a 32-bit or 64-bit type depending on
the architecture is misleading. The term "WORD" really means a
32-bit type in both 32-bit and 64-bit powerpc assembler. The intent
here is to wrap load/store to intptr_t into common macros for both
32-bit and 64-bit.

Rename the macros with a RSEQ_ prefix, and use the terms "INT"
for always 32-bit type, and "LONG" for architecture bitness-sized
type.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-10-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-ppc.h |   55 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -47,10 +47,13 @@ do {									\
 
 #ifdef __PPC64__
 
-#define STORE_WORD	"std "
-#define LOAD_WORD	"ld "
-#define LOADX_WORD	"ldx "
-#define CMP_WORD	"cmpd "
+#define RSEQ_STORE_LONG(arg)	"std%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_STORE_INT(arg)	"stw%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_LOAD_LONG(arg)	"ld%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOAD_INT(arg)	"lwz%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOADX_LONG		"ldx "							/* From base register ("b" constraint) */
+#define RSEQ_CMP_LONG		"cmpd "
+#define RSEQ_CMP_LONG_INT	"cmpdi "
 
 #define __RSEQ_ASM_DEFINE_TABLE(label, version, flags,				\
 			start_ip, post_commit_offset, abort_ip)			\
@@ -89,10 +92,13 @@ do {									\
 
 #else /* #ifdef __PPC64__ */
 
-#define STORE_WORD	"stw "
-#define LOAD_WORD	"lwz "
-#define LOADX_WORD	"lwzx "
-#define CMP_WORD	"cmpw "
+#define RSEQ_STORE_LONG(arg)	"stw%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* To memory ("m" constraint) */
+#define RSEQ_STORE_INT(arg)	RSEQ_STORE_LONG(arg)					/* To memory ("m" constraint) */
+#define RSEQ_LOAD_LONG(arg)	"lwz%U[" __rseq_str(arg) "]%X[" __rseq_str(arg) "] "	/* From memory ("m" constraint) */
+#define RSEQ_LOAD_INT(arg)	RSEQ_LOAD_LONG(arg)					/* From memory ("m" constraint) */
+#define RSEQ_LOADX_LONG		"lwzx "							/* From base register ("b" constraint) */
+#define RSEQ_CMP_LONG		"cmpw "
+#define RSEQ_CMP_LONG_INT	"cmpwi "
 
 #define __RSEQ_ASM_DEFINE_TABLE(label, version, flags,				\
 			start_ip, post_commit_offset, abort_ip)			\
@@ -125,7 +131,7 @@ do {									\
 		RSEQ_INJECT_ASM(1)						\
 		"lis %%r17, (" __rseq_str(cs_label) ")@ha\n\t"			\
 		"addi %%r17, %%r17, (" __rseq_str(cs_label) ")@l\n\t"		\
-		"stw %%r17, %[" __rseq_str(rseq_cs) "]\n\t"			\
+		RSEQ_STORE_INT(rseq_cs) "%%r17, %[" __rseq_str(rseq_cs) "]\n\t"	\
 		__rseq_str(label) ":\n\t"
 
 #endif /* #ifdef __PPC64__ */
@@ -136,7 +142,7 @@ do {									\
 
 #define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)			\
 		RSEQ_INJECT_ASM(2)						\
-		"lwz %%r17, %[" __rseq_str(current_cpu_id) "]\n\t"		\
+		RSEQ_LOAD_INT(current_cpu_id) "%%r17, %[" __rseq_str(current_cpu_id) "]\n\t" \
 		"cmpw cr7, %[" __rseq_str(cpu_id) "], %%r17\n\t"		\
 		"bne- cr7, " __rseq_str(label) "\n\t"
 
@@ -153,25 +159,25 @@ do {									\
  * 	RSEQ_ASM_OP_* (else): doesn't have hard-code registers(unless cr7)
  */
 #define RSEQ_ASM_OP_CMPEQ(var, expect, label)					\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
-		CMP_WORD "cr7, %%r17, %[" __rseq_str(expect) "]\n\t"		\
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"		\
+		RSEQ_CMP_LONG "cr7, %%r17, %[" __rseq_str(expect) "]\n\t"		\
 		"bne- cr7, " __rseq_str(label) "\n\t"
 
 #define RSEQ_ASM_OP_CMPNE(var, expectnot, label)				\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
-		CMP_WORD "cr7, %%r17, %[" __rseq_str(expectnot) "]\n\t"		\
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"		\
+		RSEQ_CMP_LONG "cr7, %%r17, %[" __rseq_str(expectnot) "]\n\t"		\
 		"beq- cr7, " __rseq_str(label) "\n\t"
 
 #define RSEQ_ASM_OP_STORE(value, var)						\
-		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"
+		RSEQ_STORE_LONG(var) "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"
 
 /* Load @var to r17 */
 #define RSEQ_ASM_OP_R_LOAD(var)							\
-		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+		RSEQ_LOAD_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"
 
 /* Store r17 to @var */
 #define RSEQ_ASM_OP_R_STORE(var)						\
-		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+		RSEQ_STORE_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"
 
 /* Add @count to r17 */
 #define RSEQ_ASM_OP_R_ADD(count)						\
@@ -179,11 +185,11 @@ do {									\
 
 /* Load (r17 + voffp) to r17 */
 #define RSEQ_ASM_OP_R_LOADX(voffp)						\
-		LOADX_WORD "%%r17, %[" __rseq_str(voffp) "], %%r17\n\t"
+		RSEQ_LOADX_LONG "%%r17, %[" __rseq_str(voffp) "], %%r17\n\t"
 
 /* TODO: implement a faster memcpy. */
 #define RSEQ_ASM_OP_R_MEMCPY() \
-		"cmpdi %%r19, 0\n\t" \
+		RSEQ_CMP_LONG_INT "%%r19, 0\n\t" \
 		"beq 333f\n\t" \
 		"addi %%r20, %%r20, -1\n\t" \
 		"addi %%r21, %%r21, -1\n\t" \
@@ -191,16 +197,16 @@ do {									\
 		"lbzu %%r18, 1(%%r20)\n\t" \
 		"stbu %%r18, 1(%%r21)\n\t" \
 		"addi %%r19, %%r19, -1\n\t" \
-		"cmpdi %%r19, 0\n\t" \
+		RSEQ_CMP_LONG_INT "%%r19, 0\n\t" \
 		"bne 222b\n\t" \
 		"333:\n\t" \
 
 #define RSEQ_ASM_OP_R_FINAL_STORE(var, post_commit_label)			\
-		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
+		RSEQ_STORE_LONG(var) "%%r17, %[" __rseq_str(var) "]\n\t"			\
 		__rseq_str(post_commit_label) ":\n\t"
 
 #define RSEQ_ASM_OP_FINAL_STORE(value, var, post_commit_label)			\
-		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t" \
+		RSEQ_STORE_LONG(var) "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t" \
 		__rseq_str(post_commit_label) ":\n\t"
 
 static inline __attribute__((always_inline))
@@ -743,9 +749,4 @@ error2:
 #endif
 }
 
-#undef STORE_WORD
-#undef LOAD_WORD
-#undef LOADX_WORD
-#undef CMP_WORD
-
 #endif /* !RSEQ_SKIP_FASTPATH */


