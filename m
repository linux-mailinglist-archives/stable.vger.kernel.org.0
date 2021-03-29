Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5624C34C9ED
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhC2IeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhC2IdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4228A619BD;
        Mon, 29 Mar 2021 08:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006740;
        bh=xklHUkCkSFA+FxueWwB1TX0vfkQ4jbI5MgkaVx6OX7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6tdfDn87Xh64DQocYM8Cp+uBg4az/xGCSVNPBt4fNDVdiB5RetCwQ3kRBkeOcLPx
         W3907voT7Zm/zSQDszqUUqu51/8Na8vP+3d2LzfGP6DWEI/W4WQJtKIN0W1v4pL3cV
         ohrs7AhNKUpcfhKymSIiRVJhxmYX1PSqDKk0JL/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.11 074/254] selinux: fix variable scope issue in live sidtab conversion
Date:   Mon, 29 Mar 2021 09:56:30 +0200
Message-Id: <20210329075635.584715806@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 6406887a12ee5dcdaffff1a8508d91113d545559 upstream.

Commit 02a52c5c8c3b ("selinux: move policy commit after updating
selinuxfs") moved the selinux_policy_commit() call out of
security_load_policy() into sel_write_load(), which caused a subtle yet
rather serious bug.

The problem is that security_load_policy() passes a reference to the
convert_params local variable to sidtab_convert(), which stores it in
the sidtab, where it may be accessed until the policy is swapped over
and RCU synchronized. Before 02a52c5c8c3b, selinux_policy_commit() was
called directly from security_load_policy(), so the convert_params
pointer remained valid all the way until the old sidtab was destroyed,
but now that's no longer the case and calls to sidtab_context_to_sid()
on the old sidtab after security_load_policy() returns may cause invalid
memory accesses.

This can be easily triggered using the stress test from commit
ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve
performance"):
```
function rand_cat() {
	echo $(( $RANDOM % 1024 ))
}

function do_work() {
	while true; do
		echo -n "system_u:system_r:kernel_t:s0:c$(rand_cat),c$(rand_cat)" \
			>/sys/fs/selinux/context 2>/dev/null || true
	done
}

do_work >/dev/null &
do_work >/dev/null &
do_work >/dev/null &

while load_policy; do echo -n .; sleep 0.1; done

kill %1
kill %2
kill %3
```

Fix this by allocating the temporary sidtab convert structures
dynamically and passing them among the
selinux_policy_{load,cancel,commit} functions.

Fixes: 02a52c5c8c3b ("selinux: move policy commit after updating selinuxfs")
Cc: stable@vger.kernel.org
Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
[PM: merge fuzz in security.h and services.c]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/include/security.h |   15 ++++++--
 security/selinux/selinuxfs.c        |   10 ++---
 security/selinux/ss/services.c      |   65 ++++++++++++++++++++++--------------
 3 files changed, 56 insertions(+), 34 deletions(-)

--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -219,14 +219,21 @@ static inline bool selinux_policycap_gen
 	return READ_ONCE(state->policycap[POLICYDB_CAPABILITY_GENFS_SECLABEL_SYMLINKS]);
 }
 
+struct selinux_policy_convert_data;
+
+struct selinux_load_state {
+	struct selinux_policy *policy;
+	struct selinux_policy_convert_data *convert_data;
+};
+
 int security_mls_enabled(struct selinux_state *state);
 int security_load_policy(struct selinux_state *state,
-			void *data, size_t len,
-			struct selinux_policy **newpolicyp);
+			 void *data, size_t len,
+			 struct selinux_load_state *load_state);
 void selinux_policy_commit(struct selinux_state *state,
-			struct selinux_policy *newpolicy);
+			   struct selinux_load_state *load_state);
 void selinux_policy_cancel(struct selinux_state *state,
-			struct selinux_policy *policy);
+			   struct selinux_load_state *load_state);
 int security_read_policy(struct selinux_state *state,
 			 void **data, size_t *len);
 
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -616,7 +616,7 @@ static ssize_t sel_write_load(struct fil
 
 {
 	struct selinux_fs_info *fsi = file_inode(file)->i_sb->s_fs_info;
-	struct selinux_policy *newpolicy;
+	struct selinux_load_state load_state;
 	ssize_t length;
 	void *data = NULL;
 
@@ -642,19 +642,19 @@ static ssize_t sel_write_load(struct fil
 	if (copy_from_user(data, buf, count) != 0)
 		goto out;
 
-	length = security_load_policy(fsi->state, data, count, &newpolicy);
+	length = security_load_policy(fsi->state, data, count, &load_state);
 	if (length) {
 		pr_warn_ratelimited("SELinux: failed to load policy\n");
 		goto out;
 	}
 
-	length = sel_make_policy_nodes(fsi, newpolicy);
+	length = sel_make_policy_nodes(fsi, load_state.policy);
 	if (length) {
-		selinux_policy_cancel(fsi->state, newpolicy);
+		selinux_policy_cancel(fsi->state, &load_state);
 		goto out;
 	}
 
-	selinux_policy_commit(fsi->state, newpolicy);
+	selinux_policy_commit(fsi->state, &load_state);
 
 	length = count;
 
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -66,6 +66,17 @@
 #include "audit.h"
 #include "policycap_names.h"
 
+struct convert_context_args {
+	struct selinux_state *state;
+	struct policydb *oldp;
+	struct policydb *newp;
+};
+
+struct selinux_policy_convert_data {
+	struct convert_context_args args;
+	struct sidtab_convert_params sidtab_params;
+};
+
 /* Forward declaration. */
 static int context_struct_to_string(struct policydb *policydb,
 				    struct context *context,
@@ -1973,12 +1984,6 @@ static inline int convert_context_handle
 	return 0;
 }
 
-struct convert_context_args {
-	struct selinux_state *state;
-	struct policydb *oldp;
-	struct policydb *newp;
-};
-
 /*
  * Convert the values in the security context
  * structure `oldc' from the values specified
@@ -2158,7 +2163,7 @@ static void selinux_policy_cond_free(str
 }
 
 void selinux_policy_cancel(struct selinux_state *state,
-			struct selinux_policy *policy)
+			   struct selinux_load_state *load_state)
 {
 	struct selinux_policy *oldpolicy;
 
@@ -2166,7 +2171,8 @@ void selinux_policy_cancel(struct selinu
 					lockdep_is_held(&state->policy_mutex));
 
 	sidtab_cancel_convert(oldpolicy->sidtab);
-	selinux_policy_free(policy);
+	selinux_policy_free(load_state->policy);
+	kfree(load_state->convert_data);
 }
 
 static void selinux_notify_policy_change(struct selinux_state *state,
@@ -2181,9 +2187,9 @@ static void selinux_notify_policy_change
 }
 
 void selinux_policy_commit(struct selinux_state *state,
-			struct selinux_policy *newpolicy)
+			   struct selinux_load_state *load_state)
 {
-	struct selinux_policy *oldpolicy;
+	struct selinux_policy *oldpolicy, *newpolicy = load_state->policy;
 	u32 seqno;
 
 	oldpolicy = rcu_dereference_protected(state->policy,
@@ -2223,6 +2229,7 @@ void selinux_policy_commit(struct selinu
 	/* Free the old policy */
 	synchronize_rcu();
 	selinux_policy_free(oldpolicy);
+	kfree(load_state->convert_data);
 
 	/* Notify others of the policy change */
 	selinux_notify_policy_change(state, seqno);
@@ -2239,11 +2246,10 @@ void selinux_policy_commit(struct selinu
  * loading the new policy.
  */
 int security_load_policy(struct selinux_state *state, void *data, size_t len,
-			struct selinux_policy **newpolicyp)
+			 struct selinux_load_state *load_state)
 {
 	struct selinux_policy *newpolicy, *oldpolicy;
-	struct sidtab_convert_params convert_params;
-	struct convert_context_args args;
+	struct selinux_policy_convert_data *convert_data;
 	int rc = 0;
 	struct policy_file file = { data, len }, *fp = &file;
 
@@ -2273,10 +2279,10 @@ int security_load_policy(struct selinux_
 		goto err_mapping;
 	}
 
-
 	if (!selinux_initialized(state)) {
 		/* First policy load, so no need to preserve state from old policy */
-		*newpolicyp = newpolicy;
+		load_state->policy = newpolicy;
+		load_state->convert_data = NULL;
 		return 0;
 	}
 
@@ -2290,29 +2296,38 @@ int security_load_policy(struct selinux_
 		goto err_free_isids;
 	}
 
+	convert_data = kmalloc(sizeof(*convert_data), GFP_KERNEL);
+	if (!convert_data) {
+		rc = -ENOMEM;
+		goto err_free_isids;
+	}
+
 	/*
 	 * Convert the internal representations of contexts
 	 * in the new SID table.
 	 */
-	args.state = state;
-	args.oldp = &oldpolicy->policydb;
-	args.newp = &newpolicy->policydb;
-
-	convert_params.func = convert_context;
-	convert_params.args = &args;
-	convert_params.target = newpolicy->sidtab;
+	convert_data->args.state = state;
+	convert_data->args.oldp = &oldpolicy->policydb;
+	convert_data->args.newp = &newpolicy->policydb;
+
+	convert_data->sidtab_params.func = convert_context;
+	convert_data->sidtab_params.args = &convert_data->args;
+	convert_data->sidtab_params.target = newpolicy->sidtab;
 
-	rc = sidtab_convert(oldpolicy->sidtab, &convert_params);
+	rc = sidtab_convert(oldpolicy->sidtab, &convert_data->sidtab_params);
 	if (rc) {
 		pr_err("SELinux:  unable to convert the internal"
 			" representation of contexts in the new SID"
 			" table\n");
-		goto err_free_isids;
+		goto err_free_convert_data;
 	}
 
-	*newpolicyp = newpolicy;
+	load_state->policy = newpolicy;
+	load_state->convert_data = convert_data;
 	return 0;
 
+err_free_convert_data:
+	kfree(convert_data);
 err_free_isids:
 	sidtab_destroy(newpolicy->sidtab);
 err_mapping:


