Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35961AC6AA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405042AbgDPOm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392640AbgDPOAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B6A120732;
        Thu, 16 Apr 2020 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045637;
        bh=20+WhrVt6rOuqY2+VFAix3C62pXVZPh2cqoTL8DX7PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rxsf3KDcfC4bpYQ3ncFQ1IXTB9mJd4iAsxMYtptbpOt8THSAe6RackN37G+5nfKic
         SnbF5705oHU4LyNv0O57W9sG++7sFqeMxJbv8sjRkzmr/gYDTGibStKQ28Ng0TVxa3
         R9ESayLm68vRhLKziEfTymnVv0Uo3XkFi9FjLzQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.6 215/254] NFS: finish_automount() requires us to hold 2 refs to the mount record
Date:   Thu, 16 Apr 2020 15:25:04 +0200
Message-Id: <20200416131352.894907687@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 75da98586af75eb80664714a67a9895bf0a5517e upstream.

We must not return from nfs_d_automount() without holding 2 references
to the mount record. Doing so, will trigger the BUG() in finish_automount().
Also ensure that we don't try to reschedule the automount timer with
a negative or zero timeout value.

Fixes: 22a1ae9a93fb ("NFS: If nfs_mountpoint_expiry_timeout < 0, do not expire submounts")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/namespace.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -145,6 +145,7 @@ struct vfsmount *nfs_d_automount(struct
 	struct vfsmount *mnt = ERR_PTR(-ENOMEM);
 	struct nfs_server *server = NFS_SERVER(d_inode(path->dentry));
 	struct nfs_client *client = server->nfs_client;
+	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 	int ret;
 
 	if (IS_ROOT(path->dentry))
@@ -190,12 +191,12 @@ struct vfsmount *nfs_d_automount(struct
 	if (IS_ERR(mnt))
 		goto out_fc;
 
-	if (nfs_mountpoint_expiry_timeout < 0)
+	mntget(mnt); /* prevent immediate expiration */
+	if (timeout <= 0)
 		goto out_fc;
 
-	mntget(mnt); /* prevent immediate expiration */
 	mnt_set_expiry(mnt, &nfs_automount_list);
-	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
+	schedule_delayed_work(&nfs_automount_task, timeout);
 
 out_fc:
 	put_fs_context(fc);
@@ -233,10 +234,11 @@ const struct inode_operations nfs_referr
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


