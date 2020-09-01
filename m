Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D825972F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbgIAPhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgIAPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F25AA205F4;
        Tue,  1 Sep 2020 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974637;
        bh=DO4WVISNhzP58pGTd3appTpyipFHW2AC97qHtec2TQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is+Orr9W8bIsm7vMIfWmHSFh3qpze5pMVgcg23troWEdeUzuMqIabSKkujAICNnv4
         0X3danYBks4y0by3KGohFb157ZTU6rBcdMuyCDNwW5edsmZUv7K0o7eNdZHal4x6YK
         cjb8HjaQHlKWrkiImbuDfneW2HpFkiTAek0ypRy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 037/255] f2fs: fix error path in do_recover_data()
Date:   Tue,  1 Sep 2020 17:08:13 +0200
Message-Id: <20200901151002.541070904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 9627a7b31f3c4ff8bc8f3be3683983ffe6eaebe6 ]

- don't panic kernel if f2fs_get_node_page() fails in
f2fs_recover_inline_data() or f2fs_recover_inline_xattr();
- return error number of f2fs_truncate_blocks() to
f2fs_recover_inline_data()'s caller;

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h     |  4 ++--
 fs/f2fs/inline.c   | 19 ++++++++++++-------
 fs/f2fs/node.c     |  6 ++++--
 fs/f2fs/recovery.c | 10 ++++++++--
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b35a50f4953c5..7d9afd54e9d8f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3287,7 +3287,7 @@ bool f2fs_alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid);
 void f2fs_alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid);
 void f2fs_alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid);
 int f2fs_try_to_free_nids(struct f2fs_sb_info *sbi, int nr_shrink);
-void f2fs_recover_inline_xattr(struct inode *inode, struct page *page);
+int f2fs_recover_inline_xattr(struct inode *inode, struct page *page);
 int f2fs_recover_xattr_data(struct inode *inode, struct page *page);
 int f2fs_recover_inode_page(struct f2fs_sb_info *sbi, struct page *page);
 int f2fs_restore_node_summary(struct f2fs_sb_info *sbi,
@@ -3750,7 +3750,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page);
 int f2fs_convert_inline_inode(struct inode *inode);
 int f2fs_try_convert_inline_dir(struct inode *dir, struct dentry *dentry);
 int f2fs_write_inline_data(struct inode *inode, struct page *page);
-bool f2fs_recover_inline_data(struct inode *inode, struct page *npage);
+int f2fs_recover_inline_data(struct inode *inode, struct page *npage);
 struct f2fs_dir_entry *f2fs_find_in_inline_dir(struct inode *dir,
 					const struct f2fs_filename *fname,
 					struct page **res_page);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index dbade310dc792..cf2c347bd7a3d 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -253,7 +253,7 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	return 0;
 }
 
-bool f2fs_recover_inline_data(struct inode *inode, struct page *npage)
+int f2fs_recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode *ri = NULL;
@@ -275,7 +275,8 @@ bool f2fs_recover_inline_data(struct inode *inode, struct page *npage)
 			ri && (ri->i_inline & F2FS_INLINE_DATA)) {
 process_inline:
 		ipage = f2fs_get_node_page(sbi, inode->i_ino);
-		f2fs_bug_on(sbi, IS_ERR(ipage));
+		if (IS_ERR(ipage))
+			return PTR_ERR(ipage);
 
 		f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 
@@ -288,21 +289,25 @@ process_inline:
 
 		set_page_dirty(ipage);
 		f2fs_put_page(ipage, 1);
-		return true;
+		return 1;
 	}
 
 	if (f2fs_has_inline_data(inode)) {
 		ipage = f2fs_get_node_page(sbi, inode->i_ino);
-		f2fs_bug_on(sbi, IS_ERR(ipage));
+		if (IS_ERR(ipage))
+			return PTR_ERR(ipage);
 		f2fs_truncate_inline_inode(inode, ipage, 0);
 		clear_inode_flag(inode, FI_INLINE_DATA);
 		f2fs_put_page(ipage, 1);
 	} else if (ri && (ri->i_inline & F2FS_INLINE_DATA)) {
-		if (f2fs_truncate_blocks(inode, 0, false))
-			return false;
+		int ret;
+
+		ret = f2fs_truncate_blocks(inode, 0, false);
+		if (ret)
+			return ret;
 		goto process_inline;
 	}
-	return false;
+	return 0;
 }
 
 struct f2fs_dir_entry *f2fs_find_in_inline_dir(struct inode *dir,
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e61ce7fb0958b..98736d0598b8d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2576,7 +2576,7 @@ int f2fs_try_to_free_nids(struct f2fs_sb_info *sbi, int nr_shrink)
 	return nr - nr_shrink;
 }
 
-void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
+int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 {
 	void *src_addr, *dst_addr;
 	size_t inline_size;
@@ -2584,7 +2584,8 @@ void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 	struct f2fs_inode *ri;
 
 	ipage = f2fs_get_node_page(F2FS_I_SB(inode), inode->i_ino);
-	f2fs_bug_on(F2FS_I_SB(inode), IS_ERR(ipage));
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
 
 	ri = F2FS_INODE(page);
 	if (ri->i_inline & F2FS_INLINE_XATTR) {
@@ -2603,6 +2604,7 @@ void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 update_inode:
 	f2fs_update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
+	return 0;
 }
 
 int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index ae5310f02e7ff..2807251944668 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -544,7 +544,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	/* step 1: recover xattr */
 	if (IS_INODE(page)) {
-		f2fs_recover_inline_xattr(inode, page);
+		err = f2fs_recover_inline_xattr(inode, page);
+		if (err)
+			goto out;
 	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
 		err = f2fs_recover_xattr_data(inode, page);
 		if (!err)
@@ -553,8 +555,12 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	}
 
 	/* step 2: recover inline data */
-	if (f2fs_recover_inline_data(inode, page))
+	err = f2fs_recover_inline_data(inode, page);
+	if (err) {
+		if (err == 1)
+			err = 0;
 		goto out;
+	}
 
 	/* step 3: recover data indices */
 	start = f2fs_start_bidx_of_node(ofs_of_node(page), inode);
-- 
2.25.1



