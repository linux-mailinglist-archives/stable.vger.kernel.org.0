Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE111AD88
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfLKOdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKOdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:33:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2552F20836;
        Wed, 11 Dec 2019 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074796;
        bh=RIF4bqLGH44MmSCFpmedln1ar4nzwME1hJBIheQsjhw=;
        h=Subject:To:From:Date:From;
        b=TNjlH8A5Z/y/NmCEcDo65dRxhE5TaOgYk5p+30FVyMrdhT22o8Y0jGsGM88CyVDlJ
         EZo7TTXpqgWal6XWkPe6xZDeGdCMe1hAUNL76gBMmK8nsqxnqGHtXkK320uFToXL8L
         Zm566xwY/KilQl1ftDThu2md3WLUhmzX/OO1yV9A=
Subject: patch "xhci: Increase STS_HALT timeout in xhci_suspend()" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:33:10 +0100
Message-ID: <1576074790116198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Increase STS_HALT timeout in xhci_suspend()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7c67cf6658cec70d8a43229f2ce74ca1443dc95e Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 11 Dec 2019 16:20:05 +0200
Subject: xhci: Increase STS_HALT timeout in xhci_suspend()

I've recently observed failed xHCI suspend attempt on AMD Raven Ridge
system:
kernel: xhci_hcd 0000:04:00.4: WARN: xHC CMD_RUN timeout
kernel: PM: suspend_common(): xhci_pci_suspend+0x0/0xd0 returns -110
kernel: PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -110
kernel: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -110
kernel: PM: Device 0000:04:00.4 failed to suspend async: error -110

Similar to commit ac343366846a ("xhci: Increase STS_SAVE timeout in
xhci_suspend()") we also need to increase the HALT timeout to make it be
able to suspend again.

Cc: <stable@vger.kernel.org> # 5.2+
Fixes: f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c5ee562c4c74..dbac0fa9748d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -970,7 +970,7 @@ static bool xhci_pending_portevent(struct xhci_hcd *xhci)
 int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 {
 	int			rc = 0;
-	unsigned int		delay = XHCI_MAX_HALT_USEC;
+	unsigned int		delay = XHCI_MAX_HALT_USEC * 2;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 	u32			res;
-- 
2.24.1


