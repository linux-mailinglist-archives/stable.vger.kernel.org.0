Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECBC566B79
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiGEMGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiGEMF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838B318E29;
        Tue,  5 Jul 2022 05:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2001D618C2;
        Tue,  5 Jul 2022 12:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A13EC36AE2;
        Tue,  5 Jul 2022 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022717;
        bh=JjrquhXw9twTv/ogNcZn0TsVy81fp54nMiQn69lssyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwu8CSs/+C4bKKGaePnF1gltYG6q3PJH8D7dYpwVWf7TIC+ReTcUW+bb9r39anyJw
         H7ckwX5EWdlbmVmXXNLqRuhefYkb+B9pOOddkyp3TI9wf1wtvM+JA/CN10aeluq/dP
         0dsu1nre1YGihpwIWuf7ghUW5SnKUX3U8K4kFMFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 44/58] selftests/rseq: Fix ppc32 offsets by using long rather than off_t
Date:   Tue,  5 Jul 2022 13:58:20 +0200
Message-Id: <20220705115611.538178310@linuxfoundation.org>
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

commit 26dc8a6d8e11552f3b797b5aafe01071ca32d692 upstream.

The semantic of off_t is for file offsets. We mean to use it as an
offset from a pointer. We really expect it to fit in a single register,
and not use a 64-bit type on 32-bit architectures.

Fix runtime issues on ppc32 where the offset is always 0 due to
inconsistency between the argument type (off_t -> 64-bit) and type
expected by the inline assembler (32-bit).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-11-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/basic_percpu_ops_test.c |    2 +-
 tools/testing/selftests/rseq/param_test.c            |    2 +-
 tools/testing/selftests/rseq/rseq-arm.h              |    2 +-
 tools/testing/selftests/rseq/rseq-arm64.h            |    2 +-
 tools/testing/selftests/rseq/rseq-mips.h             |    2 +-
 tools/testing/selftests/rseq/rseq-ppc.h              |    2 +-
 tools/testing/selftests/rseq/rseq-s390.h             |    2 +-
 tools/testing/selftests/rseq/rseq-skip.h             |    2 +-
 tools/testing/selftests/rseq/rseq-x86.h              |    6 +++---
 9 files changed, 11 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/rseq/basic_percpu_ops_test.c
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -167,7 +167,7 @@ struct percpu_list_node *this_cpu_list_p
 	for (;;) {
 		struct percpu_list_node *head;
 		intptr_t *targetptr, expectnot, *load;
-		off_t offset;
+		long offset;
 		int ret, cpu;
 
 		cpu = rseq_cpu_start();
--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -547,7 +547,7 @@ struct percpu_list_node *this_cpu_list_p
 	for (;;) {
 		struct percpu_list_node *head;
 		intptr_t *targetptr, expectnot, *load;
-		off_t offset;
+		long offset;
 		int ret;
 
 		cpu = rseq_cpu_start();
--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -217,7 +217,7 @@ error2:
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
--- a/tools/testing/selftests/rseq/rseq-arm64.h
+++ b/tools/testing/selftests/rseq/rseq-arm64.h
@@ -259,7 +259,7 @@ error2:
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
--- a/tools/testing/selftests/rseq/rseq-mips.h
+++ b/tools/testing/selftests/rseq/rseq-mips.h
@@ -222,7 +222,7 @@ error2:
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -270,7 +270,7 @@ error2:
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
--- a/tools/testing/selftests/rseq/rseq-s390.h
+++ b/tools/testing/selftests/rseq/rseq-s390.h
@@ -198,7 +198,7 @@ error2:
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
--- a/tools/testing/selftests/rseq/rseq-skip.h
+++ b/tools/testing/selftests/rseq/rseq-skip.h
@@ -13,7 +13,7 @@ int rseq_cmpeqv_storev(intptr_t *v, intp
 
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	return -1;
 }
--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -172,7 +172,7 @@ error2:
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -286,7 +286,7 @@ error1:
  *  *pval += inc;
  */
 static inline __attribute__((always_inline))
-int rseq_offset_deref_addv(intptr_t *ptr, off_t off, intptr_t inc, int cpu)
+int rseq_offset_deref_addv(intptr_t *ptr, long off, intptr_t inc, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
@@ -750,7 +750,7 @@ error2:
  */
 static inline __attribute__((always_inline))
 int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
-			       off_t voffp, intptr_t *load, int cpu)
+			       long voffp, intptr_t *load, int cpu)
 {
 	RSEQ_INJECT_C(9)
 


