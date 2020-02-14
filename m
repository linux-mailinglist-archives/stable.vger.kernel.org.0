Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8577115DE18
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389245AbgBNQCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388346AbgBNQCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A94E2187F;
        Fri, 14 Feb 2020 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696126;
        bh=TIlAmDaKuKNXe97gekocfkoxJrftjK9We8gokKkrcl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2epvvdTOxggURQqL6h4d3pBgBNfVbrTixNZf7RBnRvA5vsB30QrdaUoJmSvfF3os
         NnQOEx+t1ASvQibgQ0jSjMw7Rp4RuRzlBD8V+5jlMWAiBlmYtiHjdnfCRrI2lTMISN
         kR8SF5z7CC3Hwfrz0PVQavJWcOIaq3cUkFsJ22sA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 012/459] f2fs: call f2fs_balance_fs outside of locked page
Date:   Fri, 14 Feb 2020 10:54:22 -0500
Message-Id: <20200214160149.11681-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit bdf03299248916640a835a05d32841bb3d31912d ]

Otherwise, we can hit deadlock by waiting for the locked page in
move_data_block in GC.

 Thread A                     Thread B
 - do_page_mkwrite
  - f2fs_vm_page_mkwrite
   - lock_page
                              - f2fs_balance_fs
                                  - mutex_lock(gc_mutex)
                               - f2fs_gc
                                - do_garbage_collect
                                 - ra_data_block
                                  - grab_cache_page
   - f2fs_balance_fs
    - mutex_lock(gc_mutex)

Fixes: 39a8695824510 ("f2fs: refactor ->page_mkwrite() flow")
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 44bc5f4a9ce19..c3a9da79ac997 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -50,7 +50,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct dnode_of_data dn = { .node_changed = false };
+	struct dnode_of_data dn;
 	int err;
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -63,6 +63,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 		goto err;
 	}
 
+	/* should do out of any locked page */
+	f2fs_balance_fs(sbi, true);
+
 	sb_start_pagefault(inode->i_sb);
 
 	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
@@ -120,8 +123,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 out_sem:
 	up_read(&F2FS_I(inode)->i_mmap_sem);
 
-	f2fs_balance_fs(sbi, dn.node_changed);
-
 	sb_end_pagefault(inode->i_sb);
 err:
 	return block_page_mkwrite_return(err);
-- 
2.20.1

