Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4ABD472F12
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhLMOYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbhLMOYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:24:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95594C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:24:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 354AB610A0
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11412C34601;
        Mon, 13 Dec 2021 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639405443;
        bh=Ogz7q8dXVlnLTXqoJI9OHtkf0mrSY6EkafWaph89JgQ=;
        h=Subject:To:From:Date:From;
        b=X8Sl9AgwuXN6HGU/dKA+MX8AgDQOa1OPe8SBIxeBKoTEzXX7ubVrYba2cdWjHVnHp
         yhgUxlQabG7KDjfUOqvG3zjFTygLPS07SvddLtXaup0mEaJ6Pei+aqAsxd3hVWmKeF
         CXHfZUNeHl38W8HDul/eI/cwUgXiXyMdND7ezb+U=
Subject: patch "usb: cdnsp: Fix incorrect calling of cdnsp_died function" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 15:23:50 +0100
Message-ID: <163940543016846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix incorrect calling of cdnsp_died function

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 16f00d969afe60e233c1a91af7ac840df60d3536 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Fri, 10 Dec 2021 12:29:45 +0100
Subject: usb: cdnsp: Fix incorrect calling of cdnsp_died function

Patch restrict calling of cdnsp_died function during removing modules
or software disconnect.
This function was called because after transition controller to HALT
state the driver starts handling the deferred interrupt.
In this case such interrupt can be simple ignored.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211210112945.660-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 1b1438457fb0..e1ac6c398bd3 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1523,7 +1523,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
-		cdnsp_died(pdev);
+		/*
+		 * While removing or stopping driver there may still be deferred
+		 * not handled interrupt which should not be treated as error.
+		 * Driver should simply ignore it.
+		 */
+		if (pdev->gadget_driver)
+			cdnsp_died(pdev);
+
 		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}
-- 
2.34.1


