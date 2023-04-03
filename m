Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520FA6D4A48
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjDCOpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbjDCOpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A58F280E8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3016CCE12FE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5952C433EF;
        Mon,  3 Apr 2023 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533116;
        bh=0wS+w36jWJx84STgq0Sz5pn2XKoslqTYnWAjIUioGs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AEuWbBBd37m+GPqepk14TizBQ1BxzM+QoossQT2gMG3Lp1cKTf3ypsftd4R5ITPc
         UUnFs6Fqn4AaImuSCbwAYeeykWAyjaD/Y97T9QmMxOmcBLWVQf0McMQ0+BCdPiz1LI
         jA5TUynb34RYhrnqBwXHEhUxpKefGnIKWnuPH2Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 061/187] btrfs: use temporary variable for space_info in btrfs_update_block_group
Date:   Mon,  3 Apr 2023 16:08:26 +0200
Message-Id: <20230403140417.967972221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit df384da5a49cace5c5e3100803dfd563fd982f93 ]

We do

  cache->space_info->counter += num_bytes;

everywhere in here.  This is makes the lines longer than they need to
be, and will be especially noticeable when we add the active tracking in,
so add a temp variable for the space_info so this is cleaner.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index f40e56d44276d..c70a888bf8bf6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3336,6 +3336,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&info->delalloc_root_lock);
 
 	while (total) {
+		struct btrfs_space_info *space_info;
 		bool reclaim = false;
 
 		cache = btrfs_lookup_block_group(info, bytenr);
@@ -3343,6 +3344,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			ret = -ENOENT;
 			break;
 		}
+		space_info = cache->space_info;
 		factor = btrfs_bg_type_to_factor(cache->flags);
 
 		/*
@@ -3357,7 +3359,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		byte_in_group = bytenr - cache->start;
 		WARN_ON(byte_in_group > cache->length);
 
-		spin_lock(&cache->space_info->lock);
+		spin_lock(&space_info->lock);
 		spin_lock(&cache->lock);
 
 		if (btrfs_test_opt(info, SPACE_CACHE) &&
@@ -3370,23 +3372,23 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			old_val += num_bytes;
 			cache->used = old_val;
 			cache->reserved -= num_bytes;
-			cache->space_info->bytes_reserved -= num_bytes;
-			cache->space_info->bytes_used += num_bytes;
-			cache->space_info->disk_used += num_bytes * factor;
+			space_info->bytes_reserved -= num_bytes;
+			space_info->bytes_used += num_bytes;
+			space_info->disk_used += num_bytes * factor;
 			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
+			spin_unlock(&space_info->lock);
 		} else {
 			old_val -= num_bytes;
 			cache->used = old_val;
 			cache->pinned += num_bytes;
-			btrfs_space_info_update_bytes_pinned(info,
-					cache->space_info, num_bytes);
-			cache->space_info->bytes_used -= num_bytes;
-			cache->space_info->disk_used -= num_bytes * factor;
+			btrfs_space_info_update_bytes_pinned(info, space_info,
+							     num_bytes);
+			space_info->bytes_used -= num_bytes;
+			space_info->disk_used -= num_bytes * factor;
 
 			reclaim = should_reclaim_block_group(cache, num_bytes);
 			spin_unlock(&cache->lock);
-			spin_unlock(&cache->space_info->lock);
+			spin_unlock(&space_info->lock);
 
 			set_extent_dirty(&trans->transaction->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
-- 
2.39.2



