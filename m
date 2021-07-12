Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077D73C5287
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344665AbhGLHqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349822AbhGLHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC81C61182;
        Mon, 12 Jul 2021 07:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075682;
        bh=vdtF+omV7OLYAa/FCSoY7v45LfrG1AYg+8i89VthYI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+KpS2zsEpirgdFoOTFW3M+dMwFAJ+r51y80eD1YnFwU6BQVk9uXwsyUlhLMs+vMc
         ml2UiczoLAvW+eOUSOBj7tf5JRmazjZZI3uNxqRoQw/GE54M2lNM7n3ZmF2y//tSt0
         3aV99K2FhrC7SKNHwxruQ2kl1jZvZomJe/GKZTrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 318/800] media: i2c: rdacm21: Fix OV10640 powerup
Date:   Mon, 12 Jul 2021 08:05:41 +0200
Message-Id: <20210712060959.692502472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit ff75332b260cd33cc19000fdb5d256d9db4470d1 ]

The OV10640 image sensor powerdown signal is controlled by the first
line of the OV490 GPIO pad #1, but the pad #0 identifier
OV490_GPIO_OUTPUT_VALUE0 was erroneously used. As a result the image
sensor powerdown signal was never asserted but was left floating and
kept high by an internal pull-up resistor, causing sporadic failures
during the image sensor startup phase.

Fix this by using the correct GPIO pad identifier and wait the mandatory
1.5 millisecond delay after the powerup lane is asserted. The reset
delay is not characterized in the chip manual if not as "255 XVCLK +
initialization". Wait for at least 3 milliseconds to guarantee the SCCB
bus is available.

While at it also fix the reset sequence, as the reset line was released
before the powerdown one, and the line was not cycled.

This commit fixes a sporadic start-up error triggered by a failure to
read the OV10640 chip ID:
rdacm21 8-0054: OV10640 ID mismatch: (0x01)

Fixes: a59f853b3b4b ("media: i2c: Add driver for RDACM21 camera module")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm21.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index 179d107f494c..4b0dfd0a75e1 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -333,13 +333,19 @@ static int ov10640_initialize(struct rdacm21_device *dev)
 {
 	u8 val;
 
-	/* Power-up OV10640 by setting RESETB and PWDNB pins high. */
+	/* Enable GPIO0#0 (reset) and GPIO1#0 (pwdn) as output lines. */
 	ov490_write_reg(dev, OV490_GPIO_SEL0, OV490_GPIO0);
 	ov490_write_reg(dev, OV490_GPIO_SEL1, OV490_SPWDN0);
 	ov490_write_reg(dev, OV490_GPIO_DIRECTION0, OV490_GPIO0);
 	ov490_write_reg(dev, OV490_GPIO_DIRECTION1, OV490_SPWDN0);
+
+	/* Power up OV10640 and then reset it. */
+	ov490_write_reg(dev, OV490_GPIO_OUTPUT_VALUE1, OV490_SPWDN0);
+	usleep_range(1500, 3000);
+
+	ov490_write_reg(dev, OV490_GPIO_OUTPUT_VALUE0, 0x00);
+	usleep_range(1500, 3000);
 	ov490_write_reg(dev, OV490_GPIO_OUTPUT_VALUE0, OV490_GPIO0);
-	ov490_write_reg(dev, OV490_GPIO_OUTPUT_VALUE0, OV490_SPWDN0);
 	usleep_range(3000, 5000);
 
 	/* Read OV10640 ID to test communications. */
-- 
2.30.2



