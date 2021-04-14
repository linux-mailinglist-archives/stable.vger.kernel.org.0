Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA81435F4B2
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351269AbhDNNVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 09:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243138AbhDNNU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 09:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54791600CD;
        Wed, 14 Apr 2021 13:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618406434;
        bh=mJPWs+Zsdw7OTFCReHuJcHRdVPjeiPP31wTOdi6CexA=;
        h=Subject:To:From:Date:From;
        b=QHqbfk1HavAzea4MtNu2KfYrGufY3zGmrFcLvzMSPJuNFzpTpEfca77cq8v/gwWN0
         eKNPNa4IqjDfbsTRaCknq06vDemW71hNapjPrQXp7x4EdAk8Wig3RL8vqf8fUR66GW
         sVzQm5c3DshtS/pWG3I1MaSXk9PeR7zwUOFFMu4A=
Subject: patch "USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet" added to usb-testing
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Apr 2021 15:20:24 +0200
Message-ID: <161840642440101@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

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


