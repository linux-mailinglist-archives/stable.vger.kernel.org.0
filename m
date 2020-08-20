Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4263724BC67
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHTMpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgHTJpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B027F2224D;
        Thu, 20 Aug 2020 09:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916720;
        bh=LhrVJjLW4k5wufY+4/30vf1lucgNllhSgPLioVFX6kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vN5ykeMPKOlLXFt8CtrQ1BzDjrIClISCqbWqvoFpIyMSvubithD6dSuT//IjKFxSF
         4dhNGTLhyFV3UY/nLJGhFB5mzUdjz9zCCU2I5VJLsdSV8fHd2ppsJ2ZqRy38p62Jfd
         6DfrneyTtD3H1qDc7JR4mH4Q2O0NyCLFbKf9Rvf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 023/152] btrfs: fix race between page release and a fast fsync
Date:   Thu, 20 Aug 2020 11:19:50 +0200
Message-Id: <20200820091554.828551254@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 3d6448e631591756da36efb3ea6355ff6f383c3a upstream.

When releasing an extent map, done through the page release callback, we
can race with an ongoing fast fsync and cause the fsync to miss a new
extent and not log it. The steps for this to happen are the following:

1) A page is dirtied for some inode I;

2) Writeback for that page is triggered by a path other than fsync, for
   example by the system due to memory pressure;

3) When the ordered extent for the extent (a single 4K page) finishes,
   we unpin the corresponding extent map and set its generation to N,
   the current transaction's generation;

4) The btrfs_releasepage() callback is invoked by the system due to
   memory pressure for that no longer dirty page of inode I;

5) At the same time, some task calls fsync on inode I, joins transaction
   N, and at btrfs_log_inode() it sees that the inode does not have the
   full sync flag set, so we proceed with a fast fsync. But before we get
   into btrfs_log_changed_extents() and lock the inode's extent map tree:

6) Through btrfs_releasepage() we end up at try_release_extent_mapping()
   and we remove the extent map for the new 4Kb extent, because it is
   neither pinned anymore nor locked. By calling remove_extent_mapping(),
   we remove the extent map from the list of modified extents, since the
   extent map does not have the logging flag set. We unlock the inode's
   extent map tree;

7) The task doing the fast fsync now enters btrfs_log_changed_extents(),
   locks the inode's extent map tree and iterates its list of modified
   extents, which no longer has the 4Kb extent in it, so it does not log
   the extent;

8) The fsync finishes;

9) Before transaction N is committed, a power failure happens. After
   replaying the log, the 4K extent of inode I will be missing, since
   it was not logged due to the race with try_release_extent_mapping().

So fix this by teaching try_release_extent_mapping() to not remove an
extent map if it's still in the list of modified extents.

Fixes: ff44c6e36dc9dc ("Btrfs: do not hold the write_lock on the extent tree while logging")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4467,15 +4467,25 @@ int try_release_extent_mapping(struct pa
 				free_extent_map(em);
 				break;
 			}
-			if (!test_range_bit(tree, em->start,
-					    extent_map_end(em) - 1,
-					    EXTENT_LOCKED, 0, NULL)) {
+			if (test_range_bit(tree, em->start,
+					   extent_map_end(em) - 1,
+					   EXTENT_LOCKED, 0, NULL))
+				goto next;
+			/*
+			 * If it's not in the list of modified extents, used
+			 * by a fast fsync, we can remove it. If it's being
+			 * logged we can safely remove it since fsync took an
+			 * extra reference on the em.
+			 */
+			if (list_empty(&em->list) ||
+			    test_bit(EXTENT_FLAG_LOGGING, &em->flags)) {
 				set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 					&btrfs_inode->runtime_flags);
 				remove_extent_mapping(map, em);
 				/* once for the rb tree */
 				free_extent_map(em);
 			}
+next:
 			start = extent_map_end(em);
 			write_unlock(&map->lock);
 


