Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE87551502
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 11:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbiFTJ5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbiFTJ5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 05:57:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7354B13E97
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 02:57:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAFC4B80FF4
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183F9C3411B;
        Mon, 20 Jun 2022 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655719017;
        bh=5vpcrwcIf12lFf1+pFC8VRv5e59nLYkV6/YqdzBJXz8=;
        h=Subject:To:Cc:From:Date:From;
        b=zsws/VihETbMu9VHsPdmj269GxjFVBemPkYCgfBQJ/ovFFPsQAxAb5Rhm+KJhTW6P
         ZEM9ru5yJlooSc5z/p+8xKSa1D8zAymYfizCwzvgghmDE5eAD2daTigYQAnn4FIn+5
         t3qtZ3diA0la+bgWXIygXP25g9ZVWC8JAf3wZzuY=
Subject: FAILED: patch "[PATCH] fs: account for group membership" failed to apply to 5.15-stable tree
To:     brauner@kernel.org, cyphar@cyphar.com, hch@lst.de,
        sforshee@digitalocean.com, viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 11:56:54 +0200
Message-ID: <165571901496212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 168f912893407a5acb798a4a58613b5f1f98c717 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 13 Jun 2022 13:15:17 +0200
Subject: [PATCH] fs: account for group membership

When calling setattr_prepare() to determine the validity of the
attributes the ia_{g,u}id fields contain the value that will be written
to inode->i_{g,u}id. This is exactly the same for idmapped and
non-idmapped mounts and allows callers to pass in the values they want
to see written to inode->i_{g,u}id.

When group ownership is changed a caller whose fsuid owns the inode can
change the group of the inode to any group they are a member of. When
searching through the caller's groups we need to use the gid mapped
according to the idmapped mount otherwise we will fail to change
ownership for unprivileged users.

Consider a caller running with fsuid and fsgid 1000 using an idmapped
mount that maps id 65534 to 1000 and 65535 to 1001. Consequently, a file
owned by 65534:65535 in the filesystem will be owned by 1000:1001 in the
idmapped mount.

The caller now requests the gid of the file to be changed to 1000 going
through the idmapped mount. In the vfs we will immediately map the
requested gid to the value that will need to be written to inode->i_gid
and place it in attr->ia_gid. Since this idmapped mount maps 65534 to
1000 we place 65534 in attr->ia_gid.

When we check whether the caller is allowed to change group ownership we
first validate that their fsuid matches the inode's uid. The
inode->i_uid is 65534 which is mapped to uid 1000 in the idmapped mount.
Since the caller's fsuid is 1000 we pass the check.

We now check whether the caller is allowed to change inode->i_gid to the
requested gid by calling in_group_p(). This will compare the passed in
gid to the caller's fsgid and search the caller's additional groups.

Since we're dealing with an idmapped mount we need to pass in the gid
mapped according to the idmapped mount. This is akin to checking whether
a caller is privileged over the future group the inode is owned by. And
that needs to take the idmapped mount into account. Note, all helpers
are nops without idmapped mounts.

New regression test sent to xfstests.

Link: https://github.com/lxc/lxd/issues/10537
Link: https://lore.kernel.org/r/20220613111517.2186646-1-brauner@kernel.org
Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org # 5.15+
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

diff --git a/fs/attr.c b/fs/attr.c
index 66899b6e9bd8..dbe996b0dedf 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -61,9 +61,15 @@ static bool chgrp_ok(struct user_namespace *mnt_userns,
 		     const struct inode *inode, kgid_t gid)
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
-		return true;
+	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode))) {
+		kgid_t mapped_gid;
+
+		if (gid_eq(gid, inode->i_gid))
+			return true;
+		mapped_gid = mapped_kgid_fs(mnt_userns, i_user_ns(inode), gid);
+		if (in_group_p(mapped_gid))
+			return true;
+	}
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
 	if (gid_eq(kgid, INVALID_GID) &&
@@ -123,12 +129,20 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
+		kgid_t mapped_gid;
+
 		if (!inode_owner_or_capable(mnt_userns, inode))
 			return -EPERM;
+
+		if (ia_valid & ATTR_GID)
+			mapped_gid = mapped_kgid_fs(mnt_userns,
+						i_user_ns(inode), attr->ia_gid);
+		else
+			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
+
 		/* Also check the setgid bit! */
-               if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-                                i_gid_into_mnt(mnt_userns, inode)) &&
-                    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_p(mapped_gid) &&
+		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 

