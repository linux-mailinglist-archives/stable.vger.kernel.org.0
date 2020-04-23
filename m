Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F03B1B699C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgDWXZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48184 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728081AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zs-QD; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6fi-1s; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.cz>
Date:   Fri, 24 Apr 2020 00:04:07 +0100
Message-ID: <lsq.1587683028.984986934@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 020/245] btrfs: kill extent_buffer_page helper
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit fb85fc9a675738ee2746b51c3aedde944b18ca02 upstream.

It used to be more complex but now it's just a simple array access.

Signed-off-by: David Sterba <dsterba@suse.cz>
[bwh: Backported to 3.16 as dependency of various fixes: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent_io.c | 55 +++++++++++++++++++++-----------------------
 fs/btrfs/extent_io.h |  6 -----
 2 files changed, 26 insertions(+), 35 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2082,7 +2082,7 @@ int repair_eb_io_failure(struct btrfs_ro
 		return -EROFS;
 
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
+		struct page *p = eb->pages[i];
 		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
 					start, p, mirror_num);
 		if (ret)
@@ -3558,7 +3558,7 @@ lock_extent_buffer_for_io(struct extent_
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
+		struct page *p = eb->pages[i];
 
 		if (!trylock_page(p)) {
 			if (!flush) {
@@ -3629,7 +3629,7 @@ static noinline_for_stack int write_one_
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
+		struct page *p = eb->pages[i];
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
@@ -3652,10 +3652,8 @@ static noinline_for_stack int write_one_
 	}
 
 	if (unlikely(ret)) {
-		for (; i < num_pages; i++) {
-			struct page *p = extent_buffer_page(eb, i);
-			unlock_page(p);
-		}
+		for (; i < num_pages; i++)
+			unlock_page(eb->pages[i]);
 	}
 
 	return ret;
@@ -4459,7 +4457,7 @@ static void btrfs_release_extent_buffer_
 
 	do {
 		index--;
-		page = extent_buffer_page(eb, index);
+		page = eb->pages[index];
 		if (page && mapped) {
 			spin_lock(&page->mapping->private_lock);
 			/*
@@ -4641,7 +4639,8 @@ static void mark_extent_buffer_accessed(
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		struct page *p = extent_buffer_page(eb, i);
+		struct page *p = eb->pages[i];
+
 		if (p != accessed)
 			mark_page_accessed(p);
 	}
@@ -4810,7 +4809,7 @@ again:
 	 */
 	SetPageChecked(eb->pages[0]);
 	for (i = 1; i < num_pages; i++) {
-		p = extent_buffer_page(eb, i);
+		p = eb->pages[i];
 		ClearPageChecked(p);
 		unlock_page(p);
 	}
@@ -4921,7 +4920,7 @@ void clear_extent_buffer_dirty(struct ex
 	num_pages = num_extent_pages(eb->start, eb->len);
 
 	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		if (!PageDirty(page))
 			continue;
 
@@ -4957,7 +4956,7 @@ int set_extent_buffer_dirty(struct exten
 	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
 
 	for (i = 0; i < num_pages; i++)
-		set_page_dirty(extent_buffer_page(eb, i));
+		set_page_dirty(eb->pages[i]);
 	return was_dirty;
 }
 
@@ -4970,7 +4969,7 @@ int clear_extent_buffer_uptodate(struct
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		if (page)
 			ClearPageUptodate(page);
 	}
@@ -4986,7 +4985,7 @@ int set_extent_buffer_uptodate(struct ex
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = 0; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		SetPageUptodate(page);
 	}
 	return 0;
@@ -5026,7 +5025,7 @@ int read_extent_buffer_pages(struct exte
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		if (wait == WAIT_NONE) {
 			if (!trylock_page(page))
 				goto unlock_exit;
@@ -5049,7 +5048,7 @@ int read_extent_buffer_pages(struct exte
 	eb->read_mirror = 0;
 	atomic_set(&eb->io_pages, num_reads);
 	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
@@ -5074,7 +5073,7 @@ int read_extent_buffer_pages(struct exte
 		return ret;
 
 	for (i = start_i; i < num_pages; i++) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		wait_on_page_locked(page);
 		if (!PageUptodate(page))
 			ret = -EIO;
@@ -5085,7 +5084,7 @@ int read_extent_buffer_pages(struct exte
 unlock_exit:
 	i = start_i;
 	while (locked_pages > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		i++;
 		unlock_page(page);
 		locked_pages--;
@@ -5111,7 +5110,7 @@ void read_extent_buffer(struct extent_bu
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5143,7 +5142,7 @@ int read_extent_buffer_to_user(struct ex
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 		kaddr = page_address(page);
@@ -5192,7 +5191,7 @@ int map_private_extent_buffer(struct ext
 		return -EINVAL;
 	}
 
-	p = extent_buffer_page(eb, i);
+	p = eb->pages[i];
 	kaddr = page_address(p);
 	*map = kaddr + offset;
 	*map_len = PAGE_CACHE_SIZE - offset;
@@ -5218,7 +5217,7 @@ int memcmp_extent_buffer(struct extent_b
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 
@@ -5252,7 +5251,7 @@ void write_extent_buffer(struct extent_b
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
@@ -5282,7 +5281,7 @@ void memset_extent_buffer(struct extent_
 	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(eb, i);
+		page = eb->pages[i];
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
@@ -5313,7 +5312,7 @@ void copy_extent_buffer(struct extent_bu
 		(PAGE_CACHE_SIZE - 1);
 
 	while (len > 0) {
-		page = extent_buffer_page(dst, i);
+		page = dst->pages[i];
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
@@ -5391,8 +5390,7 @@ void memcpy_extent_buffer(struct extent_
 		cur = min_t(unsigned long, cur,
 			(unsigned long)(PAGE_CACHE_SIZE - dst_off_in_page));
 
-		copy_pages(extent_buffer_page(dst, dst_i),
-			   extent_buffer_page(dst, src_i),
+		copy_pages(dst->pages[dst_i], dst->pages[src_i],
 			   dst_off_in_page, src_off_in_page, cur);
 
 		src_offset += cur;
@@ -5438,8 +5436,7 @@ void memmove_extent_buffer(struct extent
 
 		cur = min_t(unsigned long, len, src_off_in_page + 1);
 		cur = min(cur, dst_off_in_page + 1);
-		copy_pages(extent_buffer_page(dst, dst_i),
-			   extent_buffer_page(dst, src_i),
+		copy_pages(dst->pages[dst_i], dst->pages[src_i],
 			   dst_off_in_page - cur + 1,
 			   src_off_in_page - cur + 1, cur);
 
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -286,12 +286,6 @@ static inline unsigned long num_extent_p
 		(start >> PAGE_CACHE_SHIFT);
 }
 
-static inline struct page *extent_buffer_page(struct extent_buffer *eb,
-					      unsigned long i)
-{
-	return eb->pages[i];
-}
-
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
 	atomic_inc(&eb->refs);

