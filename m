Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436AE1B3FEC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgDVKlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgDVKUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0865F20857;
        Wed, 22 Apr 2020 10:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550800;
        bh=zcjOvUCT85bEb9F0JG20QA/GI5+xjX+Y9XXT4eiJ2bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF39WtTm/SsiUfeDvVW6vbM+IIs8TaRQ2LsVpwqdJvbp4TTXdQAcu5B1QGuF0Almz
         0XR/y/dFRJhBbMUpFsCA0sU4Bc49JBIJX4F8WpycdwM8RsES6E4WgVpn9VO9LfgwsD
         W4UEA5PfDE0e1xjlztLHOpu3fWE/9D8OhjbIymUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/118] f2fs: fix to wait all node page writeback
Date:   Wed, 22 Apr 2020 11:57:40 +0200
Message-Id: <20200422095047.482419898@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8b66bc4c004b6..f14401a77d601 100644
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



