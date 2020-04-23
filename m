Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937D01B6989
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgDWXYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48316 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aN-HG; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gb-Jx; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jeff Mahoney" <jeffm@suse.com>, "Liu Bo" <bo.li.liu@oracle.com>,
        "Filipe Manana" <fdmanana@suse.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:18 +0100
Message-ID: <lsq.1587683028.872619227@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 031/245] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
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

commit ef85b25e982b5bba1530b936e283ef129f02ab9d upstream.

This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y.

Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero item")
assumes that a leaf is its root when leaf->bytenr == btrfs_root_bytenr(root),
however, we should not use btrfs_root_bytenr(root) since it's mainly got
updated during committing transaction.  So the check can fail when doing
COW on this leaf while it is a root.

This changes to use "if (leaf == btrfs_root_node(root))" instead, just like
how we check whether leaf is a root in __btrfs_cow_block().

Fixes: 1ba98d086fe3 (Btrfs: detect corruption when non-root leaf has zero item)
Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -533,13 +533,17 @@ static noinline int check_leaf(struct bt
 		 * open_ctree() some roots has not yet been set up.
 		 */
 		if (!IS_ERR_OR_NULL(check_root)) {
+			struct extent_buffer *eb;
+
+			eb = btrfs_root_node(check_root);
 			/* if leaf is the root, then it's fine */
-			if (leaf->start !=
-			    btrfs_root_bytenr(&check_root->root_item)) {
+			if (leaf != eb) {
 				CORRUPT("non-root leaf's nritems is 0",
-					leaf, root, 0);
+					leaf, check_root, 0);
+				free_extent_buffer(eb);
 				return -EIO;
 			}
+			free_extent_buffer(eb);
 		}
 		return 0;
 	}

