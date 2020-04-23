Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2D1B6994
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgDWXYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48264 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728126AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aR-Kv; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gk-Lm; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Liu Bo" <bo.li.liu@oracle.com>, "David Sterba" <dsterba@suse.com>
Date:   Fri, 24 Apr 2020 00:04:20 +0100
Message-ID: <lsq.1587683028.231159933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 033/245] Btrfs: improve check_node to avoid reading
 corrupted nodes
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

commit 6b722c1747d533ac6d4df110dc8233db46918b65 upstream.

We need to check items in a node to make sure that we're reading
a valid one, otherwise we could get various crashes while processing
delayed_refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -508,9 +508,10 @@ static int check_tree_block_fsid(struct
 }
 
 #define CORRUPT(reason, eb, root, slot)				\
-	btrfs_crit(root->fs_info, "corrupt leaf, %s: block=%llu,"	\
-		   "root=%llu, slot=%d", reason,			\
-	       btrfs_header_bytenr(eb),	root->objectid, slot)
+	btrfs_crit(root->fs_info, "corrupt %s, %s: block=%llu,"	\
+		   " root=%llu, slot=%d",			\
+		   btrfs_header_level(eb) == 0 ? "leaf" : "node",\
+		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
 
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
@@ -601,6 +602,10 @@ static noinline int check_leaf(struct bt
 static int check_node(struct btrfs_root *root, struct extent_buffer *node)
 {
 	unsigned long nr = btrfs_header_nritems(node);
+	struct btrfs_key key, next_key;
+	int slot;
+	u64 bytenr;
+	int ret = 0;
 
 	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
 		btrfs_crit(root->fs_info,
@@ -608,7 +613,26 @@ static int check_node(struct btrfs_root
 			   node->start, root->objectid, nr);
 		return -EIO;
 	}
-	return 0;
+
+	for (slot = 0; slot < nr - 1; slot++) {
+		bytenr = btrfs_node_blockptr(node, slot);
+		btrfs_node_key_to_cpu(node, &key, slot);
+		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
+
+		if (!bytenr) {
+			CORRUPT("invalid item slot", node, root, slot);
+			ret = -EIO;
+			goto out;
+		}
+
+		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
+			CORRUPT("bad key order", node, root, slot);
+			ret = -EIO;
+			goto out;
+		}
+	}
+out:
+	return ret;
 }
 
 static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,

