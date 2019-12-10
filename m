Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527D311953D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfLJVME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbfLJVMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F2C7246A8;
        Tue, 10 Dec 2019 21:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012323;
        bh=IwXQYZBTdOEeyTpQWl5WVVtM3dvJFv3nmjOMAVyAIzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMNoo1dO1X1KMrFP9/nE3j6Dbip6oL4E8OMzTyg7y5Ixifo81t4ErvWJBkaiJMTNq
         lnmtSIbMojfAYzcsq/6OKXcmSGIacxh93mvKhLEXspLyyGXLyNjwa/jUa/9KqxO4ud
         c80M4HohDRfyrTrCH8Gj6qGOu4KUhpS9AKqbcmPw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 256/350] iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw
Date:   Tue, 10 Dec 2019 16:06:01 -0500
Message-Id: <20191210210735.9077-217-sashal@kernel.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fc3f6ad7f5dc6c899fbda0255865737bac88c2e0 ]

Since st_lsm6dsx i2c master controller relies on accel device as trigger
and slave devices can run at different ODRs we must select an accel_odr >=
slave_odr. Report real accel ODR in st_lsm6dsx_check_odr() in order to
properly set sensor frequency in st_lsm6dsx_write_raw and avoid to
report unsupported frequency

Fixes: 6ffb55e5009ff ("iio: imu: st_lsm6dsx: introduce ST_LSM6DSX_ID_EXT sensor ids")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index fd5ebe1e1594f..28e011b35f21b 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -985,8 +985,7 @@ int st_lsm6dsx_check_odr(struct st_lsm6dsx_sensor *sensor, u16 odr, u8 *val)
 		return -EINVAL;
 
 	*val = odr_table->odr_avl[i].val;
-
-	return 0;
+	return odr_table->odr_avl[i].hz;
 }
 
 static u16 st_lsm6dsx_check_odr_dependency(struct st_lsm6dsx_hw *hw, u16 odr,
@@ -1149,8 +1148,10 @@ static int st_lsm6dsx_write_raw(struct iio_dev *iio_dev,
 	case IIO_CHAN_INFO_SAMP_FREQ: {
 		u8 data;
 
-		err = st_lsm6dsx_check_odr(sensor, val, &data);
-		if (!err)
+		val = st_lsm6dsx_check_odr(sensor, val, &data);
+		if (val < 0)
+			err = val;
+		else
 			sensor->odr = val;
 		break;
 	}
-- 
2.20.1

