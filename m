Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B067438AF6
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 19:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhJXRbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 13:31:35 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:44525 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhJXRbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 13:31:35 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 19OHSY3c018039;
        Sun, 24 Oct 2021 19:28:34 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Peter Cordes <peter@cordes.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/3] tools/nolibc: i386: fix initial stack alignment
Date:   Sun, 24 Oct 2021 19:28:15 +0200
Message-Id: <20211024172816.17993-3-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20211024172816.17993-1-w@1wt.eu>
References: <20211024172816.17993-1-w@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 tools/include/nolibc/nolibc.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 96b6d56acb57..7f300dc379e7 100644
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
2.17.5

