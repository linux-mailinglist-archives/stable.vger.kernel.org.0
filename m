Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1691388D70
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfHJUqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55268 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00053p-W8; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cu-Vx; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "David Jeffery" <djeffery@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.380103166@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 068/157] dm: disable DISCARD if the underlying
 storage no longer supports it
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit bcb44433bba5eaff293888ef22ffa07f1f0347d6 upstream.

Storage devices which report supporting discard commands like
WRITE_SAME_16 with unmap, but reject discard commands sent to the
storage device.  This is a clear storage firmware bug but it doesn't
change the fact that should a program cause discards to be sent to a
multipath device layered on this buggy storage, all paths can end up
failed at the same time from the discards, causing possible I/O loss.

The first discard to a path will fail with Illegal Request, Invalid
field in cdb, e.g.:
 kernel: sd 8:0:8:19: [sdfn] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
 kernel: sd 8:0:8:19: [sdfn] tag#0 Sense Key : Illegal Request [current]
 kernel: sd 8:0:8:19: [sdfn] tag#0 Add. Sense: Invalid field in cdb
 kernel: sd 8:0:8:19: [sdfn] tag#0 CDB: Write same(16) 93 08 00 00 00 00 00 a0 08 00 00 00 80 00 00 00
 kernel: blk_update_request: critical target error, dev sdfn, sector 10487808

The SCSI layer converts this to the BLK_STS_TARGET error number, the sd
device disables its support for discard on this path, and because of the
BLK_STS_TARGET error multipath fails the discard without failing any
path or retrying down a different path.  But subsequent discards can
cause path failures.  Any discards sent to the path which already failed
a discard ends up failing with EIO from blk_cloned_rq_check_limits with
an "over max size limit" error since the discard limit was set to 0 by
the sd driver for the path.  As the error is EIO, this now fails the
path and multipath tries to send the discard down the next path.  This
cycle continues as discards are sent until all paths fail.

Fix this by training DM core to disable DISCARD if the underlying
storage already did so.

Also, fix branching in dm_done() and clone_endio() to reflect the
mutually exclussive nature of the IO operations in question.

Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.16:
 - Keep using op & flag to check operation type
 - Keep using bdev_get_queue() to find queue in clone_endio()
 - WRITE_ZEROES is not handled
 - Use queue_flag_clear() instead of blk_queue_flag_clear()
 - Adjust filenames, context
 - Declare disable_discard() static as its only user is in the same
   source file]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -756,6 +756,15 @@ static void dec_pending(struct dm_io *io
 	}
 }
 
+static void disable_discard(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support DISCARD, disable it */
+	limits->max_discard_sectors = 0;
+	queue_flag_clear(QUEUE_FLAG_DISCARD, md->queue);
+}
+
 static void disable_write_same(struct mapped_device *md)
 {
 	struct queue_limits *limits = dm_get_queue_limits(md);
@@ -792,9 +801,14 @@ static void clone_endio(struct bio *bio,
 		}
 	}
 
-	if (unlikely(r == -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
-		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
-		disable_write_same(md);
+	if (unlikely(r == -EREMOTEIO)) {
+		if (bio->bi_rw & REQ_DISCARD &&
+		    !bdev_get_queue(bio->bi_bdev)->limits.max_discard_sectors)
+			disable_discard(md);
+		else if (bio->bi_rw & REQ_WRITE_SAME &&
+			 !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+ 			disable_write_same(md);
+	}
 
 	free_tio(md, tio);
 	dec_pending(io, error);
@@ -996,9 +1010,14 @@ static void dm_done(struct request *clon
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(r == -EREMOTEIO && (clone->cmd_flags & REQ_WRITE_SAME) &&
-		     !clone->q->limits.max_write_same_sectors))
-		disable_write_same(tio->md);
+	if (unlikely(r == -EREMOTEIO)) {
+		if (clone->cmd_flags & REQ_DISCARD &&
+		    !clone->q->limits.max_discard_sectors)
+			disable_discard(tio->md);
+		else if (clone->cmd_flags & REQ_WRITE_SAME &&
+			 !clone->q->limits.max_write_same_sectors)
+			disable_write_same(tio->md);
+	}
 
 	if (r <= 0)
 		/* The target wants to complete the I/O */

