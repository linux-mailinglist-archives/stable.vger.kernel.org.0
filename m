Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B549752983C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiEQDbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiEQDba (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556EC37BE9;
        Mon, 16 May 2022 20:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F9461475;
        Tue, 17 May 2022 03:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F31C34115;
        Tue, 17 May 2022 03:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652758287;
        bh=Dw8tFsGPNJpxwowTVAncpYfXnADMbsZZPIOSovGKhzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Khe0QJphBHv/ItTDiC0/Nntn2UhwH0EarPo+c+kYatw70l1PfANB5IsP9UWHhSm5L
         pgKoKpUe9P1Ge/LA9Y0U0Mq687i4eqZw+/DlN48z9HSrJaeVXAE/miXryOa2jSFLCT
         475WBoVHfvnNtoVb1iCg4ElJ1OpWiVzl/tynN2b+n31GWHDW1xB8rjxn01hmXq54r7
         E3S8yDwC/Oo5ZuC9JV1+ta4s7P3UalHVfqoVfL2+PqdC+sa3XYn/FS1MvYmaJhq8a8
         Pet21wpbDbmtrhE6fXcIauc3JgCPJuu8q86MISR0MOPdokjmo9Xr2LgXGS0LT2nC5e
         v68Na99U742FA==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH v4] f2fs: fix to do sanity check for inline inode
Date:   Tue, 17 May 2022 11:31:20 +0800
Message-Id: <20220517033120.3564912-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yanming reported a kernel bug in Bugzilla kernel [1], which can be
reproduced. The bug message is:

The kernel message is shown below:

kernel BUG at fs/inode.c:611!
Call Trace:
 evict+0x282/0x4e0
 __dentry_kill+0x2b2/0x4d0
 dput+0x2dd/0x720
 do_renameat2+0x596/0x970
 __x64_sys_rename+0x78/0x90
 do_syscall_64+0x3b/0x90

[1] https://bugzilla.kernel.org/show_bug.cgi?id=215895

The bug is due to fuzzed inode has both inline_data and encrypted flags.
During f2fs_evict_inode(), as the inode was deleted by rename(), it
will cause inline data conversion due to conflicting flags. The page
cache will be polluted and the panic will be triggered in clear_inode().

Try fixing the bug by doing more sanity checks for inline data inode in
sanity_check_inode().

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
v4:
- introduce and use f2fs_post_read_required_ondisk() only for
sanity_check_inode().
 fs/f2fs/f2fs.h   | 15 ++++++++++++++-
 fs/f2fs/file.c   |  2 +-
 fs/f2fs/inline.c | 11 ++++++++---
 fs/f2fs/inode.c  |  3 +--
 fs/f2fs/namei.c  |  2 +-
 5 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7faf230f101f..65442ab03d32 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4039,7 +4039,7 @@ extern struct kmem_cache *f2fs_inode_entry_slab;
 /*
  * inline.c
  */
-bool f2fs_may_inline_data(struct inode *inode);
+bool f2fs_may_inline_data(struct inode *inode, bool sanity_check);
 bool f2fs_may_inline_dentry(struct inode *inode);
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage);
 void f2fs_truncate_inline_inode(struct inode *inode,
@@ -4141,6 +4141,19 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
 #endif
 }
 
+static inline bool f2fs_post_read_required_ondisk(struct inode *inode)
+{
+	/*
+	 * used by sanity_check_inode(), when disk layout fields has not
+	 * been synchronized to inmem fields.
+	 */
+	if (S_ISREG(inode->i_mode) && (file_is_encrypt(inode) ||
+		F2FS_I(inode)->i_flags & F2FS_COMPR_FL ||
+		file_is_verity(inode)))
+		return true;
+
+	return false;
+}
 /*
  * Returns true if the reads of the inode's data need to undergo some
  * postprocessing step, like decryption or authenticity verification.
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0a554730d2c4..73ba1c6dceaa 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -796,7 +796,7 @@ int f2fs_truncate(struct inode *inode)
 		return err;
 
 	/* we should check inline_data size */
-	if (!f2fs_may_inline_data(inode)) {
+	if (!f2fs_may_inline_data(inode, false)) {
 		err = f2fs_convert_inline_inode(inode);
 		if (err)
 			return err;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index a578bf83b803..331ecd8af80c 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -14,7 +14,7 @@
 #include "node.h"
 #include <trace/events/f2fs.h>
 
-bool f2fs_may_inline_data(struct inode *inode)
+bool f2fs_may_inline_data(struct inode *inode, bool sanity_check)
 {
 	if (f2fs_is_atomic_file(inode))
 		return false;
@@ -25,8 +25,13 @@ bool f2fs_may_inline_data(struct inode *inode)
 	if (i_size_read(inode) > MAX_INLINE_DATA(inode))
 		return false;
 
-	if (f2fs_post_read_required(inode))
-		return false;
+	if (sanity_check) {
+		if (f2fs_post_read_required_ondisk(inode))
+			return false;
+	} else {
+		if (f2fs_post_read_required(inode))
+			return false;
+	}
 
 	return true;
 }
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2fce8fa0dac8..3384100dde0b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 	}
 
-	if (f2fs_has_inline_data(inode) &&
-			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
+	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode, true)) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c549acb52ac4..514088f707ed 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -89,7 +89,7 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	if (test_opt(sbi, INLINE_XATTR))
 		set_inode_flag(inode, FI_INLINE_XATTR);
 
-	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
+	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode, false))
 		set_inode_flag(inode, FI_INLINE_DATA);
 	if (f2fs_may_inline_dentry(inode))
 		set_inode_flag(inode, FI_INLINE_DENTRY);
-- 
2.25.1

