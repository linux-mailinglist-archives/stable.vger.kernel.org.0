Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A944B2088
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390442AbfIMNW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390909AbfIMNVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:52 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0988E20717;
        Fri, 13 Sep 2019 13:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380911;
        bh=ZGQq7XmYS3Ko11gPlRhrnwMkCQgmaoPYqlC740uS8JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOV3fhcmQCV1ZG3Z6geC8hBICzCeKey2XTDsDxTAzz/Z3ODcIElYirU3HHrwSwgD5
         4IPsUGsRDwTRf2qMyz0wlPcsirpYw9oytXOONmwHz943xTkhzh/pueNolL3KrJlam1
         TnqUhaJyW7wRyUVcJCPCkMaEY8Aw8y0ONI8+PCPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Sojka <zsojka@seznam.cz>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Drazen Kacar <drazen.kacar@oradian.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 35/37] Btrfs: fix unwritten extent buffers and hangs on future writeback attempts
Date:   Fri, 13 Sep 2019 14:07:40 +0100
Message-Id: <20190913130522.060024148@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 18dfa7117a3f379862dcd3f67cadd678013bb9dd upstream.

The lock_extent_buffer_io() returns 1 to the caller to tell it everything
went fine and the callers needs to start writeback for the extent buffer
(submit a bio, etc), 0 to tell the caller everything went fine but it does
not need to start writeback for the extent buffer, and a negative value if
some error happened.

When it's about to return 1 it tries to lock all pages, and if a try lock
on a page fails, and we didn't flush any existing bio in our "epd", it
calls flush_write_bio(epd) and overwrites the return value of 1 to 0 or
an error. The page might have been locked elsewhere, not with the goal
of starting writeback of the extent buffer, and even by some code other
than btrfs, like page migration for example, so it does not mean the
writeback of the extent buffer was already started by some other task,
so returning a 0 tells the caller (btree_write_cache_pages()) to not
start writeback for the extent buffer. Note that epd might currently have
either no bio, so flush_write_bio() returns 0 (success) or it might have
a bio for another extent buffer with a lower index (logical address).

Since we return 0 with the EXTENT_BUFFER_WRITEBACK bit set on the
extent buffer and writeback is never started for the extent buffer,
future attempts to writeback the extent buffer will hang forever waiting
on that bit to be cleared, since it can only be cleared after writeback
completes. Such hang is reported with a trace like the following:

  [49887.347053] INFO: task btrfs-transacti:1752 blocked for more than 122 seconds.
  [49887.347059]       Not tainted 5.2.13-gentoo #2
  [49887.347060] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [49887.347062] btrfs-transacti D    0  1752      2 0x80004000
  [49887.347064] Call Trace:
  [49887.347069]  ? __schedule+0x265/0x830
  [49887.347071]  ? bit_wait+0x50/0x50
  [49887.347072]  ? bit_wait+0x50/0x50
  [49887.347074]  schedule+0x24/0x90
  [49887.347075]  io_schedule+0x3c/0x60
  [49887.347077]  bit_wait_io+0x8/0x50
  [49887.347079]  __wait_on_bit+0x6c/0x80
  [49887.347081]  ? __lock_release.isra.29+0x155/0x2d0
  [49887.347083]  out_of_line_wait_on_bit+0x7b/0x80
  [49887.347084]  ? var_wake_function+0x20/0x20
  [49887.347087]  lock_extent_buffer_for_io+0x28c/0x390
  [49887.347089]  btree_write_cache_pages+0x18e/0x340
  [49887.347091]  do_writepages+0x29/0xb0
  [49887.347093]  ? kmem_cache_free+0x132/0x160
  [49887.347095]  ? convert_extent_bit+0x544/0x680
  [49887.347097]  filemap_fdatawrite_range+0x70/0x90
  [49887.347099]  btrfs_write_marked_extents+0x53/0x120
  [49887.347100]  btrfs_write_and_wait_transaction.isra.4+0x38/0xa0
  [49887.347102]  btrfs_commit_transaction+0x6bb/0x990
  [49887.347103]  ? start_transaction+0x33e/0x500
  [49887.347105]  transaction_kthread+0x139/0x15c

So fix this by not overwriting the return value (ret) with the result
from flush_write_bio(). We also need to clear the EXTENT_BUFFER_WRITEBACK
bit in case flush_write_bio() returns an error, otherwise it will hang
any future attempts to writeback the extent buffer, and undo all work
done before (set back EXTENT_BUFFER_DIRTY, etc).

This is a regression introduced in the 5.2 kernel.

Fixes: 2e3c25136adfb ("btrfs: extent_io: add proper error handling to lock_extent_buffer_for_io()")
Fixes: f4340622e0226 ("btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up")
Reported-by: Zdenek Sojka <zsojka@seznam.cz>
Link: https://lore.kernel.org/linux-btrfs/GpO.2yos.3WGDOLpx6t%7D.1TUDYM@seznam.cz/T/#u
Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Link: https://lore.kernel.org/linux-btrfs/5c4688ac-10a7-fb07-70e8-c5d31a3fbb38@profihost.ag/T/#t
Reported-by: Drazen Kacar <drazen.kacar@oradian.com>
Link: https://lore.kernel.org/linux-btrfs/DB8PR03MB562876ECE2319B3E579590F799C80@DB8PR03MB5628.eurprd03.prod.outlook.com/
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204377
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3591,6 +3591,13 @@ void wait_on_extent_buffer_writeback(str
 		       TASK_UNINTERRUPTIBLE);
 }
 
+static void end_extent_buffer_writeback(struct extent_buffer *eb)
+{
+	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+	smp_mb__after_atomic();
+	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
+}
+
 /*
  * Lock eb pages and flush the bio if we can't the locks
  *
@@ -3662,8 +3669,11 @@ static noinline_for_stack int lock_exten
 
 		if (!trylock_page(p)) {
 			if (!flush) {
-				ret = flush_write_bio(epd);
-				if (ret < 0) {
+				int err;
+
+				err = flush_write_bio(epd);
+				if (err < 0) {
+					ret = err;
 					failed_page_nr = i;
 					goto err_unlock;
 				}
@@ -3678,16 +3688,23 @@ err_unlock:
 	/* Unlock already locked pages */
 	for (i = 0; i < failed_page_nr; i++)
 		unlock_page(eb->pages[i]);
+	/*
+	 * Clear EXTENT_BUFFER_WRITEBACK and wake up anyone waiting on it.
+	 * Also set back EXTENT_BUFFER_DIRTY so future attempts to this eb can
+	 * be made and undo everything done before.
+	 */
+	btrfs_tree_lock(eb);
+	spin_lock(&eb->refs_lock);
+	set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
+	end_extent_buffer_writeback(eb);
+	spin_unlock(&eb->refs_lock);
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, eb->len,
+				 fs_info->dirty_metadata_batch);
+	btrfs_clear_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
+	btrfs_tree_unlock(eb);
 	return ret;
 }
 
-static void end_extent_buffer_writeback(struct extent_buffer *eb)
-{
-	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-	smp_mb__after_atomic();
-	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
-}
-
 static void set_btree_ioerr(struct page *page)
 {
 	struct extent_buffer *eb = (struct extent_buffer *)page->private;


