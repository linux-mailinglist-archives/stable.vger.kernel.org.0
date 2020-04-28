Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF191BC3F7
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgD1PpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 11:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgD1PpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 11:45:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C3F205C9;
        Tue, 28 Apr 2020 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588088700;
        bh=E8Z4m5rS69g2xjnG8CzDGCImBYkP2DmxFRPBgCYw91c=;
        h=Subject:To:From:Date:From;
        b=bDRDnFibyzbmdCbRtFUlr2R73VYVnQHDMphEO981bwwEG1TeMnxblI1HyvS2xEwjG
         OSir640aok6dSpPiWTPs0Fr4qG9LSTTWvmW5Cc3XWRmM5kSPzLX9KTOIjKp+4KUOl3
         GBpteyBTNHdSAQ33V1fl8/ABxfP0LaZRy9twoq9c=
Subject: patch "amba: Initialize dma_parms for amba devices" added to driver-core-linus
To:     ulf.hansson@linaro.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        haibo.chen@nxp.com, hch@lst.de, linux@armlinux.org.uk,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Apr 2020 17:44:50 +0200
Message-ID: <1588088690169240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    amba: Initialize dma_parms for amba devices

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f458488425f1cc9a396aa1d09bb00c48783936da Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 22 Apr 2020 12:10:13 +0200
Subject: amba: Initialize dma_parms for amba devices

It's currently the amba driver's responsibility to initialize the pointer,
dma_parms, for its corresponding struct device. The benefit with this
approach allows us to avoid the initialization and to not waste memory for
the struct device_dma_parameters, as this can be decided on a case by case
basis.

However, it has turned out that this approach is not very practical. Not
only does it lead to open coding, but also to real errors. In principle
callers of dma_set_max_seg_size() doesn't check the error code, but just
assumes it succeeds.

For these reasons, let's do the initialization from the common amba bus at
the device registration point. This also follows the way the PCI devices
are being managed, see pci_device_add().

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Tested-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200422101013.31267-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/bus.c       | 1 +
 include/linux/amba/bus.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index fe1523664816..8558b629880b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -645,6 +645,7 @@ static void amba_device_initialize(struct amba_device *dev, const char *name)
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->res.name = dev_name(&dev->dev);
 }
 
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 26f0ecf401ea..0bbfd647f5c6 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,6 +65,7 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
+	struct device_dma_parameters dma_parms;
 	unsigned int		periphid;
 	unsigned int		cid;
 	struct amba_cs_uci_id	uci;
-- 
2.26.2


