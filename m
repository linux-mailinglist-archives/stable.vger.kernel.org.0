Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA70D13F320
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390361AbgAPRL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:11:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390358AbgAPRL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5925524696;
        Thu, 16 Jan 2020 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194718;
        bh=82bJvPDnc5G4xgw16Uc87CO0wdYNO9sE+vaqbaDhJas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pupw2R84sojUTP7T7avYluQoBBQnbTfUyrWIqKu2FWTD4nvP63safLWrdITKm10w3
         brlbqVY29cX2Pbkc2X+5OYLJWKJ+vY0IcIiuJEm79Ea/qTYbHNhddg5LfY4huaSehD
         gn6uPjHAaW475k6M/KvoDWf19LGnESgmk8oWqFwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 554/671] f2fs: fix to avoid accessing uninitialized field of inode page in is_alive()
Date:   Thu, 16 Jan 2020 12:03:12 -0500
Message-Id: <20200116170509.12787-291-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 98194030554cd9b10568a9b58f5a135c7e7cba85 ]

If inode is newly created, inode page may not synchronize with inode cache,
so fields like .i_inline or .i_extra_isize could be wrong, in below call
path, we may access such wrong fields, result in failing to migrate valid
target block.

Thread A				Thread B
- f2fs_create
 - f2fs_add_link
  - f2fs_add_dentry
   - f2fs_init_inode_metadata
    - f2fs_add_inline_entry
     - f2fs_new_inode_page
     - f2fs_put_page
     : inode page wasn't updated with inode cache
					- gc_data_segment
					 - is_alive
					  - f2fs_get_node_page
					  - datablock_addr
					   - offset_in_addr
					   : access uninitialized fields

Fixes: 7a2af766af15 ("f2fs: enhance on-disk inode structure scalability")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c    | 5 +++++
 fs/f2fs/inline.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index cd611a57d04d..8692cfa89a1c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -572,6 +572,11 @@ int f2fs_add_regular_entry(struct inode *dir, const struct qstr *new_name,
 
 	if (inode) {
 		f2fs_i_pino_write(inode, dir->i_ino);
+
+		/* synchronize inode page's data from inode cache */
+		if (is_inode_flag_set(inode, FI_NEW_INODE))
+			f2fs_update_inode(inode, page);
+
 		f2fs_put_page(page, 1);
 	}
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3fe0dd531390..c1ba29d10789 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -578,6 +578,11 @@ int f2fs_add_inline_entry(struct inode *dir, const struct qstr *new_name,
 	/* we don't need to mark_inode_dirty now */
 	if (inode) {
 		f2fs_i_pino_write(inode, dir->i_ino);
+
+		/* synchronize inode page's data from inode cache */
+		if (is_inode_flag_set(inode, FI_NEW_INODE))
+			f2fs_update_inode(inode, page);
+
 		f2fs_put_page(page, 1);
 	}
 
-- 
2.20.1

