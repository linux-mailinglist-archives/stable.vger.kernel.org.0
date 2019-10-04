Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA2BCBA80
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJDMdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfJDMdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D1242133F;
        Fri,  4 Oct 2019 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192400;
        bh=IQiixRMKfWfBWzRWUSXlp+p5zWh2M/2g11WDHHNDHHY=;
        h=Subject:To:From:Date:From;
        b=Zz13C6EauCjQzVPFTF/p5yIHX3HkZt3jmwgfiPbHff2zuIdnvsvtXDJyZoVBeXn9u
         /BIR2wLFuKavMZlv/wVEDS5F/bPTemd/d7JtU3y9q4AltRggHdUqOeydBH+9T5HQ5c
         yKGdyC339qfF6SadWB6cNtq5viWZDVa00rA324/M=
Subject: patch "xhci: Increase STS_SAVE timeout in xhci_suspend()" added to usb-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:07 +0200
Message-ID: <157019238787152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Increase STS_SAVE timeout in xhci_suspend()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ac343366846a445bb81f0a0e8f16abb8bd5d5d88 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 4 Oct 2019 14:59:32 +0300
Subject: xhci: Increase STS_SAVE timeout in xhci_suspend()

After commit f7fac17ca925 ("xhci: Convert xhci_handshake() to use
readl_poll_timeout_atomic()"), ASMedia xHCI may fail to suspend.

Although the algorithms are essentially the same, the old max timeout is
(usec + usec * time of doing readl()), and the new max timeout is just
usec, which is much less than the old one.

Increase the timeout to make ASMedia xHCI able to suspend again.

BugLink: https://bugs.launchpad.net/bugs/1844021
Fixes: f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-8-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8c068d0cc7c1..00f3804f7aa7 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1032,7 +1032,7 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 	writel(command, &xhci->op_regs->command);
 	xhci->broken_suspend = 0;
 	if (xhci_handshake(&xhci->op_regs->status,
-				STS_SAVE, 0, 10 * 1000)) {
+				STS_SAVE, 0, 20 * 1000)) {
 	/*
 	 * AMD SNPS xHC 3.0 occasionally does not clear the
 	 * SSS bit of USBSTS and when driver tries to poll
-- 
2.23.0


