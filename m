Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8210B83F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfK0Uld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbfK0Uld (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:41:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6E920863;
        Wed, 27 Nov 2019 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887292;
        bh=yMANsvQR7BaNAKga85VnyLz+nzo9WorfhVnnC6PD6AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lje0lajaQHYVHSyK1WngnrFkCYAqno/+vsWsET2Jmnw3CTifTRXRMJkJAsKwRfZjp
         qdBf10wTJESa5XsNshR+sk7BZGDLxUJZLdfclpTJ3+TvtoDmXL1g1spruwsl71DyKm
         /xCRBcVrC9geLaOtr9cc3558hvr0XkAZEA3t6RMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weichao Guo <guoweichao@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/151] f2fs: fix to spread clear_cold_data()
Date:   Wed, 27 Nov 2019 21:30:36 +0100
Message-Id: <20191127203031.650078812@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 2baf07818549c8bb8d7b3437e889b86eab56d38e ]

We need to drop PG_checked flag on page as well when we clear PG_uptodate
flag, in order to avoid treating the page as GCing one later.

Signed-off-by: Weichao Guo <guoweichao@huawei.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c    | 8 +++++++-
 fs/f2fs/dir.c     | 1 +
 fs/f2fs/segment.c | 4 +++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9041805096e0c..0206c8c20784c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1201,6 +1201,7 @@ int do_write_data_page(struct f2fs_io_info *fio)
 	/* This page is already truncated */
 	if (fio->old_blkaddr == NULL_ADDR) {
 		ClearPageUptodate(page);
+		clear_cold_data(page);
 		goto out_writepage;
 	}
 
@@ -1337,8 +1338,10 @@ static int f2fs_write_data_page(struct page *page,
 	clear_cold_data(page);
 out:
 	inode_dec_dirty_pages(inode);
-	if (err)
+	if (err) {
 		ClearPageUptodate(page);
+		clear_cold_data(page);
+	}
 
 	if (wbc->for_reclaim) {
 		f2fs_submit_merged_bio_cond(sbi, NULL, page, 0, DATA, WRITE);
@@ -1821,6 +1824,8 @@ void f2fs_invalidate_page(struct page *page, unsigned int offset,
 			inode_dec_dirty_pages(inode);
 	}
 
+	clear_cold_data(page);
+
 	/* This is atomic written page, keep Private */
 	if (IS_ATOMIC_WRITTEN_PAGE(page))
 		return;
@@ -1839,6 +1844,7 @@ int f2fs_release_page(struct page *page, gfp_t wait)
 	if (IS_ATOMIC_WRITTEN_PAGE(page))
 		return 0;
 
+	clear_cold_data(page);
 	set_page_private(page, 0);
 	ClearPagePrivate(page);
 	return 1;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index af719d93507e8..b414892be08b7 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -772,6 +772,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 		clear_page_dirty_for_io(page);
 		ClearPagePrivate(page);
 		ClearPageUptodate(page);
+		clear_cold_data(page);
 		inode_dec_dirty_pages(dir);
 	}
 	f2fs_put_page(page, 1);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1d5a352138109..c4c84af1ec17a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -227,8 +227,10 @@ static int __revoke_inmem_pages(struct inode *inode,
 		}
 next:
 		/* we don't need to invalidate this in the sccessful status */
-		if (drop || recover)
+		if (drop || recover) {
 			ClearPageUptodate(page);
+			clear_cold_data(page);
+		}
 		set_page_private(page, 0);
 		ClearPagePrivate(page);
 		f2fs_put_page(page, 1);
-- 
2.20.1



