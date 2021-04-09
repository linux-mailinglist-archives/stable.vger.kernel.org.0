Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55735A7D5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhDIU1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhDIU1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A5D61108;
        Fri,  9 Apr 2021 20:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000053;
        bh=GyDd6shQy+0GGKIffU2lBkfQpFpuF6+LkS3D5mc8hjs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y36W/cVw4OkkykfTcG6K2EzZ7eeqXx4U1FQ4G1xVA4j12k9n7o5n0cFGTp9U9mVck
         onC49f16pwVz9NQcr267hGcwDhYINdu8vXRidW6SwTrM8RsPzdnljsxsu8fKFUDSGr
         /QLD0jKtYTuCPWmdxtMfRQZ74smPmWgomZTG62hY=
Date:   Fri, 09 Apr 2021 13:27:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ldv@altlinux.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, slyfox@gentoo.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 11/16] ia64: fix user_stack_pointer() for ptrace()
Message-ID: <20210409202732.BFWhCou9S%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
