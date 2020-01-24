Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78581482ED
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404384AbgAXLb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404379AbgAXLb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D82C20704;
        Fri, 24 Jan 2020 11:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865517;
        bh=BFxPDms5yKbomNcoOwzn5T8TnE2bM7xhqFfMO2HqoM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ5PMgLHFVw7ApxG/Ysg8kgkKhaRWZ+NqFKWZ4APoUxscM3Q1mj5e0uD7k5UpHx58
         klHaFGu0y1y7Y/VdQUKzvC6GwRHaYiA6KxnQXRyJc7x8TNIqVYFhUL+HfDrUoE7xek
         /b3C8W3UbXKzUN1nbgtFGtSJLsdMtGiiVoRYKzP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 567/639] f2fs: fix to avoid accessing uninitialized field of inode page in is_alive()
Date:   Fri, 24 Jan 2020 10:32:17 +0100
Message-Id: <20200124093200.381226008@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0d3d848d186b9..ebe19894884be 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -572,6 +572,11 @@ add_dentry:
 
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
index 3fe0dd5313903..c1ba29d10789d 100644
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



