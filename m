Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019CB1B5C82
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgDWNXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgDWNXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:23:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0691320704;
        Thu, 23 Apr 2020 13:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587648222;
        bh=58WxZnyN146G14EIL4CiEjjbEyjkAA56b86ocSNv+oI=;
        h=Subject:To:From:Date:From;
        b=G6cM6I1XBWuSlTFOWY5NE6eqDAJQvLPcLueT0FHPY8uVmfas3KIAi0pc7iWq451yj
         z7qXWvLZ4rVwEkY6puf7xG1JPH/GwBtn53WSdPXRZ4wEKmIPdrNbKcEPyb4HFaZApi
         CkuBb0AWdVF3rejoBxqN0iUJQep3HGNEplC1MtcI=
Subject: patch "usb-storage: Add unusual_devs entry for JMicron JMS566" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tipecaml@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:23:32 +0200
Message-ID: <1587648212254153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add unusual_devs entry for JMicron JMS566

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 94f9c8c3c404ee1f7aaff81ad4f24aec4e34a78b Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 22 Apr 2020 16:14:57 -0400
Subject: usb-storage: Add unusual_devs entry for JMicron JMS566

Cyril Roelandt reports that his JMicron JMS566 USB-SATA bridge fails
to handle WRITE commands with the FUA bit set, even though it claims
to support FUA.  (Oddly enough, a later version of the same bridge,
version 2.03 as opposed to 1.14, doesn't claim to support FUA.  Also
oddly, the bridge _does_ support FUA when using the UAS transport
instead of the Bulk-Only transport -- but this device was blacklisted
for uas in commit bc3bdb12bbb3 ("usb-storage: Disable UAS on JMicron
SATA enclosure") for apparently unrelated reasons.)

This patch adds a usb-storage unusual_devs entry with the BROKEN_FUA
flag.  This allows the bridge to work properly with usb-storage.

Reported-and-tested-by: Cyril Roelandt <tipecaml@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2004221613110.11262-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1880f3e13f57..f6c3681fa2e9 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2323,6 +2323,13 @@ UNUSUAL_DEV(  0x3340, 0xffff, 0x0000, 0x0000,
 		USB_SC_DEVICE,USB_PR_DEVICE,NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Cyril Roelandt <tipecaml@gmail.com> */
+UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x0114,
+		"JMicron",
+		"USB to ATA/ATAPI Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BROKEN_FUA ),
+
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
 		"iRiver",
-- 
2.26.2


