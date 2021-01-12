Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC0B2F357C
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406564AbhALQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406079AbhALQQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 11:16:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8044422227;
        Tue, 12 Jan 2021 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610468142;
        bh=YXXYylEvUI/9xeB7XFQgpQpyKopRF6w9eBWUrpHYH8w=;
        h=Subject:To:From:Date:From;
        b=WeX7ipk1RFM+CeB8eyp/YSTxu1HqpuNe4gL1rx/2uTUUIcwMoS3eT2rvEVmvfjgDr
         XjdXBtfOm3lhepSKVt6ti7TL5MSW0SqvE93LBjD5m/LZ2bftM7wzJGLws4ub1EAQtY
         QhFtZ2VMV8pU7qPwdpH4Wxy71Es7WGJ7u3f7NizA=
Subject: patch "ehci: fix EHCI host controller initialization sequence" added to usb-linus
To:     ekorenevsky@astralinux.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 Jan 2021 17:16:50 +0100
Message-ID: <161046821014125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ehci: fix EHCI host controller initialization sequence

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 280a9045bb18833db921b316a5527d2b565e9f2e Mon Sep 17 00:00:00 2001
From: Eugene Korenevsky <ekorenevsky@astralinux.ru>
Date: Sun, 10 Jan 2021 20:36:09 +0300
Subject: ehci: fix EHCI host controller initialization sequence

According to EHCI spec, EHCI HC clears USBSTS.HCHalted whenever
USBCMD.RS=1.

However, it is a good practice to wait some time after setting USBCMD.RS
(approximately 100ms) until USBSTS.HCHalted become zero.

Without this waiting, VirtualBox's EHCI virtual HC accidentally hangs
(see BugLink).

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211095
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210110173609.GA17313@himera.home
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-hcd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index e358ae17d51e..1926b328b6aa 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -574,6 +574,7 @@ static int ehci_run (struct usb_hcd *hcd)
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			temp;
 	u32			hcc_params;
+	int			rc;
 
 	hcd->uses_new_polling = 1;
 
@@ -629,9 +630,20 @@ static int ehci_run (struct usb_hcd *hcd)
 	down_write(&ehci_cf_port_reset_rwsem);
 	ehci->rh_state = EHCI_RH_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+
+	/* Wait until HC become operational */
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
+	rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT, 0, 100 * 1000);
+
 	up_write(&ehci_cf_port_reset_rwsem);
+
+	if (rc) {
+		ehci_err(ehci, "USB %x.%x, controller refused to start: %d\n",
+			 ((ehci->sbrn & 0xf0)>>4), (ehci->sbrn & 0x0f), rc);
+		return rc;
+	}
+
 	ehci->last_periodic_enable = ktime_get_real();
 
 	temp = HC_VERSION(ehci, ehci_readl(ehci, &ehci->caps->hc_capbase));
-- 
2.30.0


