Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6801566B7A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiGEMGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiGEMF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:05:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26630186F5;
        Tue,  5 Jul 2022 05:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABE6AB817CC;
        Tue,  5 Jul 2022 12:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE9C341CB;
        Tue,  5 Jul 2022 12:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022720;
        bh=wQ9jqvqxdCSyauW0dyP00+syI+DWg0HVsGbiqf7qvcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xs/U85kSXRSHr94Q8QII8ak4TMiioo/WGiKU4efi9kuYwR4bwLN6i2DnimyI6BZK3
         j/Me/sOUkSW6T+Jx6ZciBXGbWMD/cczQSfdGOg+lhpbcdVRO1Nnz/MyxAKyTXNoSOq
         7HWwlF1FPXWTHPNdiL1rIePq7HD1k0K3hYie+DRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 45/58] selftests/rseq: Fix warnings about #if checks of undefined tokens
Date:   Tue,  5 Jul 2022 13:58:21 +0200
Message-Id: <20220705115611.566216635@linuxfoundation.org>
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

commit d7ed99ade3e62b755584eea07b4e499e79240527 upstream.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124171253.22072-12-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/param_test.c |    2 +-
 tools/testing/selftests/rseq/rseq-x86.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -159,7 +159,7 @@ unsigned int yield_mod_cnt, nr_abort;
 	"	cbnz	" INJECT_ASM_REG ", 222b\n"			\
 	"333:\n"
 
-#elif __PPC__
+#elif defined(__PPC__)
 
 #define RSEQ_INJECT_INPUT \
 	, [loop_cnt_1]"m"(loop_cnt[1]) \
--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -600,7 +600,7 @@ int rseq_cmpeqv_trymemcpy_storev_release
 
 #endif /* !RSEQ_SKIP_FASTPATH */
 
-#elif __i386__
+#elif defined(__i386__)
 
 #define rseq_smp_mb()	\
 	__asm__ __volatile__ ("lock; addl $0,-128(%%esp)" ::: "memory", "cc")


