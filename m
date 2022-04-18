Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE30A505798
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244131AbiDRN4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244386AbiDRNz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:55:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA57C49C93;
        Mon, 18 Apr 2022 06:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7CEB80D9C;
        Mon, 18 Apr 2022 13:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA79C385A1;
        Mon, 18 Apr 2022 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287073;
        bh=wzvb9FIoUFC6bSJa/l8aijFtIo9uOpgHeZG/hc/Xuxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzp9XGLXr8xEYFwlHAtZ175JRUtVpn3MHPhmCxxMKsYupYvyxnQDdl2sK/2DzHHS6
         ncfEcnVbl3qy/trBYZBT8p5pi6XOG3ZuqnU0z6HTQwFpZTnM5rVshjnQarVqqwuJY8
         15b20ovXpzqMpE1dtrKqhmpIDC+DYcvw084++v5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/218] hwmon: (pmbus) Add Vin unit off handling
Date:   Mon, 18 Apr 2022 14:11:56 +0200
Message-Id: <20220418121201.043754449@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Wyman <bjwyman@gmail.com>

[ Upstream commit a5436af598779219b375c1977555c82def1c35d0 ]

If there is an input undervoltage fault, reported in STATUS_INPUT
command response, there is quite likely a "Unit Off For Insufficient
Input Voltage" condition as well.

Add a constant for bit 3 of STATUS_INPUT. Update the Vin limit
attributes to include both bits in the mask for clearing faults.

If an input undervoltage fault occurs, causing a unit off for
insufficient input voltage, but the unit is off bit is not cleared, the
STATUS_WORD will not be updated to clear the input fault condition.
Including the unit is off bit (bit 3) allows for the input fault
condition to completely clear.

Signed-off-by: Brandon Wyman <bjwyman@gmail.com>
Link: https://lore.kernel.org/r/20220317232123.2103592-1-bjwyman@gmail.com
Fixes: b4ce237b7f7d3 ("hwmon: (pmbus) Introduce infrastructure to detect sensors and limit registers")
[groeck: Dropped unnecessary ()]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.h      | 1 +
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index bfcb13bae34b..8b6acb7497e2 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -262,6 +262,7 @@ enum pmbus_regs {
 /*
  * STATUS_VOUT, STATUS_INPUT
  */
+#define PB_VOLTAGE_VIN_OFF		BIT(3)
 #define PB_VOLTAGE_UV_FAULT		BIT(4)
 #define PB_VOLTAGE_UV_WARNING		BIT(5)
 #define PB_VOLTAGE_OV_WARNING		BIT(6)
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ed8c0d276388..a662702632a8 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1133,7 +1133,7 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
 		.reg = PMBUS_VIN_UV_FAULT_LIMIT,
 		.attr = "lcrit",
 		.alarm = "lcrit_alarm",
-		.sbit = PB_VOLTAGE_UV_FAULT,
+		.sbit = PB_VOLTAGE_UV_FAULT | PB_VOLTAGE_VIN_OFF,
 	}, {
 		.reg = PMBUS_VIN_OV_WARN_LIMIT,
 		.attr = "max",
-- 
2.34.1



