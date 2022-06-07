Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5A5417BA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358060AbiFGVEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352386AbiFGVDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F318AD9F;
        Tue,  7 Jun 2022 11:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA61561295;
        Tue,  7 Jun 2022 18:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2CEC385A2;
        Tue,  7 Jun 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627724;
        bh=dbFetGycNFqXLnLqpJOm7aVXcJy1sch1epqabjZaOMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ces99LBiAlJs7J1f+7a/EETAhNiWEKUh1ZzEjgdFOX2wD4P7N9iHP47MUn5Iad8Eo
         PWjfqB3C2JrlSZOrsqY79nGjmGgTa4tWkadv5+ybaJWP7beqvilPE8CkH60NaR+8Rv
         87Qk76/MBOssYB7BTWftItkNmaBT/6lSSckaLFk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kari Argillander <kari.argillander@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 029/879] fs/ntfs3: Restore ntfs_xattr_get_acl and ntfs_xattr_set_acl functions
Date:   Tue,  7 Jun 2022 18:52:27 +0200
Message-Id: <20220607165003.521838932@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 87e21c99bad763524c953ff4d1a61ee19038ddc2 upstream.

Apparently we need to maintain these functions with
ntfs_get_acl_ex and ntfs_set_acl_ex.
This commit fixes xfstest generic/099
Fixes: 95dd8b2c1ed0 ("fs/ntfs3: Remove unnecessary functions")

Reviewed-by: Kari Argillander <kari.argillander@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -112,7 +112,7 @@ static int ntfs_read_ea(struct ntfs_inod
 		return -ENOMEM;
 
 	if (!size) {
-		;
+		/* EA info persists, but xattr is empty. Looks like EA problem. */
 	} else if (attr_ea->non_res) {
 		struct runs_tree run;
 
@@ -620,6 +620,67 @@ int ntfs_set_acl(struct user_namespace *
 	return ntfs_set_acl_ex(mnt_userns, inode, acl, type, false);
 }
 
+static int ntfs_xattr_get_acl(struct user_namespace *mnt_userns,
+			      struct inode *inode, int type, void *buffer,
+			      size_t size)
+{
+	struct posix_acl *acl;
+	int err;
+
+	if (!(inode->i_sb->s_flags & SB_POSIXACL)) {
+		ntfs_inode_warn(inode, "add mount option \"acl\" to use acl");
+		return -EOPNOTSUPP;
+	}
+
+	acl = ntfs_get_acl(inode, type, false);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
+	if (!acl)
+		return -ENODATA;
+
+	err = posix_acl_to_xattr(mnt_userns, acl, buffer, size);
+	posix_acl_release(acl);
+
+	return err;
+}
+
+static int ntfs_xattr_set_acl(struct user_namespace *mnt_userns,
+			      struct inode *inode, int type, const void *value,
+			      size_t size)
+{
+	struct posix_acl *acl;
+	int err;
+
+	if (!(inode->i_sb->s_flags & SB_POSIXACL)) {
+		ntfs_inode_warn(inode, "add mount option \"acl\" to use acl");
+		return -EOPNOTSUPP;
+	}
+
+	if (!inode_owner_or_capable(mnt_userns, inode))
+		return -EPERM;
+
+	if (!value) {
+		acl = NULL;
+	} else {
+		acl = posix_acl_from_xattr(mnt_userns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+
+		if (acl) {
+			err = posix_acl_valid(mnt_userns, acl);
+			if (err)
+				goto release_and_out;
+		}
+	}
+
+	err = ntfs_set_acl(mnt_userns, inode, acl, type);
+
+release_and_out:
+	posix_acl_release(acl);
+	return err;
+}
+
 /*
  * ntfs_init_acl - Initialize the ACLs of a new inode.
  *
@@ -786,6 +847,23 @@ static int ntfs_getxattr(const struct xa
 		goto out;
 	}
 
+#ifdef CONFIG_NTFS3_FS_POSIX_ACL
+	if ((name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
+	     !memcmp(name, XATTR_NAME_POSIX_ACL_ACCESS,
+		     sizeof(XATTR_NAME_POSIX_ACL_ACCESS))) ||
+	    (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
+	     !memcmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
+		     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT)))) {
+		/* TODO: init_user_ns? */
+		err = ntfs_xattr_get_acl(
+			&init_user_ns, inode,
+			name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1
+				? ACL_TYPE_ACCESS
+				: ACL_TYPE_DEFAULT,
+			buffer, size);
+		goto out;
+	}
+#endif
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_get_ea(inode, name, name_len, buffer, size, NULL);
 
@@ -898,6 +976,22 @@ set_new_fa:
 		goto out;
 	}
 
+#ifdef CONFIG_NTFS3_FS_POSIX_ACL
+	if ((name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
+	     !memcmp(name, XATTR_NAME_POSIX_ACL_ACCESS,
+		     sizeof(XATTR_NAME_POSIX_ACL_ACCESS))) ||
+	    (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
+	     !memcmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
+		     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT)))) {
+		err = ntfs_xattr_set_acl(
+			mnt_userns, inode,
+			name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1
+				? ACL_TYPE_ACCESS
+				: ACL_TYPE_DEFAULT,
+			value, size);
+		goto out;
+	}
+#endif
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags);
 


