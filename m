Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44258473DD6
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 08:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhLNH5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 02:57:04 -0500
Received: from linux.microsoft.com ([13.77.154.182]:55578 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhLNH5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 02:57:02 -0500
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 425FE20B7179;
        Mon, 13 Dec 2021 23:57:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 425FE20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1639468622;
        bh=EoWq2F0uPs1hqGTQBP0dqE4KbO1aReFLIITReEqN7gE=;
        h=From:To:Cc:Subject:Date:From;
        b=TR/fw5PI7WQ1tzNwGjLyEc8V08bGLjPvCXO8lcAn4UIYAsq7wiUNfy6oKj4aSPo8a
         JdXzRt3AHj4pbY9HHgPFf9IQ593a85Mu0nJwN9F5TG3EPx5+hwqJh59MRdo9fGKygM
         OVEWUH/KnqGmCuwlYZcg6aq6TgGPBVzY8lYEj6B0=
From:   Vijay Balakrishna <vijayb@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 5.4] selinux: fix race condition when computing ocontext SIDs
Date:   Mon, 13 Dec 2021 23:56:51 -0800
Message-Id: <1639468611-9753-1-git-send-email-vijayb@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
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
(cherry picked from commit cbfcd13be5cb2a07868afe67520ed181956579a7)
[vijayb: Backport contextual differences are due to v5.10 RCU related
 changes are not in 5.4]
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
---

We have kernel crashes with stack traces related to selinux security
context to sid in 5.4 --
https://lore.kernel.org/all/af058f59-ce8a-7648-25e8-f8b8a2dbb0ba@linux.microsoft.com/#t
Unfortunately we don't have a on-demand repro.  We are hoping this
patch would help in addressing a possible race in 5.4.

[    6.222870] Unable to handle kernel access to user memory outside uaccess routines at virtual address 000000000000000c
[    6.222875] Mem abort info:
[    6.222876]   ESR = 0x96000004
[    6.222878]   EC = 0x25: DABT (current EL), IL = 32 bits
[    6.222879]   SET = 0, FnV = 0
[    6.222881]   EA = 0, S1PTW = 0
[    6.222881] Data abort info:
[    6.222883]   ISV = 0, ISS = 0x00000004
[    6.222884]   CM = 0, WnR = 0
[    6.222887] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000965148000
[    6.222888] [000000000000000c] pgd=0000000000000000
[    6.222893] Internal error: Oops: 96000004 [#1] SMP
[    6.227931] Modules linked in: bnxt_en pcie_iproc_platform pcie_iproc diagbe(O)
[    6.235480] CPU: 6 PID: 1 Comm: systemd Tainted: G           O      5.4.144-xx #1
[    6.244632] Hardware name: Overlake (DT)
[    6.248677] pstate: 80400005 (Nzcv daif +PAN -UAO)
[    6.253629] pc : sidtab_context_to_sid+0x154/0x600
[    6.258570] lr : sidtab_context_to_sid+0x150/0x600
[    6.263510] sp : ffff80001005b7e0
[    6.266928] x29: ffff80001005b7e0 x28: 0000000000000000
[    6.272406] x27: 0000000000000000 x26: ffff80001005b8d8
[    6.277884] x25: ffff80001005b8f0 x24: ffff250b25230000
[    6.283362] x23: ffff80001005b9a4 x22: ffffd429fedb9808
[    6.288841] x21: ffff80001005b8c0 x20: 0000000000000118
[    6.294319] x19: 0000000000000000 x18: 0000000000000000
[    6.299797] x17: 0000000000000000 x16: 0000000000000000
[    6.305275] x15: 0000000000000000 x14: 0000000000000000
[    6.310753] x13: 0000000000000000 x12: 0000000000000010
[    6.316231] x11: 0000000000000010 x10: 0101010101010101
[    6.321710] x9 : fffffffffffffffe x8 : 7f7f7f7f7f7f7f7f
[    6.327188] x7 : fefefefefeff735e x6 : 0000808080808080
[    6.332667] x5 : 0000000000000000 x4 : ffff250b25230000
[    6.338144] x3 : ffff80001005b8c0 x2 : 0000000000000000
[    6.343622] x1 : 0000000000000119 x0 : 0000000000000000
[    6.349100] Call trace:
[    6.351625]  sidtab_context_to_sid+0x154/0x600
[    6.356207]  security_context_to_sid_core.isra.21+0x190/0x250
[    6.362133]  security_context_to_sid+0x54/0x68
[    6.366715]  selinux_kernfs_init_security+0xd0/0x210
[    6.371838]  security_kernfs_init_security+0x40/0x60
[    6.376961]  __kernfs_new_node+0x174/0x218
[    6.381185]  kernfs_new_node+0x60/0x90
[    6.385051]  __kernfs_create_file+0x60/0x300
[    6.389457]  cgroup_addrm_files+0x14c/0x308
[    6.393770]  css_populate_dir+0x7c/0x168
[    6.397815]  cgroup_apply_control_enable+0x100/0x348
[    6.402934]  cgroup_mkdir+0x380/0x520
[    6.406710]  kernfs_iop_mkdir+0x94/0xf0
[    6.410666]  vfs_mkdir+0xf4/0x1c0
[    6.414084]  do_mkdirat+0x98/0x110
[    6.417590]  __arm64_sys_mkdirat+0x28/0x38
[    6.421817]  el0_svc_handler+0x90/0x138
[    6.425773]  el0_svc+0x8/0x208
[    6.428925] Code: 2a1403e1 aa1803e0 97fffd81 aa0003fc (b9400c00)
[    6.435219] ---[ end trace bb81d12a8eb77133 ]---
---
 security/selinux/ss/services.c | 159 ++++++++++++++++++---------------
 1 file changed, 87 insertions(+), 72 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f62adf3cfce8..a0afe49309c8 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2250,6 +2250,43 @@ size_t security_policydb_len(struct selinux_state *state)
 	return len;
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
  * @protocol: protocol number
@@ -2262,10 +2299,12 @@ int security_port_sid(struct selinux_state *state,
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
 
@@ -2279,14 +2318,11 @@ int security_port_sid(struct selinux_state *state,
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
@@ -2308,10 +2344,12 @@ int security_ib_pkey_sid(struct selinux_state *state,
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
 
@@ -2326,14 +2364,11 @@ int security_ib_pkey_sid(struct selinux_state *state,
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
 
@@ -2354,10 +2389,12 @@ int security_ib_endport_sid(struct selinux_state *state,
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
 
@@ -2373,14 +2410,11 @@ int security_ib_endport_sid(struct selinux_state *state,
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
 
@@ -2399,11 +2433,13 @@ int security_netif_sid(struct selinux_state *state,
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
 
@@ -2415,19 +2451,11 @@ int security_netif_sid(struct selinux_state *state,
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
 
@@ -2469,6 +2497,7 @@ int security_node_sid(struct selinux_state *state,
 
 	read_lock(&state->ss->policy_rwlock);
 
+retry:
 	policydb = &state->ss->policydb;
 	sidtab = state->ss->sidtab;
 
@@ -2511,14 +2540,11 @@ int security_node_sid(struct selinux_state *state,
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
@@ -2677,7 +2703,7 @@ static inline int __security_genfs_sid(struct selinux_state *state,
 	u16 sclass;
 	struct genfs *genfs;
 	struct ocontext *c;
-	int rc, cmp = 0;
+	int cmp = 0;
 
 	while (path[0] == '/' && path[1] == '/')
 		path++;
@@ -2691,9 +2717,8 @@ static inline int __security_genfs_sid(struct selinux_state *state,
 			break;
 	}
 
-	rc = -ENOENT;
 	if (!genfs || cmp)
-		goto out;
+		return -ENOENT;
 
 	for (c = genfs->head; c; c = c->next) {
 		len = strlen(c->u.name);
@@ -2702,20 +2727,10 @@ static inline int __security_genfs_sid(struct selinux_state *state,
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
@@ -2750,13 +2765,15 @@ int security_fs_use(struct selinux_state *state, struct super_block *sb)
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
 
@@ -2769,13 +2786,11 @@ int security_fs_use(struct selinux_state *state, struct super_block *sb)
 
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
-- 
2.30.2

