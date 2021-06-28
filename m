Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74133B6035
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhF1OWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhF1OWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB56261990;
        Mon, 28 Jun 2021 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889969;
        bh=fXrnNMAxCvUGIEyD+v33JHz0RrQoK5Pm3Y9aqQylqb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBN1LJMO9JcwDg011Pvmk5covZVUuV/fZwH0H/Zyl/hNrCnXhq83+gBjS6jPw047u
         vZLF8NO7yAGkdcV9TS7YKy9Bk56pG19N92mRVuo0EDcrdRFMV2LxqGOV658Lg6I1Lm
         Qr6qOtjl9jjuxHYUXQEp+TBztTtNJNowbtgVRIxQ7gF+DxjCbKlzgyQrFfr0il4y2+
         oRlpEvL2Z93n+QMTWoIxbgz29Vc+MZiynnH1umunZ6oY1fJ0l/E+4qwp9HN8xyUH0q
         3PcCdn5lDwYfItsQPgnkjggOYmZ8UtfA1ssdR5dV3QD9zyfcKXQ6gA2Oe9FCXLxieb
         sjmGl/ffYR6Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>, stable@kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 070/110] s390/stack: fix possible register corruption with stack switch helper
Date:   Mon, 28 Jun 2021 10:17:48 -0400
Message-Id: <20210628141828.31757-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 67147e96a332b56c7206238162771d82467f86c0 upstream.

The CALL_ON_STACK macro is used to call a C function from inline
assembly, and therefore must consider the C ABI, which says that only
registers 6-13, and 15 are non-volatile (restored by the called
function).

The inline assembly incorrectly marks all registers used to pass
parameters to the called function as read-only input operands, instead
of operands that are read and written to. This might result in
register corruption depending on usage, compiler, and compile options.

Fix this by marking all operands used to pass parameters as read/write
operands. To keep the code simple even register 6, if used, is marked
as read-write operand.

Fixes: ff340d2472ec ("s390: add stack switch helper")
Cc: <stable@kernel.org> # 4.20
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/stacktrace.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 2b543163d90a..76c6034428be 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -91,12 +91,16 @@ struct stack_frame {
 	CALL_ARGS_4(arg1, arg2, arg3, arg4);				\
 	register unsigned long r4 asm("6") = (unsigned long)(arg5)
 
-#define CALL_FMT_0 "=&d" (r2) :
-#define CALL_FMT_1 "+&d" (r2) :
-#define CALL_FMT_2 CALL_FMT_1 "d" (r3),
-#define CALL_FMT_3 CALL_FMT_2 "d" (r4),
-#define CALL_FMT_4 CALL_FMT_3 "d" (r5),
-#define CALL_FMT_5 CALL_FMT_4 "d" (r6),
+/*
+ * To keep this simple mark register 2-6 as being changed (volatile)
+ * by the called function, even though register 6 is saved/nonvolatile.
+ */
+#define CALL_FMT_0 "=&d" (r2)
+#define CALL_FMT_1 "+&d" (r2)
+#define CALL_FMT_2 CALL_FMT_1, "+&d" (r3)
+#define CALL_FMT_3 CALL_FMT_2, "+&d" (r4)
+#define CALL_FMT_4 CALL_FMT_3, "+&d" (r5)
+#define CALL_FMT_5 CALL_FMT_4, "+&d" (r6)
 
 #define CALL_CLOBBER_5 "0", "1", "14", "cc", "memory"
 #define CALL_CLOBBER_4 CALL_CLOBBER_5
@@ -118,7 +122,7 @@ struct stack_frame {
 		"	brasl	14,%[_fn]\n"				\
 		"	la	15,0(%[_prev])\n"			\
 		: [_prev] "=&a" (prev), CALL_FMT_##nr			\
-		  [_stack] "R" (stack),					\
+		: [_stack] "R" (stack),					\
 		  [_bc] "i" (offsetof(struct stack_frame, back_chain)),	\
 		  [_frame] "d" (frame),					\
 		  [_fn] "X" (fn) : CALL_CLOBBER_##nr);			\
-- 
2.30.2

