Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7D3155617
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 11:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgBGKyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 05:54:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgBGKyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 05:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581072876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXMAHa/4xose7vPjS3JftF+xjN+Ti8wwhcbWo6T7tUM=;
        b=Tb4L6lUqytRajwj34DFzyN4UjM+gewtRfEXVJCl6JKi1Yluq2ja3ZM/0A1pkwDPKdNQMPo
        enrYEmf1ljHW40jNzsmQwytlPOGL7Oj567qUPbyFx2fW75r06r4EsPWr38dnqGILpSaBMo
        kzHuGlhbRmO0fN70VfZRXUSRQok6uvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-D9-zAhTzM_WFgjwiPFi3ug-1; Fri, 07 Feb 2020 05:54:33 -0500
X-MC-Unique: D9-zAhTzM_WFgjwiPFi3ug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A6AF1800D42;
        Fri,  7 Feb 2020 10:54:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F93C5DA7C;
        Fri,  7 Feb 2020 10:54:29 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 017AsTaa032760;
        Fri, 7 Feb 2020 05:54:29 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 017AsTAU032756;
        Fri, 7 Feb 2020 05:54:29 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 7 Feb 2020 05:54:29 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: fix incorrect flush sequence
 when doing SSD" failed to apply to 4.19-stable tree
In-Reply-To: <15810716881950@kroah.com>
Message-ID: <alpine.LRH.2.02.2002070553070.30271@file01.intranet.prod.int.rdu2.redhat.com>
References: <15810716881950@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, 7 Feb 2020, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

Here I'm sending updated patch for 4.19.

Mikulas
 

commit aa9509209c5ac2f0b35d01a922bf9ae072d0c2fc
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Jan 8 10:46:05 2020 -0500

    dm writecache: fix incorrect flush sequence when doing SSD mode commit
    
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

---
 drivers/md/dm-writecache.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

Index: linux-stable/drivers/md/dm-writecache.c
===================================================================
--- linux-stable.orig/drivers/md/dm-writecache.c	2020-02-07 11:49:46.000000000 +0100
+++ linux-stable/drivers/md/dm-writecache.c	2020-02-07 11:50:11.000000000 +0100
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

