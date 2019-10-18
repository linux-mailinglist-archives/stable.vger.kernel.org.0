Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2254BDD1DB
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfJRWGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbfJRWGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C50DD205F4;
        Fri, 18 Oct 2019 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436383;
        bh=RvdmIHjl9M/uIBvoDW1MmFcmt7/EQNFWicJ8bo2698A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqP+bEniA7GmRaCCDc9aRIZoQUy4CmkAS/gjcUnl5ZyioRuYaEgF4AsY3wxYquWTN
         QU9QfiaBHFF0futUb0e0+TEJqw9ocBJ6bVklQHlrB4q6B7qXex/nySppY8k/q7Y7lz
         TLDL9uXx12efuNZAoWGVDIw0bfCoQ6Jy8Li26rcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/100] rtc: pcf8523: set xtal load capacitance from DT
Date:   Fri, 18 Oct 2019 18:04:21 -0400
Message-Id: <20191018220525.9042-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit 189927e719e36ceefbb8037f23d3849e47833aef ]

Add support for specifying the xtal load capacitance in the DT node.
The pcf8523 supports xtal load capacitance of 7pF or 12.5pF.
If the rtc has the wrong configuration the time will
drift several hours/week.

The driver use the default value 12.5pF.

The DT may specify either 7000fF or 12500fF.
(The DT uses femto Farad to avoid decimal numbers).
Other values are warned and the driver uses the default value.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8523.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
index 3fcd2cbafc845..2e03021f15d13 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -97,8 +97,9 @@ static int pcf8523_voltage_low(struct i2c_client *client)
 	return !!(value & REG_CONTROL3_BLF);
 }
 
-static int pcf8523_select_capacitance(struct i2c_client *client, bool high)
+static int pcf8523_load_capacitance(struct i2c_client *client)
 {
+	u32 load;
 	u8 value;
 	int err;
 
@@ -106,14 +107,24 @@ static int pcf8523_select_capacitance(struct i2c_client *client, bool high)
 	if (err < 0)
 		return err;
 
-	if (!high)
-		value &= ~REG_CONTROL1_CAP_SEL;
-	else
+	load = 12500;
+	of_property_read_u32(client->dev.of_node, "quartz-load-femtofarads",
+			     &load);
+
+	switch (load) {
+	default:
+		dev_warn(&client->dev, "Unknown quartz-load-femtofarads value: %d. Assuming 12500",
+			 load);
+		/* fall through */
+	case 12500:
 		value |= REG_CONTROL1_CAP_SEL;
+		break;
+	case 7000:
+		value &= ~REG_CONTROL1_CAP_SEL;
+		break;
+	}
 
 	err = pcf8523_write(client, REG_CONTROL1, value);
-	if (err < 0)
-		return err;
 
 	return err;
 }
@@ -347,9 +358,10 @@ static int pcf8523_probe(struct i2c_client *client,
 	if (!pcf)
 		return -ENOMEM;
 
-	err = pcf8523_select_capacitance(client, true);
+	err = pcf8523_load_capacitance(client);
 	if (err < 0)
-		return err;
+		dev_warn(&client->dev, "failed to set xtal load capacitance: %d",
+			 err);
 
 	err = pcf8523_set_pm(client, 0);
 	if (err < 0)
-- 
2.20.1

