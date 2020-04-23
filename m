Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F178F1B698E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgDWXYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48266 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aH-DS; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gR-H0; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>,
        "Liu Bo" <bo.li.liu@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 00:04:16 +0100
Message-ID: <lsq.1587683028.107139602@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 029/245] Btrfs: detect corruption when non-root leaf
 has zero item
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

From: Liu Bo <bo.li.liu@oracle.com>

commit 1ba98d086fe3a14d6a31f2f66dbab70c45d00f63 upstream.

Right now we treat leaf which has zero item as a valid one
because we could have an empty tree, that is, a root that is
also a leaf without any item, however, in the same case but
when the leaf is not a root, we can end up with hitting the
BUG_ON(1) in btrfs_extend_item() called by
setup_inline_extent_backref().

This makes us check the situation as a corruption if leaf is
not its own root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -520,8 +520,29 @@ static noinline int check_leaf(struct bt
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
-	if (nritems == 0)
+	if (nritems == 0) {
+		struct btrfs_root *check_root;
+
+		key.objectid = btrfs_header_owner(leaf);
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		check_root = btrfs_get_fs_root(root->fs_info, &key, false);
+		/*
+		 * The only reason we also check NULL here is that during
+		 * open_ctree() some roots has not yet been set up.
+		 */
+		if (!IS_ERR_OR_NULL(check_root)) {
+			/* if leaf is the root, then it's fine */
+			if (leaf->start !=
+			    btrfs_root_bytenr(&check_root->root_item)) {
+				CORRUPT("non-root leaf's nritems is 0",
+					leaf, root, 0);
+				return -EIO;
+			}
+		}
 		return 0;
+	}
 
 	/* Check the 0 item */
 	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=

