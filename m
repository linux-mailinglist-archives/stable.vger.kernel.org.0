Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA5FA553
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfKMCWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbfKMBxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F66222CF;
        Wed, 13 Nov 2019 01:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610012;
        bh=jaHaRyda7MXr3YsDxYA2f/RYFTQs0cy+RIHpbN7vCdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZrqeph2rH/6fRP6PGfNwbP/5m+vd8Vr1DQYaO3V2kMdxmrvPBqapUN4B2rd8CKN3
         2r3mVRUBVCd5wzfNt2bnbPhjtMPEDcvpvItnROoX7H+4R0fXAM5m94ZzCYUgOTJNBH
         U8E1OTlnj2r1g27+6aRKzv7vD+yKimwnkyGLIz2Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 116/209] i2c: omap: use core to detect 'no zero length' quirk
Date:   Tue, 12 Nov 2019 20:48:52 -0500
Message-Id: <20191113015025.9685-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit f37b2bb6ac3e6ebf855d9d4f05cc6932a8e5b463 ]

And don't reimplement in the driver.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-omap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 2ac86096ddd95..cd9c65f3d404f 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -661,9 +661,6 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	dev_dbg(omap->dev, "addr: 0x%04x, len: %d, flags: 0x%x, stop: %d\n",
 		msg->addr, msg->len, msg->flags, stop);
 
-	if (msg->len == 0)
-		return -EINVAL;
-
 	omap->receiver = !!(msg->flags & I2C_M_RD);
 	omap_i2c_resize_fifo(omap, msg->len, omap->receiver);
 
@@ -1179,6 +1176,10 @@ static const struct i2c_algorithm omap_i2c_algo = {
 	.functionality	= omap_i2c_func,
 };
 
+static const struct i2c_adapter_quirks omap_i2c_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN,
+};
+
 #ifdef CONFIG_OF
 static struct omap_i2c_bus_platform_data omap2420_pdata = {
 	.rev = OMAP_I2C_IP_VERSION_1,
@@ -1453,6 +1454,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	adap->class = I2C_CLASS_DEPRECATED;
 	strlcpy(adap->name, "OMAP I2C adapter", sizeof(adap->name));
 	adap->algo = &omap_i2c_algo;
+	adap->quirks = &omap_i2c_quirks;
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->bus_recovery_info = &omap_i2c_bus_recovery_info;
-- 
2.20.1

