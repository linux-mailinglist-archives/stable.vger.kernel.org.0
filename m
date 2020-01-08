Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42B613480D
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgAHQeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgAHQeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 11:34:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E842067D;
        Wed,  8 Jan 2020 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578501290;
        bh=/AXSm+sTlh/4dMbcgEVJENCq/ITQ+rDscyu0oF5+3kg=;
        h=Subject:To:From:Date:From;
        b=F/b19uUAounA8OHMt/fR79RBJSSF+edIh2Gioy9Z6Jx5M0eGXIoD4v3GB2Qrqs+jr
         wcoIBPrMBM1Wne1JV/VCShoHYk1XdbAtfyquxJoMsYCwQ11SDEEblnBgTbuRtVMMus
         yvg181bLxg58/vtUgOVkHrKwniosBREO9kk+E0VY=
Subject: patch "usb: ohci-da8xx: ensure error return on variable error is set" added to usb-linus
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jan 2020 17:34:36 +0100
Message-ID: <15785012763191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: ohci-da8xx: ensure error return on variable error is set

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ba9b40810bb43e6bf73b395012b98633c03f7f59 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Tue, 7 Jan 2020 12:39:01 +0000
Subject: usb: ohci-da8xx: ensure error return on variable error is set

Currently when an error occurs when calling devm_gpiod_get_optional or
calling gpiod_to_irq it causes an uninitialized error return in variable
'error' to be returned.  Fix this by ensuring the error variable is set
from da8xx_ohci->oc_gpio and oc_irq.

Thanks to Dan Carpenter for spotting the uninitialized error in the
gpiod_to_irq failure case.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: d193abf1c913 ("usb: ohci-da8xx: add vbus and overcurrent gpios")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200107123901.101190-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-da8xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
index 38183ac438c6..1371b0c249ec 100644
--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -415,13 +415,17 @@ static int ohci_da8xx_probe(struct platform_device *pdev)
 	}
 
 	da8xx_ohci->oc_gpio = devm_gpiod_get_optional(dev, "oc", GPIOD_IN);
-	if (IS_ERR(da8xx_ohci->oc_gpio))
+	if (IS_ERR(da8xx_ohci->oc_gpio)) {
+		error = PTR_ERR(da8xx_ohci->oc_gpio);
 		goto err;
+	}
 
 	if (da8xx_ohci->oc_gpio) {
 		oc_irq = gpiod_to_irq(da8xx_ohci->oc_gpio);
-		if (oc_irq < 0)
+		if (oc_irq < 0) {
+			error = oc_irq;
 			goto err;
+		}
 
 		error = devm_request_threaded_irq(dev, oc_irq, NULL,
 				ohci_da8xx_oc_thread, IRQF_TRIGGER_RISING |
-- 
2.24.1


