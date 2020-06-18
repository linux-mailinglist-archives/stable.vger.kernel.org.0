Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6E1FEDFE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgFRInb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgFRIna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:43:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397FE2089D;
        Thu, 18 Jun 2020 08:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469808;
        bh=CeKPPyzivVcV8AmU+juQjhe6K+bmKN5cbrBJPaKdvn8=;
        h=Subject:To:From:Date:From;
        b=ovVJxD2rI5IGmD8V08a3RXyGOHHw/wDWu97nsr/QIXcXtRKwG40zA29hQxzUIVpUw
         DuB/f9P2/8gaqsBhjZy83XbG4B+NyMrCL54L/J+xgUuU1GwVcJ1izdVePIiFVwOxDs
         TvhrplkdRAK8pZhWp9LgxxjmJSeSZmozAOsl8OQU=
Subject: patch "USB: ohci-sm501: Add missed iounmap() in remove" added to usb-linus
To:     hslester96@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:43:09 +0200
Message-ID: <159246978922846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: ohci-sm501: Add missed iounmap() in remove

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 07c112fb09c86c0231f6ff0061a000ffe91c8eb9 Mon Sep 17 00:00:00 2001
From: Chuhong Yuan <hslester96@gmail.com>
Date: Wed, 10 Jun 2020 10:48:44 +0800
Subject: USB: ohci-sm501: Add missed iounmap() in remove

This driver misses calling iounmap() in remove to undo the ioremap()
called in probe.
Add the missed call to fix it.

Fixes: f54aab6ebcec ("usb: ohci-sm501 driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200610024844.3628408-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-sm501.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index cff965240327..b91d50da6127 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -191,6 +191,7 @@ static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
 	struct resource	*mem;
 
 	usb_remove_hcd(hcd);
+	iounmap(hcd->regs);
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-- 
2.27.0


