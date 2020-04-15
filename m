Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4981A9CC4
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897241AbgDOLiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:38:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43451 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408909AbgDOLht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:37:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C6CAC5C01BB;
        Wed, 15 Apr 2020 07:37:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=so8n9B
        VsQOb/O9KQNK86yBQm4CJzanrk8ahffq3jWJA=; b=KMe2x6A7ZObXZvVIVfShRp
        N9Xda1C7mlCDxOnUYMl63yx4WcpjkMR9V69dtvl9raxNZWVaEiTHMC0oUbVyqda+
        4bO6Rx7lCNE5oE+GR7d1yehJIuwyU1KhleyhgxDxTd9xxNP6+ls1AEVl2FOOveBd
        04UkS/NCV+K8ZjmvUfHiCxWX1UwFz9hZepg0kHcRD8ueXl49J5ur6YQw+4Xsya+N
        aveu8J46+FUHICUe5G7jK6vSLWhKKWAfFZkkMGEowvwEGnGeTN3v/NWpolsw/DYS
        5n9GmhdBxFp0tHbb/kr6JyS7fEu29LGgwBMPw9Yz5FuP8zG+TVp5oDiB0iK0ZCuQ
        ==
X-ME-Sender: <xms:_PGWXi-CKE8fcrItvvwTaiU7focVSldJBpGQhYgkUFAsNYzSGpP08A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_PGWXog_MA5SYfF1bCrRbaeBBKRqYfvCqJLAa1VlaOhJvkm0ROthFA>
    <xmx:_PGWXqFScQq3QQU1lE3XInp_Fiwe4XANd__PcSUqYPEkTqgpXn8K0A>
    <xmx:_PGWXjDrif-lOHLkGiktKSAnwUM3OTJQ26eTJVERyN4VpoBUZeiHJQ>
    <xmx:_PGWXhPH47UECYrHW3ldEVZ4a3PF2NNJlTxFDZrjxpGI7qOUzrSlXQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0AE0A306005E;
        Wed, 15 Apr 2020 07:37:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFS: finish_automount() requires us to hold 2 refs to the" failed to apply to 5.5-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:37:30 +0200
Message-ID: <15869506505117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 75da98586af75eb80664714a67a9895bf0a5517e Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Thu, 2 Apr 2020 10:34:36 -0400
Subject: [PATCH] NFS: finish_automount() requires us to hold 2 refs to the
 mount record

We must not return from nfs_d_automount() without holding 2 references
to the mount record. Doing so, will trigger the BUG() in finish_automount().
Also ensure that we don't try to reschedule the automount timer with
a negative or zero timeout value.

Fixes: 22a1ae9a93fb ("NFS: If nfs_mountpoint_expiry_timeout < 0, do not expire submounts")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index da67820462f2..fe19ae280262 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -145,6 +145,7 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	struct vfsmount *mnt = ERR_PTR(-ENOMEM);
 	struct nfs_server *server = NFS_SERVER(d_inode(path->dentry));
 	struct nfs_client *client = server->nfs_client;
+	int timeout = READ_ONCE(nfs_mountpoint_expiry_timeout);
 	int ret;
 
 	if (IS_ROOT(path->dentry))
@@ -190,12 +191,12 @@ struct vfsmount *nfs_d_automount(struct path *path)
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
@@ -233,10 +234,11 @@ const struct inode_operations nfs_referral_inode_operations = {
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

