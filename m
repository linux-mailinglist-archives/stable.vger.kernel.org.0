Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF25A4A46
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiH2LgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiH2Leh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:34:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AB2754B1;
        Mon, 29 Aug 2022 04:20:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD18EB80FA6;
        Mon, 29 Aug 2022 11:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED38C433C1;
        Mon, 29 Aug 2022 11:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771554;
        bh=EMpyuFnfJZNwh01gEQaqLMq8asSMxYR+wXn4bSwXpk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhtVjwJGGqC8KcK8iP3dRg2RCNJWp005BiQTjW3TdLHVe2qBqFzKx1vN53ssHj6Cr
         6Nx7Pdfte7IEACLauDfeliIkADclFFBGcbvgnfbPRtVQPKSJZsHdS8cDMnXaKFe90f
         tAMY7ZhheEvJBsZqBqUmtoyEWlhIHjRJhi7NS/dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        ntfs3@lists.linux.dev,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 022/158] ntfs: fix acl handling
Date:   Mon, 29 Aug 2022 12:57:52 +0200
Message-Id: <20220829105809.739916483@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0c3bc7899e6dfb52df1c46118a5a670ae619645f ]

While looking at our current POSIX ACL handling in the context of some
overlayfs work I went through a range of other filesystems checking how they
handle them currently and encountered ntfs3.

The posic_acl_{from,to}_xattr() helpers always need to operate on the
filesystem idmapping. Since ntfs3 can only be mounted in the initial user
namespace the relevant idmapping is init_user_ns.

The posix_acl_{from,to}_xattr() helpers are concerned with translating between
the kernel internal struct posix_acl{_entry} and the uapi struct
posix_acl_xattr_{header,entry} and the kernel internal data structure is cached
filesystem wide.

Additional idmappings such as the caller's idmapping or the mount's idmapping
are handled higher up in the VFS. Individual filesystems usually do not need to
concern themselves with these.

The posix_acl_valid() helper is concerned with checking whether the values in
the kernel internal struct posix_acl can be represented in the filesystem's
idmapping. IOW, if they can be written to disk. So this helper too needs to
take the filesystem's idmapping.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: ntfs3@lists.linux.dev
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 1b8c89dbf6684..3629049decac1 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -478,8 +478,7 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 }
 
 #ifdef CONFIG_NTFS3_FS_POSIX_ACL
-static struct posix_acl *ntfs_get_acl_ex(struct user_namespace *mnt_userns,
-					 struct inode *inode, int type,
+static struct posix_acl *ntfs_get_acl_ex(struct inode *inode, int type,
 					 int locked)
 {
 	struct ntfs_inode *ni = ntfs_i(inode);
@@ -514,7 +513,7 @@ static struct posix_acl *ntfs_get_acl_ex(struct user_namespace *mnt_userns,
 
 	/* Translate extended attribute to acl. */
 	if (err >= 0) {
-		acl = posix_acl_from_xattr(mnt_userns, buf, err);
+		acl = posix_acl_from_xattr(&init_user_ns, buf, err);
 	} else if (err == -ENODATA) {
 		acl = NULL;
 	} else {
@@ -537,8 +536,7 @@ struct posix_acl *ntfs_get_acl(struct inode *inode, int type, bool rcu)
 	if (rcu)
 		return ERR_PTR(-ECHILD);
 
-	/* TODO: init_user_ns? */
-	return ntfs_get_acl_ex(&init_user_ns, inode, type, 0);
+	return ntfs_get_acl_ex(inode, type, 0);
 }
 
 static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
@@ -590,7 +588,7 @@ static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
 		value = kmalloc(size, GFP_NOFS);
 		if (!value)
 			return -ENOMEM;
-		err = posix_acl_to_xattr(mnt_userns, acl, value, size);
+		err = posix_acl_to_xattr(&init_user_ns, acl, value, size);
 		if (err < 0)
 			goto out;
 		flags = 0;
@@ -641,7 +639,7 @@ static int ntfs_xattr_get_acl(struct user_namespace *mnt_userns,
 	if (!acl)
 		return -ENODATA;
 
-	err = posix_acl_to_xattr(mnt_userns, acl, buffer, size);
+	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
 	posix_acl_release(acl);
 
 	return err;
@@ -665,12 +663,12 @@ static int ntfs_xattr_set_acl(struct user_namespace *mnt_userns,
 	if (!value) {
 		acl = NULL;
 	} else {
-		acl = posix_acl_from_xattr(mnt_userns, value, size);
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 
 		if (acl) {
-			err = posix_acl_valid(mnt_userns, acl);
+			err = posix_acl_valid(&init_user_ns, acl);
 			if (err)
 				goto release_and_out;
 		}
-- 
2.35.1



