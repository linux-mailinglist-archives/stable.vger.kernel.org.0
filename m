Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA6E353D71
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhDEI7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237062AbhDEI7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92A1D6138A;
        Mon,  5 Apr 2021 08:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613181;
        bh=x49tOg8/oBJkUev6pP4Yx2NL3Qoo8OltRSJJaYuL9+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zld3Fiua+7AR1cdKZR2QFTxx12zIY5y4iORFs4C3EwvUqKHu+F7NKJcErXw1DEhH5
         pNYd3xkQMeexIgT4kDbcBrhQyVbVbuIXP3YUf8ehoZ4Gbv+hjxsjt0QXPsOBNivm3y
         DJnsflMM/+5ef+s3rO11nYbl/L5N/0jxV2u7ztgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 4.14 49/52] usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference
Date:   Mon,  5 Apr 2021 10:54:15 +0200
Message-Id: <20210405085023.579085787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -158,6 +158,11 @@ static int udc_pci_probe(
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
@@ -165,11 +170,6 @@ static int udc_pci_probe(
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


