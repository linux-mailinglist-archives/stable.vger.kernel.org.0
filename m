Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D797529D745
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbgJ1WWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbgJ1WWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:22:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EA24246F7;
        Wed, 28 Oct 2020 12:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603887530;
        bh=dWmkv/cPghqBP+M0mvlJ5p6VEncAftmXvK/Isw2Nc+g=;
        h=Subject:To:From:Date:From;
        b=pHNB5SF5IjEVGXoafWVaqcDGcdqVX5Z+eevcgPKPIJYmHJVSmWEnzikXd8Deepl1j
         GQCBpXNto7rC8etLjOTMI8cXao81RngAob5Ug6cnb6hiXTRKAx3Y0pWg5lUVNbRKc4
         mDpf7Wz7RHF+UIS/GG4WTH3pk3s3l/axQZBuMnms=
Subject: patch "usb: host: fsl-mph-dr-of: check return of dma_set_mask()" added to usb-linus
To:     ran.wang_1@nxp.com, gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:19:42 +0100
Message-ID: <1603887582129148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: fsl-mph-dr-of: check return of dma_set_mask()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3cd54a618834430a26a648d880dd83d740f2ae30 Mon Sep 17 00:00:00 2001
From: Ran Wang <ran.wang_1@nxp.com>
Date: Sat, 10 Oct 2020 14:03:08 +0800
Subject: usb: host: fsl-mph-dr-of: check return of dma_set_mask()

fsl_usb2_device_register() should stop init if dma_set_mask() return
error.

Fixes: cae058610465 ("drivers/usb/host: fsl: Set DMA_MASK of usb platform device")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Link: https://lore.kernel.org/r/20201010060308.33693-1-ran.wang_1@nxp.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/fsl-mph-dr-of.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/fsl-mph-dr-of.c b/drivers/usb/host/fsl-mph-dr-of.c
index ae8f60f6e6a5..44a7e58a26e3 100644
--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -94,10 +94,13 @@ static struct platform_device *fsl_usb2_device_register(
 
 	pdev->dev.coherent_dma_mask = ofdev->dev.coherent_dma_mask;
 
-	if (!pdev->dev.dma_mask)
+	if (!pdev->dev.dma_mask) {
 		pdev->dev.dma_mask = &ofdev->dev.coherent_dma_mask;
-	else
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+	} else {
+		retval = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (retval)
+			goto error;
+	}
 
 	retval = platform_device_add_data(pdev, pdata, sizeof(*pdata));
 	if (retval)
-- 
2.29.1


