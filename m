Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125005A06B8
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbiHYBoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiHYBnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1D9E0D0;
        Wed, 24 Aug 2022 18:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC2061B19;
        Thu, 25 Aug 2022 01:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DB0C433B5;
        Thu, 25 Aug 2022 01:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391566;
        bh=gMMJiU1lK+IhmnC1hxA1k0OZfgqi2aRPzLT4p9qN+/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7nXQBvispsB1P7qimpPpccGDF5p3VR3JHwJmA9KDNU79ZYIuTArA+j1e8QrsVXP+
         rc6Zz7g/Um+9VjUlYvYcmembpAm6ImhaTXYkZTUghi6gEZmqafjZezaw2oxgOdndSS
         Kk1THKXcIFUm+jX+c6nHPWteSDAWoKGBhL5ez0bNrTL/16w5TG5mU7BtaAPpRCXHFy
         gumuMpN0vifs/F+CGJmXgrRqvN7uMN6es8SyAi8D/W+3aix4Zl8ajAQVaCD0EPbuO2
         7+Tk+rXDGdAhKXuc3yzPdfsEBO4fiazkhjUQDUKaucDRIojWidubVzOiFgdIDVQimA
         AuIF6vRShdGiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/11] btrfs: tree-checker: check for overlapping extent items
Date:   Wed, 24 Aug 2022 21:38:31 -0400
Message-Id: <20220825013836.23205-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 32f1b15b25dc..1aadf9a43ef3 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1189,7 +1189,8 @@ static void extent_err(const struct extent_buffer *eb, int slot,
 }
 
 static int check_extent_item(struct extent_buffer *leaf,
-			     struct btrfs_key *key, int slot)
+			     struct btrfs_key *key, int slot,
+			     struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_extent_item *ei;
@@ -1400,6 +1401,26 @@ static int check_extent_item(struct extent_buffer *leaf,
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
 
@@ -1568,7 +1589,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
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

