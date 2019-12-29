Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357AC12C5DF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfL2Rlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbfL2Rlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:41:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A78206A4;
        Sun, 29 Dec 2019 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641304;
        bh=iie96zkexgpWLpCg2b3FR+zZD53XHt5CBj85CNQ71MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2jwJPo/NYxMrQP8kSeIdg6pj5U1tPfXtJqdbTzJ62v/ZBPcFOxF4zGY6txX12Xbf
         oN8bXVllrqAOurjK+ATmp4A/f6x5e0MNvod506REkF8J9eX3/2FvwJ4rhWJVCzjO04
         Gdk1bW2Z3BSPoYp3TjpyAH7fLmu9ji5DVaZEmsds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 011/434] net: usb: lan78xx: Fix suspend/resume PHY register access error
Date:   Sun, 29 Dec 2019 18:21:04 +0100
Message-Id: <20191229172703.016628035@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 20032b63586ac6c28c936dff696981159913a13f ]

Lan78xx driver accesses the PHY registers through MDIO bus over USB
connection. When performing a suspend/resume, the PHY registers can be
accessed before the USB connection is resumed. This will generate an
error and will prevent the device to resume correctly.
This patch adds the dependency between the MDIO bus and USB device to
allow correct handling of suspend/resume.

Fixes: ce85e13ad6ef ("lan78xx: Update to use phylib instead of mii_if_info.")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1808,6 +1808,7 @@ static int lan78xx_mdio_init(struct lan7
 	dev->mdiobus->read = lan78xx_mdiobus_read;
 	dev->mdiobus->write = lan78xx_mdiobus_write;
 	dev->mdiobus->name = "lan78xx-mdiobus";
+	dev->mdiobus->parent = &dev->udev->dev;
 
 	snprintf(dev->mdiobus->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);


