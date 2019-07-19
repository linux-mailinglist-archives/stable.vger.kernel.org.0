Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B622B6DEAB
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfGSEaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfGSEFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC900218A3;
        Fri, 19 Jul 2019 04:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509118;
        bh=iZXdCxrNKNxAbyJ1PBwAC67lJ7ZrOeEjgLlg4ZJzvX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiB1x9FamqQqgtvNVb3TtPbJLYLnmFypwfchH+p0esEle0fB/bX0/FvyNvl2Dv0Dg
         dXI55G3EN27OvGMT+Lgo2d4hl5cqSKWX+IYMPIwM6q4J4Y1+OqDSJlV5ulJoi4GRFg
         T7Tm1AXmGNEBE75hijd67/7qBkZE9aKIJYL738oE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 079/141] um: Silence lockdep complaint about mmap_sem
Date:   Fri, 19 Jul 2019 00:01:44 -0400
Message-Id: <20190719040246.15945-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 80bf6ceaf9310b3f61934c69b382d4912deee049 ]

When we get into activate_mm(), lockdep complains that we're doing
something strange:

    WARNING: possible circular locking dependency detected
    5.1.0-10252-gb00152307319-dirty #121 Not tainted
    ------------------------------------------------------
    inside.sh/366 is trying to acquire lock:
    (____ptrval____) (&(&p->alloc_lock)->rlock){+.+.}, at: flush_old_exec+0x703/0x8d7

    but task is already holding lock:
    (____ptrval____) (&mm->mmap_sem){++++}, at: flush_old_exec+0x6c5/0x8d7

    which lock already depends on the new lock.

    the existing dependency chain (in reverse order) is:

    -> #1 (&mm->mmap_sem){++++}:
           [...]
           __lock_acquire+0x12ab/0x139f
           lock_acquire+0x155/0x18e
           down_write+0x3f/0x98
           flush_old_exec+0x748/0x8d7
           load_elf_binary+0x2ca/0xddb
           [...]

    -> #0 (&(&p->alloc_lock)->rlock){+.+.}:
           [...]
           __lock_acquire+0x12ab/0x139f
           lock_acquire+0x155/0x18e
           _raw_spin_lock+0x30/0x83
           flush_old_exec+0x703/0x8d7
           load_elf_binary+0x2ca/0xddb
           [...]

    other info that might help us debug this:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(&mm->mmap_sem);
                                   lock(&(&p->alloc_lock)->rlock);
                                   lock(&mm->mmap_sem);
      lock(&(&p->alloc_lock)->rlock);

     *** DEADLOCK ***

    2 locks held by inside.sh/366:
     #0: (____ptrval____) (&sig->cred_guard_mutex){+.+.}, at: __do_execve_file+0x12d/0x869
     #1: (____ptrval____) (&mm->mmap_sem){++++}, at: flush_old_exec+0x6c5/0x8d7

    stack backtrace:
    CPU: 0 PID: 366 Comm: inside.sh Not tainted 5.1.0-10252-gb00152307319-dirty #121
    Stack:
     [...]
    Call Trace:
     [<600420de>] show_stack+0x13b/0x155
     [<6048906b>] dump_stack+0x2a/0x2c
     [<6009ae64>] print_circular_bug+0x332/0x343
     [<6009c5c6>] check_prev_add+0x669/0xdad
     [<600a06b4>] __lock_acquire+0x12ab/0x139f
     [<6009f3d0>] lock_acquire+0x155/0x18e
     [<604a07e0>] _raw_spin_lock+0x30/0x83
     [<60151e6a>] flush_old_exec+0x703/0x8d7
     [<601a8eb8>] load_elf_binary+0x2ca/0xddb
     [...]

I think it's because in exec_mmap() we have

	down_read(&old_mm->mmap_sem);
...
        task_lock(tsk);
...
	activate_mm(active_mm, mm);
	(which does down_write(&mm->mmap_sem))

I'm not really sure why lockdep throws in the whole knowledge
about the task lock, but it seems that old_mm and mm shouldn't
ever be the same (and it doesn't deadlock) so tell lockdep that
they're different.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 9f4b4bb78120..00cefd33afdd 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -52,7 +52,7 @@ static inline void activate_mm(struct mm_struct *old, struct mm_struct *new)
 	 * when the new ->mm is used for the first time.
 	 */
 	__switch_mm(&new->context.id);
-	down_write(&new->mmap_sem);
+	down_write_nested(&new->mmap_sem, 1);
 	uml_setup_stubs(new);
 	up_write(&new->mmap_sem);
 }
-- 
2.20.1

