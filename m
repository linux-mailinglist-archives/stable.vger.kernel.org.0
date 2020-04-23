Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2920D1B6974
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgDWXXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48280 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aB-8f; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gH-Dw; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Liu Bo" <bo.li.liu@oracle.com>, "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:14 +0100
Message-ID: <lsq.1587683028.37562385@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 027/245] Btrfs: check inconsistence between chunk and
 block group
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

commit 6fb37b756acce6d6e045f79c3764206033f617b4 upstream.

With btrfs-corrupt-block, one can drop one chunk item and mounting
will end up with a panic in btrfs_full_stripe_len().

This doesn't not remove the BUG_ON, but instead checks it a bit
earlier when we find the block group item.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8571,7 +8571,22 @@ static int find_first_block_group(struct
 
 		if (found_key.objectid >= key->objectid &&
 		    found_key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
-			ret = 0;
+			struct extent_map_tree *em_tree;
+			struct extent_map *em;
+
+			em_tree = &root->fs_info->mapping_tree.map_tree;
+			read_lock(&em_tree->lock);
+			em = lookup_extent_mapping(em_tree, found_key.objectid,
+						   found_key.offset);
+			read_unlock(&em_tree->lock);
+			if (!em) {
+				btrfs_err(root->fs_info,
+			"logical %llu len %llu found bg but no related chunk",
+					  found_key.objectid, found_key.offset);
+				ret = -ENOENT;
+			} else {
+				ret = 0;
+			}
 			goto out;
 		}
 		path->slots[0]++;

