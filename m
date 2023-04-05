Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1753C6D88E4
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjDEUnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 16:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjDEUnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 16:43:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B364683E0;
        Wed,  5 Apr 2023 13:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3FD862887;
        Wed,  5 Apr 2023 20:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32284C433EF;
        Wed,  5 Apr 2023 20:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680727402;
        bh=6e4aZuW0CQQJwSrwrHjU6vWTR/ojeKCfsa6BmYjfvTA=;
        h=From:To:Cc:Subject:Date:From;
        b=kVU7e56XTp0GILO03kRtXnM7vFH2/BeDjpP+O+rtcTuTvrF1HZsC3vtmE8rd0+ljh
         zyXVwpICoks53jh1WRHNftqqHZZtLrWGmJMv1e8uf2m4eK6CfXuHCaPBCPgNRFlNZg
         gSloE5T4979gfWCTRQODPVDJ25EQTdiqwFy2xNd66vQZULILV3reSwLQtTvMFP27yG
         iWbMAFcMbdUzMM/pD/cpPK7+IDIepwMqmBcOw8MKIj0vnFWZ5CMwP6xfVwtbf7FhdP
         BkKYpeYDaHmWMoVyyVBqkelbmdHwoUgnMcypzG6dyEYJLkUL9Uu4izVri6EJSYGoFZ
         3AleDHXkHQjGw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: attach/detach private value in pair
Date:   Wed,  5 Apr 2023 13:43:21 -0700
Message-Id: <20230405204321.2056498-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

set_page_private_# increases a refcount after attaching page->private, and
clear_page_private_# decreases it.
But, f2fs_release_folio and f2fs_invalidate_folio call folio_detach_private()
which decreases the refcount again, which corrupts the page cache.

Cc: <stable@vger.kernel.org>
Fixes: b763f3bedc2d ("f2fs: restructure f2fs page.private layout")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/compress.c |  4 ++--
 fs/f2fs/data.c     |  6 ++++--
 fs/f2fs/f2fs.h     | 48 ++++++++++++++++------------------------------
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 11653fa79289..70b3910db413 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1854,7 +1854,7 @@ void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
 		return;
 	}
 
-	set_page_private_data(cpage, ino);
+	set_page_private_ino(cpage, ino);
 
 	if (!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE_READ))
 		goto out;
@@ -1917,7 +1917,7 @@ void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino)
 				continue;
 			}
 
-			if (ino != get_page_private_data(&folio->page)) {
+			if (ino != get_page_private_ino(&folio->page)) {
 				folio_unlock(folio);
 				continue;
 			}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 359de650772e..7262c754ff8b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3724,8 +3724,9 @@ void f2fs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 
 	if (test_opt(sbi, COMPRESS_CACHE) &&
 			inode->i_ino == F2FS_COMPRESS_INO(sbi))
-		clear_page_private_data(&folio->page);
+		clear_page_private_ino(&folio->page);
 
+	WARN_ON_ONCE(page_private(&folio->page));
 	folio_detach_private(folio);
 }
 
@@ -3742,12 +3743,13 @@ bool f2fs_release_folio(struct folio *folio, gfp_t wait)
 		struct inode *inode = folio->mapping->host;
 
 		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
-			clear_page_private_data(&folio->page);
+			clear_page_private_ino(&folio->page);
 	}
 
 	clear_page_private_reference(&folio->page);
 	clear_page_private_gcing(&folio->page);
 
+	WARN_ON_ONCE(page_private(&folio->page));
 	folio_detach_private(folio);
 	return true;
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index dfead8160a51..3d883201e7a5 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1395,6 +1395,7 @@ enum {
 	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
 	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
 	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	PAGE_PRIVATE_DATA,			/* page has referenced data */
 	PAGE_PRIVATE_MAX
 };
 
@@ -1409,73 +1410,56 @@ static inline bool page_private_##name(struct page *page) \
 #define PAGE_PRIVATE_SET_FUNC(name, flagname) \
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) { \
-		get_page(page); \
-		SetPagePrivate(page); \
-		set_page_private(page, 0); \
-	} \
+	if (!PagePrivate(page)) \
+		attach_page_private(page, 0); \
 	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
+/* clear private by f2fs_release_folio or f2fs_invalidate_folio */
 #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
 static inline void clear_page_private_##name(struct page *page) \
 { \
 	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) { \
+	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
 		set_page_private(page, 0); \
-		if (PagePrivate(page)) { \
-			ClearPagePrivate(page); \
-			put_page(page); \
-		}\
-	} \
 }
 
 PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
 PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
 PAGE_PRIVATE_GET_FUNC(dummy, DUMMY_WRITE);
+PAGE_PRIVATE_GET_FUNC(data, DATA);
 
 PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
 PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
 PAGE_PRIVATE_SET_FUNC(dummy, DUMMY_WRITE);
+PAGE_PRIVATE_SET_FUNC(data, DATA);
 
 PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
 PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
 PAGE_PRIVATE_CLEAR_FUNC(dummy, DUMMY_WRITE);
+PAGE_PRIVATE_CLEAR_FUNC(data, DATA);
 
-static inline unsigned long get_page_private_data(struct page *page)
+static inline nid_t get_page_private_ino(struct page *page)
 {
-	unsigned long data = page_private(page);
-
-	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+	if (!page_private_data(page))
 		return 0;
-	return data >> PAGE_PRIVATE_MAX;
+	return page_private(page) >> PAGE_PRIVATE_MAX;
 }
 
-static inline void set_page_private_data(struct page *page, unsigned long data)
+static inline void set_page_private_ino(struct page *page, nid_t ino)
 {
-	if (!PagePrivate(page)) {
-		get_page(page);
-		SetPagePrivate(page);
-		set_page_private(page, 0);
-	}
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page));
-	page_private(page) |= data << PAGE_PRIVATE_MAX;
+	set_page_private_data(page);
+	page_private(page) |= ino << PAGE_PRIVATE_MAX;
 }
 
-static inline void clear_page_private_data(struct page *page)
+static inline void clear_page_private_ino(struct page *page)
 {
 	page_private(page) &= GENMASK(PAGE_PRIVATE_MAX - 1, 0);
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) {
-		set_page_private(page, 0);
-		if (PagePrivate(page)) {
-			ClearPagePrivate(page);
-			put_page(page);
-		}
-	}
+	clear_page_private_data(page);
 }
 
 /* For compression */
-- 
2.40.0.348.gf938b09366-goog

