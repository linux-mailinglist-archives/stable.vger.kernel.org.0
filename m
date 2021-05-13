Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF837FB88
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhEMQeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 12:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhEMQeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 12:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8180861106;
        Thu, 13 May 2021 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620923582;
        bh=+o1GVC59Wx2AtymsegYWPizYkKB1GQcwXYRkGhYOm7s=;
        h=Subject:To:From:Date:From;
        b=Bm00nzMzD57f+Pawdq2Ytn0qttunMTzc1PbvLKihjnf5GGDVtzaor76XLWtim9Pdh
         tOUCUPm/7L+8A6K65SEDrMz1A6BGbiHBFH0xjRGfP9KzmMXx95S14rVquijCDpV2Bb
         OvlTG1J/QUy/BErOLUjCM/cBB50jG+FCaTp540xI=
Subject: patch "Revert "rapidio: fix a NULL pointer dereference when" added to char-misc-linus
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        alex.bou9@gmail.com, kjlu@umn.edu, mporter@kernel.crashing.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 18:32:54 +0200
Message-ID: <1620923574245120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "rapidio: fix a NULL pointer dereference when

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e68b86c7b7c059c0f0ec4bf8adabe63f84a61eb Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:57:11 +0200
Subject: Revert "rapidio: fix a NULL pointer dereference when
 create_workqueue() fails"

This reverts commit 23015b22e47c5409620b1726a677d69e5cd032ba.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit has a memory leak on the error path here, it does
not clean up everything properly.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 23015b22e47c ("rapidio: fix a NULL pointer dereference when create_workqueue() fails")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-45-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
index 50ec53d67a4c..e6c16f04f2b4 100644
--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2138,14 +2138,6 @@ static int riocm_add_mport(struct device *dev,
 	mutex_init(&cm->rx_lock);
 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);
 	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
-	if (!cm->rx_wq) {
-		riocm_error("failed to allocate IBMBOX_%d on %s",
-			    cmbox, mport->name);
-		rio_release_outb_mbox(mport, cmbox);
-		kfree(cm);
-		return -ENOMEM;
-	}
-
 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);
 
 	cm->tx_slot = 0;
-- 
2.31.1


