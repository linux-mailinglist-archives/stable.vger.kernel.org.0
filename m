Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCE1A9CFD
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897442AbgDOLmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897228AbgDOLhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57DE921582;
        Wed, 15 Apr 2020 11:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950638;
        bh=a+GnE5fjJanhytnMSWobgz08WY8xeM5hUkfKKeBAIG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqplRrVd1IEWbUhNR05uRalj1WI7lJztrB7D0vCxY4XVT02EropWz0iE6rxrrudcu
         thZeCjvJr4yndyhkm4Uje8IoeRp+HmONrbtWAhIPGR34FLog49DvC1eADrjlK98GxD
         ls82uo7+XuHcK18NWts+OfCHDM6q/QEjzKhvONII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.6 128/129] f2fs: fix to wait all node page writeback
Date:   Wed, 15 Apr 2020 07:34:43 -0400
Message-Id: <20200415113445.11881-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit dc5a941223edd803f476a153abd950cc3a83c3e1 ]

There is a race condition that we may miss to wait for all node pages
writeback, fix it.

- fsync()				- shrink
 - f2fs_do_sync_file
					 - __write_node_page
					  - set_page_writeback(page#0)
					  : remove DIRTY/TOWRITE flag
  - f2fs_fsync_node_pages
  : won't find page #0 as TOWRITE flag was removeD
  - f2fs_wait_on_node_pages_writeback
  : wont' wait page #0 writeback as it was not in fsync_node_list list.
					   - f2fs_add_fsync_node_entry

Fixes: 50fa53eccf9f ("f2fs: fix to avoid broken of dnode block list")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9d02cdcdbb073..e58c4c6288346 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1562,15 +1562,16 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 	if (atomic && !test_opt(sbi, NOBARRIER))
 		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
 
-	set_page_writeback(page);
-	ClearPageError(page);
-
+	/* should add to global list before clearing PAGECACHE status */
 	if (f2fs_in_warm_node_list(sbi, page)) {
 		seq = f2fs_add_fsync_node_entry(sbi, page);
 		if (seq_id)
 			*seq_id = seq;
 	}
 
+	set_page_writeback(page);
+	ClearPageError(page);
+
 	fio.old_blkaddr = ni.blk_addr;
 	f2fs_do_write_node_page(nid, &fio);
 	set_node_addr(sbi, &ni, fio.new_blkaddr, is_fsync_dnode(page));
-- 
2.20.1

