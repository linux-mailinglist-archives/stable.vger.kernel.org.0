Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574591008BC
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKRPyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfKRPyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 10:54:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAD821934;
        Mon, 18 Nov 2019 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574092462;
        bh=os3tH9kyucZcB+CUY2G9JQjJZzec3Ep0QPlE9s0GWZ0=;
        h=Subject:To:From:Date:From;
        b=qdEXDfevA29vZvL0bGFbRrjds1fj3ZjVfFoGVl9g2oftFg/4NovLH4/HdoxXEcuKK
         h+fsyIWMGgCMtdYmWxbwVp4PtAT3i9cuW8cPrWj/y5p+kU3cCHdALYZoCct4R6NABO
         +3W8GZxCaPUKmc+72sT3Ipen6g16TpZR405es2VU=
Subject: patch "usb: dwc2: use a longer core rest timeout in dwc2_core_reset()" added to usb-next
To:     dev@kresin.me, felipe.balbi@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:52:50 +0100
Message-ID: <1574092370206140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 6689f0f4bb14e50917ba42eb9b41c25e0184970c Mon Sep 17 00:00:00 2001
From: Mathias Kresin <dev@kresin.me>
Date: Sun, 7 Jul 2019 16:22:01 +0200
Subject: usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Testing on different generations of Lantiq MIPS SoC based boards, showed
that it takes up to 1500 us until the core reset bit is cleared.

The driver from the vendor SDK (ifxhcd) uses a 1 second timeout. Use the
same timeout to fix wrong hang detections and make the driver work for
Lantiq MIPS SoCs.

At least till kernel 4.14 the hanging reset only caused a warning but
the driver was probed successful. With kernel 4.19 errors out with
EBUSY.

Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/dwc2/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index 8e41d70fd298..78a4925aa118 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -524,7 +524,7 @@ int dwc2_core_reset(struct dwc2_hsotg *hsotg, bool skip_wait)
 	greset |= GRSTCTL_CSFTRST;
 	dwc2_writel(hsotg, greset, GRSTCTL);
 
-	if (dwc2_hsotg_wait_bit_clear(hsotg, GRSTCTL, GRSTCTL_CSFTRST, 50)) {
+	if (dwc2_hsotg_wait_bit_clear(hsotg, GRSTCTL, GRSTCTL_CSFTRST, 10000)) {
 		dev_warn(hsotg->dev, "%s: HANG! Soft Reset timeout GRSTCTL GRSTCTL_CSFTRST\n",
 			 __func__);
 		return -EBUSY;
-- 
2.24.0


