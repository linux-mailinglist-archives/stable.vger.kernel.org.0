Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6211F98C
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfLORLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:11:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41347 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfLORLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:11:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ECB3A222E3;
        Sun, 15 Dec 2019 12:11:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 12:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oF+7ta
        oYHKGmWLTblb6GlVzkuiVWYx5efN10rVxnrhw=; b=CdNeHRhmaNZBSljzlmEkPc
        a75OanLi8Lo0WEVMofXpy67zPFYG214QP/kXEqbvrfYQEph1T+9iN0CLNEzy2ib3
        s1lfYby1FMyPzkSEvINPcabHwHMhEUQFqBCb88CpMquw/63TBo8XIvxhxDzvNUre
        auF4xwQom8GKk793hD3KLTkRyEMcuRaYiYPPRKAxSTdj3FmMXK5shS3aa0k1xp2P
        hM5zZbkP1nlFRk/Jy+beu2yTmInlGuJlOY+s+aUpcfLlSY+Z00+9p2gaWFe39Iea
        TUm09SMSFDPPizNMVsSJiT2j5pzTsJhV6FCG3OMJJC7bEHp5oRFDYZzC36W74x+w
        ==
X-ME-Sender: <xms:T2n2XXEw76Na_EG9bJB_xndsacBwQx3ZX76oJfrFnaXbyVZhHZ4KIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:T2n2XbR11Xz1y2-CZl9N8g-3wAU1MhiEK0HpYJNny1iLxlEjHrA5qg>
    <xmx:T2n2XeTxWUoE5q1ffogoOnhKVH4InMm6h0y54Ns-LyD_9xItuuHnJw>
    <xmx:T2n2XZdk5-IqPC9v43b9BbdhwsoiQlxGCPDPknbOmzZ6kUbqzlRZ9Q>
    <xmx:T2n2XfueZmaHovuNCD64uquZtHAOcCpLCTOAOUV7i76ixqfdVGjOSw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7255E8005B;
        Sun, 15 Dec 2019 12:11:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Avoid clang warnings around setjmp and longjmp" failed to apply to 4.14-stable tree
To:     natechancellor@gmail.com, mpe@ellerman.id.au,
        ndesaulniers@google.com, segher@kernel.crashing.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 18:11:30 +0100
Message-ID: <157642989089107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c9029ef9c95765e7b63c4d9aa780674447db1ec0 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon, 18 Nov 2019 21:57:11 -0700
Subject: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp

Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
setjmp is used") disabled -Wbuiltin-requires-header because of a
warning about the setjmp and longjmp declarations.

r367387 in clang added another diagnostic around this, complaining
that there is no jmp_buf declaration.

  In file included from ../arch/powerpc/xmon/xmon.c:47:
  ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
  built-in function 'setjmp' requires the declaration of the 'jmp_buf'
  type, commonly provided in the header <setjmp.h>.
  [-Werror,-Wincomplete-setjmp-declaration]
  extern long setjmp(long *);
              ^
  ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
  built-in function 'longjmp' requires the declaration of the 'jmp_buf'
  type, commonly provided in the header <setjmp.h>.
  [-Werror,-Wincomplete-setjmp-declaration]
  extern void longjmp(long *, long);
              ^
  2 errors generated.

We are not using the standard library's longjmp/setjmp implementations
for obvious reasons; make this clear to clang by using -ffreestanding
on these files.

Cc: stable@vger.kernel.org # 4.14+
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191119045712.39633-3-natechancellor@gmail.com

diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
index 16c1c5a19519..378f6108a414 100644
--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -3,8 +3,8 @@
 # Makefile for the linux kernel.
 #
 
-# Disable clang warning for using setjmp without setjmp.h header
-CFLAGS_crash.o		+= $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+CFLAGS_crash.o += -ffreestanding
 
 obj-y				+= core.o crash.o core_$(BITS).o
 
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index f142570ad860..c3842dbeb1b7 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Disable clang warning for using setjmp without setjmp.h header
-subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
+# Avoid clang warnings around longjmp/setjmp declarations
+subdir-ccflags-y := -ffreestanding
 
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n

