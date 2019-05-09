Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C4718FA3
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfEIRwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:52:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60993 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbfEIRwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:52:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0DF3323956;
        Thu,  9 May 2019 13:52:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 09 May 2019 13:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9x3961
        yWM2uMvzbuYatI8bQw206b4YLnn4JoZ9AWZec=; b=1dFo1MtvBCAWdVgsnhrcld
        OfnzwJJGhI1Hhut7LUt+u4B8sPbyoh3uesDxZ90aIqapwdJkQtkiqzMJfPcXpjko
        62bliOGRcuk6Kduo3eRIXg1L7AS/cO4/5S5jeHcqrWNgVkHiPtdIFEHFyPD6bYts
        jdDxW3mytHquPUSrfBer1jy2bgKoLqRvOCjv/PA5e6P7u7QkscnNdvHU6aGNNqcZ
        nrYmlOh8Vuyo5p5vzdcFpT9OgSkw7HI+9e8jcNlyHIeE0wOhyq/jNLtvLJoQhcNa
        0AjObBfO2h20ORNMOxKe+jFJpgF2mnwYbl7yWnwLus9LlQKpHL+WqLL+Cp6Rsxqg
        ==
X-ME-Sender: <xms:yWjUXGyUnreANAuU7KEEjrI4cnVW4MAwfl23EHiedAQ2LlB3ZEGaeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:yWjUXIyv-hT13A5AvEdUOKyPZ4zNpU9CGB1LK-4EAuGu6da426JeAw>
    <xmx:yWjUXLgngcR5wTInNg1N6EZO4uZ0p6n6nqtxq_glSlbqN1t8Sy5kiQ>
    <xmx:yWjUXGjOrSCFtATY6fkXTAvWdf1JlcKD_2AKO5td4CxAWjM7tVossw>
    <xmx:ymjUXN15AQrH6i4178B6T2s-E6Yr6GxiF4GvS6CeDv_ciXUVPSYqQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FC6D103CC;
        Thu,  9 May 2019 13:52:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: futex: Bound number of LDXR/STXR loops in" failed to apply to 3.18-stable tree
To:     will.deacon@arm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 09 May 2019 19:52:08 +0200
Message-ID: <1557424328112101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 3.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03110a5cb2161690ae5ac04994d47ed0cd6cef75 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 8 Apr 2019 14:23:17 +0100
Subject: [PATCH] arm64: futex: Bound number of LDXR/STXR loops in
 FUTEX_WAKE_OP

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

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index e1d95f08f8e1..2d78ea6932b7 100644
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
@@ -57,23 +65,23 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 
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
@@ -93,6 +101,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
 			      u32 oldval, u32 newval)
 {
 	int ret = 0;
+	unsigned int loops = FUTEX_MAX_LOOPS;
 	u32 val, tmp;
 	u32 __user *uaddr;
 
@@ -104,20 +113,24 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
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
 

