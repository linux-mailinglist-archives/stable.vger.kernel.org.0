Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4B65407FE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348764AbiFGRxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350140AbiFGRvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63C81406F0;
        Tue,  7 Jun 2022 10:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6667CE23E4;
        Tue,  7 Jun 2022 17:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB3BC385A5;
        Tue,  7 Jun 2022 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623255;
        bh=ns7xU3HfLmu11T2sJmzkMrgebZERH/zDN8Ir0EoctOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGaRrNsaQFX6iH8kgzqNzqCctidqFqNoCD/dAtEk55xtPxlXQSMQrh+X3kghg+j9o
         Dyve/ThGEN5+Qdrx0/IrgHRUcg0ZzB2fgD0P5ZNwgEV4bTY+7ThPXaUs/kxa2gg0JL
         4dD8aACAgPmP5N1jefSscbhav39TsIEFqpLirUwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 351/452] f2fs: fix to do sanity check for inline inode
Date:   Tue,  7 Jun 2022 19:03:28 +0200
Message-Id: <20220607164919.017006983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 677a82b44ebf263d4f9a0cfbd576a6ade797a07b upstream.

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
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h   |    1 +
 fs/f2fs/inline.c |   29 ++++++++++++++++++++++++-----
 fs/f2fs/inode.c  |    3 +--
 3 files changed, 26 insertions(+), 7 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3735,6 +3735,7 @@ extern struct kmem_cache *f2fs_inode_ent
  * inline.c
  */
 bool f2fs_may_inline_data(struct inode *inode);
+bool f2fs_sanity_check_inline_data(struct inode *inode);
 bool f2fs_may_inline_dentry(struct inode *inode);
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage);
 void f2fs_truncate_inline_inode(struct inode *inode,
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -14,21 +14,40 @@
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
+
+bool f2fs_may_inline_data(struct inode *inode)
+{
+	if (!support_inline_data(inode))
+		return false;
+
+	return !f2fs_post_read_required(inode);
+}
 
-	if (f2fs_post_read_required(inode))
+bool f2fs_sanity_check_inline_data(struct inode *inode)
+{
+	if (!f2fs_has_inline_data(inode))
 		return false;
 
-	return true;
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
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -272,8 +272,7 @@ static bool sanity_check_inode(struct in
 		}
 	}
 
-	if (f2fs_has_inline_data(inode) &&
-			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
+	if (f2fs_sanity_check_inline_data(inode)) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);


