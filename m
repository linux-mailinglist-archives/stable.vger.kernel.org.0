Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC9345DFA
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhCWMZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhCWMZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79973619B1;
        Tue, 23 Mar 2021 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502325;
        bh=JNOXv93hTlvAnM5DA/e0cGSjm2bzwLZsC0WGVB92O44=;
        h=Subject:To:From:Date:From;
        b=ofh6OzSJ38kcqlEUKfVwrjV+AObbUPWLZnXQjkyUcudDpBIx2wqYBeP3U97MHsu1I
         8EgM9AB7CfD83Ms8sAZRsXls4+LlLA351S/cALUxs6voJ+7GWwhLTaTn25RhqBMYHz
         FhdQUJDGk22zDjdvphftY63HcX9Sp9TYeR1UUhEk=
Subject: patch "usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference" added to usb-linus
To:     ztong0001@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:25:14 +0100
Message-ID: <1616502314154141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 72035f4954f0bca2d8c47cf31b3629c42116f5b7 Mon Sep 17 00:00:00 2001
From: Tong Zhang <ztong0001@gmail.com>
Date: Wed, 17 Mar 2021 19:04:00 -0400
Subject: usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

init_dma_pools() calls dma_pool_create(...dev->dev) to create dma pool.
however, dev->dev is actually set after calling init_dma_pools(), which
effectively makes dma_pool_create(..NULL) and cause crash.
To fix this issue, init dma only after dev->dev is set.

[    1.317993] RIP: 0010:dma_pool_create+0x83/0x290
[    1.323257] Call Trace:
[    1.323390]  ? pci_write_config_word+0x27/0x30
[    1.323626]  init_dma_pools+0x41/0x1a0 [snps_udc_core]
[    1.323899]  udc_pci_probe+0x202/0x2b1 [amd5536udc_pci]

Fixes: 7c51247a1f62 (usb: gadget: udc: Provide correct arguments for 'dma_pool_create')
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210317230400.357756-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/amd5536udc_pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/amd5536udc_pci.c b/drivers/usb/gadget/udc/amd5536udc_pci.c
index 8d387e0e4d91..c80f9bd51b75 100644
--- a/drivers/usb/gadget/udc/amd5536udc_pci.c
+++ b/drivers/usb/gadget/udc/amd5536udc_pci.c
@@ -153,6 +153,11 @@ static int udc_pci_probe(
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
+	dev->phys_addr = resource;
+	dev->irq = pdev->irq;
+	dev->pdev = pdev;
+	dev->dev = &pdev->dev;
+
 	/* init dma pools */
 	if (use_dma) {
 		retval = init_dma_pools(dev);
@@ -160,11 +165,6 @@ static int udc_pci_probe(
 			goto err_dma;
 	}
 
-	dev->phys_addr = resource;
-	dev->irq = pdev->irq;
-	dev->pdev = pdev;
-	dev->dev = &pdev->dev;
-
 	/* general probing */
 	if (udc_probe(dev)) {
 		retval = -ENODEV;
-- 
2.31.0


