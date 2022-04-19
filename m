Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79567506D4B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 15:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiDSNSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 09:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiDSNSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 09:18:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E214D33A17;
        Tue, 19 Apr 2022 06:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D33C61605;
        Tue, 19 Apr 2022 13:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00941C385A5;
        Tue, 19 Apr 2022 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650374117;
        bh=Nr1xI1e2E08joksC7XU9drnzSZ/vxzpYBL5YBFJG5HU=;
        h=From:To:Cc:Subject:Date:From;
        b=N2mpSVE2FrjpV80xmL/2Mb+9qzEknfIYgX5JENWENEoW0N+RxdA+SnwBi2s2uDcI1
         CL5uiuM1nj9TTHNvxFHM0EhIziDurtyCdtW4011xk9ia9hTd+5hA9AD9+UBam4bMER
         HtjGE8x8rXqXYGYZsnrJRV+HnMTTlrPnKfuIcIufxmfVA2PPmMX+RADeE8gIKpoDhI
         RLqY7lgv7jQsXHs4a86ELYdRpcYyEu7v59xfTN1wejFZTKzoNWUBhRZhIKFE1sSzuI
         TsVx1X2zF2Oi3IXBinusc0ZniYhjHnPfpjB65GMQ543ecMP7bEygAl0S5vL5z2PLJ2
         xXXpYTPyDbRPA==
From:   Christian Brauner <brauner@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Jin <peter@peterjin.org>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: [PATCH] fs: fix acl translation
Date:   Tue, 19 Apr 2022 15:14:23 +0200
Message-Id: <20220419131423.2367795-1-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5296; h=from:subject; bh=Nr1xI1e2E08joksC7XU9drnzSZ/vxzpYBL5YBFJG5HU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTFbZ3+hvWek6rhxSPNwlYP/+34tGf+j9a/Gr0njrbPDTj+ +mnenI5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ3LFiZNgTO0P+2/alL6Yeb9OZqG Zge0BcROxN/vpKC1fW36r8SZkM/3NvvUjUWtDG+uB8dG1ygc3HO6G33ssFvLujUv/0bMC2fhYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
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

Last cycle we extended the idmapped mounts infrastructure to support idmapped
mounts of idmapped filesystems (No such filesystem yet exist.).
Since then, the meaning of an idmapped mount is a mount whose idmapping is
different from the filesystems idmapping.

While doing that work we missed to adapt the acl translation helpers. They
still assume that checking for the identity mapping is enough. But they need to
use the no_idmapping() helper instead.

Note, POSIX ACLs are always translated right at the userspace-kernel boundary
using the caller's current idmapping and the initial idmapping. The order
depends on whether we're coming from or going to userspace. The filesystem's
idmapping doesn't matter at the border.

Consequently, if a non-idmapped mount is passed we need to make sure to always
pass the initial idmapping as the mount's idmapping and not the filesystem
idmapping. Since it's irrelevant here it would yield invalid ids and prevent
setting acls for filesystems that are mountable in a userns and support posix
acls (tmpfs and fuse).

I verified the regression reported in [1] and verified that this patch fixes
it. A regression test will be added to xfstests in parallel.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215849 [1]
Fixes: bd303368b776 ("fs: support mapped mounts of mapped filesystems")
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # 5.17
Cc: <regressions@lists.linux.dev>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---

Hey Linus,

Last cycle we introduced a regression that got reported to me right over Easter
on Bugzilla. It is only relevant for 5.17 and current mainline. Could you
please apply this regression fix?

Thanks!
Christian
---
 fs/posix_acl.c                  | 10 ++++++++++
 fs/xattr.c                      |  6 ++++--
 include/linux/posix_acl_xattr.h |  4 ++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 80acb6885cf9..962d32468eb4 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -759,9 +759,14 @@ static void posix_acl_fix_xattr_userns(
 }
 
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, mnt_userns, value,
@@ -769,9 +774,14 @@ void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
 }
 
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				 struct inode *inode,
 				 void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, mnt_userns, value,
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..998045165916 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -569,7 +569,8 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
+			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						      kvalue, size);
 	}
 
 	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
@@ -667,7 +668,8 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
+			posix_acl_fix_xattr_to_user(mnt_userns, d_inode(d),
+						    kvalue, error);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index 060e8d203181..1766e1de6956 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -34,15 +34,19 @@ posix_acl_xattr_count(size_t size)
 
 #ifdef CONFIG_FS_POSIX_ACL
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size);
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				 void *value, size_t size);
 #else
 static inline void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+						 struct inode *inode,
 						 void *value, size_t size)
 {
 }
 static inline void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+					       struct inode *inode,
 					       void *value, size_t size)
 {
 }

base-commit: b2d229d4ddb17db541098b83524d901257e93845
-- 
2.32.0

