Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2224C360C87
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhDOOvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhDOOu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01D386113B;
        Thu, 15 Apr 2021 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498232;
        bh=y7Cv+OVHuX4wPsXxP2+C6mwyl21cXJ8vYFpW84dFT1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hheCZu9b8PZSXZm9PFxl31W/3NOjUb8D2UxR5BW5s05np8NI6bUZ94ybyj28y4UIT
         Sh1udGRNSVNgOfctOyonC8nT5xl2SX/G5hOzBDCoZaYrXPn5/jMN/mfkWtuy02xCXV
         BzjWKv5Fk/a8xFV474zbK7vxQlXMgFKScD22u7DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 11/47] ia64: fix user_stack_pointer() for ptrace()
Date:   Thu, 15 Apr 2021 16:47:03 +0200
Message-Id: <20210415144413.836396126@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

commit 7ad1e366167837daeb93d0bacb57dee820b0b898 upstream.

ia64 has two stacks:

 - memory stack (or stack), pointed at by by r12

 - register backing store (register stack), pointed at by
   ar.bsp/ar.bspstore with complications around dirty
   register frame on CPU.

In [1] Dmitry noticed that PTRACE_GET_SYSCALL_INFO returns the register
stack instead memory stack.

The bug comes from the fact that user_stack_pointer() and
current_user_stack_pointer() don't return the same register:

  ulong user_stack_pointer(struct pt_regs *regs) { return regs->ar_bspstore; }
  #define current_user_stack_pointer() (current_pt_regs()->r12)

The change gets both back in sync.

I think ptrace(PTRACE_GET_SYSCALL_INFO) is the only affected user by
this bug on ia64.

The change fixes 'rt_sigreturn.gen.test' strace test where it was
observed initially.

Link: https://bugs.gentoo.org/769614 [1]
Link: https://lkml.kernel.org/r/20210331084447.2561532-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/include/asm/ptrace.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/ia64/include/asm/ptrace.h
+++ b/arch/ia64/include/asm/ptrace.h
@@ -53,8 +53,7 @@
 
 static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 {
-	/* FIXME: should this be bspstore + nr_dirty regs? */
-	return regs->ar_bspstore;
+	return regs->r12;
 }
 
 static inline int is_syscall_success(struct pt_regs *regs)
@@ -78,11 +77,6 @@ static inline long regs_return_value(str
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


