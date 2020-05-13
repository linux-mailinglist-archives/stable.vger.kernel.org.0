Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB001D0D9A
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbgEMJyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388087AbgEMJyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06758206D6;
        Wed, 13 May 2020 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363663;
        bh=lhC84TnuSoyPmLnCTzbZ8mLnkdWfxi1drnOTtvPdi7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPtJ6kyu8Q6mlTnwxKCiFUaffrYfgLpZckg3300euSWEqTaeAZ/cbGCwGnWLcNQBk
         ivIpE5pIdQKg0PfjmlCHI9pC9y+NT2MXjJs+S0X6J9cG4kcIu99qs8EIyyLNW9tLBN
         e4ybNSlLl0EZS+ruf+374WGya/oQF1+9W7NAcV+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Haibo Chen <haibo.chen@nxp.com>, Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.6 076/118] driver core: platform: Initialize dma_parms for platform devices
Date:   Wed, 13 May 2020 11:44:55 +0200
Message-Id: <20200513094424.279803489@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd upstream.

It's currently the platform driver's responsibility to initialize the
pointer, dma_parms, for its corresponding struct device. The benefit with
this approach allows us to avoid the initialization and to not waste memory
for the struct device_dma_parameters, as this can be decided on a case by
case basis.

However, it has turned out that this approach is not very practical.  Not
only does it lead to open coding, but also to real errors. In principle
callers of dma_set_max_seg_size() doesn't check the error code, but just
assumes it succeeds.

For these reasons, let's do the initialization from the common platform bus
at the device registration point. This also follows the way the PCI devices
are being managed, see pci_device_add().

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Tested-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200422100954.31211-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/platform.c         |    2 ++
 include/linux/platform_device.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -361,6 +361,8 @@ struct platform_object {
  */
 static void setup_pdev_dma_masks(struct platform_device *pdev)
 {
+	pdev->dev.dma_parms = &pdev->dma_parms;
+
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	if (!pdev->dev.dma_mask) {
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -25,6 +25,7 @@ struct platform_device {
 	bool		id_auto;
 	struct device	dev;
 	u64		platform_dma_mask;
+	struct device_dma_parameters dma_parms;
 	u32		num_resources;
 	struct resource	*resource;
 


