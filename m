Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A357397E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389795AbfGXTko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390066AbfGXTkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B969217D4;
        Wed, 24 Jul 2019 19:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997241;
        bh=H/DCJBNmixnAmgd2Ovp34xVh7UujKloaqaqF0z11Czc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4rIQ18R9/HriRvY1eRBtc9fwxZC8/a0vidjvbelJaf13GJjkrSwI6ZgsGVM1pC+F
         ZlCb6EYjsreVqQSSJ/UVSLL4j8fe+rRbc6khxWLjOEr0QgeeJc1oxiULGX4NKhNxbh
         w3wknCITu/eM+Tmsas/cYVNBMe4PozxN/47oCZaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitor Soares <vitor.soares@synopsys.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.2 343/413] i3c: fix i2c and i3c scl rate by bus mode
Date:   Wed, 24 Jul 2019 21:20:34 +0200
Message-Id: <20190724191800.360399753@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitor Soares <Vitor.Soares@synopsys.com>

commit ecc8fb54bd443bf69996d9d5ddb8d90a50f14936 upstream.

Currently the I3C framework limits SCL frequency to FM speed when
dealing with a mixed slow bus, even if all I2C devices are FM+ capable.

The core was also not accounting for I3C speed limitations when
operating in mixed slow mode and was erroneously using FM+ speed as the
max I2C speed when operating in mixed fast mode.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i3c/master.c |   51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c
 	up_read(&bus->lock);
 }
 
+static struct i3c_master_controller *
+i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
+{
+	return container_of(i3cbus, struct i3c_master_controller, bus);
+}
+
 static struct i3c_master_controller *dev_to_i3cmaster(struct device *dev)
 {
 	return container_of(dev, struct i3c_master_controller, dev);
@@ -565,20 +571,38 @@ static const struct device_type i3c_mast
 	.groups	= i3c_masterdev_groups,
 };
 
-int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode)
+int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
+		     unsigned long max_i2c_scl_rate)
 {
-	i3cbus->mode = mode;
+	struct i3c_master_controller *master = i3c_bus_to_i3c_master(i3cbus);
 
-	if (!i3cbus->scl_rate.i3c)
-		i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
+	i3cbus->mode = mode;
 
-	if (!i3cbus->scl_rate.i2c) {
-		if (i3cbus->mode == I3C_BUS_MODE_MIXED_SLOW)
-			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
-		else
-			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
+	switch (i3cbus->mode) {
+	case I3C_BUS_MODE_PURE:
+		if (!i3cbus->scl_rate.i3c)
+			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
+		break;
+	case I3C_BUS_MODE_MIXED_FAST:
+		if (!i3cbus->scl_rate.i3c)
+			i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
+		if (!i3cbus->scl_rate.i2c)
+			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
+		break;
+	case I3C_BUS_MODE_MIXED_SLOW:
+		if (!i3cbus->scl_rate.i2c)
+			i3cbus->scl_rate.i2c = max_i2c_scl_rate;
+		if (!i3cbus->scl_rate.i3c ||
+		    i3cbus->scl_rate.i3c > i3cbus->scl_rate.i2c)
+			i3cbus->scl_rate.i3c = i3cbus->scl_rate.i2c;
+		break;
+	default:
+		return -EINVAL;
 	}
 
+	dev_dbg(&master->dev, "i2c-scl = %ld Hz i3c-scl = %ld Hz\n",
+		i3cbus->scl_rate.i2c, i3cbus->scl_rate.i3c);
+
 	/*
 	 * I3C/I2C frequency may have been overridden, check that user-provided
 	 * values are not exceeding max possible frequency.
@@ -1966,9 +1990,6 @@ of_i3c_master_add_i2c_boardinfo(struct i
 	/* LVR is encoded in reg[2]. */
 	boardinfo->lvr = reg[2];
 
-	if (boardinfo->lvr & I3C_LVR_I2C_FM_MODE)
-		master->bus.scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
-
 	list_add_tail(&boardinfo->node, &master->boardinfo.i2c);
 	of_node_get(node);
 
@@ -2417,6 +2438,7 @@ int i3c_master_register(struct i3c_maste
 			const struct i3c_master_controller_ops *ops,
 			bool secondary)
 {
+	unsigned long i2c_scl_rate = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
 	struct i3c_bus *i3cbus = i3c_master_get_bus(master);
 	enum i3c_bus_mode mode = I3C_BUS_MODE_PURE;
 	struct i2c_dev_boardinfo *i2cbi;
@@ -2466,9 +2488,12 @@ int i3c_master_register(struct i3c_maste
 			ret = -EINVAL;
 			goto err_put_dev;
 		}
+
+		if (i2cbi->lvr & I3C_LVR_I2C_FM_MODE)
+			i2c_scl_rate = I3C_BUS_I2C_FM_SCL_RATE;
 	}
 
-	ret = i3c_bus_set_mode(i3cbus, mode);
+	ret = i3c_bus_set_mode(i3cbus, mode, i2c_scl_rate);
 	if (ret)
 		goto err_put_dev;
 


