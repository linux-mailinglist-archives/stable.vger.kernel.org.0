Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDB04C0E0
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFSSgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 14:36:49 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:58594 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730259AbfFSSgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 14:36:48 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8451EC0CA5;
        Wed, 19 Jun 2019 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560969408; bh=EEQco8VIvM4ja0VFlebpMmAQZMtk0LILbpJ86r/bqog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=hD8EbPEH5bdQ7YX0IJiAxqnXw4jwn1l9kf1uTgaMlQstcyQ4PbdnJCQxTebJgfoRP
         vZ+gzUekjSM1ODd0DbSW6/fodcLkzQn42a2iYH4JgibwsDyG1TchiM7Rze7c7W82lu
         9wY9+0Q9Fv7fg1mW4QiBW1vHfZ+FVIGAbCJqhgP+zWI2Dox80ntnvIDui0NGeFztHJ
         ctovOVSM3uqPNFKSkzB6VQkJ4CzBtpwCSq/0mwuEwTZkU+ciU/c76Qh5GUwIaiDZye
         1j1npYcCQsYDVLJOgZ82fM5gAsyHV8fMblgEwmfropVHdDYvKWenq5ideCd/iKJCTt
         FRO0eA/rKk3bQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 107FFA0060;
        Wed, 19 Jun 2019 18:36:45 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 8D08F3F214;
        Wed, 19 Jun 2019 20:36:45 +0200 (CEST)
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     linux-i3c@lists.infradead.org, Joao.Pinto@synopsys.com
Cc:     Vitor Soares <Vitor.Soares@synopsys.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] i3c: fix i2c and i3c scl rate by bus mode
Date:   Wed, 19 Jun 2019 20:36:31 +0200
Message-Id: <e63b4bbcdb5261b7c72f85d6964280c671d6e5f0.1560968688.git.vitor.soares@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1560968688.git.vitor.soares@synopsys.com>
References: <cover.1560968688.git.vitor.soares@synopsys.com>
In-Reply-To: <cover.1560968688.git.vitor.soares@synopsys.com>
References: <cover.1560968688.git.vitor.soares@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Changes in v4:
  Print i2c-scl and i3c-scl unconditionally when in debug mode

Changes in v3:
  Change dev_warn() to dev_dbg()

Changes in v2:
  Enhance commit message
  Add dev_warn() in case user-defined i2c rate doesn't match LVR constraint
  Add dev_warn() in case user-defined i3c rate lower than i2c rate

 drivers/i3c/master.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 5f4bd52..14980db 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -91,6 +91,12 @@ void i3c_bus_normaluse_unlock(struct i3c_bus *bus)
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
@@ -565,20 +571,39 @@ static const struct device_type i3c_masterdev_type = {
 	.groups	= i3c_masterdev_groups,
 };
 
-int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode)
+int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
+		     unsigned long max_i2c_scl_rate)
 {
-	i3cbus->mode = mode;
 
-	if (!i3cbus->scl_rate.i3c)
-		i3cbus->scl_rate.i3c = I3C_BUS_TYP_I3C_SCL_RATE;
+	struct i3c_master_controller *master = i3c_bus_to_i3c_master(i3cbus);
 
-	if (!i3cbus->scl_rate.i2c) {
-		if (i3cbus->mode == I3C_BUS_MODE_MIXED_SLOW)
-			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
-		else
-			i3cbus->scl_rate.i2c = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
+	i3cbus->mode = mode;
+
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
@@ -1966,9 +1991,6 @@ of_i3c_master_add_i2c_boardinfo(struct i3c_master_controller *master,
 	/* LVR is encoded in reg[2]. */
 	boardinfo->lvr = reg[2];
 
-	if (boardinfo->lvr & I3C_LVR_I2C_FM_MODE)
-		master->bus.scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
-
 	list_add_tail(&boardinfo->node, &master->boardinfo.i2c);
 	of_node_get(node);
 
@@ -2417,6 +2439,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 			const struct i3c_master_controller_ops *ops,
 			bool secondary)
 {
+	unsigned long i2c_scl_rate = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
 	struct i3c_bus *i3cbus = i3c_master_get_bus(master);
 	enum i3c_bus_mode mode = I3C_BUS_MODE_PURE;
 	struct i2c_dev_boardinfo *i2cbi;
@@ -2466,9 +2489,12 @@ int i3c_master_register(struct i3c_master_controller *master,
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
 
-- 
2.7.4

