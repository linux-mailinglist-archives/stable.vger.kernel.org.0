Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E051B692C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgDWXU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48548 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728203AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bO-Dn; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6iD-Ly; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Xu Wen" <wen.xu@gatech.edu>, "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Su Yue" <suy.fnst@cn.fujitsu.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Qu Wenruo" <wqu@suse.com>
Date:   Fri, 24 Apr 2020 00:04:38 +0100
Message-ID: <lsq.1587683028.268403345@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 051/245] btrfs: Check that each block group has
 corresponding chunk at mount time
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

commit 514c7dca85a0bf40be984dab0b477403a6db901f upstream.

A crafted btrfs image with incorrect chunk<->block group mapping will
trigger a lot of unexpected things as the mapping is essential.

Although the problem can be caught by block group item checker
added in "btrfs: tree-checker: Verify block_group_item", it's still not
sufficient.  A sufficiently valid block group item can pass the check
added by the mentioned patch but could fail to match the existing chunk.

This patch will add extra block group -> chunk mapping check, to ensure
we have a completely matching (start, len, flags) chunk for each block
group at mount time.

Here we reuse the original helper find_first_block_group(), which is
already doing the basic bg -> chunk checks, adding further checks of the
start/len and type flags.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199837
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4: Use root->fs_info instead of fs_info]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8556,6 +8556,8 @@ static int find_first_block_group(struct
 	int ret = 0;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
+	struct btrfs_block_group_item bg;
+	u64 flags;
 	int slot;
 
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
@@ -8590,8 +8592,32 @@ static int find_first_block_group(struct
 			"logical %llu len %llu found bg but no related chunk",
 					  found_key.objectid, found_key.offset);
 				ret = -ENOENT;
+			} else if (em->start != found_key.objectid ||
+				   em->len != found_key.offset) {
+				btrfs_err(root->fs_info,
+		"block group %llu len %llu mismatch with chunk %llu len %llu",
+					  found_key.objectid, found_key.offset,
+					  em->start, em->len);
+				ret = -EUCLEAN;
 			} else {
-				ret = 0;
+				read_extent_buffer(leaf, &bg,
+					btrfs_item_ptr_offset(leaf, slot),
+					sizeof(bg));
+				flags = btrfs_block_group_flags(&bg) &
+					BTRFS_BLOCK_GROUP_TYPE_MASK;
+
+				if (flags != (em->map_lookup->type &
+					      BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+					btrfs_err(root->fs_info,
+"block group %llu len %llu type flags 0x%llx mismatch with chunk type flags 0x%llx",
+						found_key.objectid,
+						found_key.offset, flags,
+						(BTRFS_BLOCK_GROUP_TYPE_MASK &
+						 em->map_lookup->type));
+					ret = -EUCLEAN;
+				} else {
+					ret = 0;
+				}
 			}
 			free_extent_map(em);
 			goto out;

