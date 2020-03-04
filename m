Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5AC178DE8
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgCDJ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgCDJ6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:58:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920FA20848;
        Wed,  4 Mar 2020 09:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315892;
        bh=3jM7PQiqkx+PVE1UR6H+lfKlfThT7IxQGwShlhEjlrc=;
        h=Subject:To:From:Date:From;
        b=MyPSna2KJjbrCVFQmRAbIJyKYPjiwqsJuNfWOe3O1AGZGule9HSFsCO+HzsueeHMU
         l4rgGF/Rp8ojHXtLQ9OMcWxOgrl4HjDH+hkkIRBgyZhlHPgJ9gtc6hdTHahgQY4VrE
         a0qwftkhGEqtvSZCdi+S8J500/tMJCGgA7L1rdoE=
Subject: patch "usb: storage: Add quirk for Samsung Fit flash" added to usb-linus
To:     jilin@nvidia.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:53 +0100
Message-ID: <15833158732147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: storage: Add quirk for Samsung Fit flash

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 86d92f5465958752481269348d474414dccb1552 Mon Sep 17 00:00:00 2001
From: Jim Lin <jilin@nvidia.com>
Date: Mon, 2 Mar 2020 22:21:35 +0800
Subject: usb: storage: Add quirk for Samsung Fit flash

Current driver has 240 (USB2.0) and 2048 (USB3.0) as max_sectors,
e.g., /sys/bus/scsi/devices/0:0:0:0/max_sectors

If data access times out, driver error handling will issue a port
reset.
Sometimes Samsung Fit (090C:1000) flash disk will not respond to
later Set Address or Get Descriptor command.

Adding this quirk to limit max_sectors to 64 sectors to avoid issue
occurring.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1583158895-31342-1-git-send-email-jilin@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1cd9b6305b06..1880f3e13f57 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1258,6 +1258,12 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
+UNUSUAL_DEV(0x090c, 0x1000, 0x1100, 0x1100,
+		"Samsung",
+		"Flash Drive FIT",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",
-- 
2.25.1


