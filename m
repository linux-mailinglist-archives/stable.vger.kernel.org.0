Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97759217004
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgGGPOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbgGGPOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E6120674;
        Tue,  7 Jul 2020 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134856;
        bh=BUnxTZ/EJQs2L/Farqq3ymAPQoSr6DJTHzHmh8O1Xc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJbW43QC5kxxmW6dNoj03d6LDzMaLrg9rE1ncU1n3vwZ//n+JRHl1eXqCvW7TI/XK
         qAiRsdPDiqcfjijEwL+yFj+jNKgtjXKTdc3XYwTO/BMEJRb2an/uPJ8IsqCaA0MBrS
         lz8Pgm+5W3p2+jgItdHajFLW3wpD0bYmMqUH25x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chu Lin <linchuyuan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/24] hwmon: (max6697) Make sure the OVERT mask is set correctly
Date:   Tue,  7 Jul 2020 17:13:46 +0200
Message-Id: <20200707145749.656617937@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chu Lin <linchuyuan@google.com>

[ Upstream commit 016983d138cbe99a5c0aaae0103ee88f5300beb3 ]

Per the datasheet for max6697, OVERT mask and ALERT mask are different.
For example, the 7th bit of OVERT is the local channel but for alert
mask, the 6th bit is the local channel. Therefore, we can't apply the
same mask for both registers. In addition to that, the max6697 driver
is supposed to be compatibale with different models. I manually went over
all the listed chips and made sure all chip types have the same layout.

Testing;
    mask value of 0x9 should map to 0x44 for ALERT and 0x84 for OVERT.
    I used iotool to read the reg value back to verify. I only tested this
    change on max6581.

Reference:
https://datasheets.maximintegrated.com/en/ds/MAX6581.pdf
https://datasheets.maximintegrated.com/en/ds/MAX6697.pdf
https://datasheets.maximintegrated.com/en/ds/MAX6699.pdf

Signed-off-by: Chu Lin <linchuyuan@google.com>
Fixes: 5372d2d71c46e ("hwmon: Driver for Maxim MAX6697 and compatibles")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index f03a71722849a..d4bb3d6aaf18c 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -46,8 +46,9 @@ static const u8 MAX6697_REG_CRIT[] = {
  * Map device tree / platform data register bit map to chip bit map.
  * Applies to alert register and over-temperature register.
  */
-#define MAX6697_MAP_BITS(reg)	((((reg) & 0x7e) >> 1) | \
+#define MAX6697_ALERT_MAP_BITS(reg)	((((reg) & 0x7e) >> 1) | \
 				 (((reg) & 0x01) << 6) | ((reg) & 0x80))
+#define MAX6697_OVERT_MAP_BITS(reg) (((reg) >> 1) | (((reg) & 0x01) << 7))
 
 #define MAX6697_REG_STAT(n)		(0x44 + (n))
 
@@ -586,12 +587,12 @@ static int max6697_init_chip(struct max6697_data *data,
 		return ret;
 
 	ret = i2c_smbus_write_byte_data(client, MAX6697_REG_ALERT_MASK,
-					MAX6697_MAP_BITS(pdata->alert_mask));
+				MAX6697_ALERT_MAP_BITS(pdata->alert_mask));
 	if (ret < 0)
 		return ret;
 
 	ret = i2c_smbus_write_byte_data(client, MAX6697_REG_OVERT_MASK,
-				MAX6697_MAP_BITS(pdata->over_temperature_mask));
+			MAX6697_OVERT_MAP_BITS(pdata->over_temperature_mask));
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1



