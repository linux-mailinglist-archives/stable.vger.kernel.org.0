Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F1E61734
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfGGTqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57004 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727499AbfGGTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:04 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0006eD-It; Sun, 07 Jul 2019 20:38:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005Y8-0g; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Stephen Smalley" <sds@tycho.nsa.gov>, "BMK" <bmktuwien@gmail.com>,
        "Paul Moore" <paul@paul-moore.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.993303889@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 023/129] selinux: avoid silent denials in permissive
 mode under RCU walk
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <sds@tycho.nsa.gov>

commit 3a28cff3bd4bf43f02be0c4e7933aebf3dc8197e upstream.

commit 0dc1ba24f7fff6 ("SELINUX: Make selinux cache VFS RCU walks safe")
results in no audit messages at all if in permissive mode because the
cache is updated during the rcu walk and thus no denial occurs on
the subsequent ref walk.  Fix this by not updating the cache when
performing a non-blocking permission check.  This only affects search
and symlink read checks during rcu walk.

Fixes: 0dc1ba24f7fff6 ("SELINUX: Make selinux cache VFS RCU walks safe")
Reported-by: BMK <bmktuwien@gmail.com>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[bwh: Backported to 3.16:
 - Add flags parameter to avc_update_node(), done upstream in commit
   fa1aa143ac4a "selinux: extended permissions for ioctls"
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -528,6 +528,7 @@ static inline int avc_sidcmp(u32 x, u32
  * @perms : Permission mask bits
  * @ssid,@tsid,@tclass : identifier of an AVC entry
  * @seqno : sequence number when decision was made
+ * @flags: the AVC_* flags, e.g. AVC_NONBLOCKING, AVC_EXTENDED_PERMS, or 0.
  *
  * if a valid AVC entry doesn't exist,this function returns -ENOENT.
  * if kmalloc() called internal returns NULL, this function returns -ENOMEM.
@@ -535,7 +536,7 @@ static inline int avc_sidcmp(u32 x, u32
  * will release later by RCU.
  */
 static int avc_update_node(u32 event, u32 perms, u32 ssid, u32 tsid, u16 tclass,
-			   u32 seqno)
+			   u32 seqno, unsigned int flags)
 {
 	int hvalue, rc = 0;
 	unsigned long flag;
@@ -543,6 +544,23 @@ static int avc_update_node(u32 event, u3
 	struct hlist_head *head;
 	spinlock_t *lock;
 
+	/*
+	 * If we are in a non-blocking code path, e.g. VFS RCU walk,
+	 * then we must not add permissions to a cache entry
+	 * because we cannot safely audit the denial.  Otherwise,
+	 * during the subsequent blocking retry (e.g. VFS ref walk), we
+	 * will find the permissions already granted in the cache entry
+	 * and won't audit anything at all, leading to silent denials in
+	 * permissive mode that only appear when in enforcing mode.
+	 *
+	 * See the corresponding handling in slow_avc_audit(), and the
+	 * logic in selinux_inode_follow_link and selinux_inode_permission
+	 * for the VFS MAY_NOT_BLOCK flag, which is transliterated into
+	 * AVC_NONBLOCKING for avc_has_perm_noaudit().
+	 */
+	if (flags & AVC_NONBLOCKING)
+		return 0;
+
 	node = avc_alloc_node();
 	if (!node) {
 		rc = -ENOMEM;
@@ -690,7 +708,7 @@ static noinline int avc_denied(u32 ssid,
 		return -EACCES;
 
 	avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
-				tsid, tclass, avd->seqno);
+			tsid, tclass, avd->seqno, flags);
 	return 0;
 }
 
@@ -701,7 +719,7 @@ static noinline int avc_denied(u32 ssid,
  * @tsid: target security identifier
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
- * @flags:  AVC_STRICT or 0
+ * @flags:  AVC_STRICT, AVC_NONBLOCKING, or 0
  * @avd: access vector decisions
  *
  * Check the AVC to determine whether the @requested permissions are granted
@@ -781,7 +799,9 @@ int avc_has_perm_flags(u32 ssid, u32 tsi
 	struct av_decision avd;
 	int rc, rc2;
 
-	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);
+	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
 
 	rc2 = avc_audit(ssid, tsid, tclass, requested, &avd, rc,
 			auditdata, flags);
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2818,7 +2818,9 @@ static int selinux_inode_permission(stru
 	sid = cred_sid(cred);
 	isec = inode->i_security;
 
-	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
+	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
 	audited = avc_audit_required(perms, &avd, rc,
 				     from_access ? FILE__AUDIT_ACCESS : 0,
 				     &denied);
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -143,6 +143,7 @@ static inline int avc_audit(u32 ssid, u3
 }
 
 #define AVC_STRICT 1 /* Ignore permissive mode. */
+#define AVC_NONBLOCKING    4	/* non blocking */
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 			 u16 tclass, u32 requested,
 			 unsigned flags,

