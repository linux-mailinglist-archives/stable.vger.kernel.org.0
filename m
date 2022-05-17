Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C333252AA73
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244889AbiEQSS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351939AbiEQSS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699FB506F7;
        Tue, 17 May 2022 11:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC8F6154E;
        Tue, 17 May 2022 18:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293B7C385B8;
        Tue, 17 May 2022 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652811507;
        bh=2LCmXWONhKrPy7V/HFUdgxZKavcQYloErhSK6XQD1tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=okiCUjDmTLzdZyWXfepJpPbdx1gK30/Wqd0sXKdy6X/Naod/JEIiHeCGOBbjFrYj+
         rHbGIXINnXvx3NrlrP1LntVd2nEQZJJT3ivOs6NnPOmt7eSX9mfARpztaHWBN7pJSA
         LxYGDl3HSnAjiNZTZWlyivpAxw4W8jarJC1mFpvMJYEYmcMrk2KzUFHG8eNIDab32j
         bfTTchj1nBXJxXtaL7H6oV/kL+e31N18OP4nb22uj26EUjgVX4frSybpvStSl9VUw1
         PrSd3ULmI+V+M83nEXjta4iZZeql8zQue2Uze4r87DZzNtxUOCurCcRd0Kt31cmPsH
         d30YIf/xo/9dQ==
Date:   Tue, 17 May 2022 11:18:25 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
Subject: Re: [PATCH v4] f2fs: fix to do sanity check for inline inode
Message-ID: <YoPm8UI61eKtKPB8@google.com>
References: <20220517033120.3564912-1-chao@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517033120.3564912-1-chao@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/17, Chao Yu wrote:
> Yanming reported a kernel bug in Bugzilla kernel [1], which can be
> reproduced. The bug message is:
> 
> The kernel message is shown below:
> 
> kernel BUG at fs/inode.c:611!
> Call Trace:
>  evict+0x282/0x4e0
>  __dentry_kill+0x2b2/0x4d0
>  dput+0x2dd/0x720
>  do_renameat2+0x596/0x970
>  __x64_sys_rename+0x78/0x90
>  do_syscall_64+0x3b/0x90
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=215895
> 
> The bug is due to fuzzed inode has both inline_data and encrypted flags.
> During f2fs_evict_inode(), as the inode was deleted by rename(), it
> will cause inline data conversion due to conflicting flags. The page
> cache will be polluted and the panic will be triggered in clear_inode().
> 
> Try fixing the bug by doing more sanity checks for inline data inode in
> sanity_check_inode().
> 
> Cc: stable@vger.kernel.org
> Reported-by: Ming Yan <yanming@tju.edu.cn>
> Signed-off-by: Chao Yu <chao.yu@oppo.com>
> ---
> v4:
> - introduce and use f2fs_post_read_required_ondisk() only for

Can we do like this?

---
 fs/f2fs/f2fs.h   |  1 +
 fs/f2fs/inline.c | 30 +++++++++++++++++++++++++-----
 fs/f2fs/inode.c  |  3 +--
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e9e32bc814df..000468bf06ca 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4019,6 +4019,7 @@ extern struct kmem_cache *f2fs_inode_entry_slab;
  * inline.c
  */
 bool f2fs_may_inline_data(struct inode *inode);
+bool f2fs_sanity_check_inline_data(struct inode *inode);
 bool f2fs_may_inline_dentry(struct inode *inode);
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage);
 void f2fs_truncate_inline_inode(struct inode *inode,
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index a578bf83b803..daf8c0e0a6b6 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -14,21 +14,41 @@
 #include "node.h"
 #include <trace/events/f2fs.h>
 
-bool f2fs_may_inline_data(struct inode *inode)
+static bool support_inline_data(struct inode *inode)
 {
 	if (f2fs_is_atomic_file(inode))
 		return false;
-
 	if (!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))
 		return false;
-
 	if (i_size_read(inode) > MAX_INLINE_DATA(inode))
 		return false;
+	return true;
+}
 
-	if (f2fs_post_read_required(inode))
+bool f2fs_may_inline_data(struct inode *inode)
+{
+	if (!support_inline_data(inode))
 		return false;
 
-	return true;
+	return !(f2fs_encrypted_file(inode) || fsverity_active(inode) ||
+		f2fs_compressed_file(inode));
+}
+
+bool f2fs_sanity_check_inline_data(struct inode *inode)
+{
+	if (!f2fs_has_inline_data(inode))
+		return false;
+
+	if (!support_inline_data(inode))
+		return true;
+
+	/*
+	 * used by sanity_check_inode(), when disk layout fields has not
+	 * been synchronized to inmem fields.
+	 */
+	return (S_ISREG(inode->i_mode) &&
+		(file_is_encrypt(inode) || file_is_verity(inode) ||
+		(F2FS_I(inode)->i_flags & F2FS_COMPR_FL)));
 }
 
 bool f2fs_may_inline_dentry(struct inode *inode)
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2fce8fa0dac8..938961a9084e 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 	}
 
-	if (f2fs_has_inline_data(inode) &&
-			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
+	if (f2fs_sanity_check_inline_data(inode)) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);
-- 
2.36.0.550.gb090851708-goog

