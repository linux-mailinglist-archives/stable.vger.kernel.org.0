Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAF458E77
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhKVMhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234308AbhKVMhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 07:37:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E05E860F25;
        Mon, 22 Nov 2021 12:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637584457;
        bh=rv+UI64AKuAZ8XwwN2v1gPvfsq7tRdBWxkYgwAbGOrM=;
        h=Subject:To:Cc:From:Date:From;
        b=V/ql6FNs0cMiCxphpEIa23oQ67EX8MIoemjBwet/2a2Vka59a7RhCjSXDRCJTK8Lp
         znLIv7h5a1O75SycaQt6NzmjZ/W3j/1SDQtSv92mmFuLI1ig4kNoc7M2fgLza+bgQn
         PFVUgZtiqVzudWBF70wRrmHGEUt5MxMDMaaHk42o=
Subject: FAILED: patch "[PATCH] s390/vdso: filter out -mstack-guard and -mstack-size" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Nov 2021 13:34:14 +0100
Message-ID: <1637584454164100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00b55eaf45549ce26424224d069a091c7e5d8bac Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Thu, 11 Nov 2021 10:58:26 +0100
Subject: [PATCH] s390/vdso: filter out -mstack-guard and -mstack-size

When CONFIG_VMAP_STACK is disabled, the user can enable CONFIG_STACK_CHECK,
which adds a stack overflow check to each C function in the kernel. This is
also done for functions in the vdso page. These functions are run in user
context and user stack sizes are usually different to what the kernel uses.
This might trigger the stack check although the stack size is valid.
Therefore filter the -mstack-guard and -mstack-size flags when compiling
vdso C files.

Cc: stable@kernel.org # 5.10+
Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 69c45f600273..609e3697324b 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -77,10 +77,12 @@ KBUILD_AFLAGS_DECOMPRESSOR += $(aflags-y)
 KBUILD_CFLAGS_DECOMPRESSOR += $(cflags-y)
 
 ifneq ($(call cc-option,-mstack-size=8192 -mstack-guard=128),)
-cflags-$(CONFIG_CHECK_STACK) += -mstack-size=$(STACK_SIZE)
-ifeq ($(call cc-option,-mstack-size=8192),)
-cflags-$(CONFIG_CHECK_STACK) += -mstack-guard=$(CONFIG_STACK_GUARD)
-endif
+  CC_FLAGS_CHECK_STACK := -mstack-size=$(STACK_SIZE)
+  ifeq ($(call cc-option,-mstack-size=8192),)
+    CC_FLAGS_CHECK_STACK += -mstack-guard=$(CONFIG_STACK_GUARD)
+  endif
+  export CC_FLAGS_CHECK_STACK
+  cflags-$(CONFIG_CHECK_STACK) += $(CC_FLAGS_CHECK_STACK)
 endif
 
 ifdef CONFIG_EXPOLINE
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index e7d911780935..9e2b95a222a9 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -8,8 +8,9 @@ ARCH_REL_TYPE_ABS += R_390_GOT|R_390_PLT
 include $(srctree)/lib/vdso/Makefile
 obj-vdso64 = vdso_user_wrapper.o note.o
 obj-cvdso64 = vdso64_generic.o getcpu.o
-CFLAGS_REMOVE_getcpu.o = -pg $(CC_FLAGS_FTRACE) $(CC_FLAGS_EXPOLINE)
-CFLAGS_REMOVE_vdso64_generic.o = -pg $(CC_FLAGS_FTRACE) $(CC_FLAGS_EXPOLINE)
+VDSO_CFLAGS_REMOVE := -pg $(CC_FLAGS_FTRACE) $(CC_FLAGS_EXPOLINE) $(CC_FLAGS_CHECK_STACK)
+CFLAGS_REMOVE_getcpu.o = $(VDSO_CFLAGS_REMOVE)
+CFLAGS_REMOVE_vdso64_generic.o = $(VDSO_CFLAGS_REMOVE)
 
 # Build rules
 

