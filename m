Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864DB11F98A
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLORLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:11:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52123 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfLORLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:11:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7E968222E3;
        Sun, 15 Dec 2019 12:11:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 12:11:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lHYr3F
        5NAhJTnTc3OM6RgyNYaWMnvsEnNoz8rv7wBgc=; b=Ipjs9lq4mko/CoNW8zg5AR
        9RTdzgwAl6HbDML//1wDePJ6IdXwIWRsmh9LR2D274BDCyxcHmr1nixUp1gnOsx9
        BDsl8GChHVrEtLs+mQOznqQFCZESD3ms/j7FghxK/FtYou5J4Pm+YXx9qRmGP+zx
        GYkVSsYjbz6O5XUbfTUHZy7mFLWQ1ObacYScgfLzlPeOLENbcAMnepCWqkUUTkmo
        sKH4I0NNomiwSCftQn/BlmhLVf50bm8YyXjDbMbFah/UjYhs3JIkyFE2WT9gHsOV
        SLnnNnKEDY9RiN05mfhjz7YNomQ0L5v8UE+jLSctWETKbQBt3xPQzYgOuswJRqxQ
        ==
X-ME-Sender: <xms:Smn2XeMFPMqg-erx59nxb-DPLHTpcmY8qMajSeHlN3Q5x4zOw7Or7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Smn2XUU0CZ5U26_DA19AASS6tsomIubaxbq-MxvEM2xUW_40YJnTfg>
    <xmx:Smn2XflmbbuKDXSaWrjBUHZSK1I3GLVzADxSPR9uLENenlCGRr16Vg>
    <xmx:Smn2XUvLEBFTmG3dtcoUIx2SD22OYZxdGpRluxbBWQrRtC607_zL3Q>
    <xmx:Smn2XRowDcoE5_Bu0v2GW8q9LUt7xEtWXcZkQ-IReGycmc3CPMgcbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2067D30600AB;
        Sun, 15 Dec 2019 12:11:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Avoid clang warnings around setjmp and longjmp" failed to apply to 4.19-stable tree
To:     natechancellor@gmail.com, mpe@ellerman.id.au,
        ndesaulniers@google.com, segher@kernel.crashing.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 18:11:29 +0100
Message-ID: <157642988918234@kroah.com>
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

