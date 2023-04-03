Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59976D3F15
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjDCIfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjDCIfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:35:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F034125
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BAC9B815AC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790B6C433D2;
        Mon,  3 Apr 2023 08:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680510935;
        bh=FF1gvDv3/TYr4yfBE7+b32vwLlzHosTybT1C8RB6RYY=;
        h=Subject:To:Cc:From:Date:From;
        b=Sp8r9zgP69HFIqvuDezGUbht8sPkxDoTo0q5Kfm8rYF/BGEBw0xdi7Xhc/gRuTDq7
         LWO7jrVZVljNi11WHiAhx2gBflhhgaMsYnbI1PB7FA2fWdWRW8PPPBqUOjuwBNYRYz
         6+06t4i2YuTd8VLOQdB7XJFheRAUFiwO7d3qVfBk=
Subject: FAILED: patch "[PATCH] dm: fix improper splitting for abnormal bios" failed to apply to 6.2-stable tree
To:     snitzer@kernel.org, orange@aiven.io
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:35:33 +0200
Message-ID: <2023040332-dodgy-chamomile-54f5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x f7b58a69fad9d2c4c90cab0247811155dd0d48e7
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040332-dodgy-chamomile-54f5@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

f7b58a69fad9 ("dm: fix improper splitting for abnormal bios")
86a3238c7b9b ("dm: change "unsigned" to "unsigned int"")
7533afa1d27b ("dm: send just one event on resize, not two")
5cd6d1d53a1f ("dm integrity: Remove bi_sector that's only used by commented debug code")
22c40e134c4c ("dm cache: Add some documentation to dm-cache-background-tracker.h")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7b58a69fad9d2c4c90cab0247811155dd0d48e7 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@kernel.org>
Date: Thu, 30 Mar 2023 14:56:38 -0400
Subject: [PATCH] dm: fix improper splitting for abnormal bios

"Abnormal" bios include discards, write zeroes and secure erase. By no
longer passing the calculated 'len' pointer, commit 7dd06a2548b2 ("dm:
allow dm_accept_partial_bio() for dm_io without duplicate bios") took a
senseless approach to disallowing dm_accept_partial_bio() from working
for duplicate bios processed using __send_duplicate_bios().

It inadvertently and incorrectly stopped the use of 'len' when
initializing a target's io (in alloc_tio). As such the resulting tio
could address more area of a device than it should.

For example, when discarding an entire DM striped device with the
following DM table:
 vg-lvol0: 0 159744 striped 2 128 7:0 2048 7:1 2048
 vg-lvol0: 159744 45056 striped 2 128 7:2 2048 7:3 2048

Before this fix:

 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=102400
 blkdiscard: attempt to access beyond end of device
 loop0: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=102400
 blkdiscard: attempt to access beyond end of device
 loop1: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

After this fix;

 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=79872
 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=79872

Fixes: 7dd06a2548b2 ("dm: allow dm_accept_partial_bio() for dm_io without duplicate bios")
Cc: stable@vger.kernel.org
Reported-by: Orange Kao <orange@aiven.io>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2d0f934ba6e6..e67a2757c53e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1467,7 +1467,8 @@ static void setup_split_accounting(struct clone_info *ci, unsigned int len)
 }
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
-				struct dm_target *ti, unsigned int num_bios)
+				struct dm_target *ti, unsigned int num_bios,
+				unsigned *len)
 {
 	struct bio *bio;
 	int try;
@@ -1478,7 +1479,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		if (try)
 			mutex_lock(&ci->io->md->table_devices_lock);
 		for (bio_nr = 0; bio_nr < num_bios; bio_nr++) {
-			bio = alloc_tio(ci, ti, bio_nr, NULL,
+			bio = alloc_tio(ci, ti, bio_nr, len,
 					try ? GFP_NOIO : GFP_NOWAIT);
 			if (!bio)
 				break;
@@ -1514,7 +1515,7 @@ static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		break;
 	default:
 		/* dm_accept_partial_bio() is not supported with shared tio->len_ptr */
-		alloc_multiple_bios(&blist, ci, ti, num_bios);
+		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 			__map_bio(clone);

