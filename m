Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA9138017
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgAKKZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgAKKZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:44 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE0920848;
        Sat, 11 Jan 2020 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738344;
        bh=gFGpe93+udtJL3IRuqv7gvEvTZ38Dbi175XlBDXH+/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmIpYRno8ymqITYFNeNOg3YFdLWIsaa16VzC6vE7+cflFpyx+8War1g2idhRtLwUz
         N/ow4tdib/8Z4CM9ldiO8Anddp6RGFiQNxEmwnxyUIyQQo1uyt9Mw40fxPYPhA5bSP
         N1cY1CrB1D03C1kSlf2IaamBkukRoCrjq9/Zr8AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/165] btrfs: handle error in btrfs_cache_block_group
Date:   Sat, 11 Jan 2020 10:49:56 +0100
Message-Id: <20200111094927.634167726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eb95ed78a18e..dc50605ecbda 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3781,6 +3781,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				u64 flags, int delalloc)
 {
 	int ret = 0;
+	int cache_block_group_error = 0;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct find_free_extent_ctl ffe_ctl = {0};
@@ -3940,7 +3941,20 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
 
@@ -4027,7 +4041,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	if (ret > 0)
 		goto search;
 
-	if (ret == -ENOSPC) {
+	if (ret == -ENOSPC && !cache_block_group_error) {
 		/*
 		 * Use ffe_ctl->total_free_space as fallback if we can't find
 		 * any contiguous hole.
@@ -4038,6 +4052,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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



