Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B531C2A532F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgKCU6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732988AbgKCU6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2FD22226;
        Tue,  3 Nov 2020 20:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437111;
        bh=JKV1P13rueea5sPPXRTCnT8wIn8fuhdMVEBEQGp2smA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/kaveWgUE1AkoRctEoNsYnGakWjq7QYvmohIZ27hrHLiSboZgYpYlmnCHpL8Xfq+
         ZGtey96Tsw3+8efII1c9hF3+uKVbzvhy0ORTwtXRz6SnfKcCjWn3Fq8stds8+Dra4R
         gaja6u+YF5OL6sv+5UAwRLav1arWCN33sNVEjDrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stable@vger.kernel.org
Subject: [PATCH 5.4 150/214] iio:light:si1145: Fix timestamp alignment and prevent data leak.
Date:   Tue,  3 Nov 2020 21:36:38 +0100
Message-Id: <20201103203304.856426331@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 0456ecf34d466261970e0ff92b2b9c78a4908637 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 24 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable array in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak appart from previous readings.

Depending on the enabled channels, the  location of the timestamp
can be at various aligned offsets through the buffer.  As such we
any use of a structure to enforce this alignment would incorrectly
suggest a single location for the timestamp.  Comments adjusted to
express this clearly in the code.

Fixes: ac45e57f1590 ("iio: light: Add driver for Silabs si1132, si1141/2/3 and si1145/6/7 ambient light, uv index and proximity sensors")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-9-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/si1145.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/iio/light/si1145.c
+++ b/drivers/iio/light/si1145.c
@@ -169,6 +169,7 @@ struct si1145_part_info {
  * @part_info:	Part information
  * @trig:	Pointer to iio trigger
  * @meas_rate:	Value of MEAS_RATE register. Only set in HW in auto mode
+ * @buffer:	Used to pack data read from sensor.
  */
 struct si1145_data {
 	struct i2c_client *client;
@@ -180,6 +181,14 @@ struct si1145_data {
 	bool autonomous;
 	struct iio_trigger *trig;
 	int meas_rate;
+	/*
+	 * Ensure timestamp will be naturally aligned if present.
+	 * Maximum buffer size (may be only partly used if not all
+	 * channels are enabled):
+	 *   6*2 bytes channels data + 4 bytes alignment +
+	 *   8 bytes timestamp
+	 */
+	u8 buffer[24] __aligned(8);
 };
 
 /**
@@ -441,12 +450,6 @@ static irqreturn_t si1145_trigger_handle
 	struct iio_poll_func *pf = private;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct si1145_data *data = iio_priv(indio_dev);
-	/*
-	 * Maximum buffer size:
-	 *   6*2 bytes channels data + 4 bytes alignment +
-	 *   8 bytes timestamp
-	 */
-	u8 buffer[24];
 	int i, j = 0;
 	int ret;
 	u8 irq_status = 0;
@@ -479,7 +482,7 @@ static irqreturn_t si1145_trigger_handle
 
 		ret = i2c_smbus_read_i2c_block_data_or_emulated(
 				data->client, indio_dev->channels[i].address,
-				sizeof(u16) * run, &buffer[j]);
+				sizeof(u16) * run, &data->buffer[j]);
 		if (ret < 0)
 			goto done;
 		j += run * sizeof(u16);
@@ -494,7 +497,7 @@ static irqreturn_t si1145_trigger_handle
 			goto done;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
 		iio_get_time_ns(indio_dev));
 
 done:


