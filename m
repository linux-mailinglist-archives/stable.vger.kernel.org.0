Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDBE38A7C1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhETKmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236894AbhETKkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B2C61C73;
        Thu, 20 May 2021 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504536;
        bh=bQBx1hhluqrEMh1n0EnQiGV0SX8Qp78t/8mKyq5dujU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjumzUsZxaqpzxWVGgj6diLMHRyjM8mzO5DDi1dZrpnWvZR2fkku1BxgfJjFIVRH5
         r84rQ1X6MotHgDg5Surm1i8w55mADXQeSH3aD/wEzbuUece8948xM+8lZpVxJuL9GR
         IbHuRqBySv56hB7YeC7mMMogfp4bs5/hijxLUWKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 291/323] iio: tsl2583: Fix division by a zero lux_val
Date:   Thu, 20 May 2021 11:23:03 +0200
Message-Id: <20210520092130.183745673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit af0e1871d79cfbb91f732d2c6fa7558e45c31038 upstream.

The lux_val returned from tsl2583_get_lux can potentially be zero,
so check for this to avoid a division by zero and an overflowed
gain_trim_val.

Fixes clang scan-build warning:

drivers/iio/light/tsl2583.c:345:40: warning: Either the
condition 'lux_val<0' is redundant or there is division
by zero at line 345. [zerodivcond]

Fixes: ac4f6eee8fe8 ("staging: iio: TAOS tsl258x: Device driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2583.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -350,6 +350,14 @@ static int tsl2583_als_calibrate(struct
 		return lux_val;
 	}
 
+	/* Avoid division by zero of lux_value later on */
+	if (lux_val == 0) {
+		dev_err(&chip->client->dev,
+			"%s: lux_val of 0 will produce out of range trim_value\n",
+			__func__);
+		return -ENODATA;
+	}
+
 	gain_trim_val = (unsigned int)(((chip->als_settings.als_cal_target)
 			* chip->als_settings.als_gain_trim) / lux_val);
 	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {


