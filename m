Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533BC3C4F2C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbhGLHX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236827AbhGLHVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C343661574;
        Mon, 12 Jul 2021 07:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074337;
        bh=OcI/GLSL85g/WHSSv0ySurcgmk5T2PB1xhgb3fsp4uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yU9YqAutOZ0s1qEJga0CS0WArVLT/re1znuksG6VNxFky+lv/aN3C3O0Tc11X117L
         +I/gEUozwxywnIA4BITdyngXcO1b9DiJQd1k6XsGqoLVa7/cLgG5Db+m9hdXo0YTgy
         8qJ2jF7BJsHhrK1DDhASktJ1GyMWNz4BmXNLCQho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 547/700] iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:30 +0200
Message-Id: <20210712061034.521341918@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 7692088f72865c41b6b531fd09486ee99a5da930 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: c91746a2361d ("iio: magn: Add support for BMC150 magnetometer")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-17-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/bmc150_magn.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/magnetometer/bmc150_magn.c b/drivers/iio/magnetometer/bmc150_magn.c
index b2f3129e1b4f..20a0842f0e3a 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -138,8 +138,11 @@ struct bmc150_magn_data {
 	struct regmap *regmap;
 	struct regulator_bulk_data regulators[2];
 	struct iio_mount_matrix orientation;
-	/* 4 x 32 bits for x, y z, 4 bytes align, 64 bits timestamp */
-	s32 buffer[6];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s32 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	struct iio_trigger *dready_trig;
 	bool dready_trigger_on;
 	int max_odr;
@@ -675,11 +678,11 @@ static irqreturn_t bmc150_magn_trigger_handler(int irq, void *p)
 	int ret;
 
 	mutex_lock(&data->mutex);
-	ret = bmc150_magn_read_xyz(data, data->buffer);
+	ret = bmc150_magn_read_xyz(data, data->scan.chans);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 
 err:
-- 
2.30.2



