Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8511F59D972
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350610AbiHWJjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351276AbiHWJiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:38:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B6469F48;
        Tue, 23 Aug 2022 01:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF8EB81C62;
        Tue, 23 Aug 2022 08:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D1CC433D6;
        Tue, 23 Aug 2022 08:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243980;
        bh=ZUgivN8zhNC9/Vowk6oVJLvlCbVPWbn1Iq8fxa3fI6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMviMhyCdG+yCk0OS6r9kUhpFOBX47cgs9daJMRptZwJYZGMUK1f1sfKhoLd04VTX
         ZIN3AM8H3Wy00rLQEOLC2o/rwjHEaQnEhC9HSvfFaJckDncTFlPMg2KeMBPK6DRh21
         JUqtWAEFC482h4QQttgEN3mg/T6xBnZivYEAnvH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Subject: [PATCH 4.14 037/229] USB: HCD: Fix URB giveback issue in tasklet function
Date:   Tue, 23 Aug 2022 10:23:18 +0200
Message-Id: <20220823080054.902065549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

commit 26c6c2f8a907c9e3a2f24990552a4d77235791e6 upstream.

Usb core introduce the mechanism of giveback of URB in tasklet context to
reduce hardware interrupt handling time. On some test situation(such as
FIO with 4KB block size), when tasklet callback function called to
giveback URB, interrupt handler add URB node to the bh->head list also.
If check bh->head list again after finish all URB giveback of local_list,
then it may introduce a "dynamic balance" between giveback URB and add URB
to bh->head list. This tasklet callback function may not exit for a long
time, which will cause other tasklet function calls to be delayed. Some
real-time applications(such as KB and Mouse) will see noticeable lag.

In order to prevent the tasklet function from occupying the cpu for a long
time at a time, new URBS will not be added to the local_list even though
the bh->head list is not empty. But also need to ensure the left URB
giveback to be processed in time, so add a member high_prio for structure
giveback_urb_bh to prioritize tasklet and schelule this tasklet again if
bh->head list is not empty.

At the same time, we are able to prioritize tasklet through structure
member high_prio. So, replace the local high_prio_bh variable with this
structure member in usb_hcd_giveback_urb.

Fixes: 94dfd7edfd5c ("USB: HCD: support giveback of URB in tasklet context")
Cc: stable <stable@kernel.org>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Link: https://lore.kernel.org/r/20220726074918.5114-1-WeitaoWang-oc@zhaoxin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c  |   26 +++++++++++++++-----------
 include/linux/usb/hcd.h |    1 +
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1814,7 +1814,6 @@ static void usb_giveback_urb_bh(unsigned
 
 	spin_lock_irq(&bh->lock);
 	bh->running = true;
- restart:
 	list_replace_init(&bh->head, &local_list);
 	spin_unlock_irq(&bh->lock);
 
@@ -1828,10 +1827,17 @@ static void usb_giveback_urb_bh(unsigned
 		bh->completing_ep = NULL;
 	}
 
-	/* check if there are new URBs to giveback */
+	/*
+	 * giveback new URBs next time to prevent this function
+	 * from not exiting for a long time.
+	 */
 	spin_lock_irq(&bh->lock);
-	if (!list_empty(&bh->head))
-		goto restart;
+	if (!list_empty(&bh->head)) {
+		if (bh->high_prio)
+			tasklet_hi_schedule(&bh->bh);
+		else
+			tasklet_schedule(&bh->bh);
+	}
 	bh->running = false;
 	spin_unlock_irq(&bh->lock);
 }
@@ -1856,7 +1862,7 @@ static void usb_giveback_urb_bh(unsigned
 void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 {
 	struct giveback_urb_bh *bh;
-	bool running, high_prio_bh;
+	bool running;
 
 	/* pass status to tasklet via unlinked */
 	if (likely(!urb->unlinked))
@@ -1867,13 +1873,10 @@ void usb_hcd_giveback_urb(struct usb_hcd
 		return;
 	}
 
-	if (usb_pipeisoc(urb->pipe) || usb_pipeint(urb->pipe)) {
+	if (usb_pipeisoc(urb->pipe) || usb_pipeint(urb->pipe))
 		bh = &hcd->high_prio_bh;
-		high_prio_bh = true;
-	} else {
+	else
 		bh = &hcd->low_prio_bh;
-		high_prio_bh = false;
-	}
 
 	spin_lock(&bh->lock);
 	list_add_tail(&urb->urb_list, &bh->head);
@@ -1882,7 +1885,7 @@ void usb_hcd_giveback_urb(struct usb_hcd
 
 	if (running)
 		;
-	else if (high_prio_bh)
+	else if (bh->high_prio)
 		tasklet_hi_schedule(&bh->bh);
 	else
 		tasklet_schedule(&bh->bh);
@@ -2900,6 +2903,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 
 	/* initialize tasklets */
 	init_giveback_urb_bh(&hcd->high_prio_bh);
+	hcd->high_prio_bh.high_prio = true;
 	init_giveback_urb_bh(&hcd->low_prio_bh);
 
 	/* enable irqs just before we start the controller,
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -65,6 +65,7 @@
 
 struct giveback_urb_bh {
 	bool running;
+	bool high_prio;
 	spinlock_t lock;
 	struct list_head  head;
 	struct tasklet_struct bh;


