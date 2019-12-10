Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90F11953F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfLJVMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbfLJVMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C046246A8;
        Tue, 10 Dec 2019 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012327;
        bh=2+gdjMLbyiDYzg7/aXxDsKYDFXgIqedg9mW47XFq21Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYSYBOHvo0XRbeMD1VG6bcUBJUL+9c+Vtb8HC2W0PP3O3ytep08d/6hGvsblFYvz3
         CSzCjzOOmKnnjrzz8zy7i6g9YwSaqof/e76eepAB274nNG6pHk8TXTZ6WKdn2ZQj/K
         tBIQ7uLReWvFf1FNuTVol92ZaeArVMkU38xOJEEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gwendal Grignou <gwendal@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 260/350] iio: cros_ec_baro: set info_mask_shared_by_all_available field
Date:   Tue, 10 Dec 2019 16:06:05 -0500
Message-Id: <20191210210735.9077-221-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit e9a4cbcaaa391ef44d623d548ee715e77265030c ]

Field was already set for light/proximity and
accelerometer/gyroscope/magnetometer sensors.

Fixes: ae7b02ad2f32 ("iio: common: cros_ec_sensors: Expose cros_ec_sensors frequency range via iio sysfs")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/cros_ec_baro.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/pressure/cros_ec_baro.c b/drivers/iio/pressure/cros_ec_baro.c
index 2354302375dee..52f53f3123b18 100644
--- a/drivers/iio/pressure/cros_ec_baro.c
+++ b/drivers/iio/pressure/cros_ec_baro.c
@@ -114,6 +114,7 @@ static int cros_ec_baro_write(struct iio_dev *indio_dev,
 static const struct iio_info cros_ec_baro_info = {
 	.read_raw = &cros_ec_baro_read,
 	.write_raw = &cros_ec_baro_write,
+	.read_avail = &cros_ec_sensors_core_read_avail,
 };
 
 static int cros_ec_baro_probe(struct platform_device *pdev)
@@ -149,6 +150,8 @@ static int cros_ec_baro_probe(struct platform_device *pdev)
 		BIT(IIO_CHAN_INFO_SCALE) |
 		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
 		BIT(IIO_CHAN_INFO_FREQUENCY);
+	channel->info_mask_shared_by_all_available =
+		BIT(IIO_CHAN_INFO_SAMP_FREQ);
 	channel->scan_type.realbits = CROS_EC_SENSOR_BITS;
 	channel->scan_type.storagebits = CROS_EC_SENSOR_BITS;
 	channel->scan_type.shift = 0;
-- 
2.20.1

