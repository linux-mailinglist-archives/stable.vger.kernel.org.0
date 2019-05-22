Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC39263CA
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfEVM1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 08:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfEVM1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 08:27:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BF0217F9;
        Wed, 22 May 2019 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558528061;
        bh=V54A063z0Jj+wfqry3189rq7GGfM0uuGOEv+kFc6rmc=;
        h=Subject:To:From:Date:From;
        b=0KD20lPu+Cy/Pt+vn4xer1DXcapOBfI/ASFZu5i4Oz578wQ6LUUchk5vPamY0ltTL
         Q5bzS2LTBkJb18GhSzc3dv+8FWZOmAfBKnU25bZRh+GEgLjtDwNvIzcoZObqXb7q8H
         eD0akiT7j7DTQrTLFIIJJ0pzToHpbTFgJqv/LIyg=
Subject: patch "xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()" added to usb-linus
To:     andrew.smirnov@gmail.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, rrangel@chromium.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 May 2019 14:27:29 +0200
Message-ID: <155852804916633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f7fac17ca925faa03fc5eb854c081a24075f8bad Mon Sep 17 00:00:00 2001
From: Andrey Smirnov <andrew.smirnov@gmail.com>
Date: Wed, 22 May 2019 14:34:01 +0300
Subject: xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Xhci_handshake() implements the algorithm already captured by
readl_poll_timeout_atomic(). Convert the former to use the latter to
avoid repetition.

Turned out this patch also fixes a bug on the AMD Stoneyridge platform
where usleep(1) sometimes takes over 10ms.
This means a 5 second timeout can easily take over 15 seconds which will
trigger the watchdog and reboot the system.

[Add info about patch fixing a bug to commit message -Mathias]
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Tested-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Raul E Rangel <rrangel@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 048a675bbc52..20db378a6012 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
 #include <linux/module.h>
@@ -52,7 +53,6 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
 	return false;
 }
 
-/* TODO: copied from ehci-hcd.c - can this be refactored? */
 /*
  * xhci_handshake - spin reading hc until handshake completes or fails
  * @ptr: address of hc register to be read
@@ -69,18 +69,16 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
 int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
 {
 	u32	result;
+	int	ret;
 
-	do {
-		result = readl(ptr);
-		if (result == ~(u32)0)		/* card removed */
-			return -ENODEV;
-		result &= mask;
-		if (result == done)
-			return 0;
-		udelay(1);
-		usec--;
-	} while (usec > 0);
-	return -ETIMEDOUT;
+	ret = readl_poll_timeout_atomic(ptr, result,
+					(result & mask) == done ||
+					result == U32_MAX,
+					1, usec);
+	if (result == U32_MAX)		/* card removed */
+		return -ENODEV;
+
+	return ret;
 }
 
 /*
-- 
2.21.0


