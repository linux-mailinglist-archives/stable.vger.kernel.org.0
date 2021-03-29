Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDB734C5F1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhC2IEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhC2ID1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AF961969;
        Mon, 29 Mar 2021 08:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005007;
        bh=COZIRsmUgNgRfddeH7B0c6+3XxvtRXdsumtJ0k71Iq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xav6y2FElvQ9Q6Y+WiTf2uJ+LRkWli5U0Nd0kTPWXICdhDd90PzFzyPBeVWULh8o9
         T+z5SjPBDEoABfOX+UNSfPbt6hANJUI8iBIA/LushI72oLjkEIZrVtXC5c6D5oTS5I
         /6z61YumhQMQe8isa44BM582L+kOyrdqGc1wtuGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 46/53] arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP
Date:   Mon, 29 Mar 2021 09:58:21 +0200
Message-Id: <20210329075609.019809612@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Fixes: 6170a97460db ("arm64: Atomic operations")
Signed-off-by: Will Deacon <will.deacon@arm.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/futex.h |   59 +++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 22 deletions(-)

--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -26,7 +26,12 @@
 #include <asm/errno.h>
 #include <asm/sysreg.h>
 
+#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
+
 #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
+do {									\
+	unsigned int loops = FUTEX_MAX_LOOPS;				\
+									\
 	asm volatile(							\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
@@ -34,21 +39,26 @@
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
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
-	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
-	: "r" (oparg), "Ir" (-EFAULT)					\
-	: "memory")
+	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
+	  "+r" (loops)							\
+	: "r" (oparg), "Ir" (-EFAULT), "Ir" (-EAGAIN)			\
+	: "memory");							\
+} while (0)
 
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
@@ -59,23 +69,23 @@ arch_futex_atomic_op_inuser(int op, int
 
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
@@ -95,6 +105,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 			      u32 oldval, u32 newval)
 {
 	int ret = 0;
+	unsigned int loops = FUTEX_MAX_LOOPS;
 	u32 val, tmp;
 	u32 __user *uaddr;
 
@@ -106,21 +117,25 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
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
+	_ASM_EXTABLE(1b, 5b)
+	_ASM_EXTABLE(2b, 5b)
 ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
-	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
-	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
+	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
+	: "r" (oldval), "r" (newval), "Ir" (-EFAULT), "Ir" (-EAGAIN)
 	: "memory");
 
 	*uval = val;


