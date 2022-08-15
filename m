Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E375944B9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344527AbiHOWGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348484AbiHOWF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C8E1160B6;
        Mon, 15 Aug 2022 12:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F9766114B;
        Mon, 15 Aug 2022 19:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81931C433D6;
        Mon, 15 Aug 2022 19:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592253;
        bh=lyksit9egkFgQzevi8lT0Oeq5R1tu5DzG6yzRvGK+bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQjzlJ6R+7iNrYQAWwKYTIQz6ujAtSAueVpxsbyEsT9w8N005HiLBZVMyv+63kzfg
         gfxtvNd3PclwznWCZvE5OOfzGMQcH3Txf04fuVqQ9Hs0xAQS/xCBA18Oy5mR/n+rud
         tKIasBxbVSWNjZ+gxUE1NRoJP0OUr6K7uioYL2RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathew McBride <matt@traverse.com.au>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.19 0081/1157] rtc: rx8025: fix 12/24 hour mode detection on RX-8035
Date:   Mon, 15 Aug 2022 19:50:37 +0200
Message-Id: <20220815180442.776331196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathew McBride <matt@traverse.com.au>

commit 71af91565052214ad86f288e0d8ffb165f790995 upstream.

The 12/24hr flag in the RX-8035 can be found in the hour register,
instead of the CTRL1 on the RX-8025. This was overlooked when
support for the RX-8035 was added, and was causing read errors when
the hour register 'overflowed'.

To deal with the relevant register not always being visible in
the relevant functions, determine the 12/24 mode at startup and
store it in the driver state.

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: f120e2e33ac8 ("rtc: rx8025: implement RX-8035 support")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220706074236.24011-1-matt@traverse.com.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rx8025.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -55,6 +55,8 @@
 #define RX8025_BIT_CTRL2_XST	BIT(5)
 #define RX8025_BIT_CTRL2_VDET	BIT(6)
 
+#define RX8035_BIT_HOUR_1224	BIT(7)
+
 /* Clock precision adjustment */
 #define RX8025_ADJ_RESOLUTION	3050 /* in ppb */
 #define RX8025_ADJ_DATA_MAX	62
@@ -78,6 +80,7 @@ struct rx8025_data {
 	struct rtc_device *rtc;
 	enum rx_model model;
 	u8 ctrl1;
+	int is_24;
 };
 
 static s32 rx8025_read_reg(const struct i2c_client *client, u8 number)
@@ -226,7 +229,7 @@ static int rx8025_get_time(struct device
 
 	dt->tm_sec = bcd2bin(date[RX8025_REG_SEC] & 0x7f);
 	dt->tm_min = bcd2bin(date[RX8025_REG_MIN] & 0x7f);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		dt->tm_hour = bcd2bin(date[RX8025_REG_HOUR] & 0x3f);
 	else
 		dt->tm_hour = bcd2bin(date[RX8025_REG_HOUR] & 0x1f) % 12
@@ -254,7 +257,7 @@ static int rx8025_set_time(struct device
 	 */
 	date[RX8025_REG_SEC] = bin2bcd(dt->tm_sec);
 	date[RX8025_REG_MIN] = bin2bcd(dt->tm_min);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		date[RX8025_REG_HOUR] = bin2bcd(dt->tm_hour);
 	else
 		date[RX8025_REG_HOUR] = (dt->tm_hour >= 12 ? 0x20 : 0)
@@ -279,6 +282,7 @@ static int rx8025_init_client(struct i2c
 	struct rx8025_data *rx8025 = i2c_get_clientdata(client);
 	u8 ctrl[2], ctrl2;
 	int need_clear = 0;
+	int hour_reg;
 	int err;
 
 	err = rx8025_read_regs(client, RX8025_REG_CTRL1, 2, ctrl);
@@ -303,6 +307,16 @@ static int rx8025_init_client(struct i2c
 
 		err = rx8025_write_reg(client, RX8025_REG_CTRL2, ctrl2);
 	}
+
+	if (rx8025->model == model_rx_8035) {
+		/* In RX-8035, 12/24 flag is in the hour register */
+		hour_reg = rx8025_read_reg(client, RX8025_REG_HOUR);
+		if (hour_reg < 0)
+			return hour_reg;
+		rx8025->is_24 = (hour_reg & RX8035_BIT_HOUR_1224);
+	} else {
+		rx8025->is_24 = (ctrl[1] & RX8025_BIT_CTRL1_1224);
+	}
 out:
 	return err;
 }
@@ -329,7 +343,7 @@ static int rx8025_read_alarm(struct devi
 	/* Hardware alarms precision is 1 minute! */
 	t->time.tm_sec = 0;
 	t->time.tm_min = bcd2bin(ald[0] & 0x7f);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		t->time.tm_hour = bcd2bin(ald[1] & 0x3f);
 	else
 		t->time.tm_hour = bcd2bin(ald[1] & 0x1f) % 12
@@ -350,7 +364,7 @@ static int rx8025_set_alarm(struct devic
 	int err;
 
 	ald[0] = bin2bcd(t->time.tm_min);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		ald[1] = bin2bcd(t->time.tm_hour);
 	else
 		ald[1] = (t->time.tm_hour >= 12 ? 0x20 : 0)


