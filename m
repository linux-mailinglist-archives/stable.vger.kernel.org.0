Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A16197953
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgC3Kco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 06:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgC3Kco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 06:32:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54CB920716;
        Mon, 30 Mar 2020 10:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585564363;
        bh=xJzg4mOPsbU/DDGqyLxkdcWDsZ0+z4e9wZ8ZnJ2hfjI=;
        h=Subject:To:From:Date:From;
        b=hTWizuq5uXDJEuX+HSdJogZPOEUfftx7mxBTTuZHSiUUb8km5rIO/+5qJJfzqvEeI
         Hlcb4WhzENmNRy1ZCLpYNfOVx1scf6F9xyY+Mc11iFnKm7jlvUS7ZH91s5H/XFAd9O
         ndEjGnkbvCrn82kw8JVACHGxI5nrQBAf3UvPASCA=
Subject: patch "amba: Initialize dma_parms for amba devices" added to char-misc-next
To:     ulf.hansson@linaro.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        hch@lst.de, linus.walleij@linaro.org, linux@armlinux.org.uk,
        ludovic.barre@st.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 12:32:14 +0200
Message-ID: <1585564334117187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    amba: Initialize dma_parms for amba devices

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 25 Mar 2020 12:34:07 +0100
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

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Suggested-by: Christoph Hellwig <hch@lst.de>
Tested-by: Ludovic Barre <ludovic.barre@st.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200325113407.26996-3-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/bus.c       | 2 ++
 include/linux/amba/bus.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index fe1523664816..5e61783ce92d 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -374,6 +374,8 @@ static int amba_device_try_add(struct amba_device *dev, struct resource *parent)
 	WARN_ON(dev->irq[0] == (unsigned int)-1);
 	WARN_ON(dev->irq[1] == (unsigned int)-1);
 
+	dev->dev.dma_parms = &dev->dma_parms;
+
 	ret = request_resource(parent, &dev->res);
 	if (ret)
 		goto err_out;
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
2.26.0


