Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB8319A513
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 08:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgDAGHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 02:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731721AbgDAGHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 02:07:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67DB20714;
        Wed,  1 Apr 2020 06:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585721237;
        bh=tYE3yJ+hRq5hJ2wM3o9q2lK9IO5qllaYcSztIE/vBGM=;
        h=Subject:To:From:Date:From;
        b=lB6VbLX4q3BJtnsFx4bYmlrPKCDwtdgHlWBuzqUPi8rcUlEcWMPz7B4wyl8qLu7yw
         YrwiqOhXavTmTgYtgyr0LPc4oaGMvLP2swDYMnAKc8VexQJoPzNXzhGDe+l7GP2duT
         KtklCQaNodYbX0EzJPDJbd6l1FGXlsTdVpfLCls0=
Subject: patch "Revert "amba: Initialize dma_parms for amba devices"" added to char-misc-testing
To:     gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        ludovic.barre@st.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Apr 2020 08:07:13 +0200
Message-ID: <158572123332129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "amba: Initialize dma_parms for amba devices"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a9d68cbd4f8834d126ebdd3097a1dee1c5973fdf Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 1 Apr 2020 08:03:28 +0200
Subject: Revert "amba: Initialize dma_parms for amba devices"

This reverts commit 5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f.  It still
needs some more work and that will happen for the next release cycle,
not this one.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ludovic Barre <ludovic.barre@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/bus.c       | 2 --
 include/linux/amba/bus.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 5e61783ce92d..fe1523664816 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -374,8 +374,6 @@ static int amba_device_try_add(struct amba_device *dev, struct resource *parent)
 	WARN_ON(dev->irq[0] == (unsigned int)-1);
 	WARN_ON(dev->irq[1] == (unsigned int)-1);
 
-	dev->dev.dma_parms = &dev->dma_parms;
-
 	ret = request_resource(parent, &dev->res);
 	if (ret)
 		goto err_out;
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 0bbfd647f5c6..26f0ecf401ea 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -65,7 +65,6 @@ struct amba_device {
 	struct device		dev;
 	struct resource		res;
 	struct clk		*pclk;
-	struct device_dma_parameters dma_parms;
 	unsigned int		periphid;
 	unsigned int		cid;
 	struct amba_cs_uci_id	uci;
-- 
2.26.0


