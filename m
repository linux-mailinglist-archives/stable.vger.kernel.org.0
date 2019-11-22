Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA81061E3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfKVF5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfKVF5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FAEF20731;
        Fri, 22 Nov 2019 05:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402253;
        bh=q/nXUueN+PhY2qiBQi4R8Z9iq0FW4Qo7pZkcszenzB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjdHVcS1Np72Bd+fVIUQafMA6yIIjHzigrNBZSr8yFqNKuxT8rlBQtg6kd68XSWLc
         cO0CkBMp0eOiljq0qUoCTR8p/HjI98Rj2mh+PoiFK9KHICvBxh+u4r7jmgLYA2iVoC
         TSONfV9thI3WqDcUdS0bycB9LWMGtxc8vUAnIdnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi Wang <wang.yi59@zte.com.cn>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 095/127] fork: fix some -Wmissing-prototypes warnings
Date:   Fri, 22 Nov 2019 00:55:13 -0500
Message-Id: <20191122055544.3299-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Wang <wang.yi59@zte.com.cn>

[ Upstream commit fb5bf31722d0805a3f394f7d59f2e8cd07acccb7 ]

We get a warning when building kernel with W=1:

  kernel/fork.c:167:13: warning: no previous prototype for `arch_release_thread_stack' [-Wmissing-prototypes]
  kernel/fork.c:779:13: warning: no previous prototype for `fork_init' [-Wmissing-prototypes]

Add the missing declaration in head file to fix this.

Also, remove arch_release_thread_stack() completely because no arch
seems to implement it since bb9d81264 (arch: remove tile port).

Link: http://lkml.kernel.org/r/1542170087-23645-1-git-send-email-wang.yi59@zte.com.cn
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task.h | 2 ++
 init/main.c                | 1 -
 kernel/fork.c              | 5 -----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index a74ec619ac510..11b4fba82950f 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -39,6 +39,8 @@ void __noreturn do_task_dead(void);
 
 extern void proc_caches_init(void);
 
+extern void fork_init(void);
+
 extern void release_task(struct task_struct * p);
 
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
diff --git a/init/main.c b/init/main.c
index 51067e2db509d..b1ab36fe1a55c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -98,7 +98,6 @@
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
-extern void fork_init(void);
 extern void radix_tree_init(void);
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 3352fdbd5e20d..3d9d6a28e21d9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -162,10 +162,6 @@ static inline void free_task_struct(struct task_struct *tsk)
 }
 #endif
 
-void __weak arch_release_thread_stack(unsigned long *stack)
-{
-}
-
 #ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
 
 /*
@@ -348,7 +344,6 @@ static void release_task_stack(struct task_struct *tsk)
 		return;  /* Better to leak the stack than to free prematurely */
 
 	account_kernel_stack(tsk, -1);
-	arch_release_thread_stack(tsk->stack);
 	free_thread_stack(tsk);
 	tsk->stack = NULL;
 #ifdef CONFIG_VMAP_STACK
-- 
2.20.1

