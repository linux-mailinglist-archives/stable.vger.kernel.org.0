Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079BD350B62
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 02:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhDAAtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 20:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhDAAtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 20:49:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F2E61056;
        Thu,  1 Apr 2021 00:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617238160;
        bh=hkERKroSLtWgicc7NTS7LStZqOZAcGul2tY9EzucowY=;
        h=Date:From:To:Subject:From;
        b=xXBo+75Y7cDSlRAQqmRnyLL1YMxeJ34w2Jl/nasGPmh627ri2A25OTrQWJzjsUMCc
         /3RYebL9088otqEYb04xG0Ih+l05ZVehAyTFGP9HWOwzB6nKdMqlLlgiUAG5pqDrh1
         hm9k/WM3MKE55CQfez41Nu4J6Z3btixlCocHvTws=
Date:   Wed, 31 Mar 2021 17:49:19 -0700
From:   akpm@linux-foundation.org
To:     ldv@altlinux.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        slyfox@gentoo.org, stable@vger.kernel.org
Subject:  + ia64-fix-user_stack_pointer-for-ptrace.patch added to
 -mm tree
Message-ID: <20210401004919.SClvSTdsD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ia64: fix user_stack_pointer() for ptrace()
has been added to the -mm tree.  Its filename is
     ia64-fix-user_stack_pointer-for-ptrace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-user_stack_pointer-for-ptrace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-user_stack_pointer-for-ptrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: fix user_stack_pointer() for ptrace()

ia64 has two stacks:
- memory stack (or stack), pointed at by by r12
- register backing store (register stack), pointed at
  ar.bsp/ar.bspstore with complications around dirty
  register frame on CPU.

In https://bugs.gentoo.org/769614 Dmitry noticed that
PTRACE_GET_SYSCALL_INFO returns register stack instead
memory stack.

The bug comes from the fact that user_stack_pointer() and
current_user_stack_pointer() don't return the same register:

  ulong user_stack_pointer(struct pt_regs *regs) { return regs->ar_bspstore; }
  #define current_user_stack_pointer() (current_pt_regs()->r12)

The change gets both back in sync.

I think ptrace(PTRACE_GET_SYSCALL_INFO) is the only affected user
by this bug on ia64.

The change fixes 'rt_sigreturn.gen.test' strace test where
it was observed initially.

Link: https://lkml.kernel.org/r/20210331084447.2561532-1-slyfox@gentoo.org
Link: https://bugs.gentoo.org/769614
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/ptrace.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/ia64/include/asm/ptrace.h~ia64-fix-user_stack_pointer-for-ptrace
+++ a/arch/ia64/include/asm/ptrace.h
@@ -54,8 +54,7 @@
 
 static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 {
-	/* FIXME: should this be bspstore + nr_dirty regs? */
-	return regs->ar_bspstore;
+	return regs->r12;
 }
 
 static inline int is_syscall_success(struct pt_regs *regs)
@@ -79,11 +78,6 @@ static inline long regs_return_value(str
 	unsigned long __ip = instruction_pointer(regs);			\
 	(__ip & ~3UL) + ((__ip & 3UL) << 2);				\
 })
-/*
- * Why not default?  Because user_stack_pointer() on ia64 gives register
- * stack backing store instead...
- */
-#define current_user_stack_pointer() (current_pt_regs()->r12)
 
   /* given a pointer to a task_struct, return the user's pt_regs */
 # define task_pt_regs(t)		(((struct pt_regs *) ((char *) (t) + IA64_STK_OFFSET)) - 1)
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-user_stack_pointer-for-ptrace.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

