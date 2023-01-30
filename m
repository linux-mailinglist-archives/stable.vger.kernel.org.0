Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8096811F4
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbjA3ORd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbjA3ORC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920133D0B4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27FB46104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD81C433EF;
        Mon, 30 Jan 2023 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088213;
        bh=Q/BRIbzshuoEbGWOMb6c8tUt8RvSZSPLK/DKIPfLb/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zF30wchhROKv/O1e5lWqngXdK4thCytmBThxLs6lfbGDbri17VtnF4aByy9Qfi2nn
         cKLC+/Tgc4o7yZRGfHHZ1sqFyykvnAQPm72gL/I7Pv6Hd2Pnv220D7NXMCc1ieaiGA
         Ybl7lSgt5TVNIzvapDrbW0lTSbre2h+e87bq8H+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Morgan <macromorgan@hotmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Wolfram Sang <wsa@kernel.org>, Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 5.15 153/204] i2c: mv64xxx: Add atomic_xfer method to driver
Date:   Mon, 30 Jan 2023 14:51:58 +0100
Message-Id: <20230130134323.275728931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Morgan <macromorgan@hotmail.com>

commit 544a8d75f3d6e60e160cd92dc56321484598a993 upstream.

Add an atomic_xfer method to the driver so that it behaves correctly
when controlling a PMIC that is responsible for device shutdown.

The atomic_xfer method added is similar to the one from the i2c-rk3x
driver. When running an atomic_xfer a bool flag in the driver data is
set, the interrupt is not unmasked on transfer start, and the IRQ
handler is manually invoked while waiting for pending transfers to
complete.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c |   52 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -150,6 +150,7 @@ struct mv64xxx_i2c_data {
 	/* Clk div is 2 to the power n, not 2 to the power n + 1 */
 	bool			clk_n_base_0;
 	struct i2c_bus_recovery_info	rinfo;
+	bool			atomic;
 };
 
 static struct mv64xxx_i2c_regs mv64xxx_i2c_regs_mv64xxx = {
@@ -179,7 +180,10 @@ mv64xxx_i2c_prepare_for_io(struct mv64xx
 	u32	dir = 0;
 
 	drv_data->cntl_bits = MV64XXX_I2C_REG_CONTROL_ACK |
-		MV64XXX_I2C_REG_CONTROL_INTEN | MV64XXX_I2C_REG_CONTROL_TWSIEN;
+			      MV64XXX_I2C_REG_CONTROL_TWSIEN;
+
+	if (!drv_data->atomic)
+		drv_data->cntl_bits |= MV64XXX_I2C_REG_CONTROL_INTEN;
 
 	if (msg->flags & I2C_M_RD)
 		dir = 1;
@@ -409,7 +413,8 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c
 	case MV64XXX_I2C_ACTION_RCV_DATA_STOP:
 		drv_data->msg->buf[drv_data->byte_posn++] =
 			readl(drv_data->reg_base + drv_data->reg_offsets.data);
-		drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
+		if (!drv_data->atomic)
+			drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
 		writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_STOP,
 			drv_data->reg_base + drv_data->reg_offsets.control);
 		drv_data->block = 0;
@@ -427,7 +432,8 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c
 		drv_data->rc = -EIO;
 		fallthrough;
 	case MV64XXX_I2C_ACTION_SEND_STOP:
-		drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
+		if (!drv_data->atomic)
+			drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
 		writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_STOP,
 			drv_data->reg_base + drv_data->reg_offsets.control);
 		drv_data->block = 0;
@@ -575,6 +581,17 @@ mv64xxx_i2c_wait_for_completion(struct m
 		spin_unlock_irqrestore(&drv_data->lock, flags);
 }
 
+static void mv64xxx_i2c_wait_polling(struct mv64xxx_i2c_data *drv_data)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), drv_data->adapter.timeout);
+
+	while (READ_ONCE(drv_data->block) &&
+	       ktime_compare(ktime_get(), timeout) < 0) {
+		udelay(5);
+		mv64xxx_i2c_intr(0, drv_data);
+	}
+}
+
 static int
 mv64xxx_i2c_execute_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg,
 				int is_last)
@@ -590,7 +607,11 @@ mv64xxx_i2c_execute_msg(struct mv64xxx_i
 	mv64xxx_i2c_send_start(drv_data);
 	spin_unlock_irqrestore(&drv_data->lock, flags);
 
-	mv64xxx_i2c_wait_for_completion(drv_data);
+	if (!drv_data->atomic)
+		mv64xxx_i2c_wait_for_completion(drv_data);
+	else
+		mv64xxx_i2c_wait_polling(drv_data);
+
 	return drv_data->rc;
 }
 
@@ -717,7 +738,7 @@ mv64xxx_i2c_functionality(struct i2c_ada
 }
 
 static int
-mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+mv64xxx_i2c_xfer_core(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 {
 	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
 	int rc, ret = num;
@@ -730,7 +751,7 @@ mv64xxx_i2c_xfer(struct i2c_adapter *ada
 	drv_data->msgs = msgs;
 	drv_data->num_msgs = num;
 
-	if (mv64xxx_i2c_can_offload(drv_data))
+	if (mv64xxx_i2c_can_offload(drv_data) && !drv_data->atomic)
 		rc = mv64xxx_i2c_offload_xfer(drv_data);
 	else
 		rc = mv64xxx_i2c_execute_msg(drv_data, &msgs[0], num == 1);
@@ -747,8 +768,27 @@ mv64xxx_i2c_xfer(struct i2c_adapter *ada
 	return ret;
 }
 
+static int
+mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+{
+	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
+
+	drv_data->atomic = 0;
+	return mv64xxx_i2c_xfer_core(adap, msgs, num);
+}
+
+static int mv64xxx_i2c_xfer_atomic(struct i2c_adapter *adap,
+				   struct i2c_msg msgs[], int num)
+{
+	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
+
+	drv_data->atomic = 1;
+	return mv64xxx_i2c_xfer_core(adap, msgs, num);
+}
+
 static const struct i2c_algorithm mv64xxx_i2c_algo = {
 	.master_xfer = mv64xxx_i2c_xfer,
+	.master_xfer_atomic = mv64xxx_i2c_xfer_atomic,
 	.functionality = mv64xxx_i2c_functionality,
 };
 


