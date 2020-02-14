Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648F615EDE9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390058AbgBNRhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390134AbgBNQFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84152217F4;
        Fri, 14 Feb 2020 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696317;
        bh=iwSvttZTfnoJ59Q8etcVUaUYc9taDPg1Smxi16iiWtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh4O5ehJb7SvrsxReoHAFO9LgOzFdTyRULosSHSvnqR5gKzGgf8xsh+Kpp1qlyAM4
         TwYRqD1TLJaO1o/yoOv+P3NzZUXY53YPTUjDcfNrqk8yljq5l6ixh7pILH+4hrz2YR
         Gs1BntZKkcSsw0TrqeYfgLbiZ/2bkl4JKDl8BhSA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <sds@tycho.nsa.gov>, Will Deacon <will@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 158/459] selinux: fall back to ref-walk if audit is required
Date:   Fri, 14 Feb 2020 10:56:48 -0500
Message-Id: <20200214160149.11681-158-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

[ Upstream commit 0188d5c025ca8fe756ba3193bd7d150139af5a88 ]

commit bda0be7ad994 ("security: make inode_follow_link RCU-walk aware")
passed down the rcu flag to the SELinux AVC, but failed to adjust the
test in slow_avc_audit() to also return -ECHILD on LSM_AUDIT_DATA_DENTRY.
Previously, we only returned -ECHILD if generating an audit record with
LSM_AUDIT_DATA_INODE since this was only relevant from inode_permission.
Move the handling of MAY_NOT_BLOCK to avc_audit() and its inlined
equivalent in selinux_inode_permission() immediately after we determine
that audit is required, and always fall back to ref-walk in this case.

Fixes: bda0be7ad994 ("security: make inode_follow_link RCU-walk aware")
Reported-by: Will Deacon <will@kernel.org>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c         | 24 +++++-------------------
 security/selinux/hooks.c       | 11 +++++++----
 security/selinux/include/avc.h |  8 +++++---
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 74c43ebe34bb8..23dc888ae3056 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -424,7 +424,7 @@ static inline int avc_xperms_audit(struct selinux_state *state,
 	if (likely(!audited))
 		return 0;
 	return slow_avc_audit(state, ssid, tsid, tclass, requested,
-			audited, denied, result, ad, 0);
+			audited, denied, result, ad);
 }
 
 static void avc_node_free(struct rcu_head *rhead)
@@ -758,8 +758,7 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
 noinline int slow_avc_audit(struct selinux_state *state,
 			    u32 ssid, u32 tsid, u16 tclass,
 			    u32 requested, u32 audited, u32 denied, int result,
-			    struct common_audit_data *a,
-			    unsigned int flags)
+			    struct common_audit_data *a)
 {
 	struct common_audit_data stack_data;
 	struct selinux_audit_data sad;
@@ -772,17 +771,6 @@ noinline int slow_avc_audit(struct selinux_state *state,
 		a->type = LSM_AUDIT_DATA_NONE;
 	}
 
-	/*
-	 * When in a RCU walk do the audit on the RCU retry.  This is because
-	 * the collection of the dname in an inode audit message is not RCU
-	 * safe.  Note this may drop some audits when the situation changes
-	 * during retry. However this is logically just as if the operation
-	 * happened a little later.
-	 */
-	if ((a->type == LSM_AUDIT_DATA_INODE) &&
-	    (flags & MAY_NOT_BLOCK))
-		return -ECHILD;
-
 	sad.tclass = tclass;
 	sad.requested = requested;
 	sad.ssid = ssid;
@@ -855,16 +843,14 @@ static int avc_update_node(struct selinux_avc *avc,
 	/*
 	 * If we are in a non-blocking code path, e.g. VFS RCU walk,
 	 * then we must not add permissions to a cache entry
-	 * because we cannot safely audit the denial.  Otherwise,
+	 * because we will not audit the denial.  Otherwise,
 	 * during the subsequent blocking retry (e.g. VFS ref walk), we
 	 * will find the permissions already granted in the cache entry
 	 * and won't audit anything at all, leading to silent denials in
 	 * permissive mode that only appear when in enforcing mode.
 	 *
-	 * See the corresponding handling in slow_avc_audit(), and the
-	 * logic in selinux_inode_follow_link and selinux_inode_permission
-	 * for the VFS MAY_NOT_BLOCK flag, which is transliterated into
-	 * AVC_NONBLOCKING for avc_has_perm_noaudit().
+	 * See the corresponding handling of MAY_NOT_BLOCK in avc_audit()
+	 * and selinux_inode_permission().
 	 */
 	if (flags & AVC_NONBLOCKING)
 		return 0;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9943539457906..44e2f46d46d2c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3015,8 +3015,7 @@ static int selinux_inode_follow_link(struct dentry *dentry, struct inode *inode,
 
 static noinline int audit_inode_permission(struct inode *inode,
 					   u32 perms, u32 audited, u32 denied,
-					   int result,
-					   unsigned flags)
+					   int result)
 {
 	struct common_audit_data ad;
 	struct inode_security_struct *isec = selinux_inode(inode);
@@ -3027,7 +3026,7 @@ static noinline int audit_inode_permission(struct inode *inode,
 
 	rc = slow_avc_audit(&selinux_state,
 			    current_sid(), isec->sid, isec->sclass, perms,
-			    audited, denied, result, &ad, flags);
+			    audited, denied, result, &ad);
 	if (rc)
 		return rc;
 	return 0;
@@ -3074,7 +3073,11 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	if (likely(!audited))
 		return rc;
 
-	rc2 = audit_inode_permission(inode, perms, audited, denied, rc, flags);
+	/* fall back to ref-walk if we have to generate audit */
+	if (flags & MAY_NOT_BLOCK)
+		return -ECHILD;
+
+	rc2 = audit_inode_permission(inode, perms, audited, denied, rc);
 	if (rc2)
 		return rc2;
 	return rc;
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 74ea50977c201..cf4cc3ef959b5 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -100,8 +100,7 @@ static inline u32 avc_audit_required(u32 requested,
 int slow_avc_audit(struct selinux_state *state,
 		   u32 ssid, u32 tsid, u16 tclass,
 		   u32 requested, u32 audited, u32 denied, int result,
-		   struct common_audit_data *a,
-		   unsigned flags);
+		   struct common_audit_data *a);
 
 /**
  * avc_audit - Audit the granting or denial of permissions.
@@ -135,9 +134,12 @@ static inline int avc_audit(struct selinux_state *state,
 	audited = avc_audit_required(requested, avd, result, 0, &denied);
 	if (likely(!audited))
 		return 0;
+	/* fall back to ref-walk if we have to generate audit */
+	if (flags & MAY_NOT_BLOCK)
+		return -ECHILD;
 	return slow_avc_audit(state, ssid, tsid, tclass,
 			      requested, audited, denied, result,
-			      a, flags);
+			      a);
 }
 
 #define AVC_STRICT 1 /* Ignore permissive mode. */
-- 
2.20.1

