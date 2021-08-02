Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92A63DD959
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhHBOAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234781AbhHBN5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC339611AD;
        Mon,  2 Aug 2021 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912485;
        bh=UAOpzwQBKRyIqKde8QpW2ilSLwTng4qW/1zuKDTAA/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHxF6TqIZo619/iwfyRU8FggtrEQc0kD0lzslxQXBZe7wP32fPsWN3x+KkYnDSci7
         Erzv9WQVpUGztEfOu9C1OqCjxqsSv6pnTQmR7eXnb0TKll1ByDuN1gG6Q8ZhTq7J/g
         7nb83bEWw0GL+xmu7/ed+kJco31bxevAy8faCR2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Javier Pello <javier.pello@urjc.es>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.13 002/104] fs/ext2: Avoid page_address on pages returned by ext2_get_page
Date:   Mon,  2 Aug 2021 15:43:59 +0200
Message-Id: <20210802134344.106539320@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Pello <javier.pello@urjc.es>

commit 728d392f8a799f037812d0f2b254fb3b5e115fcf upstream.

Commit 782b76d7abdf02b12c46ed6f1e9bf715569027f7 ("fs/ext2: Replace
kmap() with kmap_local_page()") replaced the kmap/kunmap calls in
ext2_get_page/ext2_put_page with kmap_local_page/kunmap_local for
efficiency reasons. As a necessary side change, the commit also
made ext2_get_page (and ext2_find_entry and ext2_dotdot) return
the mapping address along with the page itself, as it is required
for kunmap_local, and converted uses of page_address on such pages
to use the newly returned address instead. However, uses of
page_address on such pages were missed in ext2_check_page and
ext2_delete_entry, which triggers oopses if kmap_local_page happens
to return an address from high memory. Fix this now by converting
the remaining uses of page_address to use the right address, as
returned by kmap_local_page.

Link: https://lore.kernel.org/r/20210714185448.8707ac239e9f12b3a7f5b9f9@urjc.es
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Javier Pello <javier.pello@urjc.es>
Fixes: 782b76d7abdf ("fs/ext2: Replace kmap() with kmap_local_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/dir.c   |   12 ++++++------
 fs/ext2/ext2.h  |    3 ++-
 fs/ext2/namei.c |    4 ++--
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -106,12 +106,11 @@ static int ext2_commit_chunk(struct page
 	return err;
 }
 
-static bool ext2_check_page(struct page *page, int quiet)
+static bool ext2_check_page(struct page *page, int quiet, char *kaddr)
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned chunk_size = ext2_chunk_size(dir);
-	char *kaddr = page_address(page);
 	u32 max_inumber = le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count);
 	unsigned offs, rec_len;
 	unsigned limit = PAGE_SIZE;
@@ -205,7 +204,8 @@ static struct page * ext2_get_page(struc
 	if (!IS_ERR(page)) {
 		*page_addr = kmap_local_page(page);
 		if (unlikely(!PageChecked(page))) {
-			if (PageError(page) || !ext2_check_page(page, quiet))
+			if (PageError(page) || !ext2_check_page(page, quiet,
+								*page_addr))
 				goto fail;
 		}
 	}
@@ -584,10 +584,10 @@ out_unlock:
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date.
  */
-int ext2_delete_entry (struct ext2_dir_entry_2 * dir, struct page * page )
+int ext2_delete_entry (struct ext2_dir_entry_2 *dir, struct page *page,
+			char *kaddr)
 {
 	struct inode *inode = page->mapping->host;
-	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(ext2_chunk_size(inode)-1);
 	unsigned to = ((char *)dir - kaddr) +
 				ext2_rec_len_from_disk(dir->rec_len);
@@ -607,7 +607,7 @@ int ext2_delete_entry (struct ext2_dir_e
 		de = ext2_next_entry(de);
 	}
 	if (pde)
-		from = (char*)pde - (char*)page_address(page);
+		from = (char *)pde - kaddr;
 	pos = page_offset(page) + from;
 	lock_page(page);
 	err = ext2_prepare_chunk(page, pos, to - from);
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -740,7 +740,8 @@ extern int ext2_inode_by_name(struct ino
 extern int ext2_make_empty(struct inode *, struct inode *);
 extern struct ext2_dir_entry_2 *ext2_find_entry(struct inode *, const struct qstr *,
 						struct page **, void **res_page_addr);
-extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
+extern int ext2_delete_entry(struct ext2_dir_entry_2 *dir, struct page *page,
+			     char *kaddr);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 *ext2_dotdot(struct inode *dir, struct page **p, void **pa);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, void *,
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -293,7 +293,7 @@ static int ext2_unlink(struct inode * di
 		goto out;
 	}
 
-	err = ext2_delete_entry (de, page);
+	err = ext2_delete_entry (de, page, page_addr);
 	ext2_put_page(page, page_addr);
 	if (err)
 		goto out;
@@ -397,7 +397,7 @@ static int ext2_rename (struct user_name
 	old_inode->i_ctime = current_time(old_inode);
 	mark_inode_dirty(old_inode);
 
-	ext2_delete_entry(old_de, old_page);
+	ext2_delete_entry(old_de, old_page, old_page_addr);
 
 	if (dir_de) {
 		if (old_dir != new_dir)


