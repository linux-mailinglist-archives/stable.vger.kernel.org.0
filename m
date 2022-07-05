Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76005566C0B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiGEMKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbiGEMJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34347186FB;
        Tue,  5 Jul 2022 05:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B60F8617B1;
        Tue,  5 Jul 2022 12:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9176EC341C7;
        Tue,  5 Jul 2022 12:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022966;
        bh=vNhVnI9d0jwzfUiVzH7UAXhDhkUSrvox9ojw7yW7HGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvS4FShYvO33nZXZZ/++3+H8vv67wplui/fZ/kPEmCBAs8SsWk/sS7b3Aw7rGu6eN
         8AhIZJIxJiSlLsaqVgyfaO6HTj+pbkhX1aFhZHBimeXeVPq71LzVWuRSbmAGAHngpl
         32sik1EnxCGBGG9UthhH63v6o8BtOw9Sp3MSKbxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 72/84] selftests/rseq: Fix: work-around asm goto compiler bugs
Date:   Tue,  5 Jul 2022 13:58:35 +0200
Message-Id: <20220705115617.424540357@linuxfoundation.org>
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

commit b53823fb2ef854222853be164f3b1e815f315144 upstream.

gcc and clang each have their own compiler bugs with respect to asm
goto. Implement a work-around for compiler versions known to have those
bugs.

gcc prior to 4.8.2 miscompiles asm goto.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670

gcc prior to 8.1.0 miscompiles asm goto at O1.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103908

clang prior to version 13.0.1 miscompiles asm goto at O2.
https://github.com/llvm/llvm-project/issues/52735

Work around these issues by adding a volatile inline asm with
memory clobber in the fallthrough after the asm goto and at each
label target.  Emit this for all compilers in case other similar
issues are found in the future.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-14-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/compiler.h   |   30 +++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h   |   39 +++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm64.h |   45 +++++++++++++++++--
 tools/testing/selftests/rseq/rseq-ppc.h   |   39 +++++++++++++++++
 tools/testing/selftests/rseq/rseq-s390.h  |   29 ++++++++++++
 tools/testing/selftests/rseq/rseq-x86.h   |   68 ++++++++++++++++++++++++++++++
 tools/testing/selftests/rseq/rseq.h       |    1 
 7 files changed, 245 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/rseq/compiler.h

--- /dev/null
+++ b/tools/testing/selftests/rseq/compiler.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1-only OR MIT */
+/*
+ * rseq/compiler.h
+ *
+ * Work-around asm goto compiler bugs.
+ *
+ * (C) Copyright 2021 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef RSEQ_COMPILER_H
+#define RSEQ_COMPILER_H
+
+/*
+ * gcc prior to 4.8.2 miscompiles asm goto.
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * gcc prior to 8.1.0 miscompiles asm goto at O1.
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103908
+ *
+ * clang prior to version 13.0.1 miscompiles asm goto at O2.
+ * https://github.com/llvm/llvm-project/issues/52735
+ *
+ * Work around these issues by adding a volatile inline asm with
+ * memory clobber in the fallthrough after the asm goto and at each
+ * label target.  Emit this for all compilers in case other similar
+ * issues are found in the future.
+ */
+#define rseq_after_asm_goto()	asm volatile ("" : : : "memory")
+
+#endif  /* RSEQ_COMPILER_H_ */
--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -195,16 +195,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -263,16 +268,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -317,12 +327,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -384,16 +397,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -456,16 +474,21 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -532,18 +555,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -652,16 +681,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -771,16 +805,21 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq-arm64.h
+++ b/tools/testing/selftests/rseq/rseq-arm64.h
@@ -242,17 +242,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -300,16 +304,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -348,12 +357,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -402,17 +414,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -461,17 +477,21 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -522,19 +542,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -584,17 +609,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -644,17 +673,21 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
-
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -254,16 +254,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -322,16 +327,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -378,12 +388,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -442,16 +455,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -512,16 +530,21 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -583,18 +606,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -659,16 +688,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -735,16 +769,21 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq-s390.h
+++ b/tools/testing/selftests/rseq/rseq-s390.h
@@ -178,16 +178,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -248,16 +253,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -301,12 +311,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -364,16 +377,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -443,18 +461,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -555,16 +579,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -152,16 +152,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -220,16 +225,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -269,12 +279,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -387,16 +400,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -464,18 +482,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -574,16 +598,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -730,16 +759,21 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -798,16 +832,21 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -847,12 +886,15 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 #endif
 }
@@ -909,16 +951,21 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -977,16 +1024,21 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 
@@ -1047,18 +1099,24 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("1st expected value comparison failed");
 error3:
+	rseq_after_asm_goto();
 	rseq_bug("2nd expected value comparison failed");
 #endif
 }
@@ -1161,16 +1219,21 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -1274,16 +1337,21 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
+	rseq_after_asm_goto();
 	return 0;
 abort:
+	rseq_after_asm_goto();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_after_asm_goto();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
+	rseq_after_asm_goto();
 	rseq_bug("cpu_id comparison failed");
 error2:
+	rseq_after_asm_goto();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -17,6 +17,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include "rseq-abi.h"
+#include "compiler.h"
 
 /*
  * Empty code injection macros, override when testing.


