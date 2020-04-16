Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020991AC366
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407334AbgDPNm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgDPNmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8762222C;
        Thu, 16 Apr 2020 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044542;
        bh=Gi5aYHDbBdeR3ComheznLyhNlX0DWXrgdPGx2PutU7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLLwePG6Q+iKH/lmXUxM+jOJmKqVkO1jWN50pqUPe4ZGbP69VLJokxrlzk1qmKECU
         vPFjkLXvN9G3o2iyTDAkbidiUadoBVmkp6Ji/hHe7tIzdjgMJPZy/mKEnEAYEY9kdJ
         EXThQq0i2IhgOeQUenHp7kuJZdmT/OcYHm1JSuLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 251/257] NFS: finish_automount() requires us to hold 2 refs to the mount record
Date:   Thu, 16 Apr 2020 15:25:02 +0200
Message-Id: <20200416131356.946582634@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 75da98586af75eb80664714a67a9895bf0a5517e ]

We must not return from nfs_d_automount() without holding 2 references
to the mount record. Doing so, will trigger the BUG() in finish_automount().
Also ensure that we don't try to reschedule the automount timer with
a negative or zero timeout value.

Fixes: 22a1ae9a93fb ("NFS: If nfs_mountpoint_expiry_timeout < 0, do not expire submounts")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/namespace.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 5e0e9d29f5c57..0c5db17607411 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -143,6 +143,7 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	struct nfs_server *server = NFS_SERVER(d_inode(path->dentry));
 	struct nfs_fh *fh = NULL;
 	struct nfs_fattr *fattr = NULL;
+	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 
 	if (IS_ROOT(path->dentry))
 		return ERR_PTR(-ESTALE);
@@ -157,12 +158,12 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	if (IS_ERR(mnt))
 		goto out;
 
-	if (nfs_mountpoint_expiry_timeout < 0)
+	mntget(mnt); /* prevent immediate expiration */
+	if (timeout <= 0)
 		goto out;
 
-	mntget(mnt); /* prevent immediate expiration */
 	mnt_set_expiry(mnt, &nfs_automount_list);
-	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
+	schedule_delayed_work(&nfs_automount_task, timeout);
 
 out:
 	nfs_free_fattr(fattr);
@@ -201,10 +202,11 @@ const struct inode_operations nfs_referral_inode_operations = {
 static void nfs_expire_automounts(struct work_struct *work)
 {
 	struct list_head *list = &nfs_automount_list;
+	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 
 	mark_mounts_for_expiry(list);
-	if (!list_empty(list))
-		schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
+	if (!list_empty(list) && timeout > 0)
+		schedule_delayed_work(&nfs_automount_task, timeout);
 }
 
 void nfs_release_automount_timer(void)
-- 
2.20.1



