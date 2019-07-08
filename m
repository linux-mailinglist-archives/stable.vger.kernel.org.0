Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4BF62435
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389068AbfGHP1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389061AbfGHP13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384342173C;
        Mon,  8 Jul 2019 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599648;
        bh=ZniNPnIxLs5zo56SL2aPcnRxDq6gXxwpSuoRCs+j7ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNDbh2nn8TGX3xb3eDrNwn+LESXEpyz/8s+egKaWsTEO10iDj71A6PAX/DLQ2qdfb
         ynNRnWEK9wy5GsqAYhNCiwN6BI1OjqZ+U2Ees4PtC7LGHQE+vo3zay0laNdS15PBPX
         W2bBTlBk1wiA2PU2gQLWsICqk0qo7UQ5CmXSew9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 03/90] md/raid0: Do not bypass blocking queue entered for raid0 bios
Date:   Mon,  8 Jul 2019 17:12:30 +0200
Message-Id: <20190708150522.409130002@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>

-----------------------------------------------------------------
This patch is not on mainline and is meant to 4.19 stable *only*.
After the patch description there's a reasoning about that.
-----------------------------------------------------------------

Commit cd4a4ae4683d ("block: don't use blocking queue entered for
recursive bio submits") introduced the flag BIO_QUEUE_ENTERED in order
split bios bypass the blocking queue entering routine and use the live
non-blocking version. It was a result of an extensive discussion in
a linux-block thread[0], and the purpose of this change was to prevent
a hung task waiting on a reference to drop.

Happens that md raid0 split bios all the time, and more important,
it changes their underlying device to the raid member. After the change
introduced by this flag's usage, we experience various crashes if a raid0
member is removed during a large write. This happens because the bio
reaches the live queue entering function when the queue of the raid0
member is dying.

A simple reproducer of this behavior is presented below:
a) Build kernel v4.19.56-stable with CONFIG_BLK_DEV_THROTTLING=y.

b) Create a raid0 md array with 2 NVMe devices as members, and mount
it with an ext4 filesystem.

c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
(dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
echo 1 > /sys/block/nvme1n1/device/device/remove
(whereas nvme1n1 is the 2nd array member)

This will trigger the following warning/oops:

------------[ cut here ]------------
BUG: unable to handle kernel NULL pointer dereference at 0000000000000155
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
RIP: 0010:blk_throtl_bio+0x45/0x970
[...]
Call Trace:
 generic_make_request_checks+0x1bf/0x690
 generic_make_request+0x64/0x3f0
 raid0_make_request+0x184/0x620 [raid0]
 ? raid0_make_request+0x184/0x620 [raid0]
 md_handle_request+0x126/0x1a0
 md_make_request+0x7b/0x180
 generic_make_request+0x19e/0x3f0
 submit_bio+0x73/0x140
[...]

This patch changes raid0 driver to fallback to the "old" blocking queue
entering procedure, by clearing the BIO_QUEUE_ENTERED from raid0 bios.
This prevents the crashes and restores the regular behavior of raid0
arrays when a member is removed during a large write.

[0] lore.kernel.org/linux-block/343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp

----------------------------
Why this is not on mainline?
----------------------------

The patch was originally submitted upstream in linux-raid and
linux-block mailing-lists - it was initially accepted by Song Liu,
but Christoph Hellwig[1] observed that there was a clean-up series
ready to be accepted from Ming Lei[2] that fixed the same issue.

The accepted patches from Ming's series in upstream are: commit
47cdee29ef9d ("block: move blk_exit_queue into __blk_release_queue") and
commit fe2008640ae3 ("block: don't protect generic_make_request_checks
with blk_queue_enter"). Those patches basically do a clean-up in the
block layer involving:

1) Putting back blk_exit_queue() logic into __blk_release_queue(); that
path was changed in the past and the logic from blk_exit_queue() was
added to blk_cleanup_queue().

2) Removing the guard/protection in generic_make_request_checks() with
blk_queue_enter().

The problem with Ming's series for -stable is that it relies in the
legacy request IO path removal. So it's "backport-able" to v5.0+,
but doing that for early versions (like 4.19) would incur in complex
code changes. Hence, it was suggested by Christoph and Song Liu that
this patch was submitted to stable only; otherwise merging it upstream
would add code to fix a path removed in a subsequent commit.

[1] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
[2] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: cd4a4ae4683d ("block: don't use blocking queue entered for recursive bio submits")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -547,6 +547,7 @@ static void raid0_handle_discard(struct
 			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
 				discard_bio, disk_devt(mddev->gendisk),
 				bio->bi_iter.bi_sector);
+		bio_clear_flag(bio, BIO_QUEUE_ENTERED);
 		generic_make_request(discard_bio);
 	}
 	bio_endio(bio);
@@ -602,6 +603,7 @@ static bool raid0_make_request(struct md
 				disk_devt(mddev->gendisk), bio_sector);
 	mddev_check_writesame(mddev, bio);
 	mddev_check_write_zeroes(mddev, bio);
+	bio_clear_flag(bio, BIO_QUEUE_ENTERED);
 	generic_make_request(bio);
 	return true;
 }


