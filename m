Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7D5194231
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgCZO67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgCZO66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 10:58:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AC620722;
        Thu, 26 Mar 2020 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585234738;
        bh=pzy3Yq+TpJ7brmO/KxlKb2fc32J6ZJL1M2pihGxTD2U=;
        h=Subject:To:From:Date:From;
        b=n0Kqqt2hAzmGn5lKUW6SkT8RggaDd3/7uHnfplrDOl46dmGm050QQo1/dZ6p0hRhX
         azb1sKKWcPgVdMIPG+dc4loFn0fY455IDJqmr+WmCW40A123vcxyAw/NATqmo5A+Tg
         xcb/wa7Xp5dO9lE1bqWRFRuefUGUSv+xMFX97UJY=
Subject: patch "driver core: platform: Initialize dma_parms for platform devices" added to char-misc-testing
To:     ulf.hansson@linaro.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        hch@lst.de, linus.walleij@linaro.org, ludovic.barre@st.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Mar 2020 15:58:55 +0100
Message-ID: <158523473532132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: platform: Initialize dma_parms for platform devices

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7c8978c0837d40c302f5e90d24c298d9ca9fc097 Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 25 Mar 2020 12:34:06 +0100
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

Cc: <stable@vger.kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Tested-by: Ludovic Barre <ludovic.barre@st.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200325113407.26996-2-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c         | 1 +
 include/linux/platform_device.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b5ce7b085795..46abbfb52655 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -512,6 +512,7 @@ int platform_device_add(struct platform_device *pdev)
 		pdev->dev.parent = &platform_bus;
 
 	pdev->dev.bus = &platform_bus_type;
+	pdev->dev.dma_parms = &pdev->dma_parms;
 
 	switch (pdev->id) {
 	default:
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 041bfa412aa0..81900b3cbe37 100644
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
2.26.0


