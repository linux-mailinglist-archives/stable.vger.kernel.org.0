Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2564D5055A8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbiDRNOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244003AbiDRNKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:10:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE42396B0;
        Mon, 18 Apr 2022 05:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B3CA6124D;
        Mon, 18 Apr 2022 12:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDEDC385A1;
        Mon, 18 Apr 2022 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286220;
        bh=orYsiMU+k0qTfJ8VPyrMiFa07oD/Li21kpYPCvQblcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKlWmfrUebCKzWNTfGeRKvXUZdZG0bgseHjnKM5BJeNb97LGzRJHkNrPmYLyZo2r9
         OdHrW0Qow8aQk/L3utKPM7Ojg0jMgzfmEjyu9mlXcU68+1qxZZHp481UoiwChRK1fi
         Li1iVfc5rRoZk6zuvIo3e/gadQPHX9D8mk3YnZ7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/284] hwmon: (pmbus) Add Vin unit off handling
Date:   Mon, 18 Apr 2022 14:10:47 +0200
Message-Id: <20220418121212.567383982@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
index fa613bd209e3..1fed8ed36d5e 100644
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
index 66c72aedde5e..b736fe1a05b7 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1162,7 +1162,7 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
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



