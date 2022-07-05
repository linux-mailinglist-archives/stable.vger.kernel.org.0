Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28687566B6F
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiGEMGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiGEMFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B584C183BC;
        Tue,  5 Jul 2022 05:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52CCFB817DA;
        Tue,  5 Jul 2022 12:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B815C341CD;
        Tue,  5 Jul 2022 12:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022701;
        bh=WajH14n4LRoP5ygMUz/2lERUermXm1YHm+rjDQexCvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VANeL9uxAQmtAQmIcRRDYxJXiUM92hwvBZ2ypeHB5Vfn7eitGEoS8lyrAUi8BnUJm
         8MziW5+Nqqb6iU6AAvar04ZERBxkdtM1UzNHXpaxCzsmRzeWTy695acKxJShXHIWTE
         hJmtlE6NnjEMb0uhgDzCl1puvSE+zdRDQp7iUl1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 38/58] selftests/rseq: Remove volatile from __rseq_abi
Date:   Tue,  5 Jul 2022 13:58:14 +0200
Message-Id: <20220705115611.366613035@linuxfoundation.org>
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

commit 94b80a19ebfe347a01301d750040a61c38200e2b upstream.

This is done in preparation for the selftest uplift to become compatible
with glibc-2.35.

All accesses to the __rseq_abi fields are volatile, but remove the
volatile from the TLS variable declaration, otherwise we are stuck with
volatile for the upcoming rseq_get_abi() helper.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-5-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq.c |    4 ++--
 tools/testing/selftests/rseq/rseq.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -30,7 +30,7 @@
 #include "../kselftest.h"
 #include "rseq.h"
 
-__thread volatile struct rseq_abi __rseq_abi = {
+__thread struct rseq_abi __rseq_abi = {
 	.cpu_id = RSEQ_ABI_CPU_ID_UNINITIALIZED,
 };
 
@@ -92,7 +92,7 @@ int rseq_register_current_thread(void)
 		goto end;
 	}
 	if (errno != EBUSY)
-		__rseq_abi.cpu_id = RSEQ_ABI_CPU_ID_REGISTRATION_FAILED;
+		RSEQ_WRITE_ONCE(__rseq_abi.cpu_id, RSEQ_ABI_CPU_ID_REGISTRATION_FAILED);
 	ret = -1;
 	__rseq_refcount--;
 end:
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -43,7 +43,7 @@
 #define RSEQ_INJECT_FAILED
 #endif
 
-extern __thread volatile struct rseq_abi __rseq_abi;
+extern __thread struct rseq_abi __rseq_abi;
 extern int __rseq_handled;
 
 #define rseq_likely(x)		__builtin_expect(!!(x), 1)
@@ -139,7 +139,7 @@ static inline uint32_t rseq_current_cpu(
 
 static inline void rseq_clear_rseq_cs(void)
 {
-	__rseq_abi.rseq_cs.arch.ptr = 0;
+	RSEQ_WRITE_ONCE(__rseq_abi.rseq_cs.arch.ptr, 0);
 }
 
 /*


