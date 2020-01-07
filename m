Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65593133331
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgAGVGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgAGVGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E09724679;
        Tue,  7 Jan 2020 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431199;
        bh=oKypzh3WTh7rkLuRYSQH+bmjNOTjwhQxfxhvrpbiclQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddEABHc39kuAmx4A17u/TZw8EGKD/Wb5nIu5CS1B5fYkjBEdg/Ls/z4WQmvZB4n6r
         rGNFOMOnT8m/E+0CRELagWPuY7FUnkzcUmXsRUeMBYS3fEIQ66DRFLuY+OIPBIeRyR
         W1+BTrPlfye6a9y1hDi2xobOaCR2J+obeOzzNoPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.19 073/115] apparmor: fix aa_xattrs_match() may sleep while holding a RCU lock
Date:   Tue,  7 Jan 2020 21:54:43 +0100
Message-Id: <20200107205304.085236725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit 8c62ed27a12c00e3db1c9f04bc0f272bdbb06734 upstream.

aa_xattrs_match() is unfortunately calling vfs_getxattr_alloc() from a
context protected by an rcu_read_lock. This can not be done as
vfs_getxattr_alloc() may sleep regardles of the gfp_t value being
passed to it.

Fix this by breaking the rcu_read_lock on the policy search when the
xattr match feature is requested and restarting the search if a policy
changes occur.

Fixes: 8e51f9087f40 ("apparmor: Add support for attaching profiles via xattr, presence and value")
Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/apparmorfs.c |    2 -
 security/apparmor/domain.c     |   80 +++++++++++++++++++++--------------------
 security/apparmor/policy.c     |    4 +-
 3 files changed, 45 insertions(+), 41 deletions(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -593,7 +593,7 @@ static __poll_t ns_revision_poll(struct
 
 void __aa_bump_ns_revision(struct aa_ns *ns)
 {
-	ns->revision++;
+	WRITE_ONCE(ns->revision, ns->revision + 1);
 	wake_up_interruptible(&ns->wait);
 }
 
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -321,6 +321,7 @@ static int aa_xattrs_match(const struct
 
 	if (!bprm || !profile->xattr_count)
 		return 0;
+	might_sleep();
 
 	/* transition from exec match to xattr set */
 	state = aa_dfa_null_transition(profile->xmatch, state);
@@ -365,10 +366,11 @@ out:
 }
 
 /**
- * __attach_match_ - find an attachment match
+ * find_attach - do attachment search for unconfined processes
  * @bprm - binprm structure of transitioning task
- * @name - to match against  (NOT NULL)
+ * @ns: the current namespace  (NOT NULL)
  * @head - profile list to walk  (NOT NULL)
+ * @name - to match against  (NOT NULL)
  * @info - info message if there was an error (NOT NULL)
  *
  * Do a linear search on the profiles in the list.  There is a matching
@@ -378,12 +380,11 @@ out:
  *
  * Requires: @head not be shared or have appropriate locks held
  *
- * Returns: profile or NULL if no match found
+ * Returns: label or NULL if no match found
  */
-static struct aa_profile *__attach_match(const struct linux_binprm *bprm,
-					 const char *name,
-					 struct list_head *head,
-					 const char **info)
+static struct aa_label *find_attach(const struct linux_binprm *bprm,
+				    struct aa_ns *ns, struct list_head *head,
+				    const char *name, const char **info)
 {
 	int candidate_len = 0, candidate_xattrs = 0;
 	bool conflict = false;
@@ -392,6 +393,8 @@ static struct aa_profile *__attach_match
 	AA_BUG(!name);
 	AA_BUG(!head);
 
+	rcu_read_lock();
+restart:
 	list_for_each_entry_rcu(profile, head, base.list) {
 		if (profile->label.flags & FLAG_NULL &&
 		    &profile->label == ns_unconfined(profile->ns))
@@ -417,16 +420,32 @@ static struct aa_profile *__attach_match
 			perm = dfa_user_allow(profile->xmatch, state);
 			/* any accepting state means a valid match. */
 			if (perm & MAY_EXEC) {
-				int ret;
+				int ret = 0;
 
 				if (count < candidate_len)
 					continue;
 
-				ret = aa_xattrs_match(bprm, profile, state);
-				/* Fail matching if the xattrs don't match */
-				if (ret < 0)
-					continue;
+				if (bprm && profile->xattr_count) {
+					long rev = READ_ONCE(ns->revision);
 
+					if (!aa_get_profile_not0(profile))
+						goto restart;
+					rcu_read_unlock();
+					ret = aa_xattrs_match(bprm, profile,
+							      state);
+					rcu_read_lock();
+					aa_put_profile(profile);
+					if (rev !=
+					    READ_ONCE(ns->revision))
+						/* policy changed */
+						goto restart;
+					/*
+					 * Fail matching if the xattrs don't
+					 * match
+					 */
+					if (ret < 0)
+						continue;
+				}
 				/*
 				 * TODO: allow for more flexible best match
 				 *
@@ -449,43 +468,28 @@ static struct aa_profile *__attach_match
 				candidate_xattrs = ret;
 				conflict = false;
 			}
-		} else if (!strcmp(profile->base.name, name))
+		} else if (!strcmp(profile->base.name, name)) {
 			/*
 			 * old exact non-re match, without conditionals such
 			 * as xattrs. no more searching required
 			 */
-			return profile;
+			candidate = profile;
+			goto out;
+		}
 	}
 
-	if (conflict) {
-		*info = "conflicting profile attachments";
+	if (!candidate || conflict) {
+		if (conflict)
+			*info = "conflicting profile attachments";
+		rcu_read_unlock();
 		return NULL;
 	}
 
-	return candidate;
-}
-
-/**
- * find_attach - do attachment search for unconfined processes
- * @bprm - binprm structure of transitioning task
- * @ns: the current namespace  (NOT NULL)
- * @list: list to search  (NOT NULL)
- * @name: the executable name to match against  (NOT NULL)
- * @info: info message if there was an error
- *
- * Returns: label or NULL if no match found
- */
-static struct aa_label *find_attach(const struct linux_binprm *bprm,
-				    struct aa_ns *ns, struct list_head *list,
-				    const char *name, const char **info)
-{
-	struct aa_profile *profile;
-
-	rcu_read_lock();
-	profile = aa_get_profile(__attach_match(bprm, name, list, info));
+out:
+	candidate = aa_get_newest_profile(candidate);
 	rcu_read_unlock();
 
-	return profile ? &profile->label : NULL;
+	return &candidate->label;
 }
 
 static const char *next_name(int xtype, const char *name)
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1126,8 +1126,8 @@ ssize_t aa_remove_profiles(struct aa_ns
 	if (!name) {
 		/* remove namespace - can only happen if fqname[0] == ':' */
 		mutex_lock_nested(&ns->parent->lock, ns->level);
-		__aa_remove_ns(ns);
 		__aa_bump_ns_revision(ns);
+		__aa_remove_ns(ns);
 		mutex_unlock(&ns->parent->lock);
 	} else {
 		/* remove profile */
@@ -1139,9 +1139,9 @@ ssize_t aa_remove_profiles(struct aa_ns
 			goto fail_ns_lock;
 		}
 		name = profile->base.hname;
+		__aa_bump_ns_revision(ns);
 		__remove_profile(profile);
 		__aa_labelset_update_subtree(ns);
-		__aa_bump_ns_revision(ns);
 		mutex_unlock(&ns->lock);
 	}
 


