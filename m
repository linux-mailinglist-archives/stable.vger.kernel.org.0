Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6B6B74C2
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCMKzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCMKyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967CE10F8
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 313D96118D
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F83C4339B;
        Mon, 13 Mar 2023 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704890;
        bh=5wCXIq7u8+0cpc0R1FKhxXhrV6xsexa9uJ80I58QIsI=;
        h=Subject:To:Cc:From:Date:From;
        b=FIzpDxTceK7Vh+nH9L27aK673SZz2qvLMlDJxJfMEjHcWphgubKuCAGNgsMWvh9Hi
         QyPIHVkD8NQO8wbSTeFvzixjvDiVLCFPLCMKMVKMf6YQGSAozv0MsZuQRjJjvG+nDu
         +xlO5vbb9LrdoGTKbeIs7oeV1FtZ6ycqAkrYnxb4=
Subject: FAILED: patch "[PATCH] filelocks: use mount idmapping for setlease permission check" failed to apply to 5.15-stable tree
To:     sforshee@kernel.org, brauner@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:53:51 +0100
Message-ID: <1678704830213151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 42d0c4bdf753063b6eec55415003184d3ca24f6e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678704830213151@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

42d0c4bdf753 ("filelocks: use mount idmapping for setlease permission check")
c65454a94726 ("fs: remove locks_inode")
5970e15dbcfe ("filelock: move file locking definitions to separate header file")
8e1858710d9a ("ceph: avoid use-after-free in ceph_fl_release_lock()")
461ab10ef7e6 ("ceph: switch to vfs_inode_has_locks() to fix file lock bug")
6a518afcc206 ("Merge tag 'fs.acl.rework.v6.2' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42d0c4bdf753063b6eec55415003184d3ca24f6e Mon Sep 17 00:00:00 2001
From: Seth Forshee <sforshee@kernel.org>
Date: Thu, 9 Mar 2023 14:39:09 -0600
Subject: [PATCH] filelocks: use mount idmapping for setlease permission check

A user should be allowed to take out a lease via an idmapped mount if
the fsuid matches the mapped uid of the inode. generic_setlease() is
checking the unmapped inode uid, causing these operations to be denied.

Fix this by comparing against the mapped inode uid instead of the
unmapped uid.

Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

diff --git a/fs/locks.c b/fs/locks.c
index d82c4cacdfb9..df8b26a42524 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1863,9 +1863,10 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
 	struct inode *inode = file_inode(filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(file_mnt_idmap(filp), inode);
 	int error;
 
-	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
+	if ((!vfsuid_eq_kuid(vfsuid, current_fsuid())) && !capable(CAP_LEASE))
 		return -EACCES;
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;

