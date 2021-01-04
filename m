Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77EE2E993E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbhADPyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:54:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbhADPyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1FCB20757;
        Mon,  4 Jan 2021 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775608;
        bh=BtISzQnrDkNUNFWwcL3LUKhHzD1veWYeZfaQqqp9p7s=;
        h=Subject:To:From:Date:From;
        b=crdK6AccXLt/Ve77+3hdyCxwAI0FzW1Ofh0Gt1q8Y2TT9U15YLPN7TpgpqupshbMO
         ogeWXTF/v/GvJB4C2diUIvabOfgEanu7wu6iUy2M3m4WDvoCJc4WcS1j7VXxycRybI
         59UDTQkaOLVtnn7kkd46mGtwprkGPDKDWdf8qD0k=
Subject: patch "usb: gadget: select CONFIG_CRC32" added to usb-linus
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 16:54:54 +0100
Message-ID: <1609775694136137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: select CONFIG_CRC32

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d7889c2020e08caab0d7e36e947f642d91015bd0 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 3 Jan 2021 22:42:17 +0100
Subject: usb: gadget: select CONFIG_CRC32

Without crc32 support, this driver fails to link:

arm-linux-gnueabi-ld: drivers/usb/gadget/function/f_eem.o: in function `eem_unwrap':
f_eem.c:(.text+0x11cc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/usb/gadget/function/f_ncm.o:f_ncm.c:(.text+0x1e40):
more undefined references to `crc32_le' follow

Fixes: 6d3865f9d41f ("usb: gadget: NCM: Add transmit multi-frame.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210103214224.1996535-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 7e47e6223089..2d152571a7de 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -265,6 +265,7 @@ config USB_CONFIGFS_NCM
 	depends on NET
 	select USB_U_ETHER
 	select USB_F_NCM
+	select CRC32
 	help
 	  NCM is an advanced protocol for Ethernet encapsulation, allows
 	  grouping of several ethernet frames into one USB transfer and
@@ -314,6 +315,7 @@ config USB_CONFIGFS_EEM
 	depends on NET
 	select USB_U_ETHER
 	select USB_F_EEM
+	select CRC32
 	help
 	  CDC EEM is a newer USB standard that is somewhat simpler than CDC ECM
 	  and therefore can be supported by more hardware.  Technically ECM and
-- 
2.30.0


