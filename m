Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0781AA401
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506218AbgDONQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:16:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60605 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506214AbgDONP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:15:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 42CDE5C01C1;
        Wed, 15 Apr 2020 09:15:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 09:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jkiwxL
        GSk5aUFrimHpB16cHocHLBQ0BO3i5I3O+6ql4=; b=ejJkWfaXexkBSVGmvd4d0s
        17/qfdUH7mUvp4+OzzP+2dOG9sSLp5EPhmlHbzSgvNQ8K+ncwe27SKrrXU/w10Tr
        4xpTa/5I9XlLqvX+rm2PvaBtGaxebgxBmiTxqepxVB8w8TFIvZN6fGL5/RzLhckq
        RAxL69Bz1HmPNRdmBo8tFoyDq5VT8OnGV7eKDc21FmXiAOA7Urdl55RNOg9DYXii
        7Ld0TzJZI18i8wALzoqoMSegqKUXvx/bCT+6k3lwymyypbouM4Emwr9uD5MTRt1Q
        X32QkF+DYAKiTqOpB/M2aErh9Mo0GxudKreD+1koTFviHPbMkVIOc8zwsnq23FUQ
        ==
X-ME-Sender: <xms:DAmXXjQIWSI3fifGN72xDM06Mp-ACBVQdC6HAXzRfq49lkJSjaB64Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DAmXXpArXOaPZ_Zyz4_W7530_9-BCTIsl_cWUKfcODLKa-mrY0EXTw>
    <xmx:DAmXXj3ZzK5eS5oCVYzM6LOKVreHeATUPgpTadAxRShmOtViKYKE1w>
    <xmx:DAmXXnVWoLEdIxpQrjb0pVRCEaSiqYBx6YGuCmBFTag4xndsmSoCXg>
    <xmx:DAmXXpgVzpOC5unW7oQ66xjTykWxLQH2l98i1ntmgc2OtLggi_1JTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8A933060061;
        Wed, 15 Apr 2020 09:15:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature standard" failed to apply to 4.19-stable tree
To:     courbet@google.com, mpe@ellerman.id.au, natechancellor@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 15:15:46 +0200
Message-ID: <158695654686139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 Mon Sep 17 00:00:00 2001
From: Clement Courbet <courbet@google.com>
Date: Mon, 30 Mar 2020 10:03:56 +0200
Subject: [PATCH] powerpc: Make setjmp/longjmp signature standard

Declaring setjmp()/longjmp() as taking longs makes the signature
non-standard, and makes clang complain. In the past, this has been
worked around by adding -ffreestanding to the compile flags.

The implementation looks like it only ever propagates the value
(in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
with integer parameters.

This allows removing -ffreestanding from the compilation flags.

Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Clement Courbet <courbet@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com

diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
index e9f81bb3f83b..f798e80e4106 100644
--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -7,7 +7,9 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *) __attribute__((returns_twice));
-extern void longjmp(long *, long) __attribute__((noreturn));
+typedef long jmp_buf[JMP_BUF_LEN];
+
+extern int setjmp(jmp_buf env) __attribute__((returns_twice));
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */
diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
index 378f6108a414..86380c69f5ce 100644
--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the linux kernel.
 #
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 obj-y				+= core.o crash.o core_$(BITS).o
 
 obj-$(CONFIG_PPC32)		+= relocate_32.o
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index c3842dbeb1b7..6f9cccea54f3 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Avoid clang warnings around longjmp/setjmp declarations
-subdir-ccflags-y := -ffreestanding
-
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n

