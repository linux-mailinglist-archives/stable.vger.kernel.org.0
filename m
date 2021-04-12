Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB0835BF2F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbhDLJDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239812AbhDLJBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F7C6128B;
        Mon, 12 Apr 2021 08:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217961;
        bh=OtV9GWBvaFH6D/2+CybPSik3GzLRcmQC+6MI9sEtWRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2ZYwC3gFBT6A8w/iVPRcl3lB4alD9F3gv7UG5OpSVpKpdUb/Q7XyBZt/VFFUJOTh
         gLzIWT8+5p+0i6o23ccokJt05E2AnMCPk8Rr/sdtj6G88Fkq4nZmAm9T266aGPRhb6
         zIrKW7KnbGpOMGcVO/sgPUjMgY08wlZFFHHZSZxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.11 013/210] selinux: fix race between old and new sidtab
Date:   Mon, 12 Apr 2021 10:38:38 +0200
Message-Id: <20210412084016.449642945@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 9ad6e9cb39c66366bf7b9aece114aca277981a1f upstream.

Since commit 1b8b31a2e612 ("selinux: convert policy read-write lock to
RCU"), there is a small window during policy load where the new policy
pointer has already been installed, but some threads may still be
holding the old policy pointer in their read-side RCU critical sections.
This means that there may be conflicting attempts to add a new SID entry
to both tables via sidtab_context_to_sid().

See also (and the rest of the thread):
https://lore.kernel.org/selinux/CAFqZXNvfux46_f8gnvVvRYMKoes24nwm2n3sPbMjrB8vKTW00g@mail.gmail.com/

Fix this by installing the new policy pointer under the old sidtab's
spinlock along with marking the old sidtab as "frozen". Then, if an
attempt to add new entry to a "frozen" sidtab is detected, make
sidtab_context_to_sid() return -ESTALE to indicate that a new policy
has been installed and that the caller will have to abort the policy
transaction and try again after re-taking the policy pointer (which is
guaranteed to be a newer policy). This requires adding a retry-on-ESTALE
logic to all callers of sidtab_context_to_sid(), but fortunately these
are easy to determine and aren't that many.

This seems to be the simplest solution for this problem, even if it
looks somewhat ugly. Note that other places in the kernel (e.g.
do_mknodat() in fs/namei.c) use similar stale-retry patterns, so I think
it's reasonable.

Cc: stable@vger.kernel.org
Fixes: 1b8b31a2e612 ("selinux: convert policy read-write lock to RCU")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |  157 +++++++++++++++++++++++++++++++----------
 security/selinux/ss/sidtab.c   |   21 +++++
 security/selinux/ss/sidtab.h   |    4 +
 3 files changed, 145 insertions(+), 37 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1551,6 +1551,7 @@ static int security_context_to_sid_core(
 		if (!str)
 			goto out;
 	}
+retry:
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -1564,6 +1565,15 @@ static int security_context_to_sid_core(
 	} else if (rc)
 		goto out_unlock;
 	rc = sidtab_context_to_sid(sidtab, &context, sid);
+	if (rc == -ESTALE) {
+		rcu_read_unlock();
+		if (context.str) {
+			str = context.str;
+			context.str = NULL;
+		}
+		context_destroy(&context);
+		goto retry;
+	}
 	context_destroy(&context);
 out_unlock:
 	rcu_read_unlock();
@@ -1713,7 +1723,7 @@ static int security_compute_sid(struct s
 	struct selinux_policy *policy;
 	struct policydb *policydb;
 	struct sidtab *sidtab;
-	struct class_datum *cladatum = NULL;
+	struct class_datum *cladatum;
 	struct context *scontext, *tcontext, newcontext;
 	struct sidtab_entry *sentry, *tentry;
 	struct avtab_key avkey;
@@ -1735,6 +1745,8 @@ static int security_compute_sid(struct s
 		goto out;
 	}
 
+retry:
+	cladatum = NULL;
 	context_init(&newcontext);
 
 	rcu_read_lock();
@@ -1879,6 +1891,11 @@ static int security_compute_sid(struct s
 	}
 	/* Obtain the sid for the context. */
 	rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
+	if (rc == -ESTALE) {
+		rcu_read_unlock();
+		context_destroy(&newcontext);
+		goto retry;
+	}
 out_unlock:
 	rcu_read_unlock();
 	context_destroy(&newcontext);
@@ -2190,6 +2207,7 @@ void selinux_policy_commit(struct selinu
 			   struct selinux_load_state *load_state)
 {
 	struct selinux_policy *oldpolicy, *newpolicy = load_state->policy;
+	unsigned long flags;
 	u32 seqno;
 
 	oldpolicy = rcu_dereference_protected(state->policy,
@@ -2211,7 +2229,13 @@ void selinux_policy_commit(struct selinu
 	seqno = newpolicy->latest_granting;
 
 	/* Install the new policy. */
-	rcu_assign_pointer(state->policy, newpolicy);
+	if (oldpolicy) {
+		sidtab_freeze_begin(oldpolicy->sidtab, &flags);
+		rcu_assign_pointer(state->policy, newpolicy);
+		sidtab_freeze_end(oldpolicy->sidtab, &flags);
+	} else {
+		rcu_assign_pointer(state->policy, newpolicy);
+	}
 
 	/* Load the policycaps from the new policy */
 	security_load_policycaps(state, newpolicy);
@@ -2355,13 +2379,15 @@ int security_port_sid(struct selinux_sta
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	if (!selinux_initialized(state)) {
 		*out_sid = SECINITSID_PORT;
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2380,6 +2406,10 @@ int security_port_sid(struct selinux_sta
 		if (!c->sid[0]) {
 			rc = sidtab_context_to_sid(sidtab, &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2406,13 +2436,15 @@ int security_ib_pkey_sid(struct selinux_
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	if (!selinux_initialized(state)) {
 		*out_sid = SECINITSID_UNLABELED;
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2433,6 +2465,10 @@ int security_ib_pkey_sid(struct selinux_
 			rc = sidtab_context_to_sid(sidtab,
 						   &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2458,13 +2494,15 @@ int security_ib_endport_sid(struct selin
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	if (!selinux_initialized(state)) {
 		*out_sid = SECINITSID_UNLABELED;
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2485,6 +2523,10 @@ int security_ib_endport_sid(struct selin
 		if (!c->sid[0]) {
 			rc = sidtab_context_to_sid(sidtab, &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2508,7 +2550,7 @@ int security_netif_sid(struct selinux_st
 	struct selinux_policy *policy;
 	struct policydb *policydb;
 	struct sidtab *sidtab;
-	int rc = 0;
+	int rc;
 	struct ocontext *c;
 
 	if (!selinux_initialized(state)) {
@@ -2516,6 +2558,8 @@ int security_netif_sid(struct selinux_st
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2532,10 +2576,18 @@ int security_netif_sid(struct selinux_st
 		if (!c->sid[0] || !c->sid[1]) {
 			rc = sidtab_context_to_sid(sidtab, &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 			rc = sidtab_context_to_sid(sidtab, &c->context[1],
 						   &c->sid[1]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2585,6 +2637,7 @@ int security_node_sid(struct selinux_sta
 		return 0;
 	}
 
+retry:
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2633,6 +2686,10 @@ int security_node_sid(struct selinux_sta
 			rc = sidtab_context_to_sid(sidtab,
 						   &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2674,18 +2731,24 @@ int security_get_user_sids(struct selinu
 	struct sidtab *sidtab;
 	struct context *fromcon, usercon;
 	u32 *mysids = NULL, *mysids2, sid;
-	u32 mynel = 0, maxnel = SIDS_NEL;
+	u32 i, j, mynel, maxnel = SIDS_NEL;
 	struct user_datum *user;
 	struct role_datum *role;
 	struct ebitmap_node *rnode, *tnode;
-	int rc = 0, i, j;
+	int rc;
 
 	*sids = NULL;
 	*nel = 0;
 
 	if (!selinux_initialized(state))
-		goto out;
+		return 0;
+
+	mysids = kcalloc(maxnel, sizeof(*mysids), GFP_KERNEL);
+	if (!mysids)
+		return -ENOMEM;
 
+retry:
+	mynel = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2705,11 +2768,6 @@ int security_get_user_sids(struct selinu
 
 	usercon.user = user->value;
 
-	rc = -ENOMEM;
-	mysids = kcalloc(maxnel, sizeof(*mysids), GFP_ATOMIC);
-	if (!mysids)
-		goto out_unlock;
-
 	ebitmap_for_each_positive_bit(&user->roles, rnode, i) {
 		role = policydb->role_val_to_struct[i];
 		usercon.role = i + 1;
@@ -2721,6 +2779,10 @@ int security_get_user_sids(struct selinu
 				continue;
 
 			rc = sidtab_context_to_sid(sidtab, &usercon, &sid);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out_unlock;
 			if (mynel < maxnel) {
@@ -2743,14 +2805,14 @@ out_unlock:
 	rcu_read_unlock();
 	if (rc || !mynel) {
 		kfree(mysids);
-		goto out;
+		return rc;
 	}
 
 	rc = -ENOMEM;
 	mysids2 = kcalloc(mynel, sizeof(*mysids2), GFP_KERNEL);
 	if (!mysids2) {
 		kfree(mysids);
-		goto out;
+		return rc;
 	}
 	for (i = 0, j = 0; i < mynel; i++) {
 		struct av_decision dummy_avd;
@@ -2763,12 +2825,10 @@ out_unlock:
 			mysids2[j++] = mysids[i];
 		cond_resched();
 	}
-	rc = 0;
 	kfree(mysids);
 	*sids = mysids2;
 	*nel = j;
-out:
-	return rc;
+	return 0;
 }
 
 /**
@@ -2781,6 +2841,9 @@ out:
  * Obtain a SID to use for a file in a filesystem that
  * cannot support xattr or use a fixed labeling behavior like
  * transition SIDs or task SIDs.
+ *
+ * WARNING: This function may return -ESTALE, indicating that the caller
+ * must retry the operation after re-acquiring the policy pointer!
  */
 static inline int __security_genfs_sid(struct selinux_policy *policy,
 				       const char *fstype,
@@ -2859,11 +2922,13 @@ int security_genfs_sid(struct selinux_st
 		return 0;
 	}
 
-	rcu_read_lock();
-	policy = rcu_dereference(state->policy);
-	retval = __security_genfs_sid(policy,
-				fstype, path, orig_sclass, sid);
-	rcu_read_unlock();
+	do {
+		rcu_read_lock();
+		policy = rcu_dereference(state->policy);
+		retval = __security_genfs_sid(policy, fstype, path,
+					      orig_sclass, sid);
+		rcu_read_unlock();
+	} while (retval == -ESTALE);
 	return retval;
 }
 
@@ -2886,7 +2951,7 @@ int security_fs_use(struct selinux_state
 	struct selinux_policy *policy;
 	struct policydb *policydb;
 	struct sidtab *sidtab;
-	int rc = 0;
+	int rc;
 	struct ocontext *c;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *fstype = sb->s_type->name;
@@ -2897,6 +2962,8 @@ int security_fs_use(struct selinux_state
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -2914,6 +2981,10 @@ int security_fs_use(struct selinux_state
 		if (!c->sid[0]) {
 			rc = sidtab_context_to_sid(sidtab, &c->context[0],
 						   &c->sid[0]);
+			if (rc == -ESTALE) {
+				rcu_read_unlock();
+				goto retry;
+			}
 			if (rc)
 				goto out;
 		}
@@ -2921,6 +2992,10 @@ int security_fs_use(struct selinux_state
 	} else {
 		rc = __security_genfs_sid(policy, fstype, "/",
 					SECCLASS_DIR, &sbsec->sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
+		}
 		if (rc) {
 			sbsec->behavior = SECURITY_FS_USE_NONE;
 			rc = 0;
@@ -3130,12 +3205,13 @@ int security_sid_mls_copy(struct selinux
 	u32 len;
 	int rc;
 
-	rc = 0;
 	if (!selinux_initialized(state)) {
 		*new_sid = sid;
-		goto out;
+		return 0;
 	}
 
+retry:
+	rc = 0;
 	context_init(&newcon);
 
 	rcu_read_lock();
@@ -3194,10 +3270,14 @@ int security_sid_mls_copy(struct selinux
 		}
 	}
 	rc = sidtab_context_to_sid(sidtab, &newcon, new_sid);
+	if (rc == -ESTALE) {
+		rcu_read_unlock();
+		context_destroy(&newcon);
+		goto retry;
+	}
 out_unlock:
 	rcu_read_unlock();
 	context_destroy(&newcon);
-out:
 	return rc;
 }
 
@@ -3794,6 +3874,8 @@ int security_netlbl_secattr_to_sid(struc
 		return 0;
 	}
 
+retry:
+	rc = 0;
 	rcu_read_lock();
 	policy = rcu_dereference(state->policy);
 	policydb = &policy->policydb;
@@ -3820,23 +3902,24 @@ int security_netlbl_secattr_to_sid(struc
 				goto out;
 		}
 		rc = -EIDRM;
-		if (!mls_context_isvalid(policydb, &ctx_new))
-			goto out_free;
+		if (!mls_context_isvalid(policydb, &ctx_new)) {
+			ebitmap_destroy(&ctx_new.range.level[0].cat);
+			goto out;
+		}
 
 		rc = sidtab_context_to_sid(sidtab, &ctx_new, sid);
+		ebitmap_destroy(&ctx_new.range.level[0].cat);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
+		}
 		if (rc)
-			goto out_free;
+			goto out;
 
 		security_netlbl_cache_add(secattr, *sid);
-
-		ebitmap_destroy(&ctx_new.range.level[0].cat);
 	} else
 		*sid = SECSID_NULL;
 
-	rcu_read_unlock();
-	return 0;
-out_free:
-	ebitmap_destroy(&ctx_new.range.level[0].cat);
 out:
 	rcu_read_unlock();
 	return rc;
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -39,6 +39,7 @@ int sidtab_init(struct sidtab *s)
 	for (i = 0; i < SECINITSID_NUM; i++)
 		s->isids[i].set = 0;
 
+	s->frozen = false;
 	s->count = 0;
 	s->convert = NULL;
 	hash_init(s->context_to_sid);
@@ -281,6 +282,15 @@ int sidtab_context_to_sid(struct sidtab
 	if (*sid)
 		goto out_unlock;
 
+	if (unlikely(s->frozen)) {
+		/*
+		 * This sidtab is now frozen - tell the caller to abort and
+		 * get the new one.
+		 */
+		rc = -ESTALE;
+		goto out_unlock;
+	}
+
 	count = s->count;
 	convert = s->convert;
 
@@ -474,6 +484,17 @@ void sidtab_cancel_convert(struct sidtab
 	spin_unlock_irqrestore(&s->lock, flags);
 }
 
+void sidtab_freeze_begin(struct sidtab *s, unsigned long *flags) __acquires(&s->lock)
+{
+	spin_lock_irqsave(&s->lock, *flags);
+	s->frozen = true;
+	s->convert = NULL;
+}
+void sidtab_freeze_end(struct sidtab *s, unsigned long *flags) __releases(&s->lock)
+{
+	spin_unlock_irqrestore(&s->lock, *flags);
+}
+
 static void sidtab_destroy_entry(struct sidtab_entry *entry)
 {
 	context_destroy(&entry->context);
--- a/security/selinux/ss/sidtab.h
+++ b/security/selinux/ss/sidtab.h
@@ -86,6 +86,7 @@ struct sidtab {
 	u32 count;
 	/* access only under spinlock */
 	struct sidtab_convert_params *convert;
+	bool frozen;
 	spinlock_t lock;
 
 #if CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE > 0
@@ -125,6 +126,9 @@ int sidtab_convert(struct sidtab *s, str
 
 void sidtab_cancel_convert(struct sidtab *s);
 
+void sidtab_freeze_begin(struct sidtab *s, unsigned long *flags) __acquires(&s->lock);
+void sidtab_freeze_end(struct sidtab *s, unsigned long *flags) __releases(&s->lock);
+
 int sidtab_context_to_sid(struct sidtab *s, struct context *context, u32 *sid);
 
 void sidtab_destroy(struct sidtab *s);


