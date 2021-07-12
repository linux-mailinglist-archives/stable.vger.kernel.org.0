Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3606C3C4B4D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhGLG4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239083AbhGLGt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DD16113E;
        Mon, 12 Jul 2021 06:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072352;
        bh=QhLqPz30Jed7704xOqGcEOG4hquarFR0I1hnTVeHNLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1GkAs+v60MeC3k5i3LylwrbNru1FbSP4ktyiLpWUgzmgZepbMo2aJStcX84pl5KC
         ffMfxcZCOZdXlOwROJCJJr+gLqTmKFW3rUSUlqij68u6Co750gdfBRJqlYKlq6TCq2
         m9hXeJnXjcP2/zTl6WqWQ4X/35EfYJTn6ZrZKlNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/593] iio: magn: bmc150: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:20 +0200
Message-Id: <20210712060940.126414883@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index fc6840f9c1fa..8042175275d0 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -136,8 +136,11 @@ struct bmc150_magn_data {
 	struct mutex mutex;
 	struct regmap *regmap;
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
@@ -673,11 +676,11 @@ static irqreturn_t bmc150_magn_trigger_handler(int irq, void *p)
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



