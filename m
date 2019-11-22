Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BEB106509
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfKVGVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfKVFwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A0B2070A;
        Fri, 22 Nov 2019 05:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401942;
        bh=8YvM9+J34BD6t+/ML1qLi5wu14hLYMK6CX1h3JsZ7+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO6GRh/0du4vSEAHIhLwh7IRG28H9kNH6oOFHTfM6762JC2nKIuE+zpByv2hxX7Yz
         TtqkYc1O2JHJi4GrtWszc7Yv6+9Q+r8sELONUB2UaTwQtICX8FKgRrGnU0RRFHm/Th
         ORFxkwct0gIfixPM1WWoAr/KoafzklAQ+bEMLeZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi Wang <wang.yi59@zte.com.cn>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 166/219] fork: fix some -Wmissing-prototypes warnings
Date:   Fri, 22 Nov 2019 00:48:18 -0500
Message-Id: <20191122054911.1750-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 108ede99e5335..44c6f15800ff5 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -39,6 +39,8 @@ void __noreturn do_task_dead(void);
 
 extern void proc_caches_init(void);
 
+extern void fork_init(void);
+
 extern void release_task(struct task_struct * p);
 
 #ifdef CONFIG_HAVE_COPY_THREAD_TLS
diff --git a/init/main.c b/init/main.c
index 020972fed1171..38a603f62b7bb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -105,7 +105,6 @@
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
-extern void fork_init(void);
 extern void radix_tree_init(void);
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index aef1430bdce0b..8cb5cd7c97e19 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -163,10 +163,6 @@ static inline void free_task_struct(struct task_struct *tsk)
 }
 #endif
 
-void __weak arch_release_thread_stack(unsigned long *stack)
-{
-}
-
 #ifndef CONFIG_ARCH_THREAD_STACK_ALLOCATOR
 
 /*
@@ -376,7 +372,6 @@ static void release_task_stack(struct task_struct *tsk)
 		return;  /* Better to leak the stack than to free prematurely */
 
 	account_kernel_stack(tsk, -1);
-	arch_release_thread_stack(tsk->stack);
 	free_thread_stack(tsk);
 	tsk->stack = NULL;
 #ifdef CONFIG_VMAP_STACK
-- 
2.20.1

