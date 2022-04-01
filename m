Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02084EF7AA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiDAQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 12:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348920AbiDAQFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 12:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856D51A61D0
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 08:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D27160EC3
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 15:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC31C2BBE4;
        Fri,  1 Apr 2022 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648827048;
        bh=abqarGtXeUe3d1vHtGj1eww477S9vpFeaJy9TLE/bbM=;
        h=Subject:To:Cc:From:Date:From;
        b=jyitI9L6S46HflLwSOJCETDSND2ImkDk3qpITao46VwYJoFKF1o+LumtEXIjb0AG0
         OhiQk8kpyq964fpMAfnWivzj9sNCTEuCv3Lx1SEcOkxL20Gau+SE58CNqhnZuftRcn
         dpWthNhhRN9CFpKmB+Zx3YSQjFNE+9e4iZ6D0wD8=
Subject: FAILED: patch "[PATCH] scsi: scsi_debug: Fix qc_lock use in sdebug_blk_mq_poll()" failed to apply to 5.17-stable tree
To:     damien.lemoal@opensource.wdc.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 17:30:46 +0200
Message-ID: <1648827046150105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3fd07aecb75003fbcb0b7c3124d12f71ffd360d8 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Tue, 1 Mar 2022 20:30:09 +0900
Subject: [PATCH] scsi: scsi_debug: Fix qc_lock use in sdebug_blk_mq_poll()

The use of the 'locked' boolean variable to control locking and unlocking
of the qc_lock spinlock of struct sdebug_queue confuses sparse, leading to
a warning about an unexpected unlock. Simplify the qc_lock lock/unlock
handling code of this function to avoid this warning by removing the
'locked' boolean variable. This change also fixes unlocked access to the
in_use_bm bitmap with the find_first_bit() function.

Link: https://lore.kernel.org/r/20220301113009.595857-3-damien.lemoal@opensource.wdc.com
Fixes: b05d4e481eff ("scsi: scsi_debug: Refine sdebug_blk_mq_poll()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f4e97f2224b2..25fa8e93f5a8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7509,7 +7509,6 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 {
 	bool first;
 	bool retiring = false;
-	bool locked = false;
 	int num_entries = 0;
 	unsigned int qc_idx = 0;
 	unsigned long iflags;
@@ -7525,11 +7524,9 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	if (qc_idx >= sdebug_max_queue)
 		return 0;
 
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
+
 	for (first = true; first || qc_idx + 1 < sdebug_max_queue; )   {
-		if (!locked) {
-			spin_lock_irqsave(&sqp->qc_lock, iflags);
-			locked = true;
-		}
 		if (first) {
 			first = false;
 			if (!test_bit(qc_idx, sqp->in_use_bm))
@@ -7586,14 +7583,15 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 		}
 		WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_NONE);
 		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
-		locked = false;
 		scsi_done(scp); /* callback to mid level */
 		num_entries++;
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
 		if (find_first_bit(sqp->in_use_bm, sdebug_max_queue) >= sdebug_max_queue)
-			break;	/* if no more then exit without retaking spinlock */
+			break;
 	}
-	if (locked)
-		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+
+	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+
 	if (num_entries > 0)
 		atomic_add(num_entries, &sdeb_mq_poll_count);
 	return num_entries;

