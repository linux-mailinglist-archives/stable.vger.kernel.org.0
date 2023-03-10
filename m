Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0DB6B4881
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjCJPDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbjCJPCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553DF1269A4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0707B82312
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DBFC433D2;
        Fri, 10 Mar 2023 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460165;
        bh=jgkklR2BvU/jD4Cmdir2qUoCtqdmG+M//ScWbKe2ejI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqTKXjUcj/+jwxcijJXht+XAzSNPekPgZbr9mm4CqiRh7IqPX/TpuiBmrOsGXeEvh
         i3jhEL1WBQm9+Y903eNwjEB6Gu+v3FfcOTOTRXwznfhU8ziWahedvE8Hsr0Ah5a8y0
         KxPw4RKy4o5Vy7nxrRfqcfF1bV9TIsZc/LDgpsR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/529] Input: ads7846 - convert to full duplex
Date:   Fri, 10 Mar 2023 14:36:26 +0100
Message-Id: <20230310133816.225270980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9c9509717b53e701469493a8d87ed42c7d782502 ]

Starting with 3eac5c7e44f3 ("Input: ads7846 - extend the driver for ads7845
controller support"), the ads7845 was partially converted to full duplex
mode.

Since it is not touchscreen controller specific, it is better to extend
this conversion to cover entire driver. This will reduce CPU load and make
driver more readable.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20201110085041.16303-2-o.rempel@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 13f82ca3878d ("Input: ads7846 - always set last command to PWRDOWN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 192 +++++++++-------------------
 1 file changed, 62 insertions(+), 130 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 370e0dbc02dea..04ca0e13acd39 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -63,19 +63,26 @@
 /* this driver doesn't aim at the peak continuous sample rate */
 #define	SAMPLE_BITS	(8 /*cmd*/ + 16 /*sample*/ + 2 /* before, after */)
 
-struct ts_event {
+struct ads7846_buf {
+	u8 cmd;
 	/*
-	 * For portability, we can't read 12 bit values using SPI (which
-	 * would make the controller deliver them as native byte order u16
-	 * with msbs zeroed).  Instead, we read them as two 8-bit values,
-	 * *** WHICH NEED BYTESWAPPING *** and range adjustment.
+	 * This union is a temporary hack. The driver does an in-place
+	 * endianness conversion. This will be cleaned up in the next
+	 * patch.
 	 */
-	u16	x;
-	u16	y;
-	u16	z1, z2;
-	bool	ignore;
-	u8	x_buf[3];
-	u8	y_buf[3];
+	union {
+		__be16 data_be16;
+		u16 data;
+	};
+} __packed;
+
+
+struct ts_event {
+	bool ignore;
+	struct ads7846_buf x;
+	struct ads7846_buf y;
+	struct ads7846_buf z1;
+	struct ads7846_buf z2;
 };
 
 /*
@@ -84,11 +91,12 @@ struct ts_event {
  * systems where main memory is not DMA-coherent (most non-x86 boards).
  */
 struct ads7846_packet {
-	u8			read_x, read_y, read_z1, read_z2, pwrdown;
-	u16			dummy;		/* for the pwrdown read */
-	struct ts_event		tc;
-	/* for ads7845 with mpc5121 psc spi we use 3-byte buffers */
-	u8			read_x_cmd[3], read_y_cmd[3], pwrdown_cmd[3];
+	struct ts_event tc;
+	struct ads7846_buf read_x_cmd;
+	struct ads7846_buf read_y_cmd;
+	struct ads7846_buf read_z1_cmd;
+	struct ads7846_buf read_z2_cmd;
+	struct ads7846_buf pwrdown_cmd;
 };
 
 struct ads7846 {
@@ -687,16 +695,9 @@ static int ads7846_get_value(struct ads7846 *ts, struct spi_message *m)
 	int value;
 	struct spi_transfer *t =
 		list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
+	struct ads7846_buf *buf = t->rx_buf;
 
-	if (ts->model == 7845) {
-		value = be16_to_cpup((__be16 *)&(((char *)t->rx_buf)[1]));
-	} else {
-		/*
-		 * adjust:  on-wire is a must-ignore bit, a BE12 value, then
-		 * padding; built from two 8 bit values written msb-first.
-		 */
-		value = be16_to_cpup((__be16 *)t->rx_buf);
-	}
+	value = be16_to_cpup(&buf->data_be16);
 
 	/* enforce ADC output is 12 bits width */
 	return (value >> 3) & 0xfff;
@@ -706,8 +707,9 @@ static void ads7846_update_value(struct spi_message *m, int val)
 {
 	struct spi_transfer *t =
 		list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
+	struct ads7846_buf *buf = t->rx_buf;
 
-	*(u16 *)t->rx_buf = val;
+	buf->data = val;
 }
 
 static void ads7846_read_state(struct ads7846 *ts)
@@ -775,16 +777,14 @@ static void ads7846_report_state(struct ads7846 *ts)
 	 * from on-the-wire format as part of debouncing to get stable
 	 * readings.
 	 */
+	x = packet->tc.x.data;
+	y = packet->tc.y.data;
 	if (ts->model == 7845) {
-		x = *(u16 *)packet->tc.x_buf;
-		y = *(u16 *)packet->tc.y_buf;
 		z1 = 0;
 		z2 = 0;
 	} else {
-		x = packet->tc.x;
-		y = packet->tc.y;
-		z1 = packet->tc.z1;
-		z2 = packet->tc.z2;
+		z1 = packet->tc.z1.data;
+		z2 = packet->tc.z2.data;
 	}
 
 	/* range filtering */
@@ -1002,26 +1002,11 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 	spi_message_init(m);
 	m->context = ts;
 
-	if (ts->model == 7845) {
-		packet->read_y_cmd[0] = READ_Y(vref);
-		packet->read_y_cmd[1] = 0;
-		packet->read_y_cmd[2] = 0;
-		x->tx_buf = &packet->read_y_cmd[0];
-		x->rx_buf = &packet->tc.y_buf[0];
-		x->len = 3;
-		spi_message_add_tail(x, m);
-	} else {
-		/* y- still on; turn on only y+ (and ADC) */
-		packet->read_y = READ_Y(vref);
-		x->tx_buf = &packet->read_y;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.y;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-	}
+	packet->read_y_cmd.cmd = READ_Y(vref);
+	x->tx_buf = &packet->read_y_cmd;
+	x->rx_buf = &packet->tc.y;
+	x->len = 3;
+	spi_message_add_tail(x, m);
 
 	/*
 	 * The first sample after switching drivers can be low quality;
@@ -1031,15 +1016,11 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 	if (pdata->settle_delay_usecs) {
 		x->delay.value = pdata->settle_delay_usecs;
 		x->delay.unit = SPI_DELAY_UNIT_USECS;
-
 		x++;
-		x->tx_buf = &packet->read_y;
-		x->len = 1;
-		spi_message_add_tail(x, m);
 
-		x++;
+		x->tx_buf = &packet->read_y_cmd;
 		x->rx_buf = &packet->tc.y;
-		x->len = 2;
+		x->len = 3;
 		spi_message_add_tail(x, m);
 	}
 
@@ -1048,28 +1029,13 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 	spi_message_init(m);
 	m->context = ts;
 
-	if (ts->model == 7845) {
-		x++;
-		packet->read_x_cmd[0] = READ_X(vref);
-		packet->read_x_cmd[1] = 0;
-		packet->read_x_cmd[2] = 0;
-		x->tx_buf = &packet->read_x_cmd[0];
-		x->rx_buf = &packet->tc.x_buf[0];
-		x->len = 3;
-		spi_message_add_tail(x, m);
-	} else {
-		/* turn y- off, x+ on, then leave in lowpower */
-		x++;
-		packet->read_x = READ_X(vref);
-		x->tx_buf = &packet->read_x;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.x;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-	}
+	/* turn y- off, x+ on, then leave in lowpower */
+	x++;
+	packet->read_x_cmd.cmd = READ_X(vref);
+	x->tx_buf = &packet->read_x_cmd;
+	x->rx_buf = &packet->tc.x;
+	x->len = 3;
+	spi_message_add_tail(x, m);
 
 	/* ... maybe discard first sample ... */
 	if (pdata->settle_delay_usecs) {
@@ -1077,13 +1043,9 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 		x->delay.unit = SPI_DELAY_UNIT_USECS;
 
 		x++;
-		x->tx_buf = &packet->read_x;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
+		x->tx_buf = &packet->read_x_cmd;
 		x->rx_buf = &packet->tc.x;
-		x->len = 2;
+		x->len = 3;
 		spi_message_add_tail(x, m);
 	}
 
@@ -1095,14 +1057,10 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 		m->context = ts;
 
 		x++;
-		packet->read_z1 = READ_Z1(vref);
-		x->tx_buf = &packet->read_z1;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
+		packet->read_z1_cmd.cmd = READ_Z1(vref);
+		x->tx_buf = &packet->read_z1_cmd;
 		x->rx_buf = &packet->tc.z1;
-		x->len = 2;
+		x->len = 3;
 		spi_message_add_tail(x, m);
 
 		/* ... maybe discard first sample ... */
@@ -1111,13 +1069,9 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 			x->delay.unit = SPI_DELAY_UNIT_USECS;
 
 			x++;
-			x->tx_buf = &packet->read_z1;
-			x->len = 1;
-			spi_message_add_tail(x, m);
-
-			x++;
+			x->tx_buf = &packet->read_z1_cmd;
 			x->rx_buf = &packet->tc.z1;
-			x->len = 2;
+			x->len = 3;
 			spi_message_add_tail(x, m);
 		}
 
@@ -1127,14 +1081,10 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 		m->context = ts;
 
 		x++;
-		packet->read_z2 = READ_Z2(vref);
-		x->tx_buf = &packet->read_z2;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
+		packet->read_z2_cmd.cmd = READ_Z2(vref);
+		x->tx_buf = &packet->read_z2_cmd;
 		x->rx_buf = &packet->tc.z2;
-		x->len = 2;
+		x->len = 3;
 		spi_message_add_tail(x, m);
 
 		/* ... maybe discard first sample ... */
@@ -1143,13 +1093,9 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 			x->delay.unit = SPI_DELAY_UNIT_USECS;
 
 			x++;
-			x->tx_buf = &packet->read_z2;
-			x->len = 1;
-			spi_message_add_tail(x, m);
-
-			x++;
+			x->tx_buf = &packet->read_z2_cmd;
 			x->rx_buf = &packet->tc.z2;
-			x->len = 2;
+			x->len = 3;
 			spi_message_add_tail(x, m);
 		}
 	}
@@ -1160,24 +1106,10 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 	spi_message_init(m);
 	m->context = ts;
 
-	if (ts->model == 7845) {
-		x++;
-		packet->pwrdown_cmd[0] = PWRDOWN;
-		packet->pwrdown_cmd[1] = 0;
-		packet->pwrdown_cmd[2] = 0;
-		x->tx_buf = &packet->pwrdown_cmd[0];
-		x->len = 3;
-	} else {
-		x++;
-		packet->pwrdown = PWRDOWN;
-		x->tx_buf = &packet->pwrdown;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->dummy;
-		x->len = 2;
-	}
+	x++;
+	packet->pwrdown_cmd.cmd = PWRDOWN;
+	x->tx_buf = &packet->pwrdown_cmd;
+	x->len = 3;
 
 	CS_CHANGE(*x);
 	spi_message_add_tail(x, m);
-- 
2.39.2



