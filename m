Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142BCA90C6
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390278AbfIDSLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389606AbfIDSLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F702339E;
        Wed,  4 Sep 2019 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620697;
        bh=3rwJ7ku9/cStwdw7IJRzQ1SEy8H0NB+TKPHJlrIlwJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpPP1RMBO+Qmaz9I6t5vKO2E4SjObtdrwp9o1LJQGulapOZbMOdUGPxOH+MGxBHNp
         QQOIRE+TjVDWJxYBnnAF43pzdnjCbLa1GujFSiLS2uECGuzi5hQUGxe4j7Jdati6SR
         ItSs2c+jvmKwq7WLbjB2ynpYOtGBJdXEfXbFvZ1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 020/143] btrfs: trim: Check the range passed into to prevent overflow
Date:   Wed,  4 Sep 2019 19:52:43 +0200
Message-Id: <20190904175314.862538430@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 07301df7d2fc220d3de5f7ad804dcb941400cb00 ]

Normally the range->len is set to default value (U64_MAX), but when it's
not default value, we should check if the range overflows.

And if it overflows, return -EINVAL before doing anything.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5faf057f6f37f..b8f4720879021 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11226,6 +11226,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	struct btrfs_device *device;
 	struct list_head *devices;
 	u64 group_trimmed;
+	u64 range_end = U64_MAX;
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
@@ -11235,16 +11236,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	int dev_ret = 0;
 	int ret = 0;
 
+	/*
+	 * Check range overflow if range->len is set.
+	 * The default range->len is U64_MAX.
+	 */
+	if (range->len != U64_MAX &&
+	    check_add_overflow(range->start, range->len, &range_end))
+		return -EINVAL;
+
 	cache = btrfs_lookup_first_block_group(fs_info, range->start);
 	for (; cache; cache = next_block_group(cache)) {
-		if (cache->key.objectid >= (range->start + range->len)) {
+		if (cache->key.objectid >= range_end) {
 			btrfs_put_block_group(cache);
 			break;
 		}
 
 		start = max(range->start, cache->key.objectid);
-		end = min(range->start + range->len,
-				cache->key.objectid + cache->key.offset);
+		end = min(range_end, cache->key.objectid + cache->key.offset);
 
 		if (end - start >= range->minlen) {
 			if (!block_group_cache_done(cache)) {
-- 
2.20.1



