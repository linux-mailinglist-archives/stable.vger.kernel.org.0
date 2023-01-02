Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4E65B002
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjABKwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjABKvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:51:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068562E6
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E161C60F2C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01769C433EF;
        Mon,  2 Jan 2023 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656699;
        bh=rkZUzOXWQRWd2pKqF556twbXGKvZgeTJ0vjV7pHZdUU=;
        h=Subject:To:Cc:From:Date:From;
        b=zmBtBWnAIh6kbn6+R//GDnz/iDx4llQMA1D+xiHfllyG35l/S2mWDT7YzlIkPk6UW
         tfSYEFIy8ay/HUD+znBUXh7Kt9InNWIGIJ0d4ZSLJipmnYSbXseL/YasvsqSZtwAgI
         JHy1Y53OfaiOaU3Fod+kZ3M5raesfdcuyfkejLYI=
Subject: FAILED: patch "[PATCH] ovl: Use ovl mounter's fsuid and fsgid in ovl_link()" failed to apply to 4.9-stable tree
To:     zhangtianci.1997@bytedance.com, brauner@kernel.org,
        mszeredi@redhat.com, stable@vger.kernel.org,
        zhangjiachen.jaycee@bytedance.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:51:28 +0100
Message-ID: <167265668811921@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5b0db51215e8 ("ovl: Use ovl mounter's fsuid and fsgid in ovl_link()")
471ec5dcf4e7 ("ovl: struct cattr cleanups")
6cf00764b008 ("ovl: strip debug argument from ovl_do_ helpers")
e7dd0e71348c ("ovl: whiteout index when union nlink drops to zero")
016b720f5558 ("ovl: index directories on copy up for NFS export")
fbd2d2074bde ("ovl: index all non-dir on copy up for NFS export")
24b33ee104ec ("ovl: create ovl_need_index() helper")
9f4ec904dbd4 ("ovl: fix dput() of ERR_PTR in ovl_cleanup_index()")
ea3dad18dc5f ("ovl: mark parent impure on ovl_link()")
f4439de11828 ("ovl: mark parent impure and restore timestamp on ovl_link_up()")
caf70cb2ba5d ("ovl: cleanup orphan index entries")
5f8415d6b87e ("ovl: persistent overlay inode nlink for indexed inodes")
59be09712ab9 ("ovl: implement index dir copy up")
fd210b7d67ee ("ovl: move copy up lock out")
a6fb235a448b ("ovl: rearrange copy up")
23f0ab13eaa6 ("ovl: use struct copy_up_ctx as function argument")
7ab8b1763fd8 ("ovl: base tmpfile in workdir too")
02209d10709c ("ovl: factor out ovl_copy_up_inode() helper")
7d90b853f932 ("ovl: extract helper to get temp file in copy up")
15932c415b3e ("ovl: defer upper dir lock to tempfile link")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b0db51215e895a361bc63132caa7cca36a53d6a Mon Sep 17 00:00:00 2001
From: Zhang Tianci <zhangtianci.1997@bytedance.com>
Date: Thu, 1 Sep 2022 16:29:29 +0800
Subject: [PATCH] ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

There is a wrong case of link() on overlay:
  $ mkdir /lower /fuse /merge
  $ mount -t fuse /fuse
  $ mkdir /fuse/upper /fuse/work
  $ mount -t overlay /merge -o lowerdir=/lower,upperdir=/fuse/upper,\
    workdir=work
  $ touch /merge/file
  $ chown bin.bin /merge/file // the file's caller becomes "bin"
  $ ln /merge/file /merge/lnkfile

Then we will get an error(EACCES) because fuse daemon checks the link()'s
caller is "bin", it denied this request.

In the changing history of ovl_link(), there are two key commits:

The first is commit bb0d2b8ad296 ("ovl: fix sgid on directory") which
overrides the cred's fsuid/fsgid using the new inode. The new inode's
owner is initialized by inode_init_owner(), and inode->fsuid is
assigned to the current user. So the override fsuid becomes the
current user. We know link() is actually modifying the directory, so
the caller must have the MAY_WRITE permission on the directory. The
current caller may should have this permission. This is acceptable
to use the caller's fsuid.

The second is commit 51f7e52dc943 ("ovl: share inode for hard link")
which removed the inode creation in ovl_link(). This commit move
inode_init_owner() into ovl_create_object(), so the ovl_link() just
give the old inode to ovl_create_or_link(). Then the override fsuid
becomes the old inode's fsuid, neither the caller nor the overlay's
mounter! So this is incorrect.

Fix this bug by using ovl mounter's fsuid/fsgid to do underlying
fs's link().

Link: https://lore.kernel.org/all/20220817102952.xnvesg3a7rbv576x@wittgenstein/T
Link: https://lore.kernel.org/lkml/20220825130552.29587-1-zhangtianci.1997@bytedance.com/t
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Fixes: 51f7e52dc943 ("ovl: share inode for hard link")
Cc: <stable@vger.kernel.org> # v4.8
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6b03457f72bb..c3032cef391e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -592,28 +592,42 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 			goto out_revert_creds;
 	}
 
-	err = -ENOMEM;
-	override_cred = prepare_creds();
-	if (override_cred) {
+	if (!attr->hardlink) {
+		err = -ENOMEM;
+		override_cred = prepare_creds();
+		if (!override_cred)
+			goto out_revert_creds;
+		/*
+		 * In the creation cases(create, mkdir, mknod, symlink),
+		 * ovl should transfer current's fs{u,g}id to underlying
+		 * fs. Because underlying fs want to initialize its new
+		 * inode owner using current's fs{u,g}id. And in this
+		 * case, the @inode is a new inode that is initialized
+		 * in inode_init_owner() to current's fs{u,g}id. So use
+		 * the inode's i_{u,g}id to override the cred's fs{u,g}id.
+		 *
+		 * But in the other hardlink case, ovl_link() does not
+		 * create a new inode, so just use the ovl mounter's
+		 * fs{u,g}id.
+		 */
 		override_cred->fsuid = inode->i_uid;
 		override_cred->fsgid = inode->i_gid;
-		if (!attr->hardlink) {
-			err = security_dentry_create_files_as(dentry,
-					attr->mode, &dentry->d_name, old_cred,
-					override_cred);
-			if (err) {
-				put_cred(override_cred);
-				goto out_revert_creds;
-			}
+		err = security_dentry_create_files_as(dentry,
+				attr->mode, &dentry->d_name, old_cred,
+				override_cred);
+		if (err) {
+			put_cred(override_cred);
+			goto out_revert_creds;
 		}
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
-
-		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, attr);
-		else
-			err = ovl_create_over_whiteout(dentry, inode, attr);
 	}
+
+	if (!ovl_dentry_is_whiteout(dentry))
+		err = ovl_create_upper(dentry, inode, attr);
+	else
+		err = ovl_create_over_whiteout(dentry, inode, attr);
+
 out_revert_creds:
 	revert_creds(old_cred);
 	return err;

