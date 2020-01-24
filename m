Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6EE147FBE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbgAXLEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732464AbgAXLEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:04:42 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051AA2075D;
        Fri, 24 Jan 2020 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863881;
        bh=rMWAxS/vHH7zDOk1RcRlWDp8nPaY8lRMej4NTZauPEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfpwisQcVAV110U1V4qB2NMg37/CxLqNoFSZP1Ke870muOEw2f1o2YdAPMObqE4Bp
         M6Qgp8KFtXFeU7x6JvHu1uzO2AkQ0VHDDyZxQsPD048tKUUm4qfouXnkib7jRWMzY2
         PlHUyVK3fqtfp03pn/XFgVwWATxljowFI94L8EXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/639] fork,memcg: fix crash in free_thread_stack on memcg charge fail
Date:   Fri, 24 Jan 2020 10:24:30 +0100
Message-Id: <20200124093059.872368532@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 5eed6f1dff87bfb5e545935def3843edf42800f2 ]

Commit 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting") will
result in fork failing if allocating a kernel stack for a task in
dup_task_struct exceeds the kernel memory allowance for that cgroup.

Unfortunately, it also results in a crash.

This is due to the code jumping to free_stack and calling
free_thread_stack when the memcg kernel stack charge fails, but without
tsk->stack pointing at the freshly allocated stack.

This in turn results in the vfree_atomic in free_thread_stack oopsing
with a backtrace like this:

#5 [ffffc900244efc88] die at ffffffff8101f0ab
 #6 [ffffc900244efcb8] do_general_protection at ffffffff8101cb86
 #7 [ffffc900244efce0] general_protection at ffffffff818ff082
    [exception RIP: llist_add_batch+7]
    RIP: ffffffff8150d487  RSP: ffffc900244efd98  RFLAGS: 00010282
    RAX: 0000000000000000  RBX: ffff88085ef55980  RCX: 0000000000000000
    RDX: ffff88085ef55980  RSI: 343834343531203a  RDI: 343834343531203a
    RBP: ffffc900244efd98   R8: 0000000000000001   R9: ffff8808578c3600
    R10: 0000000000000000  R11: 0000000000000001  R12: ffff88029f6c21c0
    R13: 0000000000000286  R14: ffff880147759b00  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffffc900244efda0] vfree_atomic at ffffffff811df2c7
 #9 [ffffc900244efdb8] copy_process at ffffffff81086e37
#10 [ffffc900244efe98] _do_fork at ffffffff810884e0
#11 [ffffc900244eff10] sys_vfork at ffffffff810887ff
#12 [ffffc900244eff20] do_syscall_64 at ffffffff81002a43
    RIP: 000000000049b948  RSP: 00007ffcdb307830  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 0000000000896030  RCX: 000000000049b948
    RDX: 0000000000000000  RSI: 00007ffcdb307790  RDI: 00000000005d7421
    RBP: 000000000067370f   R8: 00007ffcdb3077b0   R9: 000000000001ed00
    R10: 0000000000000008  R11: 0000000000000246  R12: 0000000000000040
    R13: 000000000000000f  R14: 0000000000000000  R15: 000000000088d018
    ORIG_RAX: 000000000000003a  CS: 0033  SS: 002b

The simplest fix is to assign tsk->stack right where it is allocated.

Link: http://lkml.kernel.org/r/20181214231726.7ee4843c@imladris.surriel.com
Fixes: 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting")
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8cb5cd7c97e19..5718c5decc55b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -230,8 +230,10 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 	 * free_thread_stack() can be called in interrupt context,
 	 * so cache the vm_struct.
 	 */
-	if (stack)
+	if (stack) {
 		tsk->stack_vm_area = find_vm_area(stack);
+		tsk->stack = stack;
+	}
 	return stack;
 #else
 	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
@@ -268,7 +270,10 @@ static struct kmem_cache *thread_stack_cache;
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk,
 						  int node)
 {
-	return kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
+	unsigned long *stack;
+	stack = kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
+	tsk->stack = stack;
+	return stack;
 }
 
 static void free_thread_stack(struct task_struct *tsk)
-- 
2.20.1



