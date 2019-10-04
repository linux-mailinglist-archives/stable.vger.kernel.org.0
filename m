Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7143ACBA7E
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfJDMdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbfJDMdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4C12133F;
        Fri,  4 Oct 2019 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192395;
        bh=TvuxDN8zhy+S45iqaLl3+r4+If/YlR3ZaPWNH4IZBVE=;
        h=Subject:To:From:Date:From;
        b=wiFhoeKZT+l5A1+GD5ZasVLoig+4E+0urXhgTzd2WYaR5L4vEeaQh9M7Ik/hXYboV
         SGaG6jf0cR0ZCPsgCVikUhTRoAFWCKigvHGdSBeOXJn8Cfpfy9vD8dbYvt7DOjP4f8
         5AkrtwLD1MPjvmlrhptJ3bScoM6p8ZA36QdVAonk=
Subject: patch "usb: xhci: wait for CNR controller not ready bit in xhci resume" added to usb-linus
To:     rtseng@nvidia.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:06 +0200
Message-ID: <157019238642197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: wait for CNR controller not ready bit in xhci resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a70bcbc322837eda1ab5994d12db941dc9733a7d Mon Sep 17 00:00:00 2001
From: Rick Tseng <rtseng@nvidia.com>
Date: Fri, 4 Oct 2019 14:59:30 +0300
Subject: usb: xhci: wait for CNR controller not ready bit in xhci resume

NVIDIA 3.1 xHCI card would lose power when moving power state into D3Cold.
Thus we need to wait for CNR bit to clear in xhci resume, just as in
xhci init.

[Minor changes to comment and commit message -Mathias]
Cc: <stable@vger.kernel.org>
Signed-off-by: Rick Tseng <rtseng@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-6-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index aec69d294973..fe8f9ff58015 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1108,6 +1108,18 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		hibernated = true;
 
 	if (!hibernated) {
+		/*
+		 * Some controllers might lose power during suspend, so wait
+		 * for controller not ready bit to clear, just as in xHC init.
+		 */
+		retval = xhci_handshake(&xhci->op_regs->status,
+					STS_CNR, 0, 10 * 1000 * 1000);
+		if (retval) {
+			xhci_warn(xhci, "Controller not ready at resume %d\n",
+				  retval);
+			spin_unlock_irq(&xhci->lock);
+			return retval;
+		}
 		/* step 1: restore register */
 		xhci_restore_registers(xhci);
 		/* step 2: initialize command ring buffer */
-- 
2.23.0


