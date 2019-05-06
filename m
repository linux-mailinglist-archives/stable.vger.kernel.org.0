Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3223F14ECF
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfEFOiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfEFOiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2816821479;
        Mon,  6 May 2019 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153497;
        bh=FvI5gFX9R24R70VbdiLlNJDE4Pc3Edl/7/lv98bBtKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bv7V2O2f+edOwulfp1X9MaZZRBO5olTbCy0523SYDOFYo1ojT8AGT0yinK0po+p4H
         RRz2d8DwGsC3eCfs2r/ctnrJl4/Tt62ni37ruQ10Q/CPiMtSJC18Hh8x5AI+RiBD1Y
         Xz0FjUWKNid3N0lQZWROwCnP72OwwfvZhL6MYy+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, BMK <bmktuwien@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.0 112/122] selinux: avoid silent denials in permissive mode under RCU walk
Date:   Mon,  6 May 2019 16:32:50 +0200
Message-Id: <20190506143104.534069852@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/avc.c         |   23 +++++++++++++++++++++--
 security/selinux/hooks.c       |    4 +++-
 security/selinux/include/avc.h |    1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -838,6 +838,7 @@ out:
  * @ssid,@tsid,@tclass : identifier of an AVC entry
  * @seqno : sequence number when decision was made
  * @xpd: extended_perms_decision to be added to the node
+ * @flags: the AVC_* flags, e.g. AVC_NONBLOCKING, AVC_EXTENDED_PERMS, or 0.
  *
  * if a valid AVC entry doesn't exist,this function returns -ENOENT.
  * if kmalloc() called internal returns NULL, this function returns -ENOMEM.
@@ -856,6 +857,23 @@ static int avc_update_node(struct selinu
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
 	node = avc_alloc_node(avc);
 	if (!node) {
 		rc = -ENOMEM;
@@ -1115,7 +1133,7 @@ decision:
  * @tsid: target security identifier
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
- * @flags:  AVC_STRICT or 0
+ * @flags:  AVC_STRICT, AVC_NONBLOCKING, or 0
  * @avd: access vector decisions
  *
  * Check the AVC to determine whether the @requested permissions are granted
@@ -1199,7 +1217,8 @@ int avc_has_perm_flags(struct selinux_st
 	struct av_decision avd;
 	int rc, rc2;
 
-	rc = avc_has_perm_noaudit(state, ssid, tsid, tclass, requested, 0,
+	rc = avc_has_perm_noaudit(state, ssid, tsid, tclass, requested,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
 				  &avd);
 
 	rc2 = avc_audit(state, ssid, tsid, tclass, requested, &avd, rc,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2985,7 +2985,9 @@ static int selinux_inode_permission(stru
 		return PTR_ERR(isec);
 
 	rc = avc_has_perm_noaudit(&selinux_state,
-				  sid, isec->sid, isec->sclass, perms, 0, &avd);
+				  sid, isec->sid, isec->sclass, perms,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
 	audited = avc_audit_required(perms, &avd, rc,
 				     from_access ? FILE__AUDIT_ACCESS : 0,
 				     &denied);
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -142,6 +142,7 @@ static inline int avc_audit(struct selin
 
 #define AVC_STRICT 1 /* Ignore permissive mode. */
 #define AVC_EXTENDED_PERMS 2	/* update extended permissions */
+#define AVC_NONBLOCKING    4	/* non blocking */
 int avc_has_perm_noaudit(struct selinux_state *state,
 			 u32 ssid, u32 tsid,
 			 u16 tclass, u32 requested,


