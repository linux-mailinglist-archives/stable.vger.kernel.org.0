Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D49382FD6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbhEQOVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239238AbhEQOTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230A3613BA;
        Mon, 17 May 2021 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260653;
        bh=unq/C8/LdE9R8x/HBFHQ6WdMUuTSCeadQOLRSnXDmYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEp5/iqRV4DPMQY2bzWjRx7inLfqzh8N9D1KNB4JM9yZUnbVEL6DD2rSFHfv9umVA
         daXTVBk1qSzDPeyFHrwsD/h4L2q0rMRn+5EDiIf8jyiH8sWbHrRR7rBnA1w27XaIhO
         0uAfpwHJ/jqgW5dxIlhqTkmD+CoGlnuKgTY7RXek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhuang <zhuangyi1@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 144/363] f2fs: Fix a hungtask problem in atomic write
Date:   Mon, 17 May 2021 16:00:10 +0200
Message-Id: <20210517140307.482258508@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Zhuang <zhuangyi1@huawei.com>

[ Upstream commit be1ee45d51384161681ecf21085a42d316ae25f7 ]

In the cache writing process, if it is an atomic file, increase the page
count of F2FS_WB_CP_DATA, otherwise increase the page count of
F2FS_WB_DATA.

When you step into the hook branch due to insufficient memory in
f2fs_write_begin, f2fs_drop_inmem_pages_all will be called to traverse
all atomic inodes and clear the FI_ATOMIC_FILE mark of all atomic files.

In f2fs_drop_inmem_pages，first acquire the inmem_lock , revoke all the
inmem_pages, and then clear the FI_ATOMIC_FILE mark. Before this mark is
cleared, other threads may hold inmem_lock to add inmem_pages to the inode
that has just been emptied inmem_pages, and increase the page count of
F2FS_WB_CP_DATA.

When the IO returns, it is found that the FI_ATOMIC_FILE flag is cleared
by f2fs_drop_inmem_pages_all, and f2fs_is_atomic_file returns false,which
causes the page count of F2FS_WB_DATA to be decremented. The page count of
F2FS_WB_CP_DATA cannot be cleared. Finally, hungtask is triggered in
f2fs_wait_on_all_pages because get_pages will never return zero.

process A:				process B:
f2fs_drop_inmem_pages_all
->f2fs_drop_inmem_pages of inode#1
    ->mutex_lock(&fi->inmem_lock)
    ->__revoke_inmem_pages of inode#1	f2fs_ioc_commit_atomic_write
    ->mutex_unlock(&fi->inmem_lock)	->f2fs_commit_inmem_pages of inode#1
					->mutex_lock(&fi->inmem_lock)
					->__f2fs_commit_inmem_pages
					    ->f2fs_do_write_data_page
					        ->f2fs_outplace_write_data
					            ->do_write_page
					                ->f2fs_submit_page_write
					                    ->inc_page_count(sbi, F2FS_WB_CP_DATA )
					->mutex_unlock(&fi->inmem_lock)
    ->spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
    ->clear_inode_flag(inode, FI_ATOMIC_FILE)
    ->spin_unlock(&sbi->inode_lock[ATOMIC_FILE])
					f2fs_write_end_io
					->dec_page_count(sbi, F2FS_WB_DATA );

We can fix the problem by putting the action of clearing the FI_ATOMIC_FILE
mark into the inmem_lock lock. This operation can ensure that no one will
submit the inmem pages before the FI_ATOMIC_FILE mark is cleared, so that
there will be no atomic writes waiting for writeback.

Fixes: 57864ae5ce3a ("f2fs: limit # of inmemory pages")
Signed-off-by: Yi Zhuang <zhuangyi1@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4fba82294a73..d83cb1359e53 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -324,23 +324,27 @@ void f2fs_drop_inmem_pages(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 
-	while (!list_empty(&fi->inmem_pages)) {
+	do {
 		mutex_lock(&fi->inmem_lock);
+		if (list_empty(&fi->inmem_pages)) {
+			fi->i_gc_failures[GC_FAILURE_ATOMIC] = 0;
+
+			spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
+			if (!list_empty(&fi->inmem_ilist))
+				list_del_init(&fi->inmem_ilist);
+			if (f2fs_is_atomic_file(inode)) {
+				clear_inode_flag(inode, FI_ATOMIC_FILE);
+				sbi->atomic_files--;
+			}
+			spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
+
+			mutex_unlock(&fi->inmem_lock);
+			break;
+		}
 		__revoke_inmem_pages(inode, &fi->inmem_pages,
 						true, false, true);
 		mutex_unlock(&fi->inmem_lock);
-	}
-
-	fi->i_gc_failures[GC_FAILURE_ATOMIC] = 0;
-
-	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
-	if (!list_empty(&fi->inmem_ilist))
-		list_del_init(&fi->inmem_ilist);
-	if (f2fs_is_atomic_file(inode)) {
-		clear_inode_flag(inode, FI_ATOMIC_FILE);
-		sbi->atomic_files--;
-	}
-	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
+	} while (1);
 }
 
 void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
-- 
2.30.2



