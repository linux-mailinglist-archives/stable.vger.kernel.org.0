Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2D79822
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389856AbfG2Toy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389851AbfG2Tox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:44:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE2D7205F4;
        Mon, 29 Jul 2019 19:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429492;
        bh=XmTPoFu+VFvni9Pud1Y8ed/jNm/MyGdjF1WyV9HyFwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+1SiI6xNghSN3SrarpDcX1hwMi9kzAylxOgUmI2hMjehdBlrqqDf+W2DSTEV4XoM
         EP4quxqdTNijNqp/Cqp6aTwNDTMVUfdGM6h6jfRM1AlljxTbQJqLX/q49I/4Y5oXhp
         Jrcp8cYC9iRl1YwYbe5ax1y9rT3fT03O0PCteER0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Glauber <jglauber@marvell.com>,
        Jiri Kosina <jikos@kernel.org>,
        Jayachandran Chandrasekharan Nair <jnair@marvell.com>,
        Greg KH <greg@kroah.com>, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 113/113] access: avoid the RCU grace period for the temporary subjective credentials
Date:   Mon, 29 Jul 2019 21:23:20 +0200
Message-Id: <20190729190721.769129969@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d7852fbd0f0423937fa287a598bfde188bb68c22 upstream.

It turns out that 'access()' (and 'faccessat()') can cause a lot of RCU
work because it installs a temporary credential that gets allocated and
freed for each system call.

The allocation and freeing overhead is mostly benign, but because
credentials can be accessed under the RCU read lock, the freeing
involves a RCU grace period.

Which is not a huge deal normally, but if you have a lot of access()
calls, this causes a fair amount of seconday damage: instead of having a
nice alloc/free patterns that hits in hot per-CPU slab caches, you have
all those delayed free's, and on big machines with hundreds of cores,
the RCU overhead can end up being enormous.

But it turns out that all of this is entirely unnecessary.  Exactly
because access() only installs the credential as the thread-local
subjective credential, the temporary cred pointer doesn't actually need
to be RCU free'd at all.  Once we're done using it, we can just free it
synchronously and avoid all the RCU overhead.

So add a 'non_rcu' flag to 'struct cred', which can be set by users that
know they only use it in non-RCU context (there are other potential
users for this).  We can make it a union with the rcu freeing list head
that we need for the RCU case, so this doesn't need any extra storage.

Note that this also makes 'get_current_cred()' clear the new non_rcu
flag, in case we have filesystems that take a long-term reference to the
cred and then expect the RCU delayed freeing afterwards.  It's not
entirely clear that this is required, but it makes for clear semantics:
the subjective cred remains non-RCU as long as you only access it
synchronously using the thread-local accessors, but you _can_ use it as
a generic cred if you want to.

It is possible that we should just remove the whole RCU markings for
->cred entirely.  Only ->real_cred is really supposed to be accessed
through RCU, and the long-term cred copies that nfs uses might want to
explicitly re-enable RCU freeing if required, rather than have
get_current_cred() do it implicitly.

But this is a "minimal semantic changes" change for the immediate
problem.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Glauber <jglauber@marvell.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Jayachandran Chandrasekharan Nair <jnair@marvell.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/open.c            |   19 +++++++++++++++++++
 include/linux/cred.h |    7 ++++++-
 kernel/cred.c        |   21 +++++++++++++++++++--
 3 files changed, 44 insertions(+), 3 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -373,6 +373,25 @@ long do_faccessat(int dfd, const char __
 				override_cred->cap_permitted;
 	}
 
+	/*
+	 * The new set of credentials can *only* be used in
+	 * task-synchronous circumstances, and does not need
+	 * RCU freeing, unless somebody then takes a separate
+	 * reference to it.
+	 *
+	 * NOTE! This is _only_ true because this credential
+	 * is used purely for override_creds() that installs
+	 * it as the subjective cred. Other threads will be
+	 * accessing ->real_cred, not the subjective cred.
+	 *
+	 * If somebody _does_ make a copy of this (using the
+	 * 'get_current_cred()' function), that will clear the
+	 * non_rcu field, because now that other user may be
+	 * expecting RCU freeing. But normal thread-synchronous
+	 * cred accesses will keep things non-RCY.
+	 */
+	override_cred->non_rcu = 1;
+
 	old_cred = override_creds(override_cred);
 retry:
 	res = user_path_at(dfd, filename, lookup_flags, &path);
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -150,7 +150,11 @@ struct cred {
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
-	struct rcu_head	rcu;		/* RCU deletion hook */
+	/* RCU deletion */
+	union {
+		int non_rcu;			/* Can we skip RCU deletion? */
+		struct rcu_head	rcu;		/* RCU deletion hook */
+	};
 } __randomize_layout;
 
 extern void __put_cred(struct cred *);
@@ -248,6 +252,7 @@ static inline const struct cred *get_cre
 {
 	struct cred *nonconst_cred = (struct cred *) cred;
 	validate_creds(cred);
+	nonconst_cred->non_rcu = 0;
 	return get_new_cred(nonconst_cred);
 }
 
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -147,7 +147,10 @@ void __put_cred(struct cred *cred)
 	BUG_ON(cred == current->cred);
 	BUG_ON(cred == current->real_cred);
 
-	call_rcu(&cred->rcu, put_cred_rcu);
+	if (cred->non_rcu)
+		put_cred_rcu(&cred->rcu);
+	else
+		call_rcu(&cred->rcu, put_cred_rcu);
 }
 EXPORT_SYMBOL(__put_cred);
 
@@ -258,6 +261,7 @@ struct cred *prepare_creds(void)
 	old = task->cred;
 	memcpy(new, old, sizeof(struct cred));
 
+	new->non_rcu = 0;
 	atomic_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
@@ -537,7 +541,19 @@ const struct cred *override_creds(const
 
 	validate_creds(old);
 	validate_creds(new);
-	get_cred(new);
+
+	/*
+	 * NOTE! This uses 'get_new_cred()' rather than 'get_cred()'.
+	 *
+	 * That means that we do not clear the 'non_rcu' flag, since
+	 * we are only installing the cred into the thread-synchronous
+	 * '->cred' pointer, not the '->real_cred' pointer that is
+	 * visible to other threads under RCU.
+	 *
+	 * Also note that we did validate_creds() manually, not depending
+	 * on the validation in 'get_cred()'.
+	 */
+	get_new_cred((struct cred *)new);
 	alter_cred_subscribers(new, 1);
 	rcu_assign_pointer(current->cred, new);
 	alter_cred_subscribers(old, -1);
@@ -620,6 +636,7 @@ struct cred *prepare_kernel_cred(struct
 	validate_creds(old);
 
 	*new = *old;
+	new->non_rcu = 0;
 	atomic_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_uid(new->user);


