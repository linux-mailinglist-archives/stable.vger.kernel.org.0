Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021C01065F2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfKVFu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfKVFu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459102070E;
        Fri, 22 Nov 2019 05:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401828;
        bh=ifwruHAoHqHKLv+HjbF5JGJp7pgttRgm2PgncmfAWrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfaJo8jLZPKwwa0r//JrrvKBAgjxaNFkyNE4qqLAqDgshZ91g+LJ+dJ5kQfEuIwau
         CwtLJWd28IDprh9rFlelG0ZF/+Dqivb2XdmQr2TUv/ZiQ5g0U24QBq36rhU+bd7QvX
         pF4i96dpqaCBdRofT9naouugx1q+WvUmNaHvOWYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@ti.com>, Johan Hovold <johan@kernel.org>,
        Ladislav Michl <ladis@linux-mips.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 070/219] usb: ehci-omap: Fix deferred probe for phy handling
Date:   Fri, 22 Nov 2019 00:46:42 -0500
Message-Id: <20191122054911.1750-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

