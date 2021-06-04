Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B8A39B764
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 12:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFDLBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFDLBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BE96141A;
        Fri,  4 Jun 2021 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622804384;
        bh=o82lhaRZswax0hpaFS1sqfzayPbGyWN5GvL1Xo5IOa0=;
        h=Subject:To:From:Date:From;
        b=0eltMSVzdTNtJSq7G13rITXkBNMr4hh3nlVVk1IQlkviCYrAHW/sAGReNfed7rUox
         ThN2noot6iTzjSXXwNEoGTzD9XpCNXws+9wggPiSb62HKYWDUCoDG9LK4bCcmpDYZR
         7pJ5YH0quJ7L5RfjNKbwqBnD1MjMuFJE8p36cZDo=
Subject: patch "usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled" added to usb-linus
To:     narmstrong@baylibre.com, gregkh@linuxfoundation.org,
        martin.blumenstingl@googlemail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 12:59:33 +0200
Message-ID: <1622804373141114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d2aa178d2ad2fb156711113790dde13e9aa2376 Mon Sep 17 00:00:00 2001
From: Neil Armstrong <narmstrong@baylibre.com>
Date: Tue, 1 Jun 2021 10:48:30 +0200
Subject: usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled

When only PHY1 is used (for example on Odroid-HC4), the regmap init code
uses the usb2 ports when doesn't initialize the PHY1 regmap entry.

This fixes:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
...
pc : regmap_update_bits_base+0x40/0xa0
lr : dwc3_meson_g12a_usb2_init_phy+0x4c/0xf8
...
Call trace:
regmap_update_bits_base+0x40/0xa0
dwc3_meson_g12a_usb2_init_phy+0x4c/0xf8
dwc3_meson_g12a_usb2_init+0x7c/0xc8
dwc3_meson_g12a_usb_init+0x28/0x48
dwc3_meson_g12a_probe+0x298/0x540
platform_probe+0x70/0xe0
really_probe+0xf0/0x4d8
driver_probe_device+0xfc/0x168
...

Fixes: 013af227f58a97 ("usb: dwc3: meson-g12a: handle the phy and glue registers separately")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210601084830.260196-1-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index 804957525130..ffe301d6ea35 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -651,7 +651,7 @@ static int dwc3_meson_g12a_setup_regmaps(struct dwc3_meson_g12a *priv,
 		return PTR_ERR(priv->usb_glue_regmap);
 
 	/* Create a regmap for each USB2 PHY control register set */
-	for (i = 0; i < priv->usb2_ports; i++) {
+	for (i = 0; i < priv->drvdata->num_phys; i++) {
 		struct regmap_config u2p_regmap_config = {
 			.reg_bits = 8,
 			.val_bits = 32,
@@ -659,6 +659,9 @@ static int dwc3_meson_g12a_setup_regmaps(struct dwc3_meson_g12a *priv,
 			.max_register = U2P_R1,
 		};
 
+		if (!strstr(priv->drvdata->phy_names[i], "usb2"))
+			continue;
+
 		u2p_regmap_config.name = devm_kasprintf(priv->dev, GFP_KERNEL,
 							"u2p-%d", i);
 		if (!u2p_regmap_config.name)
-- 
2.31.1


