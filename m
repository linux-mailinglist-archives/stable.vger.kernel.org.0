Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED79A99BDE
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404608AbfHVR0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404601AbfHVR0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:06 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED09B2064A;
        Thu, 22 Aug 2019 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494765;
        bh=2NbwNo3m3NzWCKEbeiublQr9YuP/TvQuuTKe1d/ku7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9aJpZytQaqbWHrZ9QumKTTYS7y+8r4KYTd3w0jngYRobNlcc1L3LKt8Ea29RnjCg
         SJY0uwwflE1we/sWtm7Lgk5QeJHrr1/qhX9zBnleXOrFOXKWUXip6/RJhMd4XwN8xK
         BQ5hPqBvzDwjAKyM5gG/gLaroQbo/OfAXqRzuaXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jeffery <djeffery@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19 68/85] dm: disable DISCARD if the underlying storage no longer supports it
Date:   Thu, 22 Aug 2019 10:19:41 -0700
Message-Id: <20190822171734.134038101@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Reported-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[Salvatore Bonaccorso: backported to 4.19: Adjust for context changes in
drivers/md/dm-core.h]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-core.h |    1 +
 drivers/md/dm-rq.c   |   11 +++++++----
 drivers/md/dm.c      |   20 ++++++++++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -130,6 +130,7 @@ struct mapped_device {
 };
 
 int md_in_flight(struct mapped_device *md);
+void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
 
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -295,11 +295,14 @@ static void dm_done(struct request *clon
 	}
 
 	if (unlikely(error == BLK_STS_TARGET)) {
-		if (req_op(clone) == REQ_OP_WRITE_SAME &&
-		    !clone->q->limits.max_write_same_sectors)
+		if (req_op(clone) == REQ_OP_DISCARD &&
+		    !clone->q->limits.max_discard_sectors)
+			disable_discard(tio->md);
+		else if (req_op(clone) == REQ_OP_WRITE_SAME &&
+			 !clone->q->limits.max_write_same_sectors)
 			disable_write_same(tio->md);
-		if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
-		    !clone->q->limits.max_write_zeroes_sectors)
+		else if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
+			 !clone->q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(tio->md);
 	}
 
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -910,6 +910,15 @@ static void dec_pending(struct dm_io *io
 	}
 }
 
+void disable_discard(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support DISCARD, disable it */
+	limits->max_discard_sectors = 0;
+	blk_queue_flag_clear(QUEUE_FLAG_DISCARD, md->queue);
+}
+
 void disable_write_same(struct mapped_device *md)
 {
 	struct queue_limits *limits = dm_get_queue_limits(md);
@@ -935,11 +944,14 @@ static void clone_endio(struct bio *bio)
 	dm_endio_fn endio = tio->ti->type->end_io;
 
 	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
-		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-		    !bio->bi_disk->queue->limits.max_write_same_sectors)
+		if (bio_op(bio) == REQ_OP_DISCARD &&
+		    !bio->bi_disk->queue->limits.max_discard_sectors)
+			disable_discard(md);
+		else if (bio_op(bio) == REQ_OP_WRITE_SAME &&
+			 !bio->bi_disk->queue->limits.max_write_same_sectors)
 			disable_write_same(md);
-		if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
-		    !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
+		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
+			 !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(md);
 	}
 


