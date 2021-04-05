Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB5354433
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhDEQEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241953AbhDEQEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D867613CB;
        Mon,  5 Apr 2021 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638668;
        bh=FmeEp9DlJn1O6l/gDwyedOEMenAYz7+FkaYusJwSGo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPERcj/ZTr60rXzkvluvhEXJVzd8pYT7+OxCeUS4DoD0FqWN9Q7vFqwhpODdECW+p
         vxjZhp8bQj1nuMw+k+fEXeR9lFJ81rKW83ajbYhP+Nw+K0JrFdTEw0hRvcHuN+N2Ov
         MPPmo7iIrGLOAGnqxy3eHHHcdNfYnT0ezN981mhbHwxpgo7qdWul8OLGR5y7WwbyIx
         Ahh2b/f4w0OfyXF2o7nJwGbvWwCJZrXXPZ/H8g69k0r31mhdDMFo6iZne06jjIJOA9
         SeqWb7SL/rpINaRRHPbjbJ7Mgk7ZMfhNbaENmay3WX46UT8rN1cO3gnZzO5ihChRPc
         BxUVlG+x1y4Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        syzbot+e74b94fe601ab9552d69@syzkaller.appspotmail.com,
        Arnd Bergman <arnd@arndb.de>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 20/22] riscv: evaluate put_user() arg before enabling user access
Date:   Mon,  5 Apr 2021 12:04:03 -0400
Message-Id: <20210405160406.268132-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 285a76bb2cf51b0c74c634f2aaccdb93e1f2a359 ]

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

--
Changes since v1:
- fixed formatting and updated the patch description with more info

Changes since v2:
- fixed commenting on __put_user() (schwab@linux-m68k.org)

Change since v3:
- fixed RFC in patch title. Should be ready to merge.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/uaccess.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 824b2c9da75b..f944062c9d99 100644
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
-- 
2.30.2

