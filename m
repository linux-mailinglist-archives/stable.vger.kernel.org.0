Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5440A962
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhINIgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhINIgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D99A6103B;
        Tue, 14 Sep 2021 08:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608535;
        bh=WxKYR6s0pxd3Ri0MVVIqjP/eHCfae33AP40D/KS4TS8=;
        h=Subject:To:From:Date:From;
        b=E7GZkPj/pfMDVj0AQYJJvQOxjGbLaUDGwrZkRajeaaVrkNAzKuaFyfsz9+qG90s7y
         wBZA83mtNyb591/hcsgEBRqH6Ig6b8FXmZbLseb1DUZWUV4yDZVUTkRQkkruV4+h3G
         UPD2w/FDL5iBdwU2pZETXZFTIVTIYoku2ioejmeA=
Subject: patch "Revert "USB: bcma: Add a check for devm_gpiod_get"" added to usb-linus
To:     rafal@milecki.pl, gregkh@linuxfoundation.org, hslester96@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:35:21 +0200
Message-ID: <1631608521246139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "USB: bcma: Add a check for devm_gpiod_get"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d91adc5322ab53df4b6d1989242bfb6c63163eb2 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Tue, 31 Aug 2021 08:54:19 +0200
Subject: Revert "USB: bcma: Add a check for devm_gpiod_get"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit f3de5d857bb2362b00e2a8d4bc886cd49dcb66db.

That commit broke USB on all routers that have USB always powered on and
don't require toggling any GPIO. It's a majority of devices actually.

The original code worked and seemed safe: vcc GPIO is optional and
bcma_hci_platform_power_gpio() takes care of checking the pointer before
using it.

This revert fixes:
[   10.801127] bcma_hcd: probe of bcma0:11 failed with error -2

Fixes: f3de5d857bb2 ("USB: bcma: Add a check for devm_gpiod_get")
Cc: stable <stable@vger.kernel.org>
Cc: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20210831065419.18371-1-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/bcma-hcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 337b425dd4b0..2df52f75f6b3 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -406,12 +406,9 @@ static int bcma_hcd_probe(struct bcma_device *core)
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node) {
+	if (core->dev.of_node)
 		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
 						    GPIOD_OUT_HIGH);
-		if (IS_ERR(usb_dev->gpio_desc))
-			return PTR_ERR(usb_dev->gpio_desc);
-	}
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:
-- 
2.33.0


