Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E613C452521
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344486AbhKPBqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241926AbhKOSZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419D763283;
        Mon, 15 Nov 2021 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998997;
        bh=xwyCDuGa1sL+Hdc2cT2EvXEd3KzcpyOa9QxTuvSMMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5KAB6cx/rPpKU+RcYES6Q2G0KosEFsliHPq8CtlJMPMF9WtATWD9H3Q7Z4zfiXBN
         926JPbHcce5fN2ywFUqrHVkFzW3bkPZXezQpopmBPSqHxkclV+q1zB5PUpoHA/56yi
         oFYI9odGFjv3vEpe76txp/12lFBlciAofaUUXsTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xinjie Zheng <xinjie@google.com>,
        Sujithra Periasamy <sujithra@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.14 105/849] selinux: fix race condition when computing ocontext SIDs
Date:   Mon, 15 Nov 2021 17:53:08 +0100
Message-Id: <20211115165423.632006047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit cbfcd13be5cb2a07868afe67520ed181956579a7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |  162 +++++++++++++++++++----------------------
 1 file changed, 77 insertions(+), 85 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2375,6 +2375,43 @@ err_policy:
 }
 
 /**
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
+/**
  * security_port_sid - Obtain the SID for a port.
  * @state: SELinux state
  * @protocol: protocol number
@@ -2412,17 +2449,13 @@ retry:
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
@@ -2471,18 +2504,13 @@ retry:
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
 
@@ -2531,17 +2559,13 @@ retry:
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
 
@@ -2585,25 +2609,13 @@ retry:
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
 
@@ -2695,18 +2707,13 @@ retry:
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
@@ -2871,7 +2878,7 @@ static inline int __security_genfs_sid(s
 	u16 sclass;
 	struct genfs *genfs;
 	struct ocontext *c;
-	int rc, cmp = 0;
+	int cmp = 0;
 
 	while (path[0] == '/' && path[1] == '/')
 		path++;
@@ -2885,9 +2892,8 @@ static inline int __security_genfs_sid(s
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!genfs || cmp)
-		goto out;
+		return -ENOENT;
 
 	for (c = genfs->head; c; c = c->next) {
 		len = strlen(c->u.name);
@@ -2896,20 +2902,10 @@ static inline int __security_genfs_sid(s
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!c)
-		goto out;
+		return -ENOENT;
 
-	if (!c->sid[0]) {
-		rc = sidtab_context_to_sid(sidtab, &c->context[0], &c->sid[0]);
-		if (rc)
-			goto out;
-	}
-
-	*sid = c->sid[0];
-	rc = 0;
-out:
-	return rc;
+	return ocontext_to_sid(sidtab, c, 0, sid);
 }
 
 /**
@@ -2994,17 +2990,13 @@ retry:
 
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


