Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58341555C7
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgBGKev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:34:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43165 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgBGKeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:34:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2411C22036;
        Fri,  7 Feb 2020 05:34:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 05:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/palOc
        w53/XeAqXvbuNcaxr9wLPHe4R6qd7gZAZHqTM=; b=FZJPEB8bVf7+7jPmO41GYi
        HCcQ//wMQJS5V6g5hoS88OLZvpYcgigY1M0fmHmlyzohvUVGXEltMR3cXNbTJCKY
        aeLs6xHUhWPOe0NT3CNxNGZZDF6t45wfn4vGlyHlhX2T8AJQDRi4ryMS+ow+Ri1R
        eoqBvn8p0jRYw4PiQ1C40Sh6zKIH8Nlyj9b1QOErF0cyeBhz6WYTlqaXXSaSDyc+
        3S6/EGZS7ElfCg6OxotDoAezyN+Xe8xSg6avDfk68G0BzDO+UPgtHX/D4xv1QvR4
        Pd50zEqv2qZ/l1WKqbLF5bzUqxwJlTKP8MRNGiZnG6k9TKEjBbHXY5wVbKxJYkng
        ==
X-ME-Sender: <xms:ST09Xnd2Ai40U2HZlrl6GtHiQF6voASL8rtBrvL2N2b01Z-biaqtrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ST09Xk3T5iwG70pUxSBddO7QzFdW8n4PT9kk8-91d7S_xexsjqLJFA>
    <xmx:ST09Xgst5CYd_dN1pfG01rqQaa6tYsk_UcQWDg3ygi9Jnul7HpTz1g>
    <xmx:ST09Xg_1hAbQv45TQ1EilIPoVtDMVa9Ss5pGWgqeSLKdjrAhb3O0PQ>
    <xmx:Sj09XqaXC3LEA7MAjB-aeZzUlsrgxP_D7HXdgJv8t2xn89uTCieXPQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8332C3280062;
        Fri,  7 Feb 2020 05:34:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm writecache: fix incorrect flush sequence when doing SSD" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Feb 2020 11:34:48 +0100
Message-ID: <15810716881950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa9509209c5ac2f0b35d01a922bf9ae072d0c2fc Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 8 Jan 2020 10:46:05 -0500
Subject: [PATCH] dm writecache: fix incorrect flush sequence when doing SSD
 mode commit

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

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 7d727a72aa13..9b0a3bf6a4a1 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -442,7 +442,13 @@ static void writecache_notify_io(unsigned long error, void *context)
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
@@ -488,17 +494,20 @@ static void ssd_commit_flushed(struct dm_writecache *wc)
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
@@ -522,12 +531,6 @@ static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
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
 
@@ -724,15 +727,12 @@ static void writecache_flush(struct dm_writecache *wc)
 		e = e2;
 		cond_resched();
 	}
-	writecache_commit_flushed(wc);
-
-	if (!WC_MODE_PMEM(wc))
-		writecache_wait_for_ios(wc, WRITE);
+	writecache_commit_flushed(wc, true);
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
 	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 
 	wc->overwrote_committed = false;
 
@@ -756,7 +756,7 @@ static void writecache_flush(struct dm_writecache *wc)
 	}
 
 	if (need_flush_after_free)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static void writecache_flush_work(struct work_struct *work)
@@ -809,7 +809,7 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 	}
 
 	if (discarded_something)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static bool writecache_wait_for_writeback(struct dm_writecache *wc)
@@ -958,7 +958,7 @@ static void writecache_resume(struct dm_target *ti)
 
 	if (need_flush) {
 		writecache_flush_all_metadata(wc);
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 	}
 
 	wc_unlock(wc);
@@ -1342,7 +1342,7 @@ static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *
 			wc->writeback_size--;
 			n_walked++;
 			if (unlikely(n_walked >= ENDIO_LATENCY)) {
-				writecache_commit_flushed(wc);
+				writecache_commit_flushed(wc, false);
 				wc_unlock(wc);
 				wc_lock(wc);
 				n_walked = 0;
@@ -1423,7 +1423,7 @@ static int writecache_endio_thread(void *data)
 			writecache_wait_for_ios(wc, READ);
 		}
 
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 
 		wc_unlock(wc);
 	}
@@ -1766,10 +1766,10 @@ static int init_memory(struct dm_writecache *wc)
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

