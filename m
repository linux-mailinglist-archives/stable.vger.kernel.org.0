Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526981BC3F6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgD1Pox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 11:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgD1Pox (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 11:44:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22DC6205C9;
        Tue, 28 Apr 2020 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588088692;
        bh=1z8zC1lRAk9XK/nGMUR81uiF7G3WVg0z+22fraYPVhA=;
        h=Subject:To:From:Date:From;
        b=vmIGStjKEI4i74KWUQdChiS3zF+IEuKmXFphhvxKzCEltLPqOu2djYYAF9KWK7YYz
         eomM+9Hid5DErEjqHH/43gCkP4S6BeY+y9JFsfDstEJ0oNksK9iEcM/l1g644no/dN
         Y0R8RR3wrxN/13gnjRk3pOXmGw6qQuukTgPiI3I4=
Subject: patch "driver core: platform: Initialize dma_parms for platform devices" added to driver-core-linus
To:     ulf.hansson@linaro.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        haibo.chen@nxp.com, hch@lst.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Apr 2020 17:44:49 +0200
Message-ID: <158808868952217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: platform: Initialize dma_parms for platform devices

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 22 Apr 2020 12:09:54 +0200
Subject: driver core: platform: Initialize dma_parms for platform devices

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
 drivers/base/platform.c         | 2 ++
 include/linux/platform_device.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 5255550b7c34..b27d0f6c18c9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -380,6 +380,8 @@ struct platform_object {
  */
 static void setup_pdev_dma_masks(struct platform_device *pdev)
 {
+	pdev->dev.dma_parms = &pdev->dma_parms;
+
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	if (!pdev->dev.dma_mask) {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index bdc35753ef7c..77a2aada106d 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -25,6 +25,7 @@ struct platform_device {
 	bool		id_auto;
 	struct device	dev;
 	u64		platform_dma_mask;
+	struct device_dma_parameters dma_parms;
 	u32		num_resources;
 	struct resource	*resource;
 
-- 
2.26.2


