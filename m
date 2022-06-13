Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6D549363
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357208AbiFMM6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358394AbiFMMzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE850D12B;
        Mon, 13 Jun 2022 04:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB0AB80EA7;
        Mon, 13 Jun 2022 11:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041D9C3411F;
        Mon, 13 Jun 2022 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655118956;
        bh=kDx7bmMaP24X/iui8cBI2amajK5ZSQD2VXc5aV6AaBI=;
        h=From:To:Cc:Subject:Date:From;
        b=Rqv2cjRgID9DazjOF93YbT82/g4HbZp0PCO/4gSzIVtDJXT2tlOhiWipfBKXDo22Z
         KxgW/bKu6eIF8c5QVed3uE9AUC9CqqfVnXdkyYcNvQhlQnTUnY9mg+ak6havirTI0G
         EsNyyTy6jU3YSgenkhzdBXdCB9yhDDkjD6Tw7EOnHiG31ljEj6sGNs1349sXvZRVs7
         MNnXmBHBvUPHAklaZ80QuINFqy646FtpS0Es1s5tPy7sKSAKXvYrzbUcOsx6hO7Aea
         fX6gZ+6GOJWxBS+YNyoZfTVJ+H8SuL9VtcG7K8KKLrfBlHH4Z/zs8a7vpKQkCtPp+h
         6dbD2e0qqSQHg==
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Christian Brauner <brauner@kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH] fs: account for group membership
Date:   Mon, 13 Jun 2022 13:15:17 +0200
Message-Id: <20220613111517.2186646-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4598; h=from:subject; bh=kDx7bmMaP24X/iui8cBI2amajK5ZSQD2VXc5aV6AaBI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQtl1H0lpkmwnL3ucxJ7u12l32/eS489bp5dsckmfC5hfP1 nqUEdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk12ZGhj1BkgqL2bfq7otltnx04M Ia9qxvT3QU09QOGlVf2DJ7eiTD/8JPkzl0eQ98DpApn7z/h3l52pWqA3MSXyyQfaH98uDE9YwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org # 5.15+
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
Hey,

Detected while working on additional tests and also reported by a user
and brain on my part. I plan to work on patches to disentangle the
codepaths here a bit and make them easier to understand going forward.

Passes xfstests including new tests and LTP test suite.

Thanks!
Christian
---
 fs/attr.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

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
 

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.34.1

