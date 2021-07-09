Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E58C3C247E
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhGINXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhGINXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:23:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3777B6128A;
        Fri,  9 Jul 2021 13:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836829;
        bh=xGKGHbBAKfbQJlJpTH9BBsLPG5SPFOPOHzQMjy9TGG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y69avIQJYi5guUiv4ZTnmv43AjqrtqUMLKgCtoT+FBu7+yH+M7/A3nRx/EbhqlnFE
         yCeUMEccytIbqUNdJT8u8Tu1AFg60YrWLLr8gbchxhESA4B2yD7q/RAkP0YsiUvFLH
         ixHsaAHt8JqBIEWsHa5em4J5o2NXcDdoL2UFhkvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@kernel.org
Subject: [PATCH 5.4 2/4] s390/stack: fix possible register corruption with stack switch helper
Date:   Fri,  9 Jul 2021 15:20:16 +0200
Message-Id: <20210709131534.397822619@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
References: <20210709131531.277334979@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/s390/include/asm/stacktrace.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -79,12 +79,16 @@ struct stack_frame {
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
@@ -105,7 +109,7 @@ struct stack_frame {
 		"	brasl	14,%[_fn]\n"				\
 		"	la	15,0(%[_prev])\n"			\
 		: [_prev] "=&a" (prev), CALL_FMT_##nr			\
-		  [_stack] "a" (stack),					\
+		: [_stack] "a" (stack),					\
 		  [_bc] "i" (offsetof(struct stack_frame, back_chain)),	\
 		  [_fn] "X" (fn) : CALL_CLOBBER_##nr);			\
 	r2;								\


