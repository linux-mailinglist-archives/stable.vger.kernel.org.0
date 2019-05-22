Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8503D262FE
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfEVLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 07:31:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:39534 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbfEVLbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 07:31:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 04:31:47 -0700
X-ExtLoop1: 1
Received: from mattu-haswell.fi.intel.com ([10.237.72.164])
  by orsmga003.jf.intel.com with ESMTP; 22 May 2019 04:31:45 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5/5] xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()
Date:   Wed, 22 May 2019 14:34:01 +0300
Message-Id: <1558524841-25397-6-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558524841-25397-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1558524841-25397-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

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
---
 drivers/usb/host/xhci.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 048a675..20db378 100644
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
2.7.4

