Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0E6BAABC
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbfIVTaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392159AbfIVStQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8F0208C2;
        Sun, 22 Sep 2019 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178156;
        bh=tnJUdGvdGG0/Hb6exXH5DQf1GWv+G6e1JVUW/HKVA+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aayl4yLqFFj7OGtvScIZ4WD0WIHFpPE1eTPie1eOAceNqZG6wOMKO9yZG+smO/KWS
         H58bhhQFVqC8PoOHr3Bangv0NwvESi6faTaQlxXNMEDywY7N8K8LagArdkumBscvJX
         sD4b67PVybvNuosRdFNpXjZ4JjJpS6909TJo78q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Jungyeon Yoon <jungyeon.yoon@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 201/203] btrfs: tree-checker: Add ROOT_ITEM check
Date:   Sun, 22 Sep 2019 14:43:47 -0400
Message-Id: <20190922184350.30563-201-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 259ee7754b6793af8bdd77f9ca818bc41cfe9541 ]

This patch will introduce ROOT_ITEM check, which includes:
- Key->objectid and key->offset check
  Currently only some easy check, e.g. 0 as rootid is invalid.

- Item size check
  Root item size is fixed.

- Generation checks
  Generation, generation_v2 and last_snapshot should not be greater than
  super generation + 1

- Level and alignment check
  Level should be in [0, 7], and bytenr must be aligned to sector size.

- Flags check

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203261
Reported-by: Jungyeon Yoon <jungyeon.yoon@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 92 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ccd5706199d76..d83adda6c090a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -821,6 +821,95 @@ static int check_inode_item(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
+			   int slot)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	struct btrfs_root_item ri;
+	const u64 valid_root_flags = BTRFS_ROOT_SUBVOL_RDONLY |
+				     BTRFS_ROOT_SUBVOL_DEAD;
+
+	/* No such tree id */
+	if (key->objectid == 0) {
+		generic_err(leaf, slot, "invalid root id 0");
+		return -EUCLEAN;
+	}
+
+	/*
+	 * Some older kernel may create ROOT_ITEM with non-zero offset, so here
+	 * we only check offset for reloc tree whose key->offset must be a
+	 * valid tree.
+	 */
+	if (key->objectid == BTRFS_TREE_RELOC_OBJECTID && key->offset == 0) {
+		generic_err(leaf, slot, "invalid root id 0 for reloc tree");
+		return -EUCLEAN;
+	}
+
+	if (btrfs_item_size_nr(leaf, slot) != sizeof(ri)) {
+		generic_err(leaf, slot,
+			    "invalid root item size, have %u expect %zu",
+			    btrfs_item_size_nr(leaf, slot), sizeof(ri));
+	}
+
+	read_extent_buffer(leaf, &ri, btrfs_item_ptr_offset(leaf, slot),
+			   sizeof(ri));
+
+	/* Generation related */
+	if (btrfs_root_generation(&ri) >
+	    btrfs_super_generation(fs_info->super_copy) + 1) {
+		generic_err(leaf, slot,
+			"invalid root generation, have %llu expect (0, %llu]",
+			    btrfs_root_generation(&ri),
+			    btrfs_super_generation(fs_info->super_copy) + 1);
+		return -EUCLEAN;
+	}
+	if (btrfs_root_generation_v2(&ri) >
+	    btrfs_super_generation(fs_info->super_copy) + 1) {
+		generic_err(leaf, slot,
+		"invalid root v2 generation, have %llu expect (0, %llu]",
+			    btrfs_root_generation_v2(&ri),
+			    btrfs_super_generation(fs_info->super_copy) + 1);
+		return -EUCLEAN;
+	}
+	if (btrfs_root_last_snapshot(&ri) >
+	    btrfs_super_generation(fs_info->super_copy) + 1) {
+		generic_err(leaf, slot,
+		"invalid root last_snapshot, have %llu expect (0, %llu]",
+			    btrfs_root_last_snapshot(&ri),
+			    btrfs_super_generation(fs_info->super_copy) + 1);
+		return -EUCLEAN;
+	}
+
+	/* Alignment and level check */
+	if (!IS_ALIGNED(btrfs_root_bytenr(&ri), fs_info->sectorsize)) {
+		generic_err(leaf, slot,
+		"invalid root bytenr, have %llu expect to be aligned to %u",
+			    btrfs_root_bytenr(&ri), fs_info->sectorsize);
+		return -EUCLEAN;
+	}
+	if (btrfs_root_level(&ri) >= BTRFS_MAX_LEVEL) {
+		generic_err(leaf, slot,
+			    "invalid root level, have %u expect [0, %u]",
+			    btrfs_root_level(&ri), BTRFS_MAX_LEVEL - 1);
+		return -EUCLEAN;
+	}
+	if (ri.drop_level >= BTRFS_MAX_LEVEL) {
+		generic_err(leaf, slot,
+			    "invalid root level, have %u expect [0, %u]",
+			    ri.drop_level, BTRFS_MAX_LEVEL - 1);
+		return -EUCLEAN;
+	}
+
+	/* Flags check */
+	if (btrfs_root_flags(&ri) & ~valid_root_flags) {
+		generic_err(leaf, slot,
+			    "invalid root flags, have 0x%llx expect mask 0x%llx",
+			    btrfs_root_flags(&ri), valid_root_flags);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -856,6 +945,9 @@ static int check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_INODE_ITEM_KEY:
 		ret = check_inode_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_ITEM_KEY:
+		ret = check_root_item(leaf, key, slot);
+		break;
 	}
 	return ret;
 }
-- 
2.20.1

