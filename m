Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320E644F395
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhKMOTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhKMOTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:19:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1793B61154;
        Sat, 13 Nov 2021 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636812985;
        bh=Ys5WM1UdkdAFHSL/b+85ql7EU+HSe+WH8xCpc3THVnM=;
        h=Subject:To:Cc:From:Date:From;
        b=Hl8wl7DpL2ix3LOuvnVIkFppwgquXIqQt5ymA6sGKw6tsUudErqU2BQSOaMgnLi+d
         A4fFOS4XSkcxDvnVKyAzUvTDvDb4vv0Vlv+/GgmjEyc1HUme9Zai2cSUL1lRv3mDu/
         /vRmTgDmei6FdCco2IEIowD+3h9/lK+AkcYt0fZE=
Subject: FAILED: patch "[PATCH] selinux: fix race condition when computing ocontext SIDs" failed to apply to 4.14-stable tree
To:     omosnace@redhat.com, paul@paul-moore.com, sujithra@google.com,
        xinjie@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:16:18 +0100
Message-ID: <1636812978113114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cbfcd13be5cb2a07868afe67520ed181956579a7 Mon Sep 17 00:00:00 2001
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Wed, 28 Jul 2021 16:03:13 +0200
Subject: [PATCH] selinux: fix race condition when computing ocontext SIDs

Current code contains a lot of racy patterns when converting an
ocontext's context structure to an SID. This is being done in a "lazy"
fashion, such that the SID is looked up in the SID table only when it's
first needed and then cached in the "sid" field of the ocontext
structure. However, this is done without any locking or memory barriers
and is thus unsafe.

Between commits 24ed7fdae669 ("selinux: use separate table for initial
SID lookup") and 66f8e2f03c02 ("selinux: sidtab reverse lookup hash
table"), this race condition lead to an actual observable bug, because a
pointer to the shared sid field was passed directly to
sidtab_context_to_sid(), which was using this location to also store an
intermediate value, which could have been read by other threads and
interpreted as an SID. In practice this caused e.g. new mounts to get a
wrong (seemingly random) filesystem context, leading to strange denials.
This bug has been spotted in the wild at least twice, see [1] and [2].

Fix the race condition by making all the racy functions use a common
helper that ensures the ocontext::sid accesses are made safely using the
appropriate SMP constructs.

Note that security_netif_sid() was populating the sid field of both
contexts stored in the ocontext, but only the first one was actually
used. The SELinux wiki's documentation on the "netifcon" policy
statement [3] suggests that using only the first context is intentional.
I kept only the handling of the first context here, as there is really
no point in doing the SID lookup for the unused one.

I wasn't able to reproduce the bug mentioned above on any kernel that
includes commit 66f8e2f03c02, even though it has been reported that the
issue occurs with that commit, too, just less frequently. Thus, I wasn't
able to verify that this patch fixes the issue, but it makes sense to
avoid the race condition regardless.

[1] https://github.com/containers/container-selinux/issues/89
[2] https://lists.fedoraproject.org/archives/list/selinux@lists.fedoraproject.org/thread/6DMTAMHIOAOEMUAVTULJD45JZU7IBAFM/
[3] https://selinuxproject.org/page/NetworkStatements#netifcon

Cc: stable@vger.kernel.org
Cc: Xinjie Zheng <xinjie@google.com>
Reported-by: Sujithra Periasamy <sujithra@google.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index e5f1b2757a83..c4931bf6f92a 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2376,6 +2376,43 @@ err_policy:
 	return rc;
 }
 
+/**
+ * ocontext_to_sid - Helper to safely get sid for an ocontext
+ * @sidtab: SID table
+ * @c: ocontext structure
+ * @index: index of the context entry (0 or 1)
+ * @out_sid: pointer to the resulting SID value
+ *
+ * For all ocontexts except OCON_ISID the SID fields are populated
+ * on-demand when needed. Since updating the SID value is an SMP-sensitive
+ * operation, this helper must be used to do that safely.
+ *
+ * WARNING: This function may return -ESTALE, indicating that the caller
+ * must retry the operation after re-acquiring the policy pointer!
+ */
+static int ocontext_to_sid(struct sidtab *sidtab, struct ocontext *c,
+			   size_t index, u32 *out_sid)
+{
+	int rc;
+	u32 sid;
+
+	/* Ensure the associated sidtab entry is visible to this thread. */
+	sid = smp_load_acquire(&c->sid[index]);
+	if (!sid) {
+		rc = sidtab_context_to_sid(sidtab, &c->context[index], &sid);
+		if (rc)
+			return rc;
+
+		/*
+		 * Ensure the new sidtab entry is visible to other threads
+		 * when they see the SID.
+		 */
+		smp_store_release(&c->sid[index], sid);
+	}
+	*out_sid = sid;
+	return 0;
+}
+
 /**
  * security_port_sid - Obtain the SID for a port.
  * @state: SELinux state
@@ -2414,17 +2451,13 @@ retry:
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab, &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		*out_sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else {
 		*out_sid = SECINITSID_PORT;
 	}
@@ -2473,18 +2506,13 @@ retry:
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		*out_sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else
 		*out_sid = SECINITSID_UNLABELED;
 
@@ -2533,17 +2561,13 @@ retry:
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab, &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		*out_sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else
 		*out_sid = SECINITSID_UNLABELED;
 
@@ -2587,25 +2611,13 @@ retry:
 	}
 
 	if (c) {
-		if (!c->sid[0] || !c->sid[1]) {
-			rc = sidtab_context_to_sid(sidtab, &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
-			rc = sidtab_context_to_sid(sidtab, &c->context[1],
-						   &c->sid[1]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, if_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		*if_sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else
 		*if_sid = SECINITSID_NETIF;
 
@@ -2697,18 +2709,13 @@ retry:
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		*out_sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else {
 		*out_sid = SECINITSID_NODE;
 	}
@@ -2873,7 +2880,7 @@ static inline int __security_genfs_sid(struct selinux_policy *policy,
 	u16 sclass;
 	struct genfs *genfs;
 	struct ocontext *c;
-	int rc, cmp = 0;
+	int cmp = 0;
 
 	while (path[0] == '/' && path[1] == '/')
 		path++;
@@ -2887,9 +2894,8 @@ static inline int __security_genfs_sid(struct selinux_policy *policy,
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!genfs || cmp)
-		goto out;
+		return -ENOENT;
 
 	for (c = genfs->head; c; c = c->next) {
 		len = strlen(c->u.name);
@@ -2898,20 +2904,10 @@ static inline int __security_genfs_sid(struct selinux_policy *policy,
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!c)
-		goto out;
-
-	if (!c->sid[0]) {
-		rc = sidtab_context_to_sid(sidtab, &c->context[0], &c->sid[0]);
-		if (rc)
-			goto out;
-	}
+		return -ENOENT;
 
-	*sid = c->sid[0];
-	rc = 0;
-out:
-	return rc;
+	return ocontext_to_sid(sidtab, c, 0, sid);
 }
 
 /**
@@ -2996,17 +2992,13 @@ retry:
 
 	if (c) {
 		sbsec->behavior = c->v.behavior;
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab, &c->context[0],
-						   &c->sid[0]);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out;
+		rc = ocontext_to_sid(sidtab, c, 0, &sbsec->sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			goto retry;
 		}
-		sbsec->sid = c->sid[0];
+		if (rc)
+			goto out;
 	} else {
 		rc = __security_genfs_sid(policy, fstype, "/",
 					SECCLASS_DIR, &sbsec->sid);

