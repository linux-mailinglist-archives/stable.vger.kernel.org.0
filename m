Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4DA328A6E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbhCASRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239158AbhCASJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D1165354;
        Mon,  1 Mar 2021 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620716;
        bh=JOozNtyNU1/vGxy+lsonr+xKgbO4Qv/tYSWyICzXMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA76jlZ0C0VToNV8RAeFK5GV5EutJ0niOqvE1KDB+OIQMyuK8n/2HRJZD4F7tOhTN
         6dGlspnGKdHbXzh8/i+ABE1+DKX0BWf+uXc4ydx950z+S4+5M0LzJxoSU2SC08o/A0
         yodYjiYI2tz5UjQAwpPZcFbg3M0UOyTpwVkowCs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daiyue Zhang <zhangdaiyue1@huawei.com>,
        Dehe Gu <gudehe@huawei.com>,
        Junchao Jiang <jiangjunchao1@huawei.com>,
        Ge Qiu <qiuge@huawei.com>, Yi Chen <chenyi77@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 253/775] f2fs: fix to avoid inconsistent quota data
Date:   Mon,  1 Mar 2021 17:07:01 +0100
Message-Id: <20210301161214.133837584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Chen <chenyi77@huawei.com>

[ Upstream commit 25fb04dbce6a0e165d28fd1fa8a1d7018c637fe8 ]

Occasionally, quota data may be corrupted detected by fsck:

Info: checkpoint state = 45 :  crc compacted_summary unmount
[QUOTA WARNING] Usage inconsistent for ID 0:actual (1543036928, 762) != expected (1543032832, 762)
[ASSERT] (fsck_chk_quota_files:1986)  --> Quota file is missing or invalid quota file content found.
[QUOTA WARNING] Usage inconsistent for ID 0:actual (1352478720, 344) != expected (1352474624, 344)
[ASSERT] (fsck_chk_quota_files:1986)  --> Quota file is missing or invalid quota file content found.

[FSCK] Unreachable nat entries                        [Ok..] [0x0]
[FSCK] SIT valid block bitmap checking                [Ok..]
[FSCK] Hard link checking for regular file            [Ok..] [0x0]
[FSCK] valid_block_count matching with CP             [Ok..] [0xdf299]
[FSCK] valid_node_count matcing with CP (de lookup)   [Ok..] [0x2b01]
[FSCK] valid_node_count matcing with CP (nat lookup)  [Ok..] [0x2b01]
[FSCK] valid_inode_count matched with CP              [Ok..] [0x2665]
[FSCK] free segment_count matched with CP             [Ok..] [0xcb04]
[FSCK] next block offset is free                      [Ok..]
[FSCK] fixing SIT types
[FSCK] other corrupted bugs                           [Fail]

The root cause is:
If we open file w/ readonly flag, disk quota info won't be initialized
for this file, however, following mmap() will force to convert inline
inode via f2fs_convert_inline_inode(), which may increase block usage
for this inode w/o updating quota data, it causes inconsistent disk quota
info.

The issue will happen in following stack:
open(file, O_RDONLY)
mmap(file)
- f2fs_convert_inline_inode
 - f2fs_convert_inline_page
  - f2fs_reserve_block
   - f2fs_reserve_new_block
    - f2fs_reserve_new_blocks
     - f2fs_i_blocks_write
      - dquot_claim_block
inode->i_blocks increase, but the dqb_curspace keep the size for the dquots
is NULL.

To fix this issue, let's call dquot_initialize() anyway in both
f2fs_truncate() and f2fs_convert_inline_inode() functions to avoid potential
inconsistent quota data issue.

Fixes: 0abd675e97e6 ("f2fs: support plain user/group quota")
Signed-off-by: Daiyue Zhang <zhangdaiyue1@huawei.com>
Signed-off-by: Dehe Gu <gudehe@huawei.com>
Signed-off-by: Junchao Jiang <jiangjunchao1@huawei.com>
Signed-off-by: Ge Qiu <qiuge@huawei.com>
Signed-off-by: Yi Chen <chenyi77@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c   | 4 ++++
 fs/f2fs/inline.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index cd62b0d3369ab..18ea529ef5ea0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -767,6 +767,10 @@ int f2fs_truncate(struct inode *inode)
 		return -EIO;
 	}
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	/* we should check inline_data size */
 	if (!f2fs_may_inline_data(inode)) {
 		err = f2fs_convert_inline_inode(inode);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 806ebabf58706..993caefcd2bb0 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -192,6 +192,10 @@ int f2fs_convert_inline_inode(struct inode *inode)
 			f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
 		return 0;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	page = f2fs_grab_cache_page(inode->i_mapping, 0, false);
 	if (!page)
 		return -ENOMEM;
-- 
2.27.0



