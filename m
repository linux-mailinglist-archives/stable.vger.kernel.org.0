Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D665D19250
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfEISqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbfEISqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F9D2182B;
        Thu,  9 May 2019 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427597;
        bh=M/WflKJ18bUUTjs4bfqR6PSZ0fvoLlGIFcH8OVmjCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiQ5QylFh6A7TxJSlvqqWWddXKT5TNuDinKB9Gq8vLXAuRh5Ixzz8BqdcWJRg7woW
         gfFF3P98tPRc3ZN0SiugHtJL0YROjtV2ULycIW2xX/oeXzUNrSBUs2JE31pIsOfvm0
         UdjwbclEmBt3OSIFIbn4WymIx9HLGKwfLrydghHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.14 42/42] arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP
Date:   Thu,  9 May 2019 20:42:31 +0200
Message-Id: <20190509181300.512525411@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 03110a5cb2161690ae5ac04994d47ed0cd6cef75 upstream.

Our futex implementation makes use of LDXR/STXR loops to perform atomic
updates to user memory from atomic context. This can lead to latency
problems if we end up spinning around the LL/SC sequence at the expense
of doing something useful.

Rework our futex atomic operations so that we return -EAGAIN if we fail
to update the futex word after 128 attempts. The core futex code will
reschedule if necessary and we'll try again later.

Cc: <stable@kernel.org>
Fixes: 6170a97460db ("arm64: Atomic operations")
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/futex.h |   55 +++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -23,26 +23,34 @@
 
 #include <asm/errno.h>
 
+#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
+
 #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
 do {									\
+	unsigned int loops = FUTEX_MAX_LOOPS;				\
+									\
 	uaccess_enable();						\
 	asm volatile(							\
 "	prfm	pstl1strm, %2\n"					\
 "1:	ldxr	%w1, %2\n"						\
 	insn "\n"							\
 "2:	stlxr	%w0, %w3, %2\n"						\
-"	cbnz	%w0, 1b\n"						\
-"	dmb	ish\n"							\
+"	cbz	%w0, 3f\n"						\
+"	sub	%w4, %w4, %w0\n"					\
+"	cbnz	%w4, 1b\n"						\
+"	mov	%w0, %w7\n"						\
 "3:\n"									\
+"	dmb	ish\n"							\
 "	.pushsection .fixup,\"ax\"\n"					\
 "	.align	2\n"							\
-"4:	mov	%w0, %w5\n"						\
+"4:	mov	%w0, %w6\n"						\
 "	b	3b\n"							\
 "	.popsection\n"							\
 	_ASM_EXTABLE(1b, 4b)						\
 	_ASM_EXTABLE(2b, 4b)						\
-	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
-	: "r" (oparg), "Ir" (-EFAULT)					\
+	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
+	  "+r" (loops)							\
+	: "r" (oparg), "Ir" (-EFAULT), "Ir" (-EAGAIN)			\
 	: "memory");							\
 	uaccess_disable();						\
 } while (0)
@@ -57,23 +65,23 @@ arch_futex_atomic_op_inuser(int op, int
 
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%w3, %w4",
+		__futex_atomic_op("mov	%w3, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%w3, %w1, %w4",
+		__futex_atomic_op("add	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%w3, %w1, %w4",
+		__futex_atomic_op("orr	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%w3, %w1, %w4",
+		__futex_atomic_op("and	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%w3, %w1, %w4",
+		__futex_atomic_op("eor	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	default:
@@ -93,6 +101,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 			      u32 oldval, u32 newval)
 {
 	int ret = 0;
+	unsigned int loops = FUTEX_MAX_LOOPS;
 	u32 val, tmp;
 	u32 __user *uaddr;
 
@@ -104,20 +113,24 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
 "	prfm	pstl1strm, %2\n"
 "1:	ldxr	%w1, %2\n"
-"	sub	%w3, %w1, %w4\n"
-"	cbnz	%w3, 3f\n"
-"2:	stlxr	%w3, %w5, %2\n"
-"	cbnz	%w3, 1b\n"
-"	dmb	ish\n"
+"	sub	%w3, %w1, %w5\n"
+"	cbnz	%w3, 4f\n"
+"2:	stlxr	%w3, %w6, %2\n"
+"	cbz	%w3, 3f\n"
+"	sub	%w4, %w4, %w3\n"
+"	cbnz	%w4, 1b\n"
+"	mov	%w0, %w8\n"
 "3:\n"
+"	dmb	ish\n"
+"4:\n"
 "	.pushsection .fixup,\"ax\"\n"
-"4:	mov	%w0, %w6\n"
-"	b	3b\n"
+"5:	mov	%w0, %w7\n"
+"	b	4b\n"
 "	.popsection\n"
-	_ASM_EXTABLE(1b, 4b)
-	_ASM_EXTABLE(2b, 4b)
-	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
-	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
+	_ASM_EXTABLE(1b, 5b)
+	_ASM_EXTABLE(2b, 5b)
+	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
+	: "r" (oldval), "r" (newval), "Ir" (-EFAULT), "Ir" (-EAGAIN)
 	: "memory");
 	uaccess_disable();
 


