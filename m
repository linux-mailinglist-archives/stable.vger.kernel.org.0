Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17124ABC3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHTABe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgHTAB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62190207FB;
        Thu, 20 Aug 2020 00:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881688;
        bh=Y+kpkmPLL8WjooRROXARVVZ8iA84IVdF6B0u8hywCAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZqPtsZYJlwjziUt8SDt7GU27LTo68VY2dgYLGQnEIONFmzkzwoAdIrhUDfstGXYa
         SXjVs5jU9p0wkI5HCECm0mWyqJkjVcBXlWfnCCLR5RDdT73kK1STLf97zpG772Q2BY
         RnrMjv4tEoBzWO2ZQK3rdetabOVcK3bbR9Zp5iA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Zhiguo Niu <Zhiguo.Niu@unisoc.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 08/27] f2fs: should avoid inode eviction in synchronous path
Date:   Wed, 19 Aug 2020 20:00:57 -0400
Message-Id: <20200820000116.214821-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit b0f3b87fb3abc42c81d76c6c5795f26dbdb2f04b ]

https://bugzilla.kernel.org/show_bug.cgi?id=208565

PID: 257    TASK: ecdd0000  CPU: 0   COMMAND: "init"
  #0 [<c0b420ec>] (__schedule) from [<c0b423c8>]
  #1 [<c0b423c8>] (schedule) from [<c0b459d4>]
  #2 [<c0b459d4>] (rwsem_down_read_failed) from [<c0b44fa0>]
  #3 [<c0b44fa0>] (down_read) from [<c044233c>]
  #4 [<c044233c>] (f2fs_truncate_blocks) from [<c0442890>]
  #5 [<c0442890>] (f2fs_truncate) from [<c044d408>]
  #6 [<c044d408>] (f2fs_evict_inode) from [<c030be18>]
  #7 [<c030be18>] (evict) from [<c030a558>]
  #8 [<c030a558>] (iput) from [<c047c600>]
  #9 [<c047c600>] (f2fs_sync_node_pages) from [<c0465414>]
 #10 [<c0465414>] (f2fs_write_checkpoint) from [<c04575f4>]
 #11 [<c04575f4>] (f2fs_sync_fs) from [<c0441918>]
 #12 [<c0441918>] (f2fs_do_sync_file) from [<c0441098>]
 #13 [<c0441098>] (f2fs_sync_file) from [<c0323fa0>]
 #14 [<c0323fa0>] (vfs_fsync_range) from [<c0324294>]
 #15 [<c0324294>] (do_fsync) from [<c0324014>]
 #16 [<c0324014>] (sys_fsync) from [<c0108bc0>]

This can be caused by flush_dirty_inode() in f2fs_sync_node_pages() where
iput() requires f2fs_lock_op() again resulting in livelock.

Reported-by: Zhiguo Niu <Zhiguo.Niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 03e24df1c84f5..e61ce7fb0958b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1924,8 +1924,12 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 				goto continue_unlock;
 			}
 
-			/* flush inline_data, if it's async context. */
-			if (do_balance && is_inline_node(page)) {
+			/* flush inline_data/inode, if it's async context. */
+			if (!do_balance)
+				goto write_node;
+
+			/* flush inline_data */
+			if (is_inline_node(page)) {
 				clear_inline_node(page);
 				unlock_page(page);
 				flush_inline_data(sbi, ino_of_node(page));
@@ -1938,7 +1942,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 				if (flush_dirty_inode(page))
 					goto lock_node;
 			}
-
+write_node:
 			f2fs_wait_on_page_writeback(page, NODE, true, true);
 
 			if (!clear_page_dirty_for_io(page))
-- 
2.25.1

