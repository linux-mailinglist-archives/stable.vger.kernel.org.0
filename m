Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291CB566D56
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiGEMWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiGEMSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24A318B00;
        Tue,  5 Jul 2022 05:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A8FB8170A;
        Tue,  5 Jul 2022 12:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DEEC341C7;
        Tue,  5 Jul 2022 12:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023206;
        bh=Re8s28P1byiwhi9zFf438s/wOl1yD4U+xdQBclhNQVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sju6G0y8XXZsjXJeMYZypgxd2PjU4jhc4fHGqD2HyM/QuHjbckJ4E7G+JZkUGVsr/
         PIeb+DMI+1m0RvYkmlyG9KEVbxuw1/oMy8BWd0EWNDYC+TwRTWw7Fl2pxjb0HoCKsP
         L9kU4LV48vbj/gykLqdSQYw6YUmPkn16hwAAtIyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 73/98] selftests/rseq: Remove arm/mips asm goto compiler work-around
Date:   Tue,  5 Jul 2022 13:58:31 +0200
Message-Id: <20220705115619.648246040@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

commit 94c5cf2a0e193afffef8de48ddc42de6df7cac93 upstream.

The arm and mips work-around for asm goto size guess issues are not
properly documented, and lack reference to specific compiler versions,
upstream compiler bug tracker entry, and reproducer.

I can only find a loosely documented patch in my original LKML rseq post
refering to gcc < 7 on ARM, but it does not appear to be sufficient to
track the exact issue. Also, I am not sure MIPS really has the same
limitation.

Therefore, remove the work-around until we can properly document this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/20171121141900.18471-17-mathieu.desnoyers@efficios.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-arm.h  |   37 -------------------------------
 tools/testing/selftests/rseq/rseq-mips.h |   37 -------------------------------
 2 files changed, 74 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -147,14 +147,11 @@ do {									\
 		teardown						\
 		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
 
-#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
-
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -198,14 +195,11 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -221,7 +215,6 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -270,14 +263,11 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -292,7 +282,6 @@ int rseq_addv(intptr_t *v, intptr_t coun
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 #ifdef RSEQ_COMPARE_TWICE
@@ -328,10 +317,8 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
@@ -347,7 +334,6 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -398,14 +384,11 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -422,7 +405,6 @@ int rseq_cmpeqv_trystorev_storev_release
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -474,14 +456,11 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -498,7 +477,6 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -554,14 +532,11 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -582,7 +557,6 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -678,21 +652,16 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -706,7 +675,6 @@ int rseq_cmpeqv_trymemcpy_storev_release
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -803,21 +771,16 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }
--- a/tools/testing/selftests/rseq/rseq-mips.h
+++ b/tools/testing/selftests/rseq/rseq-mips.h
@@ -154,14 +154,11 @@ do {									\
 		teardown \
 		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
 
-#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
-
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -203,14 +200,11 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -226,7 +220,6 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -273,14 +266,11 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -295,7 +285,6 @@ int rseq_addv(intptr_t *v, intptr_t coun
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 #ifdef RSEQ_COMPARE_TWICE
@@ -331,10 +320,8 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		  , error1
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 #ifdef RSEQ_COMPARE_TWICE
@@ -350,7 +337,6 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -399,14 +385,11 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -423,7 +406,6 @@ int rseq_cmpeqv_trystorev_storev_release
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -473,14 +455,11 @@ int rseq_cmpeqv_trystorev_storev_release
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -497,7 +476,6 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 {
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -549,14 +527,11 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		  , error1, error2, error3
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
@@ -577,7 +552,6 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -670,21 +644,16 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }
@@ -698,7 +667,6 @@ int rseq_cmpeqv_trymemcpy_storev_release
 
 	RSEQ_INJECT_C(9)
 
-	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(9, 1f, 2f, 4f) /* start, commit, abort */
 		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[cmpfail])
@@ -792,21 +760,16 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		  , error1, error2
 #endif
 	);
-	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
-	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
-	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 #ifdef RSEQ_COMPARE_TWICE
 error1:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("cpu_id comparison failed");
 error2:
-	rseq_workaround_gcc_asm_size_guess();
 	rseq_bug("expected value comparison failed");
 #endif
 }


