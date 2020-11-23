Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0000B2C0886
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbgKWMwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbgKWMv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA2D20657;
        Mon, 23 Nov 2020 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135915;
        bh=ZGmFBA2wzOOiZTLl0HtWFzRlJGptdFdc91AF8Lc7JY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHBsZmKV2SZaiwDx5z0l07EuelT7bTzDVhAnoaMEzyhk1ubMQHa5yVN517sTZjEwM
         XiE/5AIaVdAibq7Ceomq+Kid002BAE1H2Sh58+XdfR1/U4Dc2VEr0ZiULAonZc6ZKt
         YRUZSkbmMzo0upWxly2xe5g6t/tV/oVOi2pSY77Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 212/252] iio: imu: st_lsm6dsx: set 10ms as min shub slave timeout
Date:   Mon, 23 Nov 2020 13:22:42 +0100
Message-Id: <20201123121845.801117965@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit fe0b980ffd1dd8b10c09f82385514819ba2a661d upstream.

Set 10ms as minimum i2c slave configuration timeout since st_lsm6dsx
relies on accel ODR for i2c master clock and at high sample rates
(e.g. 833Hz or 416Hz) the slave sensor occasionally may need more cycles
than i2c master timeout (2s/833Hz + 1 ~ 3ms) to apply the configuration
resulting in an uncomplete slave configuration and a constant reading
from the i2c slave connected to st_lsm6dsx i2c master.

Fixes: 8f9a5249e3d9 ("iio: imu: st_lsm6dsx: enable 833Hz sample frequency for tagged sensors")
Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a69c8236bf16a1569966815ed71710af2722ed7d.1604247274.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -156,11 +156,13 @@ static const struct st_lsm6dsx_ext_dev_s
 static void st_lsm6dsx_shub_wait_complete(struct st_lsm6dsx_hw *hw)
 {
 	struct st_lsm6dsx_sensor *sensor;
-	u32 odr;
+	u32 odr, timeout;
 
 	sensor = iio_priv(hw->iio_devs[ST_LSM6DSX_ID_ACC]);
 	odr = (hw->enable_mask & BIT(ST_LSM6DSX_ID_ACC)) ? sensor->odr : 12500;
-	msleep((2000000U / odr) + 1);
+	/* set 10ms as minimum timeout for i2c slave configuration */
+	timeout = max_t(u32, 2000000U / odr + 1, 10);
+	msleep(timeout);
 }
 
 /*


