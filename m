Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8519A514
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 08:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgDAGHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 02:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731721AbgDAGHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 02:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4361620714;
        Wed,  1 Apr 2020 06:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585721244;
        bh=05+j6UMyHan0YOChxsX6SSFnEpqbu9w3sxRvSrCeGWo=;
        h=Subject:To:From:Date:From;
        b=HkHQ5Y9nVXY8e7yhjVpqkh8R4TuDgLhH6kP909m5fnjfgquRYjKe8NhOEf0Glrsgx
         xcaBPn+wrKUKq0gWSCDdSq4v+kn1OVlIy2JWGMN7hhvtYnKVeNAN+ZmHyMtxHUJbE3
         3PLmNqC7oBa2wSpfjPX267sgjkFntr/p1+PMVxgY=
Subject: patch "Revert "driver core: platform: Initialize dma_parms for platform" added to char-misc-testing
To:     gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        ludovic.barre@st.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Apr 2020 08:07:14 +0200
Message-ID: <1585721234136180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "driver core: platform: Initialize dma_parms for platform

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 885a64715fd81e6af6d94a038556e0b2e6deb19c Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 1 Apr 2020 08:06:54 +0200
Subject: Revert "driver core: platform: Initialize dma_parms for platform
 devices"

This reverts commit 7c8978c0837d40c302f5e90d24c298d9ca9fc097, a new
version will come in the next release cycle.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ludovic Barre <ludovic.barre@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c         | 1 -
 include/linux/platform_device.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 46abbfb52655..b5ce7b085795 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -512,7 +512,6 @@ int platform_device_add(struct platform_device *pdev)
 		pdev->dev.parent = &platform_bus;
 
 	pdev->dev.bus = &platform_bus_type;
-	pdev->dev.dma_parms = &pdev->dma_parms;
 
 	switch (pdev->id) {
 	default:
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 81900b3cbe37..041bfa412aa0 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -25,7 +25,6 @@ struct platform_device {
 	bool		id_auto;
 	struct device	dev;
 	u64		platform_dma_mask;
-	struct device_dma_parameters dma_parms;
 	u32		num_resources;
 	struct resource	*resource;
 
-- 
2.26.0


