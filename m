Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F00EED79
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390092AbfKDWHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390086AbfKDWHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:09 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EDE214D8;
        Mon,  4 Nov 2019 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905229;
        bh=Z1qQ8+UxlcQJijWJfUxbC1ce0XHXMOMUHXD/QovTDxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKjbKmcqjNShjIyvH9NRNDok8LLHViPH2TQur5Xin/RAPKqCPSCONEjSS3HwZ0sxV
         d6XJSzbgcAkFOGqxcMF7Q1Vd/kk20OLBfKW9GcVzRl/FuYSeKpj7xUWK+G8Rrod2m3
         LTQDX9ejNN3PM6WWnbR0USI2mHhAd5pFlgumngFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 073/163] iio: imu: st_lsm6dsx: fix waitime for st_lsm6dsx i2c controller
Date:   Mon,  4 Nov 2019 22:44:23 +0100
Message-Id: <20191104212145.161217765@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fdb828e2c71a09bb9e865f41b015597c5f671705 ]

i2c controller available in st_lsm6dsx series performs i2c slave
configuration using accel clock as trigger.
st_lsm6dsx_shub_wait_complete routine is used to wait the controller has
carried out the requested configuration. However if the accel sensor is not
enabled we should not use its configured odr to estimate a proper timeout

Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index 66fbcd94642d4..4c754a02717b3 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -92,9 +92,11 @@ static const struct st_lsm6dsx_ext_dev_settings st_lsm6dsx_ext_dev_table[] = {
 static void st_lsm6dsx_shub_wait_complete(struct st_lsm6dsx_hw *hw)
 {
 	struct st_lsm6dsx_sensor *sensor;
+	u16 odr;
 
 	sensor = iio_priv(hw->iio_devs[ST_LSM6DSX_ID_ACC]);
-	msleep((2000U / sensor->odr) + 1);
+	odr = (hw->enable_mask & BIT(ST_LSM6DSX_ID_ACC)) ? sensor->odr : 13;
+	msleep((2000U / odr) + 1);
 }
 
 /**
-- 
2.20.1



