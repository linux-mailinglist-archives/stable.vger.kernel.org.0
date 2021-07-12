Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139AC3C4D58
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhGLHMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244165AbhGLHK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8850561205;
        Mon, 12 Jul 2021 07:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073593;
        bh=9UUc3f9+EGkY5PHSfYXsv9G80kacFjvDyph61i1Qs/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkMVroL4ce0Goaoi8ER62k9iG+Ro4KSdo+wSv/PLvFZ4H4cfi4n9duwUh35Rl7vFD
         iNFDEV6tKolJnuiXUAvYVrjuy54chdCgd/+mtO3/SZ+IHQ8gbaVISA3CuQvyYzT5M6
         NvdOno+SzwEdkGlqnpsQlRlS78pSBfy1L8doGJSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 293/700] media: i2c: rdacm21: Power up OV10640 before OV490
Date:   Mon, 12 Jul 2021 08:06:16 +0200
Message-Id: <20210712061007.434002777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 2b821698dc73c00719e3dc367db712f727bbda85 ]

The current RDACM21 initialization routine powers up the OV10640 image
sensor after the OV490 ISP. The ISP is programmed with a firmware loaded
from an embedded serial flash that (most probably) tries to interact and
program also the image sensor connected to the ISP.

As described in commit "media: i2c: rdacm21: Fix OV10640 powerup" the
image sensor powerdown signal is kept high by an internal pull up
resistor and occasionally fails to startup correctly if the powerdown
line is not asserted explicitly. Failures in the OV10640 startup causes
the OV490 firmware to fail to boot correctly resulting in the camera
module initialization to fail consequentially.

Fix this by powering up the OV10640 image sensor before testing the
OV490 firmware boot completion, by splitting the ov10640_initialize()
function in an ov10640_power_up() one and an ov10640_check_id() one.

Also make sure the OV10640 identification procedure gives enough time to
the image sensor to resume after the programming phase performed by the
OV490 firmware by repeating the ID read procedure.

This commit fixes a sporadic start-up error triggered by a failure to
detect the OV490 firmware boot completion:
rdacm21 8-0054: Timeout waiting for firmware boot

[hverkuil: fixed two typos in commit log]

Fixes: a59f853b3b4b ("media: i2c: Add driver for RDACM21 camera module")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm21.c | 46 ++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index 4b0dfd0a75e1..50e2af522760 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -69,6 +69,7 @@
 #define OV490_ISP_VSIZE_LOW		0x80820062
 #define OV490_ISP_VSIZE_HIGH		0x80820063
 
+#define OV10640_PID_TIMEOUT		20
 #define OV10640_ID_HIGH			0xa6
 #define OV10640_CHIP_ID			0x300a
 #define OV10640_PIXEL_RATE		55000000
@@ -329,10 +330,8 @@ static const struct v4l2_subdev_ops rdacm21_subdev_ops = {
 	.pad		= &rdacm21_subdev_pad_ops,
 };
 
-static int ov10640_initialize(struct rdacm21_device *dev)
+static void ov10640_power_up(struct rdacm21_device *dev)
 {
-	u8 val;
-
 	/* Enable GPIO0#0 (reset) and GPIO1#0 (pwdn) as output lines. */
 	ov490_write_reg(dev, OV490_GPIO_SEL0, OV490_GPIO0);
 	ov490_write_reg(dev, OV490_GPIO_SEL1, OV490_SPWDN0);
@@ -347,18 +346,35 @@ static int ov10640_initialize(struct rdacm21_device *dev)
 	usleep_range(1500, 3000);
 	ov490_write_reg(dev, OV490_GPIO_OUTPUT_VALUE0, OV490_GPIO0);
 	usleep_range(3000, 5000);
+}
 
-	/* Read OV10640 ID to test communications. */
-	ov490_write_reg(dev, OV490_SCCB_SLAVE0_DIR, OV490_SCCB_SLAVE_READ);
-	ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_HIGH, OV10640_CHIP_ID >> 8);
-	ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_LOW, OV10640_CHIP_ID & 0xff);
-
-	/* Trigger SCCB slave transaction and give it some time to complete. */
-	ov490_write_reg(dev, OV490_HOST_CMD, OV490_HOST_CMD_TRIGGER);
-	usleep_range(1000, 1500);
+static int ov10640_check_id(struct rdacm21_device *dev)
+{
+	unsigned int i;
+	u8 val;
 
-	ov490_read_reg(dev, OV490_SCCB_SLAVE0_DIR, &val);
-	if (val != OV10640_ID_HIGH) {
+	/* Read OV10640 ID to test communications. */
+	for (i = 0; i < OV10640_PID_TIMEOUT; ++i) {
+		ov490_write_reg(dev, OV490_SCCB_SLAVE0_DIR,
+				OV490_SCCB_SLAVE_READ);
+		ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_HIGH,
+				OV10640_CHIP_ID >> 8);
+		ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_LOW,
+				OV10640_CHIP_ID & 0xff);
+
+		/*
+		 * Trigger SCCB slave transaction and give it some time
+		 * to complete.
+		 */
+		ov490_write_reg(dev, OV490_HOST_CMD, OV490_HOST_CMD_TRIGGER);
+		usleep_range(1000, 1500);
+
+		ov490_read_reg(dev, OV490_SCCB_SLAVE0_DIR, &val);
+		if (val == OV10640_ID_HIGH)
+			break;
+		usleep_range(1000, 1500);
+	}
+	if (i == OV10640_PID_TIMEOUT) {
 		dev_err(dev->dev, "OV10640 ID mismatch: (0x%02x)\n", val);
 		return -ENODEV;
 	}
@@ -374,6 +390,8 @@ static int ov490_initialize(struct rdacm21_device *dev)
 	unsigned int i;
 	int ret;
 
+	ov10640_power_up(dev);
+
 	/*
 	 * Read OV490 Id to test communications. Give it up to 40msec to
 	 * exit from reset.
@@ -411,7 +429,7 @@ static int ov490_initialize(struct rdacm21_device *dev)
 		return -ENODEV;
 	}
 
-	ret = ov10640_initialize(dev);
+	ret = ov10640_check_id(dev);
 	if (ret)
 		return ret;
 
-- 
2.30.2



