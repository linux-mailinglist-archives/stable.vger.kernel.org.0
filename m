Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70573F6616
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhHXRUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240424AbhHXRSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C592C615E6;
        Tue, 24 Aug 2021 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824573;
        bh=lKLB3eQVL2IeCKz5jyTWNKjiMFwq7fKPUHbuzAStvzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1AbL/o980F1yv96gFRpZNCpFkN9apgnQ6lWE9b2GjJuxuRZaliqVPfaK1tsOWDh8
         5DFCc65HJdAPJKdlh20hkHraHL8IBOy/VGdpB0+NCIK4JOHnH2vfx/4hEESC2y4Sy4
         yGHP6bb3+/XYP/ZlLU48JVwLDEQRPUMgVWHDlZ8dzaPur+MdIUFRfktmur3w1N/Jgr
         Raw9leKFGvgZrWHDigQQfru/pm3e7ZKzp6r/QdWj1dRw9ebn6ifJm3/ZWABdz9yAB9
         j0QHNk9fHS0hvZeja1oYKpChsJH70thsPNAaiJ8FL6AICHUGAwFxV1SujGiONeXfGp
         LTujXzeZ6xLzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Lesiak <chris.lesiak@licor.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 01/84] iio: humidity: hdc100x: Add margin to the conversion time
Date:   Tue, 24 Aug 2021 13:01:27 -0400
Message-Id: <20210824170250.710392-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lesiak <chris.lesiak@licor.com>

commit 84edec86f449adea9ee0b4912a79ab8d9d65abb7 upstream.

The datasheets have the following note for the conversion time
specification: "This parameter is specified by design and/or
characterization and it is not tested in production."

Parts have been seen that require more time to do 14-bit conversions for
the relative humidity channel.  The result is ENXIO due to the address
phase of a transfer not getting an ACK.

Delay an additional 1 ms per conversion to allow for additional margin.

Fixes: 4839367d99e3 ("iio: humidity: add HDC100x support")
Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210614141820.2034827-1-chris.lesiak@licor.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hdc100x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/humidity/hdc100x.c b/drivers/iio/humidity/hdc100x.c
index 0fcaa2c0b2f4..51ad5a9ed085 100644
--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -24,6 +24,8 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#include <linux/time.h>
+
 #define HDC100X_REG_TEMP			0x00
 #define HDC100X_REG_HUMIDITY			0x01
 
@@ -165,7 +167,7 @@ static int hdc100x_get_measurement(struct hdc100x_data *data,
 				   struct iio_chan_spec const *chan)
 {
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[chan->address];
+	int delay = data->adc_int_us[chan->address] + 1*USEC_PER_MSEC;
 	int ret;
 	__be16 val;
 
@@ -322,7 +324,7 @@ static irqreturn_t hdc100x_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct hdc100x_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[0] + data->adc_int_us[1];
+	int delay = data->adc_int_us[0] + data->adc_int_us[1] + 2*USEC_PER_MSEC;
 	int ret;
 
 	/* dual read starts at temp register */
-- 
2.30.2

