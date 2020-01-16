Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8513F3E3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbgAPRKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389905AbgAPRKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A1324684;
        Thu, 16 Jan 2020 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194620;
        bh=2oal85QJQmFK27RIhexDkWAXpYE3elUidpuhTil+uP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSr4kwOxfqPfZ/WYzBaNSfAC7vHrRBYZo8wtIzjDU82FXRR1vaMmU/jf3Ier0YxK1
         xmyaYlNouynMauaEHrYMZSqWd930APeYcZ9tV2o7YMUnfzmy0VcoCRGT4o/RR5+zkP
         9dpAJfNvpqfjtPlaXlIvpFqJUhqRGA+I/6OShuDk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 482/671] iio: tsl2772: Use devm_add_action_or_reset for tsl2772_chip_off
Date:   Thu, 16 Jan 2020 12:02:00 -0500
Message-Id: <20200116170509.12787-219-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 338084135aeddb103624a6841972fb8588295cc6 ]

Use devm_add_action_or_reset to call tsl2772_chip_off
when the device is removed.
This also fixes the issue that the chip is turned off
before the device is unregistered.

Not marked for stable as fairly hard to hit the bug and
this is in the middle of a set making other cleanups
to the driver.  Hence will probably need explicit backporting.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Fixes: c06c4d793584 ("staging: iio: tsl2x7x/tsl2772: move out of staging")
Reviewed-by: Brian Masney <masneyb@onstation.org>
Tested-by: Brian Masney <masneyb@onstation.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2772.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
index df5b2a0da96c..f2e308c6d6d7 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -716,6 +716,13 @@ static int tsl2772_chip_off(struct iio_dev *indio_dev)
 	return tsl2772_write_control_reg(chip, 0x00);
 }
 
+static void tsl2772_chip_off_action(void *data)
+{
+	struct iio_dev *indio_dev = data;
+
+	tsl2772_chip_off(indio_dev);
+}
+
 /**
  * tsl2772_invoke_change - power cycle the device to implement the user
  *                         parameters
@@ -1711,9 +1718,14 @@ static int tsl2772_probe(struct i2c_client *clientp,
 	if (ret < 0)
 		return ret;
 
+	ret = devm_add_action_or_reset(&clientp->dev,
+					tsl2772_chip_off_action,
+					indio_dev);
+	if (ret < 0)
+		return ret;
+
 	ret = iio_device_register(indio_dev);
 	if (ret) {
-		tsl2772_chip_off(indio_dev);
 		dev_err(&clientp->dev,
 			"%s: iio registration failed\n", __func__);
 		return ret;
@@ -1740,8 +1752,6 @@ static int tsl2772_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
-	tsl2772_chip_off(indio_dev);
-
 	iio_device_unregister(indio_dev);
 
 	return 0;
-- 
2.20.1

