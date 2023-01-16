Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1C66CB69
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbjAPROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbjAPRNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88BB25E38
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6230861077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BBCC433D2;
        Mon, 16 Jan 2023 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888010;
        bh=Sarnle+rIYOOThD/K7URV38AHeWoQMvY5gvYVfVFM8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nassFMrP48Z0qJWkE2bsiisxBun3jOVA5QevZ89tSPyUzPH0/EvvO/qJDtj1AXCZC
         asEPy2cIQJu/NvlUXMSZ6AQlf6VCEeV5NZ8z60ba4V2znyRqTq8FTSQ/Ip/jAXwjkh
         loeweOnYh9/XAu3nB3T0pVGmhmt/Tt8CeQk/Y4n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 367/521] ovl: Use ovl mounters fsuid and fsgid in ovl_link()
Date:   Mon, 16 Jan 2023 16:50:29 +0100
Message-Id: <20230116154903.505608020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

commit 5b0db51215e895a361bc63132caa7cca36a53d6a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -561,28 +561,42 @@ static int ovl_create_or_link(struct den
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


