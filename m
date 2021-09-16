Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFE40DF97
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhIPQLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233599AbhIPQJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74B861361;
        Thu, 16 Sep 2021 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808493;
        bh=1wQoxymKe5+8ox3pj2UmRtrzTKZejCj9yDewLMQIuQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaObthDb1W7FwnD4qh1oIsemr+7PG1xxXle8Anet7wFiPWhO/fTikJw/SU9ZeCB7R
         9hAogblfug3cWPWyiIUhh4sMewn7/kj9o3CKmB7bZ5QqCvhD25a6SvJySn0VcvwNXf
         ffujFngifxbNEZqN/OCsx3VwvnnYFDxiK3AczK00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/306] f2fs: fix to unmap pages from userspace process in punch_hole()
Date:   Thu, 16 Sep 2021 17:57:29 +0200
Message-Id: <20210916155757.616265230@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit c8dc3047c48540183744f959412d44b08c5435e1 ]

We need to unmap pages from userspace process before removing pagecache
in punch_hole() like we did in f2fs_setattr().

Similar change:
commit 5e44f8c374dc ("ext4: hole-punch use truncate_pagecache_range")

Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6ee8b1e0e174..1fbaab1f7aba 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1080,7 +1080,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		if (pg_start < pg_end) {
-			struct address_space *mapping = inode->i_mapping;
 			loff_t blk_start, blk_end;
 			struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
@@ -1092,8 +1091,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 			down_write(&F2FS_I(inode)->i_mmap_sem);
 
-			truncate_inode_pages_range(mapping, blk_start,
-					blk_end - 1);
+			truncate_pagecache_range(inode, blk_start, blk_end - 1);
 
 			f2fs_lock_op(sbi);
 			ret = f2fs_truncate_hole(inode, pg_start, pg_end);
-- 
2.30.2



