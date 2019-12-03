Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF4111EDE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfLCWuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729709AbfLCWuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04BC20656;
        Tue,  3 Dec 2019 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413410;
        bh=ifwruHAoHqHKLv+HjbF5JGJp7pgttRgm2PgncmfAWrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5ATwxt3U9nExAcPozaFCfeUjqBfr1MlMKqF2Opy+j/yozm+8FGDwYm1aZtSCifEu
         5G349eM9TcEZXwwUEs/zh8oxM009Bvyof+aWl5WWPifQJ3I0JSzeujOH1ucCOZ3oGY
         Cbkwbo0DVrFFSpI/fI///NoVWOoxvE5OtCC474Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ladislav Michl <ladis@linux-mips.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/321] usb: ehci-omap: Fix deferred probe for phy handling
Date:   Tue,  3 Dec 2019 23:33:02 +0100
Message-Id: <20191203223433.182056324@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit 8dc7623bf608495b6e6743e805807c7840673573 ]

PHY model is being used on omap5 platforms even if port mode
is not OMAP_EHCI_PORT_MODE_PHY. So don't guess if PHY is required
or not based on PHY mode.

If PHY is provided in device tree, it must be required. So, if
devm_usb_get_phy_by_phandle() gives us an error code other
than -ENODEV (no PHY) then error out.

This fixes USB Ethernet on omap5-uevm if PHY happens to
probe after EHCI thus causing a -EPROBE_DEFER.

Cc: Johan Hovold <johan@kernel.org>
Cc: Ladislav Michl <ladis@linux-mips.org>
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-omap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 7e4c13346a1ee..7d20296cbe9f9 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -159,11 +159,12 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		/* get the PHY device */
 		phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
 		if (IS_ERR(phy)) {
-			/* Don't bail out if PHY is not absolutely necessary */
-			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
+			ret = PTR_ERR(phy);
+			if (ret == -ENODEV) { /* no PHY */
+				phy = NULL;
 				continue;
+			}
 
-			ret = PTR_ERR(phy);
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Can't get PHY for port %d: %d\n",
 					i, ret);
-- 
2.20.1



