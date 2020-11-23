Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CE2C0A30
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgKWMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732830AbgKWMmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC91E20857;
        Mon, 23 Nov 2020 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135319;
        bh=dQ98rYUh9QMADQhZ0dug/LdlZNxUxxchAjpVTpcAuHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9ZdtMecg/tjnbxw7WuOuRE3WE9kp+oKeNKCXXPRyu/st0Wv9ZUK+7IOHrZRPIvb1
         r6EFMXOavXnFy0Bn5EwpOJAOKoAV+4fbPWgVHsK/WvyaFKG4FDiRk6bol0XEqoFXdj
         Xxv+kM+sd1Ox7UWxRbHQAyirrvlW7pYB3uKBw6ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 026/252] net: lantiq: Wait for the GPHY firmware to be ready
Date:   Mon, 23 Nov 2020 13:19:36 +0100
Message-Id: <20201123121836.860347375@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 2a1828e378c1b5ba1ff283ed8f8c5cc37bb391dc ]

A user reports (slightly shortened from the original message):
  libphy: lantiq,xrx200-mdio: probed
  mdio_bus 1e108000.switch-mii: MDIO device at address 17 is missing.
  gswip 1e108000.switch lan: no phy at 2
  gswip 1e108000.switch lan: failed to connect to port 2: -19
  lantiq,xrx200-net 1e10b308.eth eth0: error -19 setting up slave phy

This is a single-port board using the internal Fast Ethernet PHY. The
user reports that switching to PHY scanning instead of configuring the
PHY within device-tree works around this issue.

The documentation for the standalone variant of the PHY11G (which is
probably very similar to what is used inside the xRX200 SoCs but having
the firmware burnt onto that standalone chip in the factory) states that
the PHY needs 300ms to be ready for MDIO communication after releasing
the reset.

Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
firmware had enough time to initialize and to appear on the MDIO bus.
Unfortunately there is no (known) documentation on what the minimum time
to wait after releasing the reset on an internal PHY so play safe and
take the one for the external variant. Only wait after the last GPHY
firmware is loaded to not slow down the initialization too much (
xRX200 has two GPHYs but newer SoCs have at least three GPHYs).

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201115165757.552641-1-martin.blumenstingl@googlemail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>
 #include <linux/if_bridge.h>
@@ -1821,6 +1822,16 @@ static int gswip_gphy_fw_list(struct gsw
 		i++;
 	}
 
+	/* The standalone PHY11G requires 300ms to be fully
+	 * initialized and ready for any MDIO communication after being
+	 * taken out of reset. For the SoC-internal GPHY variant there
+	 * is no (known) documentation for the minimum time after a
+	 * reset. Use the same value as for the standalone variant as
+	 * some users have reported internal PHYs not being detected
+	 * without any delay.
+	 */
+	msleep(300);
+
 	return 0;
 
 remove_gphy:


