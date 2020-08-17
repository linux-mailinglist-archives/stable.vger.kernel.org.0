Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2909F24750B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392255AbgHQTSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbgHQPiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CD023134;
        Mon, 17 Aug 2020 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678680;
        bh=1MCbLa/2FROptC0TWFoBxOWO79n1UkwvKYg/ofYlKiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cklv+5HAKEkal5vZdE5K1TftXutHsBhu59vfNV5qvZRF+tegWFOIYNk4KTF3JNd1I
         Ge4+1y7AV4u4S7xRBof68/C4R1Ow4sXt7al9jBahE3UhVf0+yiBldEzIoHMCe/Vhi9
         YgkZlIQMGV4KkVmDqXiqduGbZhGkEnen9YD+ggc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 387/464] net: phy: fix memory leak in device-create error path
Date:   Mon, 17 Aug 2020 17:15:40 +0200
Message-Id: <20200817143852.318634090@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit d02cbc46136105cf86f84ac355e16f04696f538d ]

A recent commit introduced a late error path in phy_device_create()
which fails to release the device name allocated by dev_set_name().

Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -616,7 +616,9 @@ struct phy_device *phy_device_create(str
 	if (c45_ids)
 		dev->c45_ids = *c45_ids;
 	dev->irq = bus->irq[addr];
+
 	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
+	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
 
@@ -650,10 +652,8 @@ struct phy_device *phy_device_create(str
 		ret = phy_request_driver_module(dev, phy_id);
 	}
 
-	if (!ret) {
-		device_initialize(&mdiodev->dev);
-	} else {
-		kfree(dev);
+	if (ret) {
+		put_device(&mdiodev->dev);
 		dev = ERR_PTR(ret);
 	}
 


