Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A0E375E9
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfFFOAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 10:00:10 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:48084 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727009AbfFFOAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 10:00:10 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7339FC0B9B;
        Thu,  6 Jun 2019 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559829588; bh=D7GbiPqmdrQeotVDa2DBsWTpcWpA9vK3PAnxRN5AHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=MjN9hDKAQ96DypJ9rgePcFO8rwvlc2m0ahCK99zWvUnwzJ5y01oF7h6jySnThAEFS
         RmXbfXKOeY4E2RlBHxE3wUyFH37Go0Nvyb1uothYjRerj+7Z/LEJ6OHLbEHS/8dVRh
         AZhzPsL4KD6ApN5Nu3FJQFkg4dDPRgRYik2GNj9YOQgqTRIFxkkDKKzCMsCMdJQ/G4
         4bkMz1KNeEy3sQbcd1wKvnlteR7a0+NUrN3qS5V0QP9eSyzPRh80zqkTLBPY2qjorU
         SF+M0UtMCtAqiMe4jQgnCW+OkhxZvQGHK7D7fnpHRvac0n+ketw3UJwjlhIKmWE01l
         OMEWmUTGXKK1g==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id EC7F4A005C;
        Thu,  6 Jun 2019 14:00:07 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id D51793F6CE;
        Thu,  6 Jun 2019 16:00:07 +0200 (CEST)
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     linux-i3c@lists.infradead.org
Cc:     Joao.Pinto@synopsys.com, Vitor Soares <Vitor.Soares@synopsys.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] i3c: fix i2c and i3c scl rate by bus mode
Date:   Thu,  6 Jun 2019 16:00:01 +0200
Message-Id: <47de89f2335930df0ed6903be9afe6de4f46e503.1559821228.git.vitor.soares@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559821227.git.vitor.soares@synopsys.com>
References: <cover.1559821227.git.vitor.soares@synopsys.com>
In-Reply-To: <cover.1559821227.git.vitor.soares@synopsys.com>
References: <cover.1559821227.git.vitor.soares@synopsys.com>
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
Changes in v2:
  Enhance commit message
  Add dev_warn() in case user-defined i2c rate doesn't match LVR constraint
  Add dev_warn() in case user-defined i3c rate lower than i2c rate.

 drivers/i3c/master.c | 61 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 5f4bd52..8cd5824 100644
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
@@ -565,20 +571,48 @@ static const struct device_type i3c_masterdev_type = {
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
 
+	if (i3cbus->scl_rate.i3c < i3cbus->scl_rate.i2c)
+		dev_warn(&master->dev,
+			 "i3c-scl-hz=%ld lower than i2c-scl-hz=%ld\n",
+			 i3cbus->scl_rate.i3c, i3cbus->scl_rate.i2c);
+
+	if (i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_SCL_RATE &&
+	    i3cbus->scl_rate.i2c != I3C_BUS_I2C_FM_PLUS_SCL_RATE &&
+	    i3cbus->mode != I3C_BUS_MODE_PURE)
+		dev_warn(&master->dev,
+			 "i2c-scl-hz=%ld not defined according MIPI I3C spec\n"
+			 , i3cbus->scl_rate.i2c);
+
 	/*
 	 * I3C/I2C frequency may have been overridden, check that user-provided
 	 * values are not exceeding max possible frequency.
@@ -1966,9 +2000,6 @@ of_i3c_master_add_i2c_boardinfo(struct i3c_master_controller *master,
 	/* LVR is encoded in reg[2]. */
 	boardinfo->lvr = reg[2];
 
-	if (boardinfo->lvr & I3C_LVR_I2C_FM_MODE)
-		master->bus.scl_rate.i2c = I3C_BUS_I2C_FM_SCL_RATE;
-
 	list_add_tail(&boardinfo->node, &master->boardinfo.i2c);
 	of_node_get(node);
 
@@ -2417,6 +2448,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 			const struct i3c_master_controller_ops *ops,
 			bool secondary)
 {
+	unsigned long i2c_scl_rate = I3C_BUS_I2C_FM_PLUS_SCL_RATE;
 	struct i3c_bus *i3cbus = i3c_master_get_bus(master);
 	enum i3c_bus_mode mode = I3C_BUS_MODE_PURE;
 	struct i2c_dev_boardinfo *i2cbi;
@@ -2466,9 +2498,12 @@ int i3c_master_register(struct i3c_master_controller *master,
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

