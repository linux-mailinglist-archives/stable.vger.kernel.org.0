Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1D1611DC
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgBQMRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 07:17:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10629 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726932AbgBQMRY (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 17 Feb 2020 07:17:24 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BFA8EB09D511E23A9159;
        Mon, 17 Feb 2020 20:17:21 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Feb 2020
 20:17:13 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <richard@nod.at>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>, <yi.zhang@huawei.com>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <Stable@vger.kernel.org>
Subject: [PATCH 4.4] ubifs: Fix deadlock in concurrent bulk-read and writepage
Date:   Mon, 17 Feb 2020 20:23:59 +0800
Message-ID: <1581942239-112920-1-git-send-email-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2 ]

In ubifs, concurrent execution of writepage and bulk read on the same file
may cause ABBA deadlock, for example (Reproduce method see Link):

Process A(Bulk-read starts from page4)         Process B(write page4 back)
  vfs_read                                       wb_workfn or fsync
  ...                                            ...
  generic_file_buffered_read                     write_cache_pages
    ubifs_readpage                                 LOCK(page4)

      ubifs_bulk_read                              ubifs_writepage
        LOCK(ui->ui_mutex)                           ubifs_write_inode

	  ubifs_do_bulk_read                           LOCK(ui->ui_mutex)
	    find_or_create_page(alloc page4)                  ↑
	      LOCK(page4)                   <--     ABBA deadlock occurs!

In order to ensure the serialization execution of bulk read, we can't
remove the big lock 'ui->ui_mutex' in ubifs_bulk_read(). Instead, we
allow ubifs_do_bulk_read() to lock page failed by replacing
find_or_create_page(FGP_LOCK) with
pagecache_get_page(FGP_LOCK | FGP_NOWAIT).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: <Stable@vger.kernel.org>
Fixes: 4793e7c5e1c ("UBIFS: add bulk-read facility")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206153
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b895af7d8d80..e6d0a7df341d 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -782,8 +782,9 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 
 		if (page_offset > end_index)
 			break;
-		page = find_or_create_page(mapping, page_offset,
-					   GFP_NOFS | __GFP_COLD);
+		page = pagecache_get_page(mapping, page_offset,
+				 FGP_LOCK|FGP_ACCESSED|FGP_CREAT|FGP_NOWAIT,
+				 GFP_NOFS | __GFP_COLD);
 		if (!page)
 			break;
 		if (!PageUptodate(page))
-- 
2.7.4

