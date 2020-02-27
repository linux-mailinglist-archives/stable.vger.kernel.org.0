Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EF3172168
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgB0Osk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgB0Nmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:42:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B0D20578;
        Thu, 27 Feb 2020 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810958;
        bh=T1ZKD43Hoi0VlEAm4qsLbLuTAyNG1fwLV0FTSp5WMTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWlvm7bK6+joRGuTwyG651Dlh5bEaoqMC5xgm509cDfkBjgJeQLcwLEwYKOSduIg4
         SoMYuczvXYVDf1wNW8Qc4tjo21WqkQHkLHccffgkBP6v2YFufMoH4L3bKRmedpcxeL
         KRHcPTgCyew6HULquNqzObjAJEHTWfXWGPVa8I54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/113] Input: edt-ft5x06 - work around first register access error
Date:   Thu, 27 Feb 2020 14:36:11 +0100
Message-Id: <20200227132220.559320477@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit e112324cc0422c046f1cf54c56f333d34fa20885 ]

The EP0700MLP1 returns bogus data on the first register read access
(reading the threshold parameter from register 0x00):

    edt_ft5x06 2-0038: crc error: 0xfc expected, got 0x40

It ignores writes until then. This patch adds a dummy read after which
the number of sensors and parameter read/writes work correctly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/edt-ft5x06.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 0b0f8c17f3f7e..a9d97d577a7e9 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -880,6 +880,7 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 {
 	const struct edt_i2c_chip_data *chip_data;
 	struct edt_ft5x06_ts_data *tsdata;
+	u8 buf[2] = { 0xfc, 0x00 };
 	struct input_dev *input;
 	unsigned long irq_flags;
 	int error;
@@ -949,6 +950,12 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		return error;
 	}
 
+	/*
+	 * Dummy read access. EP0700MLP1 returns bogus data on the first
+	 * register read access and ignores writes.
+	 */
+	edt_ft5x06_ts_readwrite(tsdata->client, 2, buf, 2, buf);
+
 	edt_ft5x06_ts_set_regs(tsdata);
 	edt_ft5x06_ts_get_defaults(&client->dev, tsdata);
 	edt_ft5x06_ts_get_parameters(tsdata);
-- 
2.20.1



