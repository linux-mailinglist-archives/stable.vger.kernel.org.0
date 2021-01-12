Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E31A2F35A4
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406839AbhALQYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406688AbhALQYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 11:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CE42080D;
        Tue, 12 Jan 2021 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610468641;
        bh=PFPzMJSd7PZL3pkAEOSixJaWNaCqX5AEwvhVI0Sgwdc=;
        h=Subject:To:From:Date:From;
        b=cbyyXNi56q4OGav7EVAiFBwC6IcDyF/GqcVqXmKRsV2dSmzxpF0kX8xuInD2tP5d4
         Cg1kMcD4xCTsBczxInmARcKaAyAcsmJJneoTRjQpSmd6VaVS+kP96sVGW3bZ3bgpt6
         Uf+YIOeSCQbYDPbjO19ZsCsJvzJn4uBAWQ8bMrYw=
Subject: patch "USB: ehci: fix an interrupt calltrace error" added to usb-linus
To:     liulongfang@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Jan 2021 17:25:09 +0100
Message-ID: <16104687092528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: ehci: fix an interrupt calltrace error

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 643a4df7fe3f6831d14536fd692be85f92670a52 Mon Sep 17 00:00:00 2001
From: Longfang Liu <liulongfang@huawei.com>
Date: Tue, 12 Jan 2021 09:57:27 +0800
Subject: USB: ehci: fix an interrupt calltrace error

The system that use Synopsys USB host controllers goes to suspend
when using USB audio player. This causes the USB host controller
continuous send interrupt signal to system, When the number of
interrupts exceeds 100000, the system will forcibly close the
interrupts and output a calltrace error.

When the system goes to suspend, the last interrupt is reported to
the driver. At this time, the system has set the state to suspend.
This causes the last interrupt to not be processed by the system and
not clear the interrupt flag. This uncleared interrupt flag constantly
triggers new interrupt event. This causing the driver to receive more
than 100,000 interrupts, which causes the system to forcibly close the
interrupt report and report the calltrace error.

so, when the driver goes to sleep and changes the system state to
suspend, the interrupt flag needs to be cleared.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1610416647-45774-1-git-send-email-liulongfang@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-hub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 087402aec5cb..9f9ab5ccea88 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -345,6 +345,9 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 
 	unlink_empty_async_suspended(ehci);
 
+	/* Some Synopsys controllers mistakenly leave IAA turned on */
+	ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+
 	/* Any IAA cycle that started before the suspend is now invalid */
 	end_iaa_cycle(ehci);
 	ehci_handle_start_intr_unlinks(ehci);
-- 
2.30.0


