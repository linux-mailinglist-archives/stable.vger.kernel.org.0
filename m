Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4354FD9C2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353315AbiDLID2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356949AbiDLHjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4A74B1C4;
        Tue, 12 Apr 2022 00:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B222E616AB;
        Tue, 12 Apr 2022 07:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCACC385A1;
        Tue, 12 Apr 2022 07:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747435;
        bh=CBy5DzSt/DDqfNIg2zikiyymZmnWiRhZbtSG9wmBV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW3gbfiS4SEcNbvqVmItBM3FPJYlrv/qyU3lCE8gAWxppcZh8fs/cu/eCQQMDwisq
         6jTicJu+vYV4KI4LmDMAk3649Wlt5PdZYVuWOWz3xvg7B7gpIi9z3m84RVyFs0G11V
         EzaaRkNd765T+8zEFOVrrrW4aQY8dfR+HgAczAMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 079/343] power: supply: axp288-charger: Set Vhold to 4.4V
Date:   Tue, 12 Apr 2022 08:28:17 +0200
Message-Id: <20220412062953.380604209@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5ac121b81b4051e7fc83d5b3456a5e499d5bd147 ]

The AXP288's recommended and factory default Vhold value (minimum
input voltage below which the input current draw will be reduced)
is 4.4V. This lines up with other charger IC's such as the TI
bq2419x/bq2429x series which use 4.36V or 4.44V.

For some reason some BIOS-es initialize Vhold to 4.6V or even 4.7V
which combined with the typical voltage drop over typically low
wire gauge micro-USB cables leads to the input-current getting
capped below 1A (with a 2A capable dedicated charger) based on Vhold.

This leads to slow charging, or even to the device slowly discharging
if the device is in heavy use.

As the Linux AXP288 drivers use the builtin BC1.2 charger detection
and send the input-current-limit according to the detected charger
there really is no reason not to use the recommended 4.4V Vhold.

Set Vhold to 4.4V to fix the slow charging issue on various devices.

There is one exception, the special-case of the HP X2 2-in-1s which
combine this BC1.2 capable PMIC with a Type-C port and a 5V/3A factory
provided charger with a Type-C plug which does not do BC1.2. These
have their input-current-limit hardcoded to 3A (like under Windows)
and use a higher Vhold on purpose to limit the current when used
with other chargers. To avoid touching Vhold on these HP X2 laptops
the code setting Vhold is added to an else branch of the if checking
for these models.

Note this also fixes the sofar unused VBUS_ISPOUT_VHOLD_SET_MASK
define, which was wrong.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_charger.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index ec41f6cd3f93..c498e62ab4e2 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -42,11 +42,11 @@
 #define VBUS_ISPOUT_CUR_LIM_1500MA	0x1	/* 1500mA */
 #define VBUS_ISPOUT_CUR_LIM_2000MA	0x2	/* 2000mA */
 #define VBUS_ISPOUT_CUR_NO_LIM		0x3	/* 2500mA */
-#define VBUS_ISPOUT_VHOLD_SET_MASK	0x31
+#define VBUS_ISPOUT_VHOLD_SET_MASK	0x38
 #define VBUS_ISPOUT_VHOLD_SET_BIT_POS	0x3
 #define VBUS_ISPOUT_VHOLD_SET_OFFSET	4000	/* 4000mV */
 #define VBUS_ISPOUT_VHOLD_SET_LSB_RES	100	/* 100mV */
-#define VBUS_ISPOUT_VHOLD_SET_4300MV	0x3	/* 4300mV */
+#define VBUS_ISPOUT_VHOLD_SET_4400MV	0x4	/* 4400mV */
 #define VBUS_ISPOUT_VBUS_PATH_DIS	BIT(7)
 
 #define CHRG_CCCV_CC_MASK		0xf		/* 4 bits */
@@ -769,6 +769,16 @@ static int charger_init_hw_regs(struct axp288_chrg_info *info)
 		ret = axp288_charger_vbus_path_select(info, true);
 		if (ret < 0)
 			return ret;
+	} else {
+		/* Set Vhold to the factory default / recommended 4.4V */
+		val = VBUS_ISPOUT_VHOLD_SET_4400MV << VBUS_ISPOUT_VHOLD_SET_BIT_POS;
+		ret = regmap_update_bits(info->regmap, AXP20X_VBUS_IPSOUT_MGMT,
+					 VBUS_ISPOUT_VHOLD_SET_MASK, val);
+		if (ret < 0) {
+			dev_err(&info->pdev->dev, "register(%x) write error(%d)\n",
+				AXP20X_VBUS_IPSOUT_MGMT, ret);
+			return ret;
+		}
 	}
 
 	/* Read current charge voltage and current limit */
-- 
2.35.1



