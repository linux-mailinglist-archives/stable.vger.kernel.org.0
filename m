Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808C61333D9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAGVVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgAGVDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577F42077B;
        Tue,  7 Jan 2020 21:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430988;
        bh=bdTfHbXrSAgAnMP3Fhjwl4O1KnISGipcmSYtsztw+hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOXZWnM+VzdihQyTY5+1h/c25fzkc73M1/J63OOQs5/xu0e4/ZO0M9iHg6oSzmbPc
         tZqGcHBg77WnH2s9Pf577nkGlvpsJ7JjB72/US532hWoI0RkuiEWC/zAgE7w+jBxLv
         sBLkW+Qu0C7dYLDgTwLStRGeGpqukemWNy031hSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/191] Btrfs: only associate the locked page with one async_chunk struct
Date:   Tue,  7 Jan 2020 21:55:00 +0100
Message-Id: <20200107205342.628178029@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mason <clm@fb.com>

[ Upstream commit 1d53c9e6723022b12e4a5ed4b141f67c834b7f6f ]

The btrfs writepages function collects a large range of pages flagged
for delayed allocation, and then sends them down through the COW code
for processing.  When compression is on, we allocate one async_chunk
structure for every 512K, and then run those pages through the
compression code for IO submission.

writepages starts all of this off with a single page, locked by the
original call to extent_write_cache_pages(), and it's important to keep
track of this page because it has already been through
clear_page_dirty_for_io().

The btrfs async_chunk struct has a pointer to the locked_page, and when
we're redirtying the page because compression had to fallback to
uncompressed IO, we use page->index to decide if a given async_chunk
struct really owns that page.

But, this is racey.  If a given delalloc range is broken up into two
async_chunks (chunkA and chunkB), we can end up with something like
this:

 compress_file_range(chunkA)
 submit_compress_extents(chunkA)
 submit compressed bios(chunkA)
 put_page(locked_page)

				 compress_file_range(chunkB)
				 ...

Or:

 async_cow_submit
  submit_compressed_extents <--- falls back to buffered writeout
   cow_file_range
    extent_clear_unlock_delalloc
     __process_pages_contig
       put_page(locked_pages)

					    async_cow_submit

The end result is that chunkA is completed and cleaned up before chunkB
even starts processing.  This means we can free locked_page() and reuse
it elsewhere.  If we get really lucky, it'll have the same page->index
in its new home as it did before.

While we're processing chunkB, we might decide we need to fall back to
uncompressed IO, and so compress_file_range() will call
__set_page_dirty_nobufers() on chunkB->locked_page.

Without cgroups in use, this creates as a phantom dirty page, which
isn't great but isn't the end of the world. What can happen, it can go
through the fixup worker and the whole COW machinery again:

in submit_compressed_extents():
  while (async extents) {
  ...
    cow_file_range
    if (!page_started ...)
      extent_write_locked_range
    else if (...)
      unlock_page
    continue;

This hasn't been observed in practice but is still possible.

With cgroups in use, we might crash in the accounting code because
page->mapping->i_wb isn't set.

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000d0
  IP: percpu_counter_add_batch+0x11/0x70
  PGD 66534e067 P4D 66534e067 PUD 66534f067 PMD 0
  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
  CPU: 16 PID: 2172 Comm: rm Not tainted
  RIP: 0010:percpu_counter_add_batch+0x11/0x70
  RSP: 0018:ffffc9000a97bbe0 EFLAGS: 00010286
  RAX: 0000000000000005 RBX: 0000000000000090 RCX: 0000000000026115
  RDX: 0000000000000030 RSI: ffffffffffffffff RDI: 0000000000000090
  RBP: 0000000000000000 R08: fffffffffffffff5 R09: 0000000000000000
  R10: 00000000000260c0 R11: ffff881037fc26c0 R12: ffffffffffffffff
  R13: ffff880fe4111548 R14: ffffc9000a97bc90 R15: 0000000000000001
  FS:  00007f5503ced480(0000) GS:ffff880ff7200000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000d0 CR3: 00000001e0459005 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   account_page_cleaned+0x15b/0x1f0
   __cancel_dirty_page+0x146/0x200
   truncate_cleanup_page+0x92/0xb0
   truncate_inode_pages_range+0x202/0x7d0
   btrfs_evict_inode+0x92/0x5a0
   evict+0xc1/0x190
   do_unlinkat+0x176/0x280
   do_syscall_64+0x63/0x1a0
   entry_SYSCALL_64_after_hwframe+0x42/0xb7

The fix here is to make asyc_chunk->locked_page NULL everywhere but the
one async_chunk struct that's allowed to do things to the locked page.

Link: https://lore.kernel.org/linux-btrfs/c2419d01-5c84-3fb4-189e-4db519d08796@suse.com/
Fixes: 771ed689d2cd ("Btrfs: Optimize compressed writeback and reads")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Chris Mason <clm@fb.com>
[ update changelog from mail thread discussion ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/inode.c     | 25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index be9dc78aa727..33c6b191ca59 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1899,7 +1899,7 @@ static int __process_pages_contig(struct address_space *mapping,
 			if (page_ops & PAGE_SET_PRIVATE2)
 				SetPagePrivate2(pages[i]);
 
-			if (pages[i] == locked_page) {
+			if (locked_page && pages[i] == locked_page) {
 				put_page(pages[i]);
 				pages_locked++;
 				continue;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dc14fc2e4206..0b2758961b1c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -712,10 +712,12 @@ cleanup_and_bail_uncompressed:
 	 * to our extent and set things up for the async work queue to run
 	 * cow_file_range to do the normal delalloc dance.
 	 */
-	if (page_offset(async_chunk->locked_page) >= start &&
-	    page_offset(async_chunk->locked_page) <= end)
+	if (async_chunk->locked_page &&
+	    (page_offset(async_chunk->locked_page) >= start &&
+	     page_offset(async_chunk->locked_page)) <= end) {
 		__set_page_dirty_nobuffers(async_chunk->locked_page);
 		/* unlocked later on in the async handlers */
+	}
 
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
@@ -795,7 +797,7 @@ retry:
 						  async_extent->start +
 						  async_extent->ram_size - 1,
 						  WB_SYNC_ALL);
-			else if (ret)
+			else if (ret && async_chunk->locked_page)
 				unlock_page(async_chunk->locked_page);
 			kfree(async_extent);
 			cond_resched();
@@ -1264,10 +1266,25 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_chunk[i].inode = inode;
 		async_chunk[i].start = start;
 		async_chunk[i].end = cur_end;
-		async_chunk[i].locked_page = locked_page;
 		async_chunk[i].write_flags = write_flags;
 		INIT_LIST_HEAD(&async_chunk[i].extents);
 
+		/*
+		 * The locked_page comes all the way from writepage and its
+		 * the original page we were actually given.  As we spread
+		 * this large delalloc region across multiple async_chunk
+		 * structs, only the first struct needs a pointer to locked_page
+		 *
+		 * This way we don't need racey decisions about who is supposed
+		 * to unlock it.
+		 */
+		if (locked_page) {
+			async_chunk[i].locked_page = locked_page;
+			locked_page = NULL;
+		} else {
+			async_chunk[i].locked_page = NULL;
+		}
+
 		btrfs_init_work(&async_chunk[i].work, async_cow_start,
 				async_cow_submit, async_cow_free);
 
-- 
2.20.1



