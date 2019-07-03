Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BC45E32C
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGCLvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 07:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfGCLvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 07:51:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43DA218AD;
        Wed,  3 Jul 2019 11:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562154701;
        bh=XPDxoQ1rMJT/sODKFIXcGOxDJ2pz/anE1UZ1U+pyLj8=;
        h=Subject:To:From:Date:From;
        b=H4tRi+FP/eRfOmcNr/EdmrdtITTFvUskTnYcVwzIRdFZhePrlFmFnUUDCDP3+LOau
         U7b2AkiTjmsP5mvVsJ9gAlQFvmz4mk85VA962HhcHY6EH58+K6apFXaNx59+10x4uO
         DGa24aDOzBjC5imBPWLnGKOd0X17SbDmXeDw3RnQ=
Subject: patch "usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()" added to usb-testing
To:     martin.blumenstingl@googlemail.com, felipe.balbi@linux.intel.com,
        hminas@synopsys.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 13:51:15 +0200
Message-ID: <1562154675113191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From dfc4fdebc5d62ac4e2fe5428e59b273675515fb2 Mon Sep 17 00:00:00 2001
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 20 Jun 2019 19:50:22 +0200
Subject: usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()

Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
consistent with the other "wait for AHB master IDLE state" ocurrences.

This fixes a problem for me where dwc2 would not want to initialize when
updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
4.14.
Testing on my board shows that it takes 180us until AHB master IDLE
state is signalled. The very old vendor driver for this SoC (ifxhcd)
used a 1 second timeout.
Use the same timeout that is used everywhere when polling for
GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
(180us in my case) to have consistent behavior across the dwc2 driver.

Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/dwc2/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index 8b499d643461..8e41d70fd298 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -531,7 +531,7 @@ int dwc2_core_reset(struct dwc2_hsotg *hsotg, bool skip_wait)
 	}
 
 	/* Wait for AHB master IDLE state */
-	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 50)) {
+	if (dwc2_hsotg_wait_bit_set(hsotg, GRSTCTL, GRSTCTL_AHBIDLE, 10000)) {
 		dev_warn(hsotg->dev, "%s: HANG! AHB Idle timeout GRSTCTL GRSTCTL_AHBIDLE\n",
 			 __func__);
 		return -EBUSY;
-- 
2.22.0


