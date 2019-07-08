Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E336243B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389314AbfGHPkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388961AbfGHP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80155204EC;
        Mon,  8 Jul 2019 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599617;
        bh=NfLoLLeH7eSGhcnt96sdNuieZAZctpcByoEAZDD5WGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVSBI8eCUI8pduu6dZ3ab4YGfkGkKmqGdruZPQysN/t5YpATGYn5bNcQ3R1/1tm5y
         EraG5HeSK4v379eaE8a8HILQnnq1jTTfqjzMaOXRk61v7VWjog1kFm7rYpdP+N+HGL
         /CMW/L/QgOrpQ6h0huLdqrTLnMNcLBEej/VfV2mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 02/90] block: Fix a NULL pointer dereference in generic_make_request()
Date:   Mon,  8 Jul 2019 17:12:29 +0200
Message-Id: <20190708150522.353010149@linuxfoundation.org>
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

Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
with device removal triggers a crash") introduced a NULL pointer
dereference in generic_make_request(). The patch sets q to NULL and
enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
which is not taken, and then the 'else' will dereference q in
blk_queue_dying(q).

This patch just moves the 'q = NULL' to a point in which it won't trigger
the oops, although the semantics of this NULLification remains untouched.

A simple test case/reproducer is as follows:
a) Build kernel v4.19.56-stable with CONFIG_BLK_CGROUP=n.

b) Create a raid0 md array with 2 NVMe devices as members, and mount
it with an ext4 filesystem.

c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
(dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
echo 1 > /sys/block/nvme1n1/device/device/remove
(whereas nvme1n1 is the 2nd array member)

This will trigger the following oops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
RIP: 0010:generic_make_request+0x32b/0x400
Call Trace:
 submit_bio+0x73/0x140
 ext4_io_submit+0x4d/0x60
 ext4_writepages+0x626/0xe90
 do_writepages+0x4b/0xe0
[...]

This patch has no functional changes and preserves the md/raid0 behavior
when a member is removed before kernel v4.17.

----------------------------
Why this is not on mainline?
----------------------------

The patch was originally submitted upstream in linux-raid and
linux-block mailing-lists - it was initially accepted by Song Liu,
but Christoph Hellwig[0] observed that there was a clean-up series
ready to be accepted from Ming Lei[1] that fixed the same issue.

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

[0] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
[1] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Eric Ren <renzhengeek@gmail.com>
Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2445,10 +2445,8 @@ blk_qc_t generic_make_request(struct bio
 			flags = 0;
 			if (bio->bi_opf & REQ_NOWAIT)
 				flags = BLK_MQ_REQ_NOWAIT;
-			if (blk_queue_enter(q, flags) < 0) {
+			if (blk_queue_enter(q, flags) < 0)
 				enter_succeeded = false;
-				q = NULL;
-			}
 		}
 
 		if (enter_succeeded) {
@@ -2479,6 +2477,7 @@ blk_qc_t generic_make_request(struct bio
 				bio_wouldblock_error(bio);
 			else
 				bio_io_error(bio);
+			q = NULL;
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);


