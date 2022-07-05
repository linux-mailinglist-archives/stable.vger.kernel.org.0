Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FE2566C20
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiGEMLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiGEMKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8806518E37;
        Tue,  5 Jul 2022 05:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9478B817DA;
        Tue,  5 Jul 2022 12:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0B8C341C7;
        Tue,  5 Jul 2022 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022988;
        bh=WuuSJuTTkvZY6tfwa6klBJfO8MirsENKQ0hsHuEAZS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvsXflEMdfVGE0SW4zf0X/qmFMPXjAAS7xPIQSKEtdr6Tlv1qGsgsboOsoT+XUkMa
         Qd1zp6htvw68DK7C6gUXDIS4NvByp4dsy7gRlpWOjk/71o7MTmxpqSVRgsvcw+w1nJ
         2VMUa2AVI8y/Z6RPn9b5E9j6aiFw3DahkB8jLauc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 75/84] selftests/rseq: Change type of rseq_offset to ptrdiff_t
Date:   Tue,  5 Jul 2022 13:58:38 +0200
Message-Id: <20220705115617.510784609@linuxfoundation.org>
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

commit 889c5d60fbcf332c8b6ab7054d45f2768914a375 upstream.

Just before the 2.35 release of glibc, the __rseq_offset userspace ABI
was changed from int to ptrdiff_t.

Adapt to this change in the kernel selftests.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://sourceware.org/pipermail/libc-alpha/2022-February/136024.html
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-x86.h |   14 +++++++-------
 tools/testing/selftests/rseq/rseq.c     |    5 +++--
 tools/testing/selftests/rseq/rseq.h     |    3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -143,7 +143,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -214,7 +214,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -270,7 +270,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"er" (count)
@@ -329,7 +329,7 @@ int rseq_offset_deref_addv(intptr_t *ptr
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [ptr]			"m" (*ptr),
 		  [off]			"er" (off),
@@ -387,7 +387,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -469,7 +469,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -581,7 +581,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 #endif
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
-		  [rseq_offset]		"r" ((long)rseq_offset),
+		  [rseq_offset]		"r" (rseq_offset),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -27,16 +27,17 @@
 #include <signal.h>
 #include <limits.h>
 #include <dlfcn.h>
+#include <stddef.h>
 
 #include "../kselftest.h"
 #include "rseq.h"
 
-static const int *libc_rseq_offset_p;
+static const ptrdiff_t *libc_rseq_offset_p;
 static const unsigned int *libc_rseq_size_p;
 static const unsigned int *libc_rseq_flags_p;
 
 /* Offset from the thread pointer to the rseq area.  */
-int rseq_offset;
+ptrdiff_t rseq_offset;
 
 /* Size of the registered rseq area.  0 if the registration was
    unsuccessful.  */
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -16,6 +16,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stddef.h>
 #include "rseq-abi.h"
 #include "compiler.h"
 
@@ -47,7 +48,7 @@
 #include "rseq-thread-pointer.h"
 
 /* Offset from the thread pointer to the rseq area.  */
-extern int rseq_offset;
+extern ptrdiff_t rseq_offset;
 /* Size of the registered rseq area.  0 if the registration was
    unsuccessful.  */
 extern unsigned int rseq_size;


