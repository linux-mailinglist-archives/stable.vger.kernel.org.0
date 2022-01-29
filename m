Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361624A2FD0
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345839AbiA2Nbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239973AbiA2Nbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:31:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E639C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 05:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EED3B81211
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8132C340E5;
        Sat, 29 Jan 2022 13:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643463110;
        bh=YAb0z9d2XgshovK93GMTRTEIB0IJ8PiyPQR19/ivTaQ=;
        h=Subject:To:Cc:From:Date:From;
        b=l65gQDvdOFSx0gEs4hZaZwWitfdFKTnNR1oNkw29enE9/STtooR+FFOiPzyDDwFkV
         tWQUcnLi2tEa3qV7JuQbNSJTun5H0DXNZoiZOEbO4dMK8ufKvUWekNqiG2A4r+npYR
         4McKrrVLTkBCcS8eRBB2voLEVGdffFWOFyyxn9X0=
Subject: FAILED: patch "[PATCH] dm: revert partial fix for redundant bio-based IO accounting" failed to apply to 5.10-stable tree
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:31:34 +0100
Message-ID: <164346309416313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f524d9c95fab54783d0038f7a3e8c014d5b56857 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 28 Jan 2022 10:58:40 -0500
Subject: [PATCH] dm: revert partial fix for redundant bio-based IO accounting

Reverts a1e1cb72d9649 ("dm: fix redundant IO accounting for bios that
need splitting") because it was too narrow in scope (only addressed
redundant 'sectors[]' accounting and not ios, nsecs[], etc).

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20220128155841.39644-3-snitzer@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c0ae8087c602..9849114b3c08 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1442,9 +1442,6 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->sector = bio->bi_iter.bi_sector;
 }
 
-#define __dm_part_stat_sub(part, field, subnd)	\
-	(part_stat_get(part, field) -= (subnd))
-
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
@@ -1480,18 +1477,6 @@ static void __split_and_process_bio(struct mapped_device *md,
 						  GFP_NOIO, &md->queue->bio_split);
 			ci.io->orig_bio = b;
 
-			/*
-			 * Adjust IO stats for each split, otherwise upon queue
-			 * reentry there will be redundant IO accounting.
-			 * NOTE: this is a stop-gap fix, a proper fix involves
-			 * significant refactoring of DM core's bio splitting
-			 * (by eliminating DM's splitting and just using bio_split)
-			 */
-			part_stat_lock();
-			__dm_part_stat_sub(dm_disk(md)->part0,
-					   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
-			part_stat_unlock();
-
 			bio_chain(b, bio);
 			trace_block_split(b, bio->bi_iter.bi_sector);
 			submit_bio_noacct(bio);

