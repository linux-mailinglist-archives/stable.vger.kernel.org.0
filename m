Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC50113220
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbfLDSGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbfLDSGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:01 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D87420675;
        Wed,  4 Dec 2019 18:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482761;
        bh=q/nXUueN+PhY2qiBQi4R8Z9iq0FW4Qo7pZkcszenzB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVahyrZyqAHCcqgISyaTbr1eKiOTjzW/Om4MaA1L3mqGQx4awFIQs/9aUO1pqI2dv
         SGMwCwGrCFalZ5XLUznYndFQbngNFjQTC+zjx54e+gdcS7xVwj9wtk9ZOP+suUSFi7
         yNbFRNVWQjIHdgv8n2MG4/VFzssbipXvBIMTwljI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Wang <wang.yi59@zte.com.cn>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/209] fork: fix some -Wmissing-prototypes warnings
Date:   Wed,  4 Dec 2019 18:55:35 +0100
Message-Id: <20191204175331.534849390@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



