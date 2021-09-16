Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9960240E2BE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244133AbhIPQlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244489AbhIPQjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71591619F5;
        Thu, 16 Sep 2021 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809380;
        bh=oSF4S3CTDgEgFEs4mTPb5cHmLiOozTKjmUXB/FL2zEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXFWhdA+u85quEjc5M7O/b9o30HVzynFZjgBysipkpwgYAgIr19CGK6uwtM/QBgYo
         vH8icoy3ryrPX33Q39hA9wwGb54JY26JfNlfJBaY448mNyGOg35tMW/KLgEY43ukEj
         3e2eFue5E9EIcvE/PnB6O1c3tPJ6JoPjvT6M+z0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 133/380] f2fs: fix to unmap pages from userspace process in punch_hole()
Date:   Thu, 16 Sep 2021 17:58:10 +0200
Message-Id: <20210916155808.561604472@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index fb27d49e4da7..3a11e81fdf65 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1086,7 +1086,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		if (pg_start < pg_end) {
-			struct address_space *mapping = inode->i_mapping;
 			loff_t blk_start, blk_end;
 			struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
@@ -1098,8 +1097,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 			down_write(&F2FS_I(inode)->i_mmap_sem);
 
-			truncate_inode_pages_range(mapping, blk_start,
-					blk_end - 1);
+			truncate_pagecache_range(inode, blk_start, blk_end - 1);
 
 			f2fs_lock_op(sbi);
 			ret = f2fs_truncate_hole(inode, pg_start, pg_end);
-- 
2.30.2



