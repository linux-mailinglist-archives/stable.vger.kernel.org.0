Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934661FEDF5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgFRIlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRIlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:41:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BC12089D;
        Thu, 18 Jun 2020 08:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469712;
        bh=Y1Yo+pV0Y6x5kHKFWWIAPXAyecGJzhMj7nnLf2g2DHU=;
        h=Subject:To:From:Date:From;
        b=xVFL55Vbt8eWGJKc0T7OJQdnliwdntKJbA8/XWZ7BM2WYJI8qmnPFqtWd1YdNa4DT
         tH3VShNFnG/ookHZNyoT16QJ4Uot4iIpdy3DHiyj8ylcCpDg/DvO+ZnEMzXfV9eztm
         pPPRVoxrlDgq2NgqKselbhqGa17+xA6D8bgfWm28=
Subject: patch "usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()" added to usb-linus
To:     tangbin@cmss.chinamobile.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zhangshengju@cmss.chinamobile.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:41:35 +0200
Message-ID: <1592469695128137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 44ed240d62736ad29943ec01e41e194b96f7c5e9 Mon Sep 17 00:00:00 2001
From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Tue, 2 Jun 2020 19:47:08 +0800
Subject: usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
exynos_ehci_probe(). And when get irq failed, the function
platform_get_irq() logs an error message, so remove redundant
message here.

Fixes: 1bcc5aa87f04 ("USB: Add initial S5P EHCI driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20200602114708.28620-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-exynos.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index a4e9abcbdc4f..1a9b7572e17f 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -203,9 +203,8 @@ static int exynos_ehci_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(res);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		dev_err(&pdev->dev, "Failed to get IRQ\n");
-		err = -ENODEV;
+	if (irq < 0) {
+		err = irq;
 		goto fail_io;
 	}
 
-- 
2.27.0


