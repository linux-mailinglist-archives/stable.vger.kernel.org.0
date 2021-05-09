Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85A837754A
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 06:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhEIEgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 00:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhEIEgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 00:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B9F61059;
        Sun,  9 May 2021 04:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620534934;
        bh=WRU/VD8WvNc4KAuqqrFa08irF9Y9u7eAqxdm20mMlPA=;
        h=Date:From:To:Subject:From;
        b=RKJSAu/wiGIHUeW2nkpRgcyuDNavBMTL7JJxlJPgoK454ZJ9BaIxHUbqGkpxASRHt
         5gjJRdgjzpMjgESPULWKuA0UhH6/nkBD59VlBnfAeASictehnRSzIjKK5w5FBiyhdS
         OnCjoYHmLriMp1qW/ZZdBXGTxN4ucQJdSmao5+ks=
Date:   Sat, 08 May 2021 21:35:34 -0700
From:   akpm@linux-foundation.org
To:     anatoly.trosinenko@gmail.com, anton@tuxera.com,
        jouni.roivas@tuxera.com, mm-commits@vger.kernel.org,
        slava@dubeyko.com, stable@vger.kernel.org
Subject:  + hfsplus-prevent-corruption-in-shrinking-truncate.patch
 added to -mm tree
Message-ID: <20210509043534.4rnqcaWZ8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hfsplus: prevent corruption in shrinking truncate
has been added to the -mm tree.  Its filename is
     hfsplus-prevent-corruption-in-shrinking-truncate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfsplus-prevent-corruption-in-shrinking-truncate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-prevent-corruption-in-shrinking-truncate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jouni Roivas <jouni.roivas@tuxera.com>
Subject: hfsplus: prevent corruption in shrinking truncate

I believe there are some issues introduced by commit 31651c607151
("hfsplus: avoid deadlock on file truncation")

HFS+ has extent records which always contains 8 extents.  In case the
first extent record in catalog file gets full, new ones are allocated from
extents overflow file.

In case shrinking truncate happens to middle of an extent record which
locates in extents overflow file, the logic in hfsplus_file_truncate() was
changed so that call to hfs_brec_remove() is not guarded any more.

Right action would be just freeing the extents that exceed the new size
inside extent record by calling hfsplus_free_extents(), and then check if
the whole extent record should be removed.  However since the guard
(blk_cnt > start) is now after the call to hfs_brec_remove(), this has
unfortunate effect that the last matching extent record is removed
unconditionally.

To reproduce this issue, create a file which has at least 10 extents, and
then perform shrinking truncate into middle of the last extent record, so
that the number of remaining extents is not under or divisible by 8.  This
causes the last extent record (8 extents) to be removed totally instead of
truncating into middle of it.  Thus this causes corruption, and lost data.

Fix for this is simply checking if the new truncated end is below the
start of this extent record, making it safe to remove the full extent
record.  However call to hfs_brec_remove() can't be moved to it's previous
place since we're dropping ->tree_lock and it can cause a race condition
and the cached info being invalidated possibly corrupting the node data.

Another issue is related to this one.  When entering into the block
(blk_cnt > start) we are not holding the ->tree_lock.  We break out from
the loop not holding the lock, but hfs_find_exit() does unlock it.  Not
sure if it's possible for someone else to take the lock under our feet,
but it can cause hard to debug errors and premature unlocking.  Even if
there's no real risk of it, the locking should still always be kept in
balance.  Thus taking the lock now just before the check.

Link: https://lkml.kernel.org/r/20210429165139.3082828-1-jouni.roivas@tuxera.com
Fixes: 31651c607151f ("hfsplus: avoid deadlock on file truncation")
Signed-off-by: Jouni Roivas <jouni.roivas@tuxera.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/hfsplus/extents.c~hfsplus-prevent-corruption-in-shrinking-truncate
+++ a/fs/hfsplus/extents.c
@@ -598,13 +598,15 @@ void hfsplus_file_truncate(struct inode
 		res = __hfsplus_ext_cache_extent(&fd, inode, alloc_cnt);
 		if (res)
 			break;
-		hfs_brec_remove(&fd);
 
-		mutex_unlock(&fd.tree->tree_lock);
 		start = hip->cached_start;
+		if (blk_cnt <= start)
+			hfs_brec_remove(&fd);
+		mutex_unlock(&fd.tree->tree_lock);
 		hfsplus_free_extents(sb, hip->cached_extents,
 				     alloc_cnt - start, alloc_cnt - blk_cnt);
 		hfsplus_dump_extent(hip->cached_extents);
+		mutex_lock(&fd.tree->tree_lock);
 		if (blk_cnt > start) {
 			hip->extent_state |= HFSPLUS_EXT_DIRTY;
 			break;
@@ -612,7 +614,6 @@ void hfsplus_file_truncate(struct inode
 		alloc_cnt = start;
 		hip->cached_start = hip->cached_blocks = 0;
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
-		mutex_lock(&fd.tree->tree_lock);
 	}
 	hfs_find_exit(&fd);
 
_

Patches currently in -mm which might be from jouni.roivas@tuxera.com are

hfsplus-prevent-corruption-in-shrinking-truncate.patch

