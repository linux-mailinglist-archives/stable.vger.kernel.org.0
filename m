Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A917F2ABC51
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgKINgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbgKINEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05A621D40;
        Mon,  9 Nov 2020 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927070;
        bh=BOx2XQZa4drMIEVbXKATM8ux/UvHNjZ25Cpx8SGigZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkeiZv/moSthKyo8yLCXd/F4MPwZX/bH3nbnDY96V/OMPNvX9xHtHNlPp0c2Sqfft
         +2/FcE/JL4nn4+ESPtA1+zUY04dv/mKs8jfCcealM6LPEjCs2maLYb5oYg9DsRkFjO
         puFUzFq4KhH+Z0pg5FFqH1++oixJo+UdWTrI6V2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 100/117] ftrace: Handle tracing when switching between context
Date:   Mon,  9 Nov 2020 13:55:26 +0100
Message-Id: <20201109125030.450305480@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 726b3d3f141fba6f841d715fc4d8a4a84f02c02a upstream.

When an interrupt or NMI comes in and switches the context, there's a delay
from when the preempt_count() shows the update. As the preempt_count() is
used to detect recursion having each context have its own bit get set when
tracing starts, and if that bit is already set, it is considered a recursion
and the function exits. But if this happens in that section where context
has changed but preempt_count() has not been updated, this will be
incorrectly flagged as a recursion.

To handle this case, create another bit call TRANSITION and test it if the
current context bit is already set. Flag the call as a recursion if the
TRANSITION bit is already set, and if not, set it and continue. The
TRANSITION bit will be cleared normally on the return of the function that
set it, or if the current context bit is clear, set it and clear the
TRANSITION bit to allow for another transition between the current context
and an even higher one.

Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.h          |   23 +++++++++++++++++++++--
 kernel/trace/trace_selftest.c |    9 +++++++--
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -491,6 +491,12 @@ enum {
  * can only be modified by current, we can reuse trace_recursion.
  */
 	TRACE_IRQ_BIT,
+
+	/*
+	 * When transitioning between context, the preempt_count() may
+	 * not be correct. Allow for a single recursion to cover this case.
+	 */
+	TRACE_TRANSITION_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
@@ -535,8 +541,21 @@ static __always_inline int trace_test_an
 		return 0;
 
 	bit = trace_get_context_bit() + start;
-	if (unlikely(val & (1 << bit)))
-		return -1;
+	if (unlikely(val & (1 << bit))) {
+		/*
+		 * It could be that preempt_count has not been updated during
+		 * a switch between contexts. Allow for a single recursion.
+		 */
+		bit = TRACE_TRANSITION_BIT;
+		if (trace_recursion_test(bit))
+			return -1;
+		trace_recursion_set(bit);
+		barrier();
+		return bit + 1;
+	}
+
+	/* Normal check passed, clear the transition to allow it again */
+	trace_recursion_clear(TRACE_TRANSITION_BIT);
 
 	val |= 1 << bit;
 	current->trace_recursion = val;
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -490,8 +490,13 @@ trace_selftest_function_recursion(void)
 	unregister_ftrace_function(&test_rec_probe);
 
 	ret = -1;
-	if (trace_selftest_recursion_cnt != 1) {
-		pr_cont("*callback not called once (%d)* ",
+	/*
+	 * Recursion allows for transitions between context,
+	 * and may call the callback twice.
+	 */
+	if (trace_selftest_recursion_cnt != 1 &&
+	    trace_selftest_recursion_cnt != 2) {
+		pr_cont("*callback not called once (or twice) (%d)* ",
 			trace_selftest_recursion_cnt);
 		goto out;
 	}


