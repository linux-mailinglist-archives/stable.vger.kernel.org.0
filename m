Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D8F18B842
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgCSNmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgCSNmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:42:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7076207FC;
        Thu, 19 Mar 2020 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584625372;
        bh=PsAxtC4FjGDQ24yM5CKq8AIgU9920s16YPXXRv9kz5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWTGHnycHKW88RlF4s8BXWKQnYQdLOK7gfw22km2/V/SlW5+58TUyB1xjDImWZVM8
         J8e84Tou4YvMN3dNzB+1DUdf3kwILzsOmuku0Fr/OhhyIMSwD3b4Vn4FrWBmVahqMe
         YKiO660RteN38czxC5PQ3VVRJwW3glm1lhV4qWOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Philip Li <philip.li@intel.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 4.14 91/99] signal: avoid double atomic counter increments for user accounting
Date:   Thu, 19 Mar 2020 14:04:09 +0100
Message-Id: <20200319124006.961377061@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fda31c50292a5062332fa0343c084bd9f46604d9 ]

When queueing a signal, we increment both the users count of pending
signals (for RLIMIT_SIGPENDING tracking) and we increment the refcount
of the user struct itself (because we keep a reference to the user in
the signal structure in order to correctly account for it when freeing).

That turns out to be fairly expensive, because both of them are atomic
updates, and particularly under extreme signal handling pressure on big
machines, you can get a lot of cache contention on the user struct.
That can then cause horrid cacheline ping-pong when you do these
multiple accesses.

So change the reference counting to only pin the user for the _first_
pending signal, and to unpin it when the last pending signal is
dequeued.  That means that when a user sees a lot of concurrent signal
queuing - which is the only situation when this matters - the only
atomic access needed is generally the 'sigpending' count update.

This was noticed because of a particularly odd timing artifact on a
dual-socket 96C/192T Cascade Lake platform: when you get into bad
contention, on that machine for some reason seems to be much worse when
the contention happens in the upper 32-byte half of the cacheline.

As a result, the kernel test robot will-it-scale 'signal1' benchmark had
an odd performance regression simply due to random alignment of the
'struct user_struct' (and pointed to a completely unrelated and
apparently nonsensical commit for the regression).

Avoiding the double increments (and decrements on the dequeueing side,
of course) makes for much less contention and hugely improved
performance on that will-it-scale microbenchmark.

Quoting Feng Tang:

 "It makes a big difference, that the performance score is tripled! bump
  from original 17000 to 54000. Also the gap between 5.0-rc6 and
  5.0-rc6+Jiri's patch is reduced to around 2%"

[ The "2% gap" is the odd cacheline placement difference on that
  platform: under the extreme contention case, the effect of which half
  of the cacheline was hot was 5%, so with the reduced contention the
  odd timing artifact is reduced too ]

It does help in the non-contended case too, but is not nearly as
noticeable.

Reported-and-tested-by: Feng Tang <feng.tang@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Philip Li <philip.li@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8fee1f2eba2f9..c066168f88541 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -379,27 +379,32 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimi
 {
 	struct sigqueue *q = NULL;
 	struct user_struct *user;
+	int sigpending;
 
 	/*
 	 * Protect access to @t credentials. This can go away when all
 	 * callers hold rcu read lock.
+	 *
+	 * NOTE! A pending signal will hold on to the user refcount,
+	 * and we get/put the refcount only when the sigpending count
+	 * changes from/to zero.
 	 */
 	rcu_read_lock();
-	user = get_uid(__task_cred(t)->user);
-	atomic_inc(&user->sigpending);
+	user = __task_cred(t)->user;
+	sigpending = atomic_inc_return(&user->sigpending);
+	if (sigpending == 1)
+		get_uid(user);
 	rcu_read_unlock();
 
-	if (override_rlimit ||
-	    atomic_read(&user->sigpending) <=
-			task_rlimit(t, RLIMIT_SIGPENDING)) {
+	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	} else {
 		print_dropped_signal(sig);
 	}
 
 	if (unlikely(q == NULL)) {
-		atomic_dec(&user->sigpending);
-		free_uid(user);
+		if (atomic_dec_and_test(&user->sigpending))
+			free_uid(user);
 	} else {
 		INIT_LIST_HEAD(&q->list);
 		q->flags = 0;
@@ -413,8 +418,8 @@ static void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
-	atomic_dec(&q->user->sigpending);
-	free_uid(q->user);
+	if (atomic_dec_and_test(&q->user->sigpending))
+		free_uid(q->user);
 	kmem_cache_free(sigqueue_cachep, q);
 }
 
-- 
2.20.1



