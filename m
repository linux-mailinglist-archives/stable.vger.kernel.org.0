Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C9F2A3FD1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 10:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCJSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 04:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgKCJSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 04:18:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C869322400;
        Tue,  3 Nov 2020 09:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604395123;
        bh=+rPFEmZoGPxPcc1nfYHfozynz4QZa82cRXE+Ro1yls4=;
        h=Subject:To:From:Date:From;
        b=2GaE8pohiaErFZpkKblP3B0pZYfQOTDscHJKQRCO8NQZnVyZch4MntJF+M6hJKJJu
         ypOFxu49X0Nsb8hvx3D3V9l6Ai6KHrN905KRT4E2RyPjDM5YCF3/N9xi/ls6MpCdAJ
         V46atmv+qnU4cVfnmtIag0QROhbKV0DeHkudazSk=
Subject: patch "USB: Add NO_LPM quirk for Kingston flash drive" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        julroy67@gmail.com, jwrdegoede@fedoraproject.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 10:19:34 +0100
Message-ID: <160439517412187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Add NO_LPM quirk for Kingston flash drive

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From afaa2e745a246c5ab95103a65b1ed00101e1bc63 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 2 Nov 2020 09:58:21 -0500
Subject: USB: Add NO_LPM quirk for Kingston flash drive

In Bugzilla #208257, Julien Humbert reports that a 32-GB Kingston
flash drive spontaneously disconnects and reconnects, over and over.
Testing revealed that disabling Link Power Management for the drive
fixed the problem.

This patch adds a quirk entry for that drive to turn off LPM permanently.

CC: Hans de Goede <jwrdegoede@fedoraproject.org>
CC: <stable@vger.kernel.org>
Reported-and-tested-by: Julien Humbert <julroy67@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201102145821.GA1478741@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 10574fa3f927..a1e3a037a289 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -378,6 +378,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Kingston DataTraveler 3.0 */
+	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
-- 
2.29.2


