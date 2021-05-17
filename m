Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8703834DB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbhEQPMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242984AbhEQPKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19CAE6162F;
        Mon, 17 May 2021 14:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261844;
        bh=e6rbGkevxH80htg2S1pnTYsN/VIFVvqRPI21soQ99II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHHHqz1doA/498YAa3g7v6CD49bro4vN3DloxyCGv2K5GPmSqRKwRM12HhRm1HnoO
         ysuLhUKnjYg9E5JQ17kgRwerBmBWJEgwa4aPSja8ldBe8A20Y/kLWYm0muYv2zMRTj
         BWJDK1JGZkKxce+CsdcJyqNK1UkVpRy3IquCa8js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Roivas <jouni.roivas@tuxera.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 099/141] hfsplus: prevent corruption in shrinking truncate
Date:   Mon, 17 May 2021 16:02:31 +0200
Message-Id: <20210517140246.101569802@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Roivas <jouni.roivas@tuxera.com>

commit c3187cf32216313fb316084efac4dab3a8459b1d upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/extents.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
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
 


