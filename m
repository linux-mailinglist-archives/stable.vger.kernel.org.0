Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ECD4D86E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfFTS0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfFTSGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:06:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE25204FD;
        Thu, 20 Jun 2019 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053964;
        bh=i9Ko+0/eQ4ec+hUVmpS3MjI3uwmIUDUjQmFTmcYNk1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TahNF0GltYeurJerwxoTgMnfQF+WgHTXMJmRg/4+LIBOkETPUCQrcSY0TqLcGwUYs
         8NgW/wvRwDIkHyrV++R7S9LMavLBNJZVaUZ0by8z7NntnzzKPPV5aJNpV86cfuLTpV
         x7QkkpddmukpUZ1GHq4I267WTRD3usXKvMvO8cY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Erik=20=C4=8Cuk?= <erik.cuk@domel.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.9 089/117] rtc: pcf8523: dont return invalid date when battery is low
Date:   Thu, 20 Jun 2019 19:57:03 +0200
Message-Id: <20190620174357.424257264@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

commit ecb4a353d3afd45b9bb30c85d03ee113a0589079 upstream.

The RTC_VL_READ ioctl reports the low battery condition. Still,
pcf8523_rtc_read_time() happily returns invalid dates in this case.
Check the battery health on pcf8523_rtc_read_time() to avoid that.

Reported-by: Erik Čuk <erik.cuk@domel.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pcf8523.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -82,6 +82,18 @@ static int pcf8523_write(struct i2c_clie
 	return 0;
 }
 
+static int pcf8523_voltage_low(struct i2c_client *client)
+{
+	u8 value;
+	int err;
+
+	err = pcf8523_read(client, REG_CONTROL3, &value);
+	if (err < 0)
+		return err;
+
+	return !!(value & REG_CONTROL3_BLF);
+}
+
 static int pcf8523_select_capacitance(struct i2c_client *client, bool high)
 {
 	u8 value;
@@ -164,6 +176,14 @@ static int pcf8523_rtc_read_time(struct
 	struct i2c_msg msgs[2];
 	int err;
 
+	err = pcf8523_voltage_low(client);
+	if (err < 0) {
+		return err;
+	} else if (err > 0) {
+		dev_err(dev, "low voltage detected, time is unreliable\n");
+		return -EINVAL;
+	}
+
 	msgs[0].addr = client->addr;
 	msgs[0].flags = 0;
 	msgs[0].len = 1;
@@ -248,17 +268,13 @@ static int pcf8523_rtc_ioctl(struct devi
 			     unsigned long arg)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 value;
-	int ret = 0, err;
+	int ret;
 
 	switch (cmd) {
 	case RTC_VL_READ:
-		err = pcf8523_read(client, REG_CONTROL3, &value);
-		if (err < 0)
-			return err;
-
-		if (value & REG_CONTROL3_BLF)
-			ret = 1;
+		ret = pcf8523_voltage_low(client);
+		if (ret < 0)
+			return ret;
 
 		if (copy_to_user((void __user *)arg, &ret, sizeof(int)))
 			return -EFAULT;


