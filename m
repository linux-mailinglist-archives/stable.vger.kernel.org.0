Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397C743A2B1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhJYTvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238504AbhJYTtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19E761179;
        Mon, 25 Oct 2021 19:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190890;
        bh=VC2rFYLdYM82o4zhySlqUJzTRi5fcOOuGil3Jb5xoPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1QQ0hA+LNzqVwcL2zb+3pLr1sLYyZxcZjfw9dVkOyf21nmlNSpxLEGxmjGJMxekX
         phbXE1nkR9BcLU8MPlGT47C3rcf207B8KmY6o/S1xTaULvbG5zit+9QopETEyVsZx1
         27M4/BMAlPAZUeYdj1QYD53K+1UH66gsBjHeSzHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Rune Kleveland <rune.kleveland@infomedia.dk>,
        Yu Zhao <yuzhao@google.com>,
        Jordan Glover <Golden_Miller83@protonmail.ch>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.14 096/169] ucounts: Fix signal ucount refcounting
Date:   Mon, 25 Oct 2021 21:14:37 +0200
Message-Id: <20211025191029.841268166@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 15bc01effefe97757ef02ca09e9d1b927ab22725 upstream.

In commit fda31c50292a ("signal: avoid double atomic counter
increments for user accounting") Linus made a clever optimization to
how rlimits and the struct user_struct.  Unfortunately that
optimization does not work in the obvious way when moved to nested
rlimits.  The problem is that the last decrement of the per user
namespace per user sigpending counter might also be the last decrement
of the sigpending counter in the parent user namespace as well.  Which
means that simply freeing the leaf ucount in __free_sigqueue is not
enough.

Maintain the optimization and handle the tricky cases by introducing
inc_rlimit_get_ucounts and dec_rlimit_put_ucounts.

By moving the entire optimization into functions that perform all of
the work it becomes possible to ensure that every level is handled
properly.

The new function inc_rlimit_get_ucounts returns 0 on failure to
increment the ucount.  This is different than inc_rlimit_ucounts which
increments the ucounts and returns LONG_MAX if the ucount counter has
exceeded it's maximum or it wrapped (to indicate the counter needs to
decremented).

I wish we had a single user to account all pending signals to across
all of the threads of a process so this complexity was not necessary

Cc: stable@vger.kernel.org
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
v1: https://lkml.kernel.org/r/87mtnavszx.fsf_-_@disp2133
Link: https://lkml.kernel.org/r/87fssytizw.fsf_-_@disp2133
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Tested-by: Rune Kleveland <rune.kleveland@infomedia.dk>
Tested-by: Yu Zhao <yuzhao@google.com>
Tested-by: Jordan Glover <Golden_Miller83@protonmail.ch>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/user_namespace.h |    2 +
 kernel/signal.c                |   25 +++++---------------
 kernel/ucount.c                |   49 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 19 deletions(-)

--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -127,6 +127,8 @@ static inline long get_ucounts_value(str
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum ucount_type type);
+void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum ucount_type type);
 bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long max);
 
 static inline void set_rlimit_ucount_max(struct user_namespace *ns,
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -425,22 +425,10 @@ __sigqueue_alloc(int sig, struct task_st
 	 */
 	rcu_read_lock();
 	ucounts = task_ucounts(t);
-	sigpending = inc_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING, 1);
-	switch (sigpending) {
-	case 1:
-		if (likely(get_ucounts(ucounts)))
-			break;
-		fallthrough;
-	case LONG_MAX:
-		/*
-		 * we need to decrease the ucount in the userns tree on any
-		 * failure to avoid counts leaking.
-		 */
-		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING, 1);
-		rcu_read_unlock();
-		return NULL;
-	}
+	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING);
 	rcu_read_unlock();
+	if (!sigpending)
+		return NULL;
 
 	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
 		q = kmem_cache_alloc(sigqueue_cachep, gfp_flags);
@@ -449,8 +437,7 @@ __sigqueue_alloc(int sig, struct task_st
 	}
 
 	if (unlikely(q == NULL)) {
-		if (dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING, 1))
-			put_ucounts(ucounts);
+		dec_rlimit_put_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING);
 	} else {
 		INIT_LIST_HEAD(&q->list);
 		q->flags = sigqueue_flags;
@@ -463,8 +450,8 @@ static void __sigqueue_free(struct sigqu
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
-	if (q->ucounts && dec_rlimit_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING, 1)) {
-		put_ucounts(q->ucounts);
+	if (q->ucounts) {
+		dec_rlimit_put_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING);
 		q->ucounts = NULL;
 	}
 	kmem_cache_free(sigqueue_cachep, q);
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -284,6 +284,55 @@ bool dec_rlimit_ucounts(struct ucounts *
 	return (new == 0);
 }
 
+static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
+				struct ucounts *last, enum ucount_type type)
+{
+	struct ucounts *iter, *next;
+	for (iter = ucounts; iter != last; iter = next) {
+		long dec = atomic_long_add_return(-1, &iter->ucount[type]);
+		WARN_ON_ONCE(dec < 0);
+		next = iter->ns->ucounts;
+		if (dec == 0)
+			put_ucounts(iter);
+	}
+}
+
+void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum ucount_type type)
+{
+	do_dec_rlimit_put_ucounts(ucounts, NULL, type);
+}
+
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum ucount_type type)
+{
+	/* Caller must hold a reference to ucounts */
+	struct ucounts *iter;
+	long dec, ret = 0;
+
+	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
+		long max = READ_ONCE(iter->ns->ucount_max[type]);
+		long new = atomic_long_add_return(1, &iter->ucount[type]);
+		if (new < 0 || new > max)
+			goto unwind;
+		if (iter == ucounts)
+			ret = new;
+		/*
+		 * Grab an extra ucount reference for the caller when
+		 * the rlimit count was previously 0.
+		 */
+		if (new != 1)
+			continue;
+		if (!get_ucounts(iter))
+			goto dec_unwind;
+	}
+	return ret;
+dec_unwind:
+	dec = atomic_long_add_return(-1, &iter->ucount[type]);
+	WARN_ON_ONCE(dec < 0);
+unwind:
+	do_dec_rlimit_put_ucounts(ucounts, iter, type);
+	return 0;
+}
+
 bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long max)
 {
 	struct ucounts *iter;


