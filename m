Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82924DC45
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgHUQ6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgHUQTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:19:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87B022D2B;
        Fri, 21 Aug 2020 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026714;
        bh=VD+KgXXlDeSVV4/9DHHVSUa4GxvvhNoi+O0+b8jPa8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV5PKEsCssYWzAKHFTQV4SIsiC+vlkpkxwvPbo28kPRhmeTxXwzXufQ+txzuJa0tO
         g66H8wwKt4FFRM1HX5yqotLmHv9tdWxJDRf633Kg8ev5MDSGloIHuotBCne9XnB3wX
         CMsmf1nMvm8no2VodaEcoQmgEkVmIiwV72TODyns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 21/38] f2fs: fix error path in do_recover_data()
Date:   Fri, 21 Aug 2020 12:17:50 -0400
Message-Id: <20200821161807.348600-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161807.348600-1-sashal@kernel.org>
References: <20200821161807.348600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6b5b685af5990..53ffa6fe207a3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2921,7 +2921,7 @@ bool f2fs_alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid);
 void f2fs_alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid);
 void f2fs_alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid);
 int f2fs_try_to_free_nids(struct f2fs_sb_info *sbi, int nr_shrink);
-void f2fs_recover_inline_xattr(struct inode *inode, struct page *page);
+int f2fs_recover_inline_xattr(struct inode *inode, struct page *page);
 int f2fs_recover_xattr_data(struct inode *inode, struct page *page);
 int f2fs_recover_inode_page(struct f2fs_sb_info *sbi, struct page *page);
 int f2fs_restore_node_summary(struct f2fs_sb_info *sbi,
@@ -3314,7 +3314,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page);
 int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page);
 int f2fs_convert_inline_inode(struct inode *inode);
 int f2fs_write_inline_data(struct inode *inode, struct page *page);
-bool f2fs_recover_inline_data(struct inode *inode, struct page *npage);
+int f2fs_recover_inline_data(struct inode *inode, struct page *npage);
 struct f2fs_dir_entry *f2fs_find_in_inline_dir(struct inode *dir,
 			struct fscrypt_name *fname, struct page **res_page);
 int f2fs_make_empty_inline_dir(struct inode *inode, struct inode *parent,
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index c1ba29d10789d..2fabeb0bb28fd 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -256,7 +256,7 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	return 0;
 }
 
-bool f2fs_recover_inline_data(struct inode *inode, struct page *npage)
+int f2fs_recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode *ri = NULL;
@@ -278,7 +278,8 @@ bool f2fs_recover_inline_data(struct inode *inode, struct page *npage)
 			ri && (ri->i_inline & F2FS_INLINE_DATA)) {
 process_inline:
 		ipage = f2fs_get_node_page(sbi, inode->i_ino);
-		f2fs_bug_on(sbi, IS_ERR(ipage));
+		if (IS_ERR(ipage))
+			return PTR_ERR(ipage);
 
 		f2fs_wait_on_page_writeback(ipage, NODE, true);
 
@@ -291,21 +292,25 @@ bool f2fs_recover_inline_data(struct inode *inode, struct page *npage)
 
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
index f0714c1258c79..2ff02541c53d5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2451,7 +2451,7 @@ int f2fs_try_to_free_nids(struct f2fs_sb_info *sbi, int nr_shrink)
 	return nr - nr_shrink;
 }
 
-void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
+int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 {
 	void *src_addr, *dst_addr;
 	size_t inline_size;
@@ -2459,7 +2459,8 @@ void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 	struct f2fs_inode *ri;
 
 	ipage = f2fs_get_node_page(F2FS_I_SB(inode), inode->i_ino);
-	f2fs_bug_on(F2FS_I_SB(inode), IS_ERR(ipage));
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
 
 	ri = F2FS_INODE(page);
 	if (ri->i_inline & F2FS_INLINE_XATTR) {
@@ -2478,6 +2479,7 @@ void f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 update_inode:
 	f2fs_update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
+	return 0;
 }
 
 int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 733f005b85d65..ad0486beee2c0 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -471,7 +471,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	/* step 1: recover xattr */
 	if (IS_INODE(page)) {
-		f2fs_recover_inline_xattr(inode, page);
+		err = f2fs_recover_inline_xattr(inode, page);
+		if (err)
+			goto out;
 	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
 		err = f2fs_recover_xattr_data(inode, page);
 		if (!err)
@@ -480,8 +482,12 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
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

