Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B64328842
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhCARhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236483AbhCAR3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E78965096;
        Mon,  1 Mar 2021 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617539;
        bh=f9GQficVXPduAOkfpth9PBryVzldvHmd8cvgCsowEfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5q5GfSOtJLEaYF/7/WR/wesWTZwGLXrtWPMvEsmWjliOmN6Hoj7bME27NlWXgrtH
         b8uGMfCH4HgptK4Qpfp2cZ8OJzxQBhF0KSCZfksWjPDsLrYmaIHpWciGMq6zfjQNsm
         I4rP6c57NKXlwl8+qqAOVTBGAV+/0MyeFWPq5f+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daiyue Zhang <zhangdaiyue1@huawei.com>,
        Dehe Gu <gudehe@huawei.com>,
        Junchao Jiang <jiangjunchao1@huawei.com>,
        Ge Qiu <qiuge@huawei.com>, Yi Chen <chenyi77@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/340] f2fs: fix to avoid inconsistent quota data
Date:   Mon,  1 Mar 2021 17:10:54 +0100
Message-Id: <20210301161053.748832880@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 5d94abe467a4f..6273a8768081e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -686,6 +686,10 @@ int f2fs_truncate(struct inode *inode)
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
index 183388393c6a8..cbd17e4ff920c 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -189,6 +189,10 @@ int f2fs_convert_inline_inode(struct inode *inode)
 	if (!f2fs_has_inline_data(inode))
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



