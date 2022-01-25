Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC2049BA8C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244870AbiAYRn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378615AbiAYRnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:43:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C55C06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:43:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 627D5B819AB
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786A4C340E0;
        Tue, 25 Jan 2022 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643132587;
        bh=MQUS3iT75OkoXcsIUKkME9bB0+3JQlEj9tIFMuFI7Rc=;
        h=Subject:To:From:Date:From;
        b=XUDyHV/ZqPa2HZCaWwhPnwFnoR0SmLsmz8Z3si8VidF0P8QyAGdOz3ZgW5c+75R4S
         XNny+YLBl6hteBi9PNjtZ76M13svlOfORFaSr5j9a5x6JdFvVXlcEBeJ61rTq4zpV9
         f4D9UoPXsNHlo3x4QdXwjgAT8g5BV0dXdZDIPvQM=
Subject: patch "usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux@weissschuh.net, mail@vacharakis.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 18:43:04 +0100
Message-ID: <164313258465106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5b67b315037250a61861119683e7fcb509deea25 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 24 Jan 2022 15:14:40 -0500
Subject: usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Two people have reported (and mentioned numerous other reports on the
web) that VIA's VL817 USB-SATA bridge does not work with the uas
driver.  Typical log messages are:

[ 3606.232149] sd 14:0:0:0: [sdg] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
[ 3606.232154] sd 14:0:0:0: [sdg] tag#2 CDB: Write(16) 8a 00 00 00 00 00 18 0c c9 80 00 00 00 80 00 00
[ 3606.306257] usb 4-4.4: reset SuperSpeed Plus Gen 2x1 USB device number 11 using xhci_hcd
[ 3606.328584] scsi host14: uas_eh_device_reset_handler success

Surprisingly, the devices do seem to work okay for some other people.
The cause of the differing behaviors is not known.

In the hope of getting the devices to work for the most users, even at
the possible cost of degraded performance for some, this patch adds an
unusual_devs entry for the VL817 to block it from binding to the uas
driver by default.  Users will be able to override this entry by means
of a module parameter, if they want.

CC: <stable@vger.kernel.org>
Reported-by: DocMAX <mail@vacharakis.de>
Reported-and-tested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/Ye8IsK2sjlEv1rqU@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 29191d33c0e3..1a05e3dcfec8 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2301,6 +2301,16 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
 		US_FL_SCM_MULT_TARG ),
 
+/*
+ * Reported by DocMAX <mail@vacharakis.de>
+ * and Thomas Weißschuh <linux@weissschuh.net>
+ */
+UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+		"VIA Labs, Inc.",
+		"VL817 SATA Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
-- 
2.35.0


