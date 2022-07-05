Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5A566C50
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiGEMNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbiGEMMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5818D193D7;
        Tue,  5 Jul 2022 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA66361876;
        Tue,  5 Jul 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C0C385A9;
        Tue,  5 Jul 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023017;
        bh=yyv1QTRD/fdO+KwqBJmek/GYW6ehA2VMIbs+g6ANEwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nC/cb2cmlkuWMoiKshld1kBzPgyvrfjFwW9q+3PMF74XwdNkpqsB0royrsHi0sGLM
         ilA2PQHPRlncZJkSxnHXCN9JvpJuAgwlUMDG1JESINSEfJAxx9hIDHEKiElBCU9Vmo
         lXvcHFlBLoYBNyjombVqlaj9CoTSNDUW3h7JQss8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 74/84] selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area
Date:   Tue,  5 Jul 2022 13:58:37 +0200
Message-Id: <20220705115617.482200151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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

commit 127b6429d235ab7c358223bbfd8a8b8d8cc799b6 upstream.

Rather than use rseq_get_abi() and pass its result through a register to
the inline assembler, directly access the per-thread rseq area through a
memory reference combining the %gs segment selector, the constant offset
of the field in struct rseq, and the rseq_offset value (in a register).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-16-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-x86.h |   66 ++++++++++++++++----------------
 1 file changed, 34 insertions(+), 32 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -633,6 +633,8 @@ int rseq_cmpeqv_trymemcpy_storev_release
 
 #elif defined(__i386__)
 
+#define RSEQ_ASM_TP_SEGMENT	%%gs
+
 #define rseq_smp_mb()	\
 	__asm__ __volatile__ ("lock; addl $0,-128(%%esp)" ::: "memory", "cc")
 #define rseq_smp_rmb()	\
@@ -732,14 +734,14 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -750,7 +752,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -798,15 +800,15 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[v], %%ebx\n\t"
 		"cmpl %%ebx, %[expectnot]\n\t"
 		"je %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"movl %[v], %%ebx\n\t"
 		"cmpl %%ebx, %[expectnot]\n\t"
 		"je %l[error2]\n\t"
@@ -821,7 +823,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -864,11 +866,11 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error1])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 #endif
 		/* final store */
 		"addl %[count], %[v]\n\t"
@@ -877,7 +879,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"ir" (count)
@@ -916,14 +918,14 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 #endif
@@ -938,7 +940,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"m" (newv2),
@@ -987,15 +989,15 @@ int rseq_cmpeqv_trystorev_storev_release
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error2])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %[v], %%eax\n\t"
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"movl %[expect], %%eax\n\t"
 		"cmpl %[v], %%eax\n\t"
 		"jnz %l[error2]\n\t"
@@ -1011,7 +1013,7 @@ int rseq_cmpeqv_trystorev_storev_release
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -1062,8 +1064,8 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error3])
 #endif
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[cmpfail]\n\t"
@@ -1072,7 +1074,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		"jnz %l[cmpfail]\n\t"
 		RSEQ_INJECT_ASM(5)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), %l[error1])
 		"cmpl %[v], %[expect]\n\t"
 		"jnz %l[error2]\n\t"
 		"cmpl %[expect2], %[v2]\n\t"
@@ -1086,7 +1088,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -1144,15 +1146,15 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		"movl %[dst], %[rseq_scratch1]\n\t"
 		"movl %[len], %[rseq_scratch2]\n\t"
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 5f\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 6f)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 6f)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 7f\n\t"
@@ -1202,7 +1204,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"m" (expect),
@@ -1261,15 +1263,15 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		"movl %[dst], %[rseq_scratch1]\n\t"
 		"movl %[len], %[rseq_scratch2]\n\t"
 		/* Start rseq by storing table entry pointer into rseq_cs. */
-		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_ASM_TP_SEGMENT:RSEQ_CS_OFFSET(%[rseq_offset]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 4f)
 		RSEQ_INJECT_ASM(3)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 5f\n\t"
 		RSEQ_INJECT_ASM(4)
 #ifdef RSEQ_COMPARE_TWICE
-		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 6f)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_ASM_TP_SEGMENT:RSEQ_CPU_ID_OFFSET(%[rseq_offset]), 6f)
 		"movl %[expect], %%eax\n\t"
 		"cmpl %%eax, %[v]\n\t"
 		"jnz 7f\n\t"
@@ -1320,7 +1322,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_abi]		"r" (rseq_get_abi()),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"m" (expect),


