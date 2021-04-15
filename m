Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82CF3602C6
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhDOG4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhDOG4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6909761154;
        Thu, 15 Apr 2021 06:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618469746;
        bh=pkunuDTJO2VhEgjvNDv+mu8EXIUUZCIayJydjv0HUj0=;
        h=Subject:To:From:Date:From;
        b=Pekp3fDGcEOqdePovdfOxaFXWQbGxa4QBUQIMnzRnYjo7U2pftpNKfy2zZjfjlAqo
         mJXvLOKsFkvi7wQaDAcBPpcba8+PzWaWTna/tOco/dZZydMVTkNtmFwlAAsVLiqb1K
         9exvaVGJf8TYmh+T0KA4JnM9oILRNQKKXRLG7gHc=
Subject: patch "USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet" added to usb-next
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 08:55:40 +0200
Message-ID: <1618469740223199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 8f23fe35ff1e5491b4d279323a8209a31f03ae65 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Mon, 12 Apr 2021 21:54:53 +0800
Subject: USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

This is another branded 8153 device that doesn't work well with LPM
enabled:
[ 400.597506] r8152 5-1.1:1.0 enx482ae3a2a6f0: Tx status -71

So disable LPM to resolve the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
BugLink: https://bugs.launchpad.net/bugs/1922651
Link: https://lore.kernel.org/r/20210412135455.791971-1-kai.heng.feng@canonical.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 76ac5d6555ae..6114cf83bb44 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,6 +438,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },
-- 
2.31.1


