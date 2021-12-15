Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE1475F2E
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhLOR2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbhLOR1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:27:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC84C0613B4;
        Wed, 15 Dec 2021 09:26:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FA2B8202B;
        Wed, 15 Dec 2021 17:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D94DC36AE2;
        Wed, 15 Dec 2021 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589169;
        bh=Sq/71RSsotFYaoRHT5gT82Pvznye7HKyEPNdxT3OD5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0G75yRp4NYpUb7/I1GAOlplhK6ZtfrnliGpKLGBSeNXiLP7o9Dmh2O9yXG2IJwco
         IBSRdjmoMyVbtFN705FTv21KaZmxmcNRDWfXC9fWcWhY057XhZhLOPRw2cr2yQa0CE
         WkX3QB5n4LWwutUfXg1Nt08D5kUN51ZlMRZlIfzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xinjie Zheng <xinjie@google.com>,
        Sujithra Periasamy <sujithra@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: [PATCH 5.4 11/18] selinux: fix race condition when computing ocontext SIDs
Date:   Wed, 15 Dec 2021 18:21:32 +0100
Message-Id: <20211215172023.192907977@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
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
[vijayb: Backport contextual differences are due to v5.10 RCU related
 changes are not in 5.4]
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |  159 ++++++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 72 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2251,6 +2251,43 @@ size_t security_policydb_len(struct seli
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
  * @protocol: protocol number
  * @port: port number
@@ -2262,10 +2299,12 @@ int security_port_sid(struct selinux_sta
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
+	rc = 0;
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2279,14 +2318,11 @@ int security_port_sid(struct selinux_sta
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc)
-				goto out;
-		}
-		*out_sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else {
 		*out_sid = SECINITSID_PORT;
 	}
@@ -2308,10 +2344,12 @@ int security_ib_pkey_sid(struct selinux_
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
+	rc = 0;
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2326,14 +2364,11 @@ int security_ib_pkey_sid(struct selinux_
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc)
-				goto out;
-		}
-		*out_sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else
 		*out_sid = SECINITSID_UNLABELED;
 
@@ -2354,10 +2389,12 @@ int security_ib_endport_sid(struct selin
 	struct policydb *policydb;
 	struct sidtab *sidtab;
 	struct ocontext *c;
-	int rc = 0;
+	int rc;
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
+	rc = 0;
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2373,14 +2410,11 @@ int security_ib_endport_sid(struct selin
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc)
-				goto out;
-		}
-		*out_sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else
 		*out_sid = SECINITSID_UNLABELED;
 
@@ -2399,11 +2433,13 @@ int security_netif_sid(struct selinux_st
 {
 	struct policydb *policydb;
 	struct sidtab *sidtab;
-	int rc = 0;
+	int rc;
 	struct ocontext *c;
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
+	rc = 0;
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2415,19 +2451,11 @@ int security_netif_sid(struct selinux_st
 	}
 
 	if (c) {
-		if (!c->sid[0] || !c->sid[1]) {
-			rc = sidtab_context_to_sid(sidtab,
-						  &c->context[0],
-						  &c->sid[0]);
-			if (rc)
-				goto out;
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[1],
-						   &c->sid[1]);
-			if (rc)
-				goto out;
-		}
-		*if_sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, if_sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else
 		*if_sid = SECINITSID_NETIF;
 
@@ -2469,6 +2497,7 @@ int security_node_sid(struct selinux_sta
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2511,14 +2540,11 @@ int security_node_sid(struct selinux_sta
 	}
 
 	if (c) {
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab,
-						   &c->context[0],
-						   &c->sid[0]);
-			if (rc)
-				goto out;
-		}
-		*out_sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, out_sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else {
 		*out_sid = SECINITSID_NODE;
 	}
@@ -2677,7 +2703,7 @@ static inline int __security_genfs_sid(s
 	u16 sclass;
 	struct genfs *genfs;
 	struct ocontext *c;
-	int rc, cmp = 0;
+	int cmp = 0;
 
 	while (path[0] == '/' && path[1] == '/')
 		path++;
@@ -2691,9 +2717,8 @@ static inline int __security_genfs_sid(s
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!genfs || cmp)
-		goto out;
+		return -ENOENT;
 
 	for (c = genfs->head; c; c = c->next) {
 		len = strlen(c->u.name);
@@ -2702,20 +2727,10 @@ static inline int __security_genfs_sid(s
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
@@ -2750,13 +2765,15 @@ int security_fs_use(struct selinux_state
 {
 	struct policydb *policydb;
 	struct sidtab *sidtab;
-	int rc = 0;
+	int rc;
 	struct ocontext *c;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *fstype = sb->s_type->name;
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
+	rc = 0;
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2769,13 +2786,11 @@ int security_fs_use(struct selinux_state
 
 	if (c) {
 		sbsec->behavior = c->v.behavior;
-		if (!c->sid[0]) {
-			rc = sidtab_context_to_sid(sidtab, &c->context[0],
-						   &c->sid[0]);
-			if (rc)
-				goto out;
-		}
-		sbsec->sid = c->sid[0];
+		rc = ocontext_to_sid(sidtab, c, 0, &sbsec->sid);
+		if (rc == -ESTALE)
+			goto retry;
+		if (rc)
+			goto out;
 	} else {
 		rc = __security_genfs_sid(state, fstype, "/", SECCLASS_DIR,
 					  &sbsec->sid);


