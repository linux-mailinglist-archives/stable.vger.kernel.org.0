Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EEA15F11E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbgBNPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731422AbgBNPz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795B224676;
        Fri, 14 Feb 2020 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695755;
        bh=6j1K92uXQHGUNZx44H0eiABCvbiGImXRdsQbp3X8P6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZfWP+s4qH4O7clynH7/CPtZKUsLJ6Wzdl71bI9ULIjG3SDU2UxLoBquKxAFkcLc6
         JnBsS8ThlJlW62v2SOUpDDaUw9ZLqY/SAFsNoxzUbGm1njdz430u7oOAFBNfI6THbb
         Q1rk/vQBLcUdgN46IgDzrd685j3SwlWRYuOaJDfY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 324/542] Input: edt-ft5x06 - work around first register access error
Date:   Fri, 14 Feb 2020 10:45:16 -0500
Message-Id: <20200214154854.6746-324-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d61731c0037d1..b87b1e074f624 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -1050,6 +1050,7 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 {
 	const struct edt_i2c_chip_data *chip_data;
 	struct edt_ft5x06_ts_data *tsdata;
+	u8 buf[2] = { 0xfc, 0x00 };
 	struct input_dev *input;
 	unsigned long irq_flags;
 	int error;
@@ -1140,6 +1141,12 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
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

