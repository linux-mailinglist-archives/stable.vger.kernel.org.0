Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76E63A640F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhFNLUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhFNLRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D9061975;
        Mon, 14 Jun 2021 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667822;
        bh=ZcfdP4wZpIkbwOWLzuaTBwIoeeY2OSRxS/uPiLlq+MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/ypeKaELiEVnaxq8ojw7z3UXyNzMlnXdQJp8Lf2tqAF2YU6E7GIiDMzP0hGb/8lC
         aeq5WzScp4Ky+2q6b/+00+5WWj/nCA2L1OoNpFk7MDj98busz4ZLJlL8aD/FxSwUPe
         bm0A39Axy5XqhWwod4ZSJs2+ThhniyiqdOiLLs0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.12 088/173] usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled
Date:   Mon, 14 Jun 2021 12:27:00 +0200
Message-Id: <20210614102701.092625791@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 4d2aa178d2ad2fb156711113790dde13e9aa2376 upstream.

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
 drivers/usb/dwc3/dwc3-meson-g12a.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -651,7 +651,7 @@ static int dwc3_meson_g12a_setup_regmaps
 		return PTR_ERR(priv->usb_glue_regmap);
 
 	/* Create a regmap for each USB2 PHY control register set */
-	for (i = 0; i < priv->usb2_ports; i++) {
+	for (i = 0; i < priv->drvdata->num_phys; i++) {
 		struct regmap_config u2p_regmap_config = {
 			.reg_bits = 8,
 			.val_bits = 32,
@@ -659,6 +659,9 @@ static int dwc3_meson_g12a_setup_regmaps
 			.max_register = U2P_R1,
 		};
 
+		if (!strstr(priv->drvdata->phy_names[i], "usb2"))
+			continue;
+
 		u2p_regmap_config.name = devm_kasprintf(priv->dev, GFP_KERNEL,
 							"u2p-%d", i);
 		if (!u2p_regmap_config.name)


