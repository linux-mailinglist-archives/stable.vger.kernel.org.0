Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB59465AFC
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 01:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354562AbhLBAhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 19:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354470AbhLBAhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 19:37:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0AAC061748;
        Wed,  1 Dec 2021 16:33:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4843ECE207A;
        Thu,  2 Dec 2021 00:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C09C53FAD;
        Thu,  2 Dec 2021 00:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638405228;
        bh=BeuD0OdxB65KhgHIaFtCjVcFOJPO0wx8Xc+Aw91Yuyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jv5DyS2XdePi4pTnDhaALrNxHEeLypXJiRunnuI0QYVcSU46zF6XVozpv8iXN8+zh
         iOTs9AHDDZwEUWMBWToF+NTJ0l8b2nsdRb5GWVvKp9LM83OMRLYJmjJl44YMRko+Lc
         JybIU+DfU+HuGjYdenXXGbFQRiQ+hH70PnGWy9jtI9Wv1yCXykLLXYzKcS4rcoz7q8
         s9GoncMxJ3JL9+olGc4pwN+KVNHYb2tDICNm3uAhZJCz8mCAZVGn6q5SyiP6OCy71F
         SW73TSyEWjUNXoQUUGgNOmjix4XLU1jR4YMJ6cAAV+WlYdbbe8m7j09bQuG/yAKUeg
         0bzbwBPdGdepA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 3BD535C100F; Wed,  1 Dec 2021 16:33:48 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org, Willy Tarreau <w@1wt.eu>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        stable@vger.kernel.org, "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH rcu 2/6] tools/nolibc: i386: fix initial stack alignment
Date:   Wed,  1 Dec 2021 16:33:42 -0800
Message-Id: <20211202003346.3129110-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20211202003322.GA3128775@paulmck-ThinkPad-P17-Gen-1>
References: <20211202003322.GA3128775@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

After re-checking in the spec and comparing stack offsets with glibc,
The last pushed argument must be 16-byte aligned (i.e. aligned before the
call) so that in the callee esp+4 is multiple of 16, so the principle is
the 32-bit equivalent to what Ammar fixed for x86_64. It's possible that
32-bit code using SSE2 or MMX could have been affected. In addition the
frame pointer ought to be zero at the deepest level.

Link: https://gitlab.com/x86-psABIs/i386-ABI/-/wikis/Intel386-psABI
Cc: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 tools/include/nolibc/nolibc.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 96b6d56acb572..7f300dc379e70 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -583,13 +583,21 @@ struct sys_stat_struct {
 })
 
 /* startup code */
+/*
+ * i386 System V ABI mandates:
+ * 1) last pushed argument must be 16-byte aligned.
+ * 2) The deepest stack frame should be set to zero
+ *
+ */
 asm(".section .text\n"
     ".global _start\n"
     "_start:\n"
     "pop %eax\n"                // argc   (first arg, %eax)
     "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
     "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
-    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned when
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
+    "sub $4, %esp\n"            // the call instruction (args are aligned)
     "push %ecx\n"               // push all registers on the stack so that we
     "push %ebx\n"               // support both regparm and plain stack modes
     "push %eax\n"
-- 
2.31.1.189.g2e36527f23

