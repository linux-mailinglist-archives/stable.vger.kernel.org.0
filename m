Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D375129A7
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 04:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbiD1CxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 22:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiD1CxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 22:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCE986F8;
        Wed, 27 Apr 2022 19:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76AA961667;
        Thu, 28 Apr 2022 02:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BB9C385A9;
        Thu, 28 Apr 2022 02:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651114190;
        bh=+QjhRstIP0l49yEI8x36m/NyfYc/s4NAkMUHD/Mjies=;
        h=From:To:Cc:Subject:Date:From;
        b=kjlY47SHJq9f31TN4d5rVmz9o9AYA+jovPHmtb5OZ4m34zPVJyX4iaOU0U5htexFy
         T2dIx1OwDp6kn2dA292lIikXa99zBTjBO00ZELmH7PsD1PsR/a+BnRgw5k/UOrw8cu
         lRn+nr+0scKxp7Bfq/Juu9EFy6JIi1aMQy0YLPd1529LqbO/JiFKVPVSjn9Su/knuI
         dj70qjUNEa1wyODnw3Ewfee9yO9nerrsScAamgm6pwQNO6cAAiLnD8RgBLHF7QH+st
         a/T0YeMPBKTRgSvxFXtDW+4E14IZ61TNw03ZSO3FCOe8enE2xmSqfmuvCOgeE9frJ1
         CmC/DwOgFtZhg==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH] f2fs: fix to do sanity check for inline inode
Date:   Thu, 28 Apr 2022 10:49:40 +0800
Message-Id: <20220428024940.12102-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215895

I have encountered a bug in F2FS file system in kernel v5.17.

The kernel message is shown below:

kernel BUG at fs/inode.c:611!
Call Trace:
 evict+0x282/0x4e0
 __dentry_kill+0x2b2/0x4d0
 dput+0x2dd/0x720
 do_renameat2+0x596/0x970
 __x64_sys_rename+0x78/0x90
 do_syscall_64+0x3b/0x90

The root cause is: fuzzed inode has both inline_data flag and encrypted
flag, so after it was deleted by rename(), during f2fs_evict_inode(),
it will cause inline data conversion due to flags confilction, then
page cache will be polluted and trigger panic in clear_inode().

This patch tries to fix the issue by do more sanity checks for inline
data inode in sanity_check_inode().

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
 fs/f2fs/f2fs.h  | 7 +++++++
 fs/f2fs/inode.c | 3 +--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 27aa93caec06..64c511b498cc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4173,6 +4173,13 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
  */
 static inline bool f2fs_post_read_required(struct inode *inode)
 {
+	/*
+	 * used by sanity_check_inode(), when disk layout fields has not
+	 * been synchronized to inmem fields.
+	 */
+	if (file_is_encrypt(inode) || file_is_verity(inode) ||
+			F2FS_I(inode)->i_flags & F2FS_COMPR_FL)
+		return true;
 	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
 		f2fs_compressed_file(inode);
 }
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 83639238a1fe..234b8ed02644 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 	}
 
-	if (f2fs_has_inline_data(inode) &&
-			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
+	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode)) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);
-- 
2.25.1

