Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B611192D3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfLJVE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfLJVE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE4EA24654;
        Tue, 10 Dec 2019 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011866;
        bh=8sQZi92LYMSGs3wG0gKqFzU+WlXbbH0AzH5Aku7580E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYWzKvMmotEGSTwHac1rIRFATAANTKlw+VfCRxwecWiuGmROSbdnqBsHEPtkIlBQ4
         /uATLyNi+Lp9qvXJiHH+Wi/eudEfEeoRkiUGa6NRFW23ZKZH+a6JiuorH0qv0c2+sl
         QgbtwrWej8gZK9ia0R+ZNIODkHcs9XDNA9DvZ4rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 019/350] iio: tcs3414: fix iio_triggered_buffer_{pre,post}enable positions
Date:   Tue, 10 Dec 2019 15:58:31 -0500
Message-Id: <20191210210402.8367-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 0fe2f2b789190661df24bb8bf62294145729a1fe ]

The iio_triggered_buffer_{predisable,postenable} functions attach/detach
the poll functions.

For the predisable hook, the disable code should occur before detaching
the poll func, and for the postenable hook, the poll func should be
attached before the enable code.

The driver was slightly reworked. The preenable hook was moved to the
postenable, to add some symmetry to the postenable/predisable part.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tcs3414.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/light/tcs3414.c b/drivers/iio/light/tcs3414.c
index 7c0291c5fe76e..b542e5619ead8 100644
--- a/drivers/iio/light/tcs3414.c
+++ b/drivers/iio/light/tcs3414.c
@@ -240,32 +240,42 @@ static const struct iio_info tcs3414_info = {
 	.attrs = &tcs3414_attribute_group,
 };
 
-static int tcs3414_buffer_preenable(struct iio_dev *indio_dev)
+static int tcs3414_buffer_postenable(struct iio_dev *indio_dev)
 {
 	struct tcs3414_data *data = iio_priv(indio_dev);
+	int ret;
+
+	ret = iio_triggered_buffer_postenable(indio_dev);
+	if (ret)
+		return ret;
 
 	data->control |= TCS3414_CONTROL_ADC_EN;
-	return i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
+	ret = i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
 		data->control);
+	if (ret)
+		iio_triggered_buffer_predisable(indio_dev);
+
+	return ret;
 }
 
 static int tcs3414_buffer_predisable(struct iio_dev *indio_dev)
 {
 	struct tcs3414_data *data = iio_priv(indio_dev);
-	int ret;
-
-	ret = iio_triggered_buffer_predisable(indio_dev);
-	if (ret < 0)
-		return ret;
+	int ret, ret2;
 
 	data->control &= ~TCS3414_CONTROL_ADC_EN;
-	return i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
+	ret = i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
 		data->control);
+
+	ret2 = iio_triggered_buffer_predisable(indio_dev);
+	if (!ret)
+		ret = ret2;
+
+	return ret;
 }
 
 static const struct iio_buffer_setup_ops tcs3414_buffer_setup_ops = {
-	.preenable = tcs3414_buffer_preenable,
-	.postenable = &iio_triggered_buffer_postenable,
+	.postenable = tcs3414_buffer_postenable,
 	.predisable = tcs3414_buffer_predisable,
 };
 
-- 
2.20.1

