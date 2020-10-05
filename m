Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6518E283A11
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgJEPa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgJEPau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF81420B80;
        Mon,  5 Oct 2020 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911844;
        bh=y8Io8YksLWQ3JO0z7ywAZntHC7GYrvZoNv80IByDLOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0W8X9OdC78guCtXCxC9AdYe9ggtvm/NTyLpNTXlZ6qwhRa4IQrKprcVdjiDEZ0PN
         /4JJgWE1ThfayX8rP0cJMZxq7Z0EKVzeVURUT+kHHenwg5g9pSxb/XYB2GVnd/x3uC
         bp12Yp3xwDDT/6FN4OJhDoHf48Hn7afIursGnVQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 47/57] block/diskstats: more accurate approximation of io_ticks for slow disks
Date:   Mon,  5 Oct 2020 17:26:59 +0200
Message-Id: <20201005142112.070155997@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit 2b8bd423614c595540eaadcfbc702afe8e155e50 upstream.

Currently io_ticks is approximated by adding one at each start and end of
requests if jiffies counter has changed. This works perfectly for requests
shorter than a jiffy or if one of requests starts/ends at each jiffy.

If disk executes just one request at a time and they are longer than two
jiffies then only first and last jiffies will be accounted.

Fix is simple: at the end of request add up into io_ticks jiffies passed
since last update rather than just one jiffy.

Example: common HDD executes random read 4k requests around 12ms.

fio --name=test --filename=/dev/sdb --rw=randread --direct=1 --runtime=30 &
iostat -x 10 sdb

Note changes of iostat's "%util" 8,43% -> 99,99% before/after patch:

Before:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0,00     0,00   82,60    0,00   330,40     0,00     8,00     0,96   12,09   12,09    0,00   1,02   8,43

After:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0,00     0,00   82,50    0,00   330,00     0,00     8,00     1,00   12,10   12,10    0,00  12,12  99,99

Now io_ticks does not loose time between start and end of requests, but
for queue-depth > 1 some I/O time between adjacent starts might be lost.

For load estimation "%util" is not as useful as average queue length,
but it clearly shows how often disk queue is completely empty.

Fixes: 5b18b5a73760 ("block: delete part_round_stats and switch to less precise counting")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/iostats.rst |    5 ++++-
 block/bio.c                           |    8 ++++----
 block/blk-core.c                      |    4 ++--
 include/linux/genhd.h                 |    2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/iostats.rst
+++ b/Documentation/admin-guide/iostats.rst
@@ -99,7 +99,7 @@ Field 10 -- # of milliseconds spent doin
 
     Since 5.0 this field counts jiffies when at least one request was
     started or completed. If request runs more than 2 jiffies then some
-    I/O time will not be accounted unless there are other requests.
+    I/O time might be not accounted in case of concurrent requests.
 
 Field 11 -- weighted # of milliseconds spent doing I/Os
     This field is incremented at each I/O start, I/O completion, I/O
@@ -133,6 +133,9 @@ are summed (possibly overflowing the uns
 summed to) and the result given to the user.  There is no convenient
 user interface for accessing the per-CPU counters themselves.
 
+Since 4.19 request times are measured with nanoseconds precision and
+truncated to milliseconds before showing in this interface.
+
 Disks vs Partitions
 -------------------
 
--- a/block/bio.c
+++ b/block/bio.c
@@ -1754,14 +1754,14 @@ defer:
 	schedule_work(&bio_dirty_work);
 }
 
-void update_io_ticks(struct hd_struct *part, unsigned long now)
+void update_io_ticks(struct hd_struct *part, unsigned long now, bool end)
 {
 	unsigned long stamp;
 again:
 	stamp = READ_ONCE(part->stamp);
 	if (unlikely(stamp != now)) {
 		if (likely(cmpxchg(&part->stamp, stamp, now) == stamp)) {
-			__part_stat_add(part, io_ticks, 1);
+			__part_stat_add(part, io_ticks, end ? now - stamp : 1);
 		}
 	}
 	if (part->partno) {
@@ -1777,7 +1777,7 @@ void generic_start_io_acct(struct reques
 
 	part_stat_lock();
 
-	update_io_ticks(part, jiffies);
+	update_io_ticks(part, jiffies, false);
 	part_stat_inc(part, ios[sgrp]);
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_inc_in_flight(q, part, op_is_write(op));
@@ -1795,7 +1795,7 @@ void generic_end_io_acct(struct request_
 
 	part_stat_lock();
 
-	update_io_ticks(part, now);
+	update_io_ticks(part, now, true);
 	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
 	part_stat_add(part, time_in_queue, duration);
 	part_dec_in_flight(q, part, op_is_write(req_op));
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1334,7 +1334,7 @@ void blk_account_io_done(struct request
 		part_stat_lock();
 		part = req->part;
 
-		update_io_ticks(part, jiffies);
+		update_io_ticks(part, jiffies, true);
 		part_stat_inc(part, ios[sgrp]);
 		part_stat_add(part, nsecs[sgrp], now - req->start_time_ns);
 		part_stat_add(part, time_in_queue, nsecs_to_jiffies64(now - req->start_time_ns));
@@ -1376,7 +1376,7 @@ void blk_account_io_start(struct request
 		rq->part = part;
 	}
 
-	update_io_ticks(part, jiffies);
+	update_io_ticks(part, jiffies, false);
 
 	part_stat_unlock();
 }
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -419,7 +419,7 @@ static inline void free_part_info(struct
 	kfree(part->info);
 }
 
-void update_io_ticks(struct hd_struct *part, unsigned long now);
+void update_io_ticks(struct hd_struct *part, unsigned long now, bool end);
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,


