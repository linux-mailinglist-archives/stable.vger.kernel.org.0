Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5FB18FB4
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfEIRzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:55:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39999 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbfEIRzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 13:55:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 99179244A8;
        Thu,  9 May 2019 13:55:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 09 May 2019 13:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+G7UE9
        lbaCs9iP+2Ya4VMZEXQx/MnHCHPaTRmtbklRE=; b=OUFRYTD5CW4z910Afh6lky
        yUgzJWI4Gqh4/EnBy64R9YdoeNLDz1bp4W26OwU0Y6pbmNjBDVrGfL4mLVUTkKrj
        kXVp7uF0ViT9m2DNy/WpKF/6z1hmsYKYoQiS4H2lqgOjAi/gSDQtDSSo/3VIS9os
        an8lwWOEOQL0YJbgwRSLV2DIMOuoSA6QYnjrpuYMfPi/a6r/u86lNw192IkCEyx5
        RBdf3uK7jnI57kmoeu3hUOUvj48TfSEDefMki1kdlD7TYflJe2vVJGeSH7nbbKW8
        Oqtal7+Asegc1bClptIeCRCAkwnAv1SEAmjMyAyPHw/diaa5Ycn5+KRJkDcCCL7g
        ==
X-ME-Sender: <xms:mWnUXDfF-7D0C2iaUmy3UaGcOBMlgXppj8CfwSZ_h9h-KecWtmOfEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:mWnUXEL5FT9mzElLSp5-w6trWUizpbWPBEVrmzbh8Q8VqpPvqqP-iw>
    <xmx:mWnUXPJSO_g7ran_W3ImtFMj5m9qI8X257k0UH5bdly3b08xl0p_jQ>
    <xmx:mWnUXDtxkGMpuT_5ObEsSEP3QuXM1bRZRexQichxLODzQURyRIHu-g>
    <xmx:mWnUXJb1gjSaWGMKijV3q_c1GIOppI3fpti8Rill6jY_XpVGczJ_aQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 027318005A;
        Thu,  9 May 2019 13:55:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: futex: Fix FUTEX_WAKE_OP atomic ops with non-zero" failed to apply to 5.0-stable tree
To:     will.deacon@arm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 09 May 2019 19:55:34 +0200
Message-ID: <155742453474105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 84ff7a09c371bc7417eabfda19bf7f113ec917b6 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 8 Apr 2019 12:45:09 +0100
Subject: [PATCH] arm64: futex: Fix FUTEX_WAKE_OP atomic ops with non-zero
 result value

Rather embarrassingly, our futex() FUTEX_WAKE_OP implementation doesn't
explicitly set the return value on the non-faulting path and instead
leaves it holding the result of the underlying atomic operation. This
means that any FUTEX_WAKE_OP atomic operation which computes a non-zero
value will be reported as having failed. Regrettably, I wrote the buggy
code back in 2011 and it was upstreamed as part of the initial arm64
support in 2012.

The reasons we appear to get away with this are:

  1. FUTEX_WAKE_OP is rarely used and therefore doesn't appear to get
     exercised by futex() test applications

  2. If the result of the atomic operation is zero, the system call
     behaves correctly

  3. Prior to version 2.25, the only operation used by GLIBC set the
     futex to zero, and therefore worked as expected. From 2.25 onwards,
     FUTEX_WAKE_OP is not used by GLIBC at all.

Fix the implementation by ensuring that the return value is either 0
to indicate that the atomic operation completed successfully, or -EFAULT
if we encountered a fault when accessing the user mapping.

Cc: <stable@kernel.org>
Fixes: 6170a97460db ("arm64: Atomic operations")
Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index cccb83ad7fa8..e1d95f08f8e1 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -30,8 +30,8 @@ do {									\
 "	prfm	pstl1strm, %2\n"					\
 "1:	ldxr	%w1, %2\n"						\
 	insn "\n"							\
-"2:	stlxr	%w3, %w0, %2\n"						\
-"	cbnz	%w3, 1b\n"						\
+"2:	stlxr	%w0, %w3, %2\n"						\
+"	cbnz	%w0, 1b\n"						\
 "	dmb	ish\n"							\
 "3:\n"									\
 "	.pushsection .fixup,\"ax\"\n"					\
@@ -50,30 +50,30 @@ do {									\
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
-	int oldval = 0, ret, tmp;
+	int oldval, ret, tmp;
 	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
 
 	pagefault_disable();
 
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%w0, %w4",
+		__futex_atomic_op("mov	%w3, %w4",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%w0, %w1, %w4",
+		__futex_atomic_op("add	%w3, %w1, %w4",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%w0, %w1, %w4",
+		__futex_atomic_op("orr	%w3, %w1, %w4",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%w0, %w1, %w4",
+		__futex_atomic_op("and	%w3, %w1, %w4",
 				  ret, oldval, uaddr, tmp, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%w0, %w1, %w4",
+		__futex_atomic_op("eor	%w3, %w1, %w4",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	default:

