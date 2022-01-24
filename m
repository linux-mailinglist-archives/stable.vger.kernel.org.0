Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9C498E46
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355140AbiAXTkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33890 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353906AbiAXTfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:35:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED8C3614B8;
        Mon, 24 Jan 2022 19:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55DC340E5;
        Mon, 24 Jan 2022 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052932;
        bh=9RyE6ZLi77tUv4uCLRdOWWqq4WpjHFSm/tVZXOPXU14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfoWxPA4qGCPDv3SG5RlfrDbEbKT76GEyTOtRS8D0YjDjTB1dYOp8mDLnpvF4PoVc
         yoDqmvQRAWTxbwEDwBIs6MCvb//IdkIj2QhLcbxECRcWBri+ZVD7YbzVCfODMEgpE9
         jqsxwOy69Aq0KqW4uHtNYIGuy8NaqApLxLiomer8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/320] jffs2: GC deadlock reading a page that is used in jffs2_write_begin()
Date:   Mon, 24 Jan 2022 19:43:07 +0100
Message-Id: <20220124184000.541931930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>

[ Upstream commit aa39cc675799bc92da153af9a13d6f969c348e82 ]

GC task can deadlock in read_cache_page() because it may attempt
to release a page that is actually allocated by another task in
jffs2_write_begin().
The reason is that in jffs2_write_begin() there is a small window
a cache page is allocated for use but not set Uptodate yet.

This ends up with a deadlock between two tasks:
1) A task (e.g. file copy)
   - jffs2_write_begin() locks a cache page
   - jffs2_write_end() tries to lock "alloc_sem" from
	 jffs2_reserve_space() <-- STUCK
2) GC task (jffs2_gcd_mtd3)
   - jffs2_garbage_collect_pass() locks "alloc_sem"
   - try to lock the same cache page in read_cache_page() <-- STUCK

So to avoid this deadlock, hold "alloc_sem" in jffs2_write_begin()
while reading data in a cache page.

Signed-off-by: Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/file.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index f8fb89b10227c..34880a4c21732 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -135,20 +135,15 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct page *pg;
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
 	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
-	pg = grab_cache_page_write_begin(mapping, index, flags);
-	if (!pg)
-		return -ENOMEM;
-	*pagep = pg;
-
 	jffs2_dbg(1, "%s()\n", __func__);
 
 	if (pageofs > inode->i_size) {
 		/* Make new hole frag from old EOF to new page */
-		struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
@@ -159,7 +154,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
 		if (ret)
-			goto out_page;
+			goto out_err;
 
 		mutex_lock(&f->sem);
 		memset(&ri, 0, sizeof(ri));
@@ -189,7 +184,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			ret = PTR_ERR(fn);
 			jffs2_complete_reservation(c);
 			mutex_unlock(&f->sem);
-			goto out_page;
+			goto out_err;
 		}
 		ret = jffs2_add_full_dnode_to_inode(c, f, fn);
 		if (f->metadata) {
@@ -204,13 +199,26 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
 			mutex_unlock(&f->sem);
-			goto out_page;
+			goto out_err;
 		}
 		jffs2_complete_reservation(c);
 		inode->i_size = pageofs;
 		mutex_unlock(&f->sem);
 	}
 
+	/*
+	 * While getting a page and reading data in, lock c->alloc_sem until
+	 * the page is Uptodate. Otherwise GC task may attempt to read the same
+	 * page in read_cache_page(), which causes a deadlock.
+	 */
+	mutex_lock(&c->alloc_sem);
+	pg = grab_cache_page_write_begin(mapping, index, flags);
+	if (!pg) {
+		ret = -ENOMEM;
+		goto release_sem;
+	}
+	*pagep = pg;
+
 	/*
 	 * Read in the page if it wasn't already present. Cannot optimize away
 	 * the whole page write case until jffs2_write_end can handle the
@@ -220,15 +228,17 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		mutex_lock(&f->sem);
 		ret = jffs2_do_readpage_nolock(inode, pg);
 		mutex_unlock(&f->sem);
-		if (ret)
-			goto out_page;
+		if (ret) {
+			unlock_page(pg);
+			put_page(pg);
+			goto release_sem;
+		}
 	}
 	jffs2_dbg(1, "end write_begin(). pg->flags %lx\n", pg->flags);
-	return ret;
 
-out_page:
-	unlock_page(pg);
-	put_page(pg);
+release_sem:
+	mutex_unlock(&c->alloc_sem);
+out_err:
 	return ret;
 }
 
-- 
2.34.1



