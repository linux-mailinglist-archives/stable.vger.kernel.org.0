Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4F74F2820
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiDEIKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiDEH6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BE3A1456;
        Tue,  5 Apr 2022 00:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F83615CD;
        Tue,  5 Apr 2022 07:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42447C34110;
        Tue,  5 Apr 2022 07:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145143;
        bh=fR0LPZAFW7MV+r5mifjCwMPbuQwjL9+Zm/J+XCY09io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd31HzG7dpvwZqVsV2dShX0bKnKeTTwnj8CoVPMUHujjtD/m9iUlGU0afVxE5/PB6
         3qejTbvJIw4BRul5l9C18lwMFlqxq55fLcw+bsPWaTHzfixchsO1kfrJyTNiTKfrS3
         WM/DDbA78CgKCMgp/MiJo6ehrwfbfkJBD7TLGhHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Wyman <bjwyman@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0262/1126] hwmon: (pmbus) Add Vin unit off handling
Date:   Tue,  5 Apr 2022 09:16:49 +0200
Message-Id: <20220405070415.301141553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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
index e0aa8aa46d8c..ef3a8ecde4df 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -319,6 +319,7 @@ enum pmbus_fan_mode { percent = 0, rpm };
 /*
  * STATUS_VOUT, STATUS_INPUT
  */
+#define PB_VOLTAGE_VIN_OFF		BIT(3)
 #define PB_VOLTAGE_UV_FAULT		BIT(4)
 #define PB_VOLTAGE_UV_WARNING		BIT(5)
 #define PB_VOLTAGE_OV_WARNING		BIT(6)
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index b1386a4df4cc..ca0bfaf2f691 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1373,7 +1373,7 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
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



