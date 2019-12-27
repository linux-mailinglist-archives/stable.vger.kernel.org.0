Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9884C12B811
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfL0RxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbfL0Rmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCD121582;
        Fri, 27 Dec 2019 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468572;
        bh=6vZo0/a/kuflm0kBrVLyo8mMTul4k1bx6ud3tQqFMdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9/N6Wb/jXGTn304ho/LQNwfXyoywTiQ7J3ruWW9Otfmhnv4XXKpFRF3HG9D1L/ml
         /XKsyaCi41zFgHXTTULP5j+yH65tjkgklzgolHojMV6bWUitoun/h9fgBW2J1Eida+
         8FSrht0hrv4uBSABA2ctlUszVjPH7g/0K6GHjdz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 097/187] btrfs: handle error in btrfs_cache_block_group
Date:   Fri, 27 Dec 2019 12:39:25 -0500
Message-Id: <20191227174055.4923-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit db8fe64f9ce61d1d89d3c3c34d111a43afb9f053 ]

We have a BUG_ON(ret < 0) in find_free_extent from
btrfs_cache_block_group.  If we fail to allocate our ctl we'll just
panic, which is not good.  Instead just go on to another block group.
If we fail to find a block group we don't want to return ENOSPC, because
really we got a ENOMEM and that's the root of the problem.  Save our
return from btrfs_cache_block_group(), and then if we still fail to make
our allocation return that ret so we get the right error back.

Tested with inject-error.py from bcc.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 49cb26fa7c63..9ee6a6e55e4e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3780,6 +3780,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				u64 flags, int delalloc)
 {
 	int ret = 0;
+	int cache_block_group_error = 0;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct find_free_extent_ctl ffe_ctl = {0};
@@ -3939,7 +3940,20 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		if (unlikely(!ffe_ctl.cached)) {
 			ffe_ctl.have_caching_bg = true;
 			ret = btrfs_cache_block_group(block_group, 0);
-			BUG_ON(ret < 0);
+
+			/*
+			 * If we get ENOMEM here or something else we want to
+			 * try other block groups, because it may not be fatal.
+			 * However if we can't find anything else we need to
+			 * save our return here so that we return the actual
+			 * error that caused problems, not ENOSPC.
+			 */
+			if (ret < 0) {
+				if (!cache_block_group_error)
+					cache_block_group_error = ret;
+				ret = 0;
+				goto loop;
+			}
 			ret = 0;
 		}
 
@@ -4026,7 +4040,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	if (ret > 0)
 		goto search;
 
-	if (ret == -ENOSPC) {
+	if (ret == -ENOSPC && !cache_block_group_error) {
 		/*
 		 * Use ffe_ctl->total_free_space as fallback if we can't find
 		 * any contiguous hole.
@@ -4037,6 +4051,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		space_info->max_extent_size = ffe_ctl.max_extent_size;
 		spin_unlock(&space_info->lock);
 		ins->offset = ffe_ctl.max_extent_size;
+	} else if (ret == -ENOSPC) {
+		ret = cache_block_group_error;
 	}
 	return ret;
 }
-- 
2.20.1

