Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC624A44C4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359624AbiAaLc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379406AbiAaLaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F36AC0617AE;
        Mon, 31 Jan 2022 03:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D8261214;
        Mon, 31 Jan 2022 11:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A363C340EE;
        Mon, 31 Jan 2022 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628008;
        bh=IR4qDBZBsb9q2Ri7BZxMKf/izArnxWz5eMQaB0C0emY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0mXjdMAcRMHh+okwT/+QpnPrJ+QUwZk5B2aSM8NfRbIR8u5d4T5u+WcLpAk/ln+H
         xIauLjabVMwSP8KitA4t+XbWCTJ3xA428lC4OjjcUQMAd+OIboVKL8oRZpeCQZ4bcV
         wrZh+wt8CDLozuuF8wu0bxQUhOsF25hhu4BeqwQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 062/200] dm: revert partial fix for redundant bio-based IO accounting
Date:   Mon, 31 Jan 2022 11:55:25 +0100
Message-Id: <20220131105235.663972456@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit f524d9c95fab54783d0038f7a3e8c014d5b56857 upstream.

Reverts a1e1cb72d9649 ("dm: fix redundant IO accounting for bios that
need splitting") because it was too narrow in scope (only addressed
redundant 'sectors[]' accounting and not ios, nsecs[], etc).

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20220128155841.39644-3-snitzer@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1510,9 +1510,6 @@ static void init_clone_info(struct clone
 	ci->sector = bio->bi_iter.bi_sector;
 }
 
-#define __dm_part_stat_sub(part, field, subnd)	\
-	(part_stat_get(part, field) -= (subnd))
-
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
@@ -1548,18 +1545,6 @@ static void __split_and_process_bio(stru
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


