Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1A86DC4D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388544AbfGSEO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389936AbfGSEO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:14:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E1A2082F;
        Fri, 19 Jul 2019 04:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509697;
        bh=WB0YDzieqaIoEi48HKnNmW7KfdKVqPrD7AxajqycSxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Teo310IJDHNPNsipI7M9G1sNKAAh5LSCjz9J+OneL4GekotGlEgzy76oe138ueO/r
         N4IOInXPVHSMnpASLS2bcC/dhqhd2tHAWJQQBaCSHPBo95NjW50SfxVH5u0ruapQ9h
         ZxNXeXkmnLyfffw/0KKntIWZPauHnZQmsMGPhyAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 17/35] iio: st_accel: fix iio_triggered_buffer_{pre,post}enable positions
Date:   Fri, 19 Jul 2019 00:14:05 -0400
Message-Id: <20190719041423.19322-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041423.19322-1-sashal@kernel.org>
References: <20190719041423.19322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 05b8bcc96278c9ef927a6f25a98e233e55de42e1 ]

The iio_triggered_buffer_{predisable,postenable} functions attach/detach
the poll functions.

For the predisable hook, the disable code should occur before detaching
the poll func, and for the postenable hook, the poll func should be
attached before the enable code.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Acked-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/st_accel_buffer.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/accel/st_accel_buffer.c b/drivers/iio/accel/st_accel_buffer.c
index a1e642ee13d6..4f838277184a 100644
--- a/drivers/iio/accel/st_accel_buffer.c
+++ b/drivers/iio/accel/st_accel_buffer.c
@@ -46,17 +46,19 @@ static int st_accel_buffer_postenable(struct iio_dev *indio_dev)
 		goto allocate_memory_error;
 	}
 
-	err = st_sensors_set_axis_enable(indio_dev,
-					(u8)indio_dev->active_scan_mask[0]);
+	err = iio_triggered_buffer_postenable(indio_dev);
 	if (err < 0)
 		goto st_accel_buffer_postenable_error;
 
-	err = iio_triggered_buffer_postenable(indio_dev);
+	err = st_sensors_set_axis_enable(indio_dev,
+					(u8)indio_dev->active_scan_mask[0]);
 	if (err < 0)
-		goto st_accel_buffer_postenable_error;
+		goto st_sensors_set_axis_enable_error;
 
 	return err;
 
+st_sensors_set_axis_enable_error:
+	iio_triggered_buffer_predisable(indio_dev);
 st_accel_buffer_postenable_error:
 	kfree(adata->buffer_data);
 allocate_memory_error:
@@ -65,20 +67,22 @@ static int st_accel_buffer_postenable(struct iio_dev *indio_dev)
 
 static int st_accel_buffer_predisable(struct iio_dev *indio_dev)
 {
-	int err;
+	int err, err2;
 	struct st_sensor_data *adata = iio_priv(indio_dev);
 
-	err = iio_triggered_buffer_predisable(indio_dev);
-	if (err < 0)
-		goto st_accel_buffer_predisable_error;
-
 	err = st_sensors_set_axis_enable(indio_dev, ST_SENSORS_ENABLE_ALL_AXIS);
 	if (err < 0)
 		goto st_accel_buffer_predisable_error;
 
 	err = st_sensors_set_enable(indio_dev, false);
+	if (err < 0)
+		goto st_accel_buffer_predisable_error;
 
 st_accel_buffer_predisable_error:
+	err2 = iio_triggered_buffer_predisable(indio_dev);
+	if (!err)
+		err = err2;
+
 	kfree(adata->buffer_data);
 	return err;
 }
-- 
2.20.1

