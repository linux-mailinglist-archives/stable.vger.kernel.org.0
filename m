Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB871253F16
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgH0H0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbgH0H0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BAD522BEA;
        Thu, 27 Aug 2020 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513168;
        bh=SnCOdHsKwEIfQtaPsexVEvCmcHEdRTChMP3fSW18jgQ=;
        h=Subject:To:From:Date:From;
        b=QG8hRcnml3C/imrpty4rBOCXBhE+ok3NXmWs+BC/X/uMvrJjMHu2Inah/kOlD0j1G
         bajJKs6ZvJ+NKjcbke7oLVjHXo/mJt91mwPNkxSflgz4YF9hRs4GRbSXfsILS855TO
         ZutDvMfRJLxv2/MYDJ5fzHCCpq9hsQkH8KyF8zjg=
Subject: patch "usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()" added to usb-linus
To:     tangbin@cmss.chinamobile.com, gregkh@linuxfoundation.org,
        krzk@kernel.org, stable@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Aug 2020 09:26:22 +0200
Message-ID: <159851318218131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1d4169834628d18b2392a2da92b7fbf5e8e2ce89 Mon Sep 17 00:00:00 2001
From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Wed, 26 Aug 2020 22:49:31 +0800
Subject: usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
exynos_ohci_probe(). And when get irq failed, the function
platform_get_irq() logs an error message, so remove redundant
message here.

Fixes: 62194244cf87 ("USB: Add Samsung Exynos OHCI diver")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200826144931.1828-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-exynos.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index bd40e597f256..5f5e8a64c8e2 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -171,9 +171,8 @@ static int exynos_ohci_probe(struct platform_device *pdev)
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
2.28.0


