Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC99353F67
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbhDEJL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238871AbhDEJLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026C2613B0;
        Mon,  5 Apr 2021 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613872;
        bh=TLfNtit7mxypnT50eV012j8QyfYlr8lSJ2xARyOlL5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQBdoiCpGYLZoN2OdWBU0Sy2glJLX3CyiC4jX5PN9qh4No4o/BT6iacxLyNvwHEO4
         qJ4ubhtt7fB8av7olLG+b+ZZkxPQyu+DHkuXMytL36M1jtpJHhizR5R9YjR9gtWhVp
         8XJNzo/cs99wKLBL4fU8HyHyG4cyNHXmMtxfu4os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        syzbot+e74b94fe601ab9552d69@syzkaller.appspotmail.com,
        Arnd Bergman <arnd@arndb.de>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 124/126] riscv: evaluate put_user() arg before enabling user access
Date:   Mon,  5 Apr 2021 10:54:46 +0200
Message-Id: <20210405085035.132419500@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit 285a76bb2cf51b0c74c634f2aaccdb93e1f2a359 upstream.

The <asm/uaccess.h> header has a problem with put_user(a, ptr) if
the 'a' is not a simple variable, such as a function. This can lead
to the compiler producing code as so:

1:	enable_user_access()
2:	evaluate 'a' into register 'r'
3:	put 'r' to 'ptr'
4:	disable_user_acess()

The issue is that 'a' is now being evaluated with the user memory
protections disabled. So we try and force the evaulation by assigning
'x' to __val at the start, and hoping the compiler barriers in
 enable_user_access() do the job of ordering step 2 before step 1.

This has shown up in a bug where 'a' sleeps and thus schedules out
and loses the SR_SUM flag. This isn't sufficient to fully fix, but
should reduce the window of opportunity. The first instance of this
we found is in scheudle_tail() where the code does:

$ less -N kernel/sched/core.c

4263  if (current->set_child_tid)
4264         put_user(task_pid_vnr(current), current->set_child_tid);

Here, the task_pid_vnr(current) is called within the block that has
enabled the user memory access. This can be made worse with KASAN
which makes task_pid_vnr() a rather large call with plenty of
opportunity to sleep.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reported-by: syzbot+e74b94fe601ab9552d69@syzkaller.appspotmail.com
Suggested-by: Arnd Bergman <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
Changes since v1:
- fixed formatting and updated the patch description with more info

Changes since v2:
- fixed commenting on __put_user() (schwab@linux-m68k.org)

Change since v3:
- fixed RFC in patch title. Should be ready to merge.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/include/asm/uaccess.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -306,7 +306,9 @@ do {								\
  * data types like structures or arrays.
  *
  * @ptr must have pointer-to-simple-variable type, and @x must be assignable
- * to the result of dereferencing @ptr.
+ * to the result of dereferencing @ptr. The value of @x is copied to avoid
+ * re-ordering where @x is evaluated inside the block that enables user-space
+ * access (thus bypassing user space protection if @x is a function).
  *
  * Caller must check the pointer with access_ok() before calling this
  * function.
@@ -316,12 +318,13 @@ do {								\
 #define __put_user(x, ptr)					\
 ({								\
 	__typeof__(*(ptr)) __user *__gu_ptr = (ptr);		\
+	__typeof__(*__gu_ptr) __val = (x);			\
 	long __pu_err = 0;					\
 								\
 	__chk_user_ptr(__gu_ptr);				\
 								\
 	__enable_user_access();					\
-	__put_user_nocheck(x, __gu_ptr, __pu_err);		\
+	__put_user_nocheck(__val, __gu_ptr, __pu_err);		\
 	__disable_user_access();				\
 								\
 	__pu_err;						\


