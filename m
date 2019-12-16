Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5831012162B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbfLPSP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbfLPSP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A286206E0;
        Mon, 16 Dec 2019 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520156;
        bh=54g1RQWe0ZQcTMSuQP2WxVHfbj0WlZ+Smeh/tvKqMiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1Ppr9LzIwWA0CFqE7m1o63ypXfgG2nFoh/pte+Za9EOHUtbIDk+hEOjRqbpraWmV
         sk40J0WRithHSLCfcymjdpIyfmuX/spmnewmpsqz/sQ0va/L9DozqvgG2xUg6ILiec
         pxFSJmx/zIlyLdD7cMYl91E22OfpSPCnZX+N8OfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 038/177] iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw
Date:   Mon, 16 Dec 2019 18:48:14 +0100
Message-Id: <20191216174828.973318534@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit fc3f6ad7f5dc6c899fbda0255865737bac88c2e0 upstream.

Since st_lsm6dsx i2c master controller relies on accel device as trigger
and slave devices can run at different ODRs we must select an accel_odr >=
slave_odr. Report real accel ODR in st_lsm6dsx_check_odr() in order to
properly set sensor frequency in st_lsm6dsx_write_raw and avoid to
report unsupported frequency

Fixes: 6ffb55e5009ff ("iio: imu: st_lsm6dsx: introduce ST_LSM6DSX_ID_EXT sensor ids")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -985,8 +985,7 @@ int st_lsm6dsx_check_odr(struct st_lsm6d
 		return -EINVAL;
 
 	*val = odr_table->odr_avl[i].val;
-
-	return 0;
+	return odr_table->odr_avl[i].hz;
 }
 
 static u16 st_lsm6dsx_check_odr_dependency(struct st_lsm6dsx_hw *hw, u16 odr,
@@ -1149,8 +1148,10 @@ static int st_lsm6dsx_write_raw(struct i
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


