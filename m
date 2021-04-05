Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4FC353DC3
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhDEJCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237387AbhDEJCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22830613A3;
        Mon,  5 Apr 2021 09:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613327;
        bh=X1xc9gdX2vPMnUuIVxv1xipMtvOftPSA7kCR5++fVQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTy9lw2DTNtpl/wJn9nJrIpWe5jZeJtxRlonyLVDqnPuXh7QjFd7IXD/qKzaIniGr
         LHN1HjErqnT3ZuY9Zy1dhmXv5ZXgMOlKJCrF6wizciAOUgKQTieQNjCNDA/UdfTmFe
         EvacIQVkeM5x5Rqm3hYNMj9bBhqrokJUWEgZM/Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 4.19 52/56] usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference
Date:   Mon,  5 Apr 2021 10:54:23 +0200
Message-Id: <20210405085024.181944690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

commit 72035f4954f0bca2d8c47cf31b3629c42116f5b7 upstream.

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
 drivers/usb/gadget/udc/amd5536udc_pci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/udc/amd5536udc_pci.c
+++ b/drivers/usb/gadget/udc/amd5536udc_pci.c
@@ -154,6 +154,11 @@ static int udc_pci_probe(
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
@@ -161,11 +166,6 @@ static int udc_pci_probe(
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


