Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF7157BA9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgBJNbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgBJMgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:00 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F5B24672;
        Mon, 10 Feb 2020 12:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338159;
        bh=42VBH1B1ZQWlunEn568D+fE+UMHh4mj7PObaRMREYEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCBml2MSluVbYu7tRRzuTP2dSqE/GhyC6iz8xkxF7rp0Mlz6NDbr9ZdAHVraAIrMX
         PjIhnaegX3tSL6KEBLWmpbChbK4pBNoJPXubwYq26BD1BP01ZZEh/tuEyNYveU6Dg4
         lmP3OQxkI8R/ryb17BfVyKLzR6g5ASJFNlTndGAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 090/195] dm writecache: fix incorrect flush sequence when doing SSD mode commit
Date:   Mon, 10 Feb 2020 04:32:28 -0800
Message-Id: <20200210122314.137077319@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit aa9509209c5ac2f0b35d01a922bf9ae072d0c2fc upstream.

When committing state, the function writecache_flush does the following:
1. write metadata (writecache_commit_flushed)
2. flush disk cache (writecache_commit_flushed)
3. wait for data writes to complete (writecache_wait_for_ios)
4. increase superblock seq_count
5. write the superblock
6. flush disk cache

It may happen that at step 3, when we wait for some write to finish, the
disk may report the write as finished, but the write only hit the disk
cache and it is not yet stored in persistent storage. At step 5 we write
the superblock - it may happen that the superblock is written before the
write that we waited for in step 3. If the machine crashes, it may result
in incorrect data being returned after reboot.

In order to fix the bug, we must swap steps 2 and 3 in the above sequence,
so that we first wait for writes to complete and then flush the disk
cache.

Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -447,7 +447,13 @@ static void writecache_notify_io(unsigne
 		complete(&endio->c);
 }
 
-static void ssd_commit_flushed(struct dm_writecache *wc)
+static void writecache_wait_for_ios(struct dm_writecache *wc, int direction)
+{
+	wait_event(wc->bio_in_progress_wait[direction],
+		   !atomic_read(&wc->bio_in_progress[direction]));
+}
+
+static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 {
 	struct dm_io_region region;
 	struct dm_io_request req;
@@ -493,17 +499,20 @@ static void ssd_commit_flushed(struct dm
 	writecache_notify_io(0, &endio);
 	wait_for_completion_io(&endio.c);
 
+	if (wait_for_ios)
+		writecache_wait_for_ios(wc, WRITE);
+
 	writecache_disk_flush(wc, wc->ssd_dev);
 
 	memset(wc->dirty_bitmap, 0, wc->dirty_bitmap_size);
 }
 
-static void writecache_commit_flushed(struct dm_writecache *wc)
+static void writecache_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 {
 	if (WC_MODE_PMEM(wc))
 		wmb();
 	else
-		ssd_commit_flushed(wc);
+		ssd_commit_flushed(wc, wait_for_ios);
 }
 
 static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
@@ -527,12 +536,6 @@ static void writecache_disk_flush(struct
 		writecache_error(wc, r, "error flushing metadata: %d", r);
 }
 
-static void writecache_wait_for_ios(struct dm_writecache *wc, int direction)
-{
-	wait_event(wc->bio_in_progress_wait[direction],
-		   !atomic_read(&wc->bio_in_progress[direction]));
-}
-
 #define WFE_RETURN_FOLLOWING	1
 #define WFE_LOWEST_SEQ		2
 
@@ -730,14 +733,12 @@ static void writecache_flush(struct dm_w
 		e = e2;
 		cond_resched();
 	}
-	writecache_commit_flushed(wc);
-
-	writecache_wait_for_ios(wc, WRITE);
+	writecache_commit_flushed(wc, true);
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
 	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 
 	wc->overwrote_committed = false;
 
@@ -761,7 +762,7 @@ static void writecache_flush(struct dm_w
 	}
 
 	if (need_flush_after_free)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static void writecache_flush_work(struct work_struct *work)
@@ -814,7 +815,7 @@ static void writecache_discard(struct dm
 	}
 
 	if (discarded_something)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static bool writecache_wait_for_writeback(struct dm_writecache *wc)
@@ -963,7 +964,7 @@ erase_this:
 
 	if (need_flush) {
 		writecache_flush_all_metadata(wc);
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 	}
 
 	wc_unlock(wc);
@@ -1347,7 +1348,7 @@ static void __writecache_endio_pmem(stru
 			wc->writeback_size--;
 			n_walked++;
 			if (unlikely(n_walked >= ENDIO_LATENCY)) {
-				writecache_commit_flushed(wc);
+				writecache_commit_flushed(wc, false);
 				wc_unlock(wc);
 				wc_lock(wc);
 				n_walked = 0;
@@ -1428,7 +1429,7 @@ pop_from_list:
 			writecache_wait_for_ios(wc, READ);
 		}
 
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 
 		wc_unlock(wc);
 	}
@@ -1759,10 +1760,10 @@ static int init_memory(struct dm_writeca
 		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
 
 	writecache_flush_all_metadata(wc);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
 	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 
 	return 0;
 }


