Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BD4995B7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352975AbiAXUyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:54:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441878AbiAXUvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:51:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC436091C;
        Mon, 24 Jan 2022 20:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2AAC340E5;
        Mon, 24 Jan 2022 20:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057507;
        bh=E8N01BRn+ZSoMWY1IVzzlzEZ8SnabB6tW00fO7KDffU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgbLG2AWXDil7q8OwwCldyyBm7K/8WNf3PwLDBEypoMrVWUTmNpYSlWmsJZ2FhnRb
         ixvaFuco4menxURH8VDPTL90k1vm14EfH6N0UBKEuueNICWZTkoqhgBWHqZSbcc5hX
         ztOpF17x5BheAACcDCTBdmfk4ZIKLsQMvzLa+QPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 836/846] net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices
Date:   Mon, 24 Jan 2022 19:45:53 +0100
Message-Id: <20220124184129.751977334@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit f1131b9c23fb4a3540a774828ff49f421619f902 upstream.

On a setup with KSZ9131 and MACB drivers it happens on suspend path, from
time to time, that the PHY interrupt arrives after PHY and MACB were
suspended (PHY via genphy_suspend(), MACB via macb_suspend()). In this
case the phy_read() at the beginning of kszphy_handle_interrupt() will
fail (as MACB driver is suspended at this time) leading to phy_error()
being called and a stack trace being displayed on console. To solve this
.suspend/.resume functions for all KSZ devices implementing
.handle_interrupt were replaced with kszphy_suspend()/kszphy_resume()
which disable/enable interrupt before/after calling
genphy_suspend()/genphy_resume().

The fix has been adapted for all KSZ devices which implements
.handle_interrupt but it has been tested only on KSZ9131.

Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1547,8 +1547,8 @@ static struct phy_driver ksphy_driver[]
 	.config_init	= kszphy_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8021,
 	.phy_id_mask	= 0x00ffffff,
@@ -1562,8 +1562,8 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8031,
 	.phy_id_mask	= 0x00ffffff,
@@ -1577,8 +1577,8 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8041,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1609,8 +1609,8 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.name		= "Micrel KSZ8051",
 	/* PHY_BASIC_FEATURES */
@@ -1623,8 +1623,8 @@ static struct phy_driver ksphy_driver[]
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
 	.match_phy_device = ksz8051_match_phy_device,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8001,
 	.name		= "Micrel KSZ8001 or KS8721",
@@ -1638,8 +1638,8 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8081,
 	.name		= "Micrel KSZ8081 or KSZ8091",
@@ -1669,8 +1669,8 @@ static struct phy_driver ksphy_driver[]
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
@@ -1685,8 +1685,8 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 	.read_mmd	= genphy_read_mmd_unsupported,
 	.write_mmd	= genphy_write_mmd_unsupported,
 }, {
@@ -1704,7 +1704,7 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
+	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_LAN8814,
@@ -1732,7 +1732,7 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
+	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8873MLL,


