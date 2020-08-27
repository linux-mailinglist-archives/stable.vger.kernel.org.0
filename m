Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57850253F17
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgH0H0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgH0H0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005BA22BEA;
        Thu, 27 Aug 2020 07:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513176;
        bh=cd8u4RsVIhMJm40P15D4D6mO9JWstGhkWH52kIrejRE=;
        h=Subject:To:From:Date:From;
        b=0566Cl/UNyywWebY8tmbi08aoBRf8I76AsuUKoSiDJ6/EO9dhfwgzj058+a/UhI88
         fBiOhOHsK1EogUT7GJGPAuk9m3e4+gKrzBfwlm+TkxxzEAByrjGtsttfSmGsbjEWz0
         3RdBJyxh6h0BxvH7ErNY0gdQU41FTCUm76d6T76Y=
Subject: patch "USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge" added to usb-linus
To:     tipecaml@gmail.com, brice.goglin@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Aug 2020 09:26:22 +0200
Message-ID: <159851318222376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9aa37788e7ebb3f489fb4b71ce07adadd444264a Mon Sep 17 00:00:00 2001
From: Cyril Roelandt <tipecaml@gmail.com>
Date: Tue, 25 Aug 2020 23:22:31 +0200
Subject: USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

This device does not support UAS properly and a similar entry already
exists in drivers/usb/storage/unusual_uas.h. Without this patch,
storage_probe() defers the handling of this device to UAS, which cannot
handle it either.

Tested-by: Brice Goglin <brice.goglin@gmail.com>
Fixes: bc3bdb12bbb3 ("usb-storage: Disable UAS on JMicron SATA enclosure")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
Link: https://lore.kernel.org/r/20200825212231.46309-1-tipecaml@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 220ae2c356ee..5732e9691f08 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2328,7 +2328,7 @@ UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x0114,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_BROKEN_FUA ),
+		US_FL_BROKEN_FUA | US_FL_IGNORE_UAS ),
 
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
-- 
2.28.0


