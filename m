Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D965C566B71
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiGEMGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiGEMFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFE418E2B;
        Tue,  5 Jul 2022 05:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C57F618BB;
        Tue,  5 Jul 2022 12:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA62C341CD;
        Tue,  5 Jul 2022 12:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022712;
        bh=EOZo9s1qbmNa7TGA1A9FPZ5KLTRFRYSWC118HBm/k08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeROG7AN2DKkGOooFSO+FAstlHwLC55eTwbWErVhSmDm5IhlsZoNIdNvnND32zBl3
         NzLlfQrScoOZfPJtNvGsf0wiuyx2E6kbbAQyrBakgPf3sDZjhA9zaxnL1h1WC5Mz7K
         pLuhGf7pWcPDP4EiGD0QI7Exitu/EUDe7ZhjIJ4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 42/58] selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian
Date:   Tue,  5 Jul 2022 13:58:18 +0200
Message-Id: <20220705115611.481794724@linuxfoundation.org>
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

commit 24d1136a29da5953de5c0cbc6c83eb62a1e0bf14 upstream.

ppc32 incorrectly uses padding as rseq_cs pointer field. Fix this by
using the rseq_cs.arch.ptr field.

Use this field across all architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-9-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-arm.h   |   16 ++++++++--------
 tools/testing/selftests/rseq/rseq-arm64.h |   16 ++++++++--------
 tools/testing/selftests/rseq/rseq-mips.h  |   16 ++++++++--------
 tools/testing/selftests/rseq/rseq-ppc.h   |   16 ++++++++--------
 tools/testing/selftests/rseq/rseq-s390.h  |   12 ++++++------
 5 files changed, 38 insertions(+), 38 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -186,7 +186,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -256,7 +256,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -317,7 +317,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [count]		"Ir" (count)
 		  RSEQ_INJECT_INPUT
@@ -382,7 +382,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -458,7 +458,7 @@ int rseq_cmpeqv_trystorev_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -538,7 +538,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -658,7 +658,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -783,7 +783,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
--- a/tools/testing/selftests/rseq/rseq-arm64.h
+++ b/tools/testing/selftests/rseq/rseq-arm64.h
@@ -231,7 +231,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -288,7 +288,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expectnot]		"r" (expectnot),
 		  [load]		"Qo" (*load),
@@ -338,7 +338,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [count]		"r" (count)
 		  RSEQ_INJECT_INPUT
@@ -389,7 +389,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -448,7 +448,7 @@ int rseq_cmpeqv_trystorev_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -509,7 +509,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"Qo" (*v),
 		  [expect]		"r" (expect),
 		  [v2]			"Qo" (*v2),
@@ -570,7 +570,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
@@ -630,7 +630,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"Qo" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [expect]		"r" (expect),
 		  [v]			"Qo" (*v),
 		  [newv]		"r" (newv),
--- a/tools/testing/selftests/rseq/rseq-mips.h
+++ b/tools/testing/selftests/rseq/rseq-mips.h
@@ -191,7 +191,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -259,7 +259,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -320,7 +320,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [count]		"Ir" (count)
 		  RSEQ_INJECT_INPUT
@@ -383,7 +383,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -457,7 +457,7 @@ int rseq_cmpeqv_trystorev_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -533,7 +533,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -650,7 +650,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -772,7 +772,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -236,7 +236,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -302,7 +302,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -360,7 +360,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"r" (count)
@@ -420,7 +420,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -490,7 +490,7 @@ int rseq_cmpeqv_trystorev_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -561,7 +561,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -636,7 +636,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
@@ -712,7 +712,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
--- a/tools/testing/selftests/rseq/rseq-s390.h
+++ b/tools/testing/selftests/rseq/rseq-s390.h
@@ -166,7 +166,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),
 		  [newv]		"r" (newv)
@@ -234,7 +234,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expectnot]		"r" (expectnot),
@@ -289,7 +289,7 @@ int rseq_addv(intptr_t *v, intptr_t coun
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [count]		"r" (count)
@@ -348,7 +348,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* try store input */
 		  [v2]			"m" (*v2),
 		  [newv2]		"r" (newv2),
@@ -427,7 +427,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* cmp2 input */
 		  [v2]			"m" (*v2),
 		  [expect2]		"r" (expect2),
@@ -535,7 +535,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_
 		: /* gcc asm goto does not allow outputs */
 		: [cpu_id]		"r" (cpu),
 		  [current_cpu_id]	"m" (rseq_get_abi()->cpu_id),
-		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs),
+		  [rseq_cs]		"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 		  /* final store input */
 		  [v]			"m" (*v),
 		  [expect]		"r" (expect),


