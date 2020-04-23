Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7C1B6937
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgDWXVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48544 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728199AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bY-2N; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6iH-Mh; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David Sterba" <dsterba@suse.com>,
        "Gu Jinxiang" <gujx@cn.fujitsu.com>, "Xu Wen" <wen.xu@gatech.edu>,
        "Qu Wenruo" <wqu@suse.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:39 +0100
Message-ID: <lsq.1587683028.752578447@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 052/245] btrfs: Verify that every chunk has
 corresponding block group at mount time
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 7ef49515fa6727cb4b6f2f5b0ffbc5fc20a9f8c6 upstream.

If a crafted image has missing block group items, it could cause
unexpected behavior and breaks the assumption of 1:1 chunk<->block group
mapping.

Although we have the block group -> chunk mapping check, we still need
chunk -> block group mapping check.

This patch will do extra check to ensure each chunk has its
corresponding block group.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c | 58 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8819,6 +8819,62 @@ btrfs_create_block_group_cache(struct bt
 	return cache;
 }
 
+
+/*
+ * Iterate all chunks and verify that each of them has the corresponding block
+ * group
+ */
+static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct extent_map *em;
+	struct btrfs_block_group_cache *bg;
+	u64 start = 0;
+	int ret = 0;
+
+	while (1) {
+		read_lock(&map_tree->map_tree.lock);
+		/*
+		 * lookup_extent_mapping will return the first extent map
+		 * intersecting the range, so setting @len to 1 is enough to
+		 * get the first chunk.
+		 */
+		em = lookup_extent_mapping(&map_tree->map_tree, start, 1);
+		read_unlock(&map_tree->map_tree.lock);
+		if (!em)
+			break;
+
+		bg = btrfs_lookup_block_group(fs_info, em->start);
+		if (!bg) {
+			btrfs_err(fs_info,
+	"chunk start=%llu len=%llu doesn't have corresponding block group",
+				     em->start, em->len);
+			ret = -EUCLEAN;
+			free_extent_map(em);
+			break;
+		}
+		if (bg->key.objectid != em->start ||
+		    bg->key.offset != em->len ||
+		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=
+		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+			btrfs_err(fs_info,
+"chunk start=%llu len=%llu flags=0x%llx doesn't match block group start=%llu len=%llu flags=0x%llx",
+				em->start, em->len,
+				em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK,
+				bg->key.objectid, bg->key.offset,
+				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
+			ret = -EUCLEAN;
+			free_extent_map(em);
+			btrfs_put_block_group(bg);
+			break;
+		}
+		start = em->start + em->len;
+		free_extent_map(em);
+		btrfs_put_block_group(bg);
+	}
+	return ret;
+}
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -8981,7 +9037,7 @@ int btrfs_read_block_groups(struct btrfs
 	}
 
 	init_global_block_rsv(info);
-	ret = 0;
+	ret = check_chunk_block_group_mappings(info);
 error:
 	btrfs_free_path(path);
 	return ret;

