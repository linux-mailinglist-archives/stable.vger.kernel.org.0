Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1924FA60
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHXIgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgHXIgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:36:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA1C206F0;
        Mon, 24 Aug 2020 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258174;
        bh=TMcgGpj0HK5jtl7J2jbGq1Bs+4VVnmcgR1udoAv4ziQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO4XS+GqaP2sMJvZYDLFTuY2+QvtPHMX+ERdJQxuQZsJhiHZnhXG0+m6FSYOzgdWf
         t/zjBZQ4hUI1+FJPIDJmFcJw26D+b6VCy7ARtwJhipp9wEl7PF0wq2bOoBNtBgMwXk
         zHMrcmCEbfAQ2AeDCYYl4kRPs0ucGSNqOpxR0xA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 102/148] watch_queue: Limit the number of watches a user can hold
Date:   Mon, 24 Aug 2020 10:30:00 +0200
Message-Id: <20200824082418.916968691@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 29e44f4535faa71a70827af3639b5e6762d8f02a ]

Impose a limit on the number of watches that a user can hold so that
they can't use this mechanism to fill up all the available memory.

This is done by putting a counter in user_struct that's incremented when
a watch is allocated and decreased when it is released.  If the number
exceeds the RLIMIT_NOFILE limit, the watch is rejected with EAGAIN.

This can be tested by the following means:

 (1) Create a watch queue and attach it to fd 5 in the program given - in
     this case, bash:

	keyctl watch_session /tmp/nlog /tmp/gclog 5 bash

 (2) In the shell, set the maximum number of files to, say, 99:

	ulimit -n 99

 (3) Add 200 keyrings:

	for ((i=0; i<200; i++)); do keyctl newring a$i @s || break; done

 (4) Try to watch all of the keyrings:

	for ((i=0; i<200; i++)); do echo $i; keyctl watch_add 5 %:a$i || break; done

     This should fail when the number of watches belonging to the user hits
     99.

 (5) Remove all the keyrings and all of those watches should go away:

	for ((i=0; i<200; i++)); do keyctl unlink %:a$i; done

 (6) Kill off the watch queue by exiting the shell spawned by
     watch_session.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/user.h | 3 +++
 kernel/watch_queue.c       | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 917d88edb7b9d..a8ec3b6093fcb 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -36,6 +36,9 @@ struct user_struct {
     defined(CONFIG_NET) || defined(CONFIG_IO_URING)
 	atomic_long_t locked_vm;
 #endif
+#ifdef CONFIG_WATCH_QUEUE
+	atomic_t nr_watches;	/* The number of watches this user currently has */
+#endif
 
 	/* Miscellaneous per-user rate limit */
 	struct ratelimit_state ratelimit;
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index f74020f6bd9d5..0ef8f65bd2d71 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -393,6 +393,7 @@ static void free_watch(struct rcu_head *rcu)
 	struct watch *watch = container_of(rcu, struct watch, rcu);
 
 	put_watch_queue(rcu_access_pointer(watch->queue));
+	atomic_dec(&watch->cred->user->nr_watches);
 	put_cred(watch->cred);
 }
 
@@ -452,6 +453,13 @@ int add_watch_to_object(struct watch *watch, struct watch_list *wlist)
 	watch->cred = get_current_cred();
 	rcu_assign_pointer(watch->watch_list, wlist);
 
+	if (atomic_inc_return(&watch->cred->user->nr_watches) >
+	    task_rlimit(current, RLIMIT_NOFILE)) {
+		atomic_dec(&watch->cred->user->nr_watches);
+		put_cred(watch->cred);
+		return -EAGAIN;
+	}
+
 	spin_lock_bh(&wqueue->lock);
 	kref_get(&wqueue->usage);
 	kref_get(&watch->usage);
-- 
2.25.1



