Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E90261C51
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgIHTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgIHQCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDB924147;
        Tue,  8 Sep 2020 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579512;
        bh=jYmkvO4JgWaK0dz1wwE7dMugPeoMLh4sDC5DGhK7VwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrfHXPtWiXE2RqtDCSFCan5rN5A4RMQLr+8ZxT3MtgkqsHIYYBs6PICG3Ki9KxBtV
         J0akThM6TFybhPswXS+3IH90B8Di6XN87mXRjgOn1jMUNGPBojh+90N8J5xqaQkiC5
         rsCyMeMOUfdQd3qFwU0ANtyNB8l1kg9mr2EOT0vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 079/186] media: i2c: imx214: select V4L2_FWNODE
Date:   Tue,  8 Sep 2020 17:23:41 +0200
Message-Id: <20200908152245.477803800@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit bca82e3557ee1fbfbdacb09033a2d81ac76c86eb ]

After the recent conversion of the media build infrastructure to select
V4L2 components instead of depending on their presence, which took place
in:
32a363d0b0b14 ("media: Kconfig files: use select for V4L2 subdevs and MC")

imx214 stands out as being the (only?) media I2C driver that still depends
on a V4L2 core symbol instead of selecting it.

This confuses the build system which claims it has detected a circular
dependency when other drivers select the same symbol as the imx214
driver does.

drivers/media/i2c/Kconfig:728:error: recursive dependency detected!
drivers/media/i2c/Kconfig:728:	symbol VIDEO_IMX214 depends on V4L2_FWNODE
drivers/media/v4l2-core/Kconfig:71:	symbol V4L2_FWNODE is selected by VIDEO_BCM2835_UNICAM
drivers/media/platform/bcm2835/Kconfig:3:	symbol VIDEO_BCM2835_UNICAM depends on VIDEO_V4L2_SUBDEV_API
drivers/media/v4l2-core/Kconfig:19:	symbol VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER
drivers/media/Kconfig:168:	symbol MEDIA_CONTROLLER is selected by VIDEO_IMX214

Fix this by making the imx214 driver select V4L2_FWNODE instead of
depending on it and align it with all the other drivers.

Fixes: 32a363d0b0b14 ("media: Kconfig files: use select for V4L2 subdevs and MC")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index da11036ad804d..6b1a6851ccb0b 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -728,7 +728,7 @@ config VIDEO_HI556
 config VIDEO_IMX214
 	tristate "Sony IMX214 sensor support"
 	depends on GPIOLIB && I2C && VIDEO_V4L2
-	depends on V4L2_FWNODE
+	select V4L2_FWNODE
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
 	select REGMAP_I2C
-- 
2.25.1



