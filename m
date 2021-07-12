Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53C93C551A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352895AbhGLIJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352612AbhGLH7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F62A61179;
        Mon, 12 Jul 2021 07:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076409;
        bh=PWU2nR3R00QI77hwPsUT04DykDt4M+oAgY0uToP8OAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHMg3z0uTdTLaIm/+Jym1JT3YZhdAlNq7hKUAWfKoR4Od6utCn1DLV4lYK8xuW/pG
         89YLGOXw56GL/uyUcNR2F91hMhnOfo05qH9oGzJSP2dpI5+eaVAwiFSP6Tz795UXxy
         hUu5OUZiuKI7FBfZkRWPBjfXkGTLXsS7agE+3lJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 631/800] iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:54 +0200
Message-Id: <20210712061034.305735205@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 00f9766bad5c..d534f4f3909e 100644
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



