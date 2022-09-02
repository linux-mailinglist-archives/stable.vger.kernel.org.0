Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48FF5AB198
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbiIBNhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236934AbiIBNgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:36:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FCFC0E61;
        Fri,  2 Sep 2022 06:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0753D621B3;
        Fri,  2 Sep 2022 12:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B11BC43140;
        Fri,  2 Sep 2022 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122081;
        bh=FadrqUdVsz2jlLOfSCllylWQHjBpsfMwpCQB/vkl2lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/xyY4VuatCgkVbNd7d6yxonhBvE/YJOPh3Njproj27lOVOdsLGOD453QPLh3A73l
         YOT/DRAZr84uI0YNwerPRokm28YiK3MYeg2BgOslqQRxIErXluF3l/3x8QZ8mkWJg7
         BpKdvF//qSGipGDAgguaA9mBK8g+v1yZbsT6LdAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/73] btrfs: tree-checker: check for overlapping extent items
Date:   Fri,  2 Sep 2022 14:19:32 +0200
Message-Id: <20220902121406.640584762@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 899b7f69f244e539ea5df1b4d756046337de44a5 ]

We're seeing a weird problem in production where we have overlapping
extent items in the extent tree.  It's unclear where these are coming
from, and in debugging we realized there's no check in the tree checker
for this sort of problem.  Add a check to the tree-checker to make sure
that the extents do not overlap each other.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 51382d2be3d44..a84d2d4895104 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1216,7 +1216,8 @@ static void extent_err(const struct extent_buffer *eb, int slot,
 }
 
 static int check_extent_item(struct extent_buffer *leaf,
-			     struct btrfs_key *key, int slot)
+			     struct btrfs_key *key, int slot,
+			     struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_extent_item *ei;
@@ -1436,6 +1437,26 @@ static int check_extent_item(struct extent_buffer *leaf,
 			   total_refs, inline_refs);
 		return -EUCLEAN;
 	}
+
+	if ((prev_key->type == BTRFS_EXTENT_ITEM_KEY) ||
+	    (prev_key->type == BTRFS_METADATA_ITEM_KEY)) {
+		u64 prev_end = prev_key->objectid;
+
+		if (prev_key->type == BTRFS_METADATA_ITEM_KEY)
+			prev_end += fs_info->nodesize;
+		else
+			prev_end += prev_key->offset;
+
+		if (unlikely(prev_end > key->objectid)) {
+			extent_err(leaf, slot,
+	"previous extent [%llu %u %llu] overlaps current extent [%llu %u %llu]",
+				   prev_key->objectid, prev_key->type,
+				   prev_key->offset, key->objectid, key->type,
+				   key->offset);
+			return -EUCLEAN;
+		}
+	}
+
 	return 0;
 }
 
@@ -1604,7 +1625,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
-		ret = check_extent_item(leaf, key, slot);
+		ret = check_extent_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_TREE_BLOCK_REF_KEY:
 	case BTRFS_SHARED_DATA_REF_KEY:
-- 
2.35.1



