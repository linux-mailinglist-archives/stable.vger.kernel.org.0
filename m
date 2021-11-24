Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05645C619
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351529AbhKXOFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353761AbhKXOAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95E2632FF;
        Wed, 24 Nov 2021 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759376;
        bh=lB1YH8Cq42+K4nVaMcthN0NQY/xt9i492ijKuYsf5/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRG/535b7zq/6di1KOAzYhddDcMGa8Ev6kMlC1Z8nGyr/y1WAMJj23knwH41dWGPv
         QKAUkQyXM9+gOB06DWuW5UpYNcW8zDkX7SU430T7XUnQNVP/QgIlY/960ffNtDRkuu
         9Zji+oplYnZixdOgPwdBHNEeTZsuVOcuL1ngjoDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@kernel.org
Subject: [PATCH 5.15 219/279] s390/vdso: filter out -mstack-guard and -mstack-size
Date:   Wed, 24 Nov 2021 12:58:26 +0100
Message-Id: <20211124115726.306720039@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 00b55eaf45549ce26424224d069a091c7e5d8bac upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile               |   10 ++++++----
 arch/s390/kernel/vdso64/Makefile |    5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -79,10 +79,12 @@ KBUILD_AFLAGS_DECOMPRESSOR += $(aflags-y
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
 


