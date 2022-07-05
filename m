Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350FF566BA1
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiGEMJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiGEMH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063819022;
        Tue,  5 Jul 2022 05:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764AD61806;
        Tue,  5 Jul 2022 12:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859ABC36AE3;
        Tue,  5 Jul 2022 12:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022775;
        bh=xvac9IYhlt5laQwLoXORrlpsJx1lDM8cK18PQIxR9cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wtm62yAZyvjAoi8hmQJofz2LilJ1WQOEdA68hRo2RUmjim2PGZy7zuJWyKLZ6Evkq
         HKZ4vbYUKV1Ly1ybPAa01GEqIz9vgSPD2W5JpuziBmp4En/g24rMPSj/59XsVWHHgq
         0gfjnTOLmK0HtgvxSjJY4HloZ5rfAJxx388mABis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Oskolkov <posk@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.4 34/58] rseq/selftests,x86_64: Add rseq_offset_deref_addv()
Date:   Tue,  5 Jul 2022 13:58:10 +0200
Message-Id: <20220705115611.250167699@linuxfoundation.org>
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

From: Peter Oskolkov <posk@google.com>

commit ea366dd79c05fcd4cf5e225d2de8a3a7c293160c upstream.

This patch adds rseq_offset_deref_addv() function to
tools/testing/selftests/rseq/rseq-x86.h, to be used in a selftest in
the next patch in the patchset.

Once an architecture adds support for this function they should define
"RSEQ_ARCH_HAS_OFFSET_DEREF_ADDV".

Signed-off-by: Peter Oskolkov <posk@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lkml.kernel.org/r/20200923233618.2572849-2-posk@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-x86.h |   57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -279,6 +279,63 @@ error1:
 #endif
 }
 
+#define RSEQ_ARCH_HAS_OFFSET_DEREF_ADDV
+
+/*
+ *   pval = *(ptr+off)
+ *  *pval += inc;
+ */
+static inline __attribute__((always_inline))
+int rseq_offset_deref_addv(intptr_t *ptr, off_t off, intptr_t inc, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, 1f, 2f, 4f) /* start, commit, abort */
+#ifdef RSEQ_COMPARE_TWICE
+		RSEQ_ASM_DEFINE_EXIT_POINT(1f, %l[error1])
+#endif
+		/* Start rseq by storing table entry pointer into rseq_cs. */
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, RSEQ_CS_OFFSET(%[rseq_abi]))
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), 4f)
+		RSEQ_INJECT_ASM(3)
+#ifdef RSEQ_COMPARE_TWICE
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, RSEQ_CPU_ID_OFFSET(%[rseq_abi]), %l[error1])
+#endif
+		/* get p+v */
+		"movq %[ptr], %%rbx\n\t"
+		"addq %[off], %%rbx\n\t"
+		/* get pv */
+		"movq (%%rbx), %%rcx\n\t"
+		/* *pv += inc */
+		"addq %[inc], (%%rcx)\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		RSEQ_ASM_DEFINE_ABORT(4, "", abort)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]		"r" (cpu),
+		  [rseq_abi]		"r" (&__rseq_abi),
+		  /* final store input */
+		  [ptr]			"m" (*ptr),
+		  [off]			"er" (off),
+		  [inc]			"er" (inc)
+		: "memory", "cc", "rax", "rbx", "rcx"
+		  RSEQ_INJECT_CLOBBER
+		: abort
+#ifdef RSEQ_COMPARE_TWICE
+		  , error1
+#endif
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+#ifdef RSEQ_COMPARE_TWICE
+error1:
+	rseq_bug("cpu_id comparison failed");
+#endif
+}
+
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 				 intptr_t *v2, intptr_t newv2,


