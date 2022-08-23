Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A259D3B8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbiHWILx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbiHWIKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C82869F50;
        Tue, 23 Aug 2022 01:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 662F86125A;
        Tue, 23 Aug 2022 08:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B54C433C1;
        Tue, 23 Aug 2022 08:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242061;
        bh=4N9AcPigy1UGJGRo7sTsLORTRnWlZmrSq/qM6X6kAEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmA3ezIA9L9LfOCrNtpr91+0vnN/xKjI2+/+PQIBFFJ11qRCIiP9l1vXOTtDtuZH/
         Ea6TM56MPoNJJjne/YlTeFxJTnz3UPJVuTE4o5RS3Ii7qi9eVR8GIQxvaDR/P9C2a2
         +RG3Cs3patOVel2V7W0Nx2qPfPT9tsGY+sSXLYkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 013/101] selinux: Convert isec->lock into a spinlock
Date:   Tue, 23 Aug 2022 10:02:46 +0200
Message-Id: <20220823080035.086186727@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 9287aed2ad1ff1bde5eb190bcd6dccd5f1cf47d3 upstream.

Convert isec->lock from a mutex into a spinlock.  Instead of holding
the lock while sleeping in inode_doinit_with_dentry, set
isec->initialized to LABEL_PENDING and release the lock.  Then, when
the sid has been determined, re-acquire the lock.  If isec->initialized
is still set to LABEL_PENDING, set isec->sid; otherwise, the sid has
been set by another task (LABEL_INITIALIZED) or invalidated
(LABEL_INVALID) in the meantime.

This fixes a deadlock on gfs2 where

 * one task is in inode_doinit_with_dentry -> gfs2_getxattr, holds
   isec->lock, and tries to acquire the inode's glock, and

 * another task is in do_xmote -> inode_go_inval ->
   selinux_inode_invalidate_secctx, holds the inode's glock, and
   tries to acquire isec->lock.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[PM: minor tweaks to keep checkpatch.pl happy]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c          |  101 +++++++++++++++++++++++---------------
 security/selinux/include/objsec.h |    5 +
 2 files changed, 66 insertions(+), 40 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -231,7 +231,7 @@ static int inode_alloc_security(struct i
 	if (!isec)
 		return -ENOMEM;
 
-	mutex_init(&isec->lock);
+	spin_lock_init(&isec->lock);
 	INIT_LIST_HEAD(&isec->list);
 	isec->inode = inode;
 	isec->sid = SECINITSID_UNLABELED;
@@ -1387,7 +1387,8 @@ static int inode_doinit_with_dentry(stru
 {
 	struct superblock_security_struct *sbsec = NULL;
 	struct inode_security_struct *isec = inode->i_security;
-	u32 sid;
+	u32 task_sid, sid = 0;
+	u16 sclass;
 	struct dentry *dentry;
 #define INITCONTEXTLEN 255
 	char *context = NULL;
@@ -1397,7 +1398,7 @@ static int inode_doinit_with_dentry(stru
 	if (isec->initialized == LABEL_INITIALIZED)
 		return 0;
 
-	mutex_lock(&isec->lock);
+	spin_lock(&isec->lock);
 	if (isec->initialized == LABEL_INITIALIZED)
 		goto out_unlock;
 
@@ -1416,12 +1417,18 @@ static int inode_doinit_with_dentry(stru
 		goto out_unlock;
 	}
 
+	sclass = isec->sclass;
+	task_sid = isec->task_sid;
+	sid = isec->sid;
+	isec->initialized = LABEL_PENDING;
+	spin_unlock(&isec->lock);
+
 	switch (sbsec->behavior) {
 	case SECURITY_FS_USE_NATIVE:
 		break;
 	case SECURITY_FS_USE_XATTR:
 		if (!(inode->i_opflags & IOP_XATTR)) {
-			isec->sid = sbsec->def_sid;
+			sid = sbsec->def_sid;
 			break;
 		}
 		/* Need a dentry, since the xattr API requires one.
@@ -1443,7 +1450,7 @@ static int inode_doinit_with_dentry(stru
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			goto out_unlock;
+			goto out;
 		}
 
 		len = INITCONTEXTLEN;
@@ -1451,7 +1458,7 @@ static int inode_doinit_with_dentry(stru
 		if (!context) {
 			rc = -ENOMEM;
 			dput(dentry);
-			goto out_unlock;
+			goto out;
 		}
 		context[len] = '\0';
 		rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, context, len);
@@ -1462,14 +1469,14 @@ static int inode_doinit_with_dentry(stru
 			rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, NULL, 0);
 			if (rc < 0) {
 				dput(dentry);
-				goto out_unlock;
+				goto out;
 			}
 			len = rc;
 			context = kmalloc(len+1, GFP_NOFS);
 			if (!context) {
 				rc = -ENOMEM;
 				dput(dentry);
-				goto out_unlock;
+				goto out;
 			}
 			context[len] = '\0';
 			rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, context, len);
@@ -1481,7 +1488,7 @@ static int inode_doinit_with_dentry(stru
 				       "%d for dev=%s ino=%ld\n", __func__,
 				       -rc, inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
-				goto out_unlock;
+				goto out;
 			}
 			/* Map ENODATA to the default file SID */
 			sid = sbsec->def_sid;
@@ -1511,28 +1518,25 @@ static int inode_doinit_with_dentry(stru
 			}
 		}
 		kfree(context);
-		isec->sid = sid;
 		break;
 	case SECURITY_FS_USE_TASK:
-		isec->sid = isec->task_sid;
+		sid = task_sid;
 		break;
 	case SECURITY_FS_USE_TRANS:
 		/* Default to the fs SID. */
-		isec->sid = sbsec->sid;
+		sid = sbsec->sid;
 
 		/* Try to obtain a transition SID. */
-		rc = security_transition_sid(isec->task_sid, sbsec->sid,
-					     isec->sclass, NULL, &sid);
+		rc = security_transition_sid(task_sid, sid, sclass, NULL, &sid);
 		if (rc)
-			goto out_unlock;
-		isec->sid = sid;
+			goto out;
 		break;
 	case SECURITY_FS_USE_MNTPOINT:
-		isec->sid = sbsec->mntpoint_sid;
+		sid = sbsec->mntpoint_sid;
 		break;
 	default:
 		/* Default to the fs superblock SID. */
-		isec->sid = sbsec->sid;
+		sid = sbsec->sid;
 
 		if ((sbsec->flags & SE_SBGENFS) && !S_ISLNK(inode->i_mode)) {
 			/* We must have a dentry to determine the label on
@@ -1555,21 +1559,30 @@ static int inode_doinit_with_dentry(stru
 			 * could be used again by userspace.
 			 */
 			if (!dentry)
-				goto out_unlock;
-			rc = selinux_genfs_get_sid(dentry, isec->sclass,
+				goto out;
+			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			dput(dentry);
 			if (rc)
-				goto out_unlock;
-			isec->sid = sid;
+				goto out;
 		}
 		break;
 	}
 
-	isec->initialized = LABEL_INITIALIZED;
+out:
+	spin_lock(&isec->lock);
+	if (isec->initialized == LABEL_PENDING) {
+		if (!sid || rc) {
+			isec->initialized = LABEL_INVALID;
+			goto out_unlock;
+		}
+
+		isec->initialized = LABEL_INITIALIZED;
+		isec->sid = sid;
+	}
 
 out_unlock:
-	mutex_unlock(&isec->lock);
+	spin_unlock(&isec->lock);
 	return rc;
 }
 
@@ -3199,9 +3212,11 @@ static void selinux_inode_post_setxattr(
 	}
 
 	isec = backing_inode_security(dentry);
+	spin_lock(&isec->lock);
 	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
 	isec->initialized = LABEL_INITIALIZED;
+	spin_unlock(&isec->lock);
 
 	return;
 }
@@ -3298,9 +3313,11 @@ static int selinux_inode_setsecurity(str
 	if (rc)
 		return rc;
 
+	spin_lock(&isec->lock);
 	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = newsid;
 	isec->initialized = LABEL_INITIALIZED;
+	spin_unlock(&isec->lock);
 	return 0;
 }
 
@@ -3956,9 +3973,11 @@ static void selinux_task_to_inode(struct
 	struct inode_security_struct *isec = inode->i_security;
 	u32 sid = task_sid(p);
 
+	spin_lock(&isec->lock);
 	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = sid;
 	isec->initialized = LABEL_INITIALIZED;
+	spin_unlock(&isec->lock);
 }
 
 /* Returns error only if unable to parse addresses */
@@ -4277,24 +4296,24 @@ static int selinux_socket_post_create(st
 	const struct task_security_struct *tsec = current_security();
 	struct inode_security_struct *isec = inode_security_novalidate(SOCK_INODE(sock));
 	struct sk_security_struct *sksec;
+	u16 sclass = socket_type_to_security_class(family, type, protocol);
+	u32 sid = SECINITSID_KERNEL;
 	int err = 0;
 
-	isec->sclass = socket_type_to_security_class(family, type, protocol);
-
-	if (kern)
-		isec->sid = SECINITSID_KERNEL;
-	else {
-		err = socket_sockcreate_sid(tsec, isec->sclass, &(isec->sid));
+	if (!kern) {
+		err = socket_sockcreate_sid(tsec, sclass, &sid);
 		if (err)
 			return err;
 	}
 
+	isec->sclass = sclass;
+	isec->sid = sid;
 	isec->initialized = LABEL_INITIALIZED;
 
 	if (sock->sk) {
 		sksec = sock->sk->sk_security;
-		sksec->sid = isec->sid;
-		sksec->sclass = isec->sclass;
+		sksec->sclass = sclass;
+		sksec->sid = sid;
 		err = selinux_netlbl_socket_post_create(sock->sk, family);
 	}
 
@@ -4478,16 +4497,22 @@ static int selinux_socket_accept(struct
 	int err;
 	struct inode_security_struct *isec;
 	struct inode_security_struct *newisec;
+	u16 sclass;
+	u32 sid;
 
 	err = sock_has_perm(current, sock->sk, SOCKET__ACCEPT);
 	if (err)
 		return err;
 
-	newisec = inode_security_novalidate(SOCK_INODE(newsock));
-
 	isec = inode_security_novalidate(SOCK_INODE(sock));
-	newisec->sclass = isec->sclass;
-	newisec->sid = isec->sid;
+	spin_lock(&isec->lock);
+	sclass = isec->sclass;
+	sid = isec->sid;
+	spin_unlock(&isec->lock);
+
+	newisec = inode_security_novalidate(SOCK_INODE(newsock));
+	newisec->sclass = sclass;
+	newisec->sid = sid;
 	newisec->initialized = LABEL_INITIALIZED;
 
 	return 0;
@@ -6010,9 +6035,9 @@ static void selinux_inode_invalidate_sec
 {
 	struct inode_security_struct *isec = inode->i_security;
 
-	mutex_lock(&isec->lock);
+	spin_lock(&isec->lock);
 	isec->initialized = LABEL_INVALID;
-	mutex_unlock(&isec->lock);
+	spin_unlock(&isec->lock);
 }
 
 /*
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -39,7 +39,8 @@ struct task_security_struct {
 
 enum label_initialized {
 	LABEL_INVALID,		/* invalid or not initialized */
-	LABEL_INITIALIZED	/* initialized */
+	LABEL_INITIALIZED,	/* initialized */
+	LABEL_PENDING
 };
 
 struct inode_security_struct {
@@ -52,7 +53,7 @@ struct inode_security_struct {
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
 	unsigned char initialized;	/* initialization flag */
-	struct mutex lock;
+	spinlock_t lock;
 };
 
 struct file_security_struct {


