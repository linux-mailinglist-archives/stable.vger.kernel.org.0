Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2494852767B
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 11:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiEOJGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 05:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiEOJF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 05:05:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB40765C;
        Sun, 15 May 2022 02:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3C4FB80AF2;
        Sun, 15 May 2022 09:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C060C385B8;
        Sun, 15 May 2022 09:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652605553;
        bh=Mwj8x5n/ya19o/UjDZ9DoXSZRKW2j74+Pxpl01vamHo=;
        h=From:To:Cc:Subject:Date:From;
        b=Aw8nfDi+XuMAAvR8hXetPUqHAMISpxvq/+AC3YD6OlFkrUOrRQrZ1Ak72n1lAmdT2
         N9a0UuSW1irAO31CoFBE/4uD5AVZ77ZriRkVJX7OfEnShDnVEZZtTqEF9CGc2v3qX3
         ypfyVg5YVIV80gg5sAi46/WGSKQpQPKut23DiTxeVWm0K1lReth16WCT0vQDiq0R00
         O58qgnIlyRsLttNVpJhPVHA4nibzXiw8VuYKLzxh8r+Zq3xOhFtnzz8TkMec2CzzOH
         nZG33bMVgW6VMsoPZlkgbCJvcMijg10UgcdjBfK1nch1wLlIDfiX0yLSUu582iM2cd
         zUnzgPBA+TONQ==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH v3] f2fs: fix to do sanity check for inline inode
Date:   Sun, 15 May 2022 17:05:47 +0800
Message-Id: <20220515090547.1914-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
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
v3:
- clean up commit message suggested by Bagas Sanjaya.
 fs/f2fs/f2fs.h  | 8 ++++++++
 fs/f2fs/inode.c | 3 +--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 492af5b96de1..0dc2461ef02c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4126,6 +4126,14 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
  */
 static inline bool f2fs_post_read_required(struct inode *inode)
 {
+	/*
+	 * used by sanity_check_inode(), when disk layout fields has not
+	 * been synchronized to inmem fields.
+	 */
+	if (S_ISREG(inode->i_mode) && (file_is_encrypt(inode) ||
+		F2FS_I(inode)->i_flags & F2FS_COMPR_FL ||
+		file_is_verity(inode)))
+		return true;
 	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
 		f2fs_compressed_file(inode);
 }
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2fce8fa0dac8..5e494c98e3c2 100644
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
2.32.0

