Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9009A38ED7A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhEXPiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233892AbhEXPgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CFA461414;
        Mon, 24 May 2021 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870362;
        bh=mbTBEpLuOGOSt73j/DVn5yuJombL/qCnen1JDX7faB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7sBZnXaguojsLziOD2NaxL99V53qxi2pBlGmqFyK2rCQs3f687i7m/s6xhw3715x
         LHqMftHmY4oN6mYx1gDUnL56Gua0cmPUm0eR/DY0UZyTYo2Yqh0MzaqLvdIv0eRM1N
         qXDBLjhw5Ef/Eh1R1R+FPiaT1GJkqvMVgfDcRl/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 36/36] iio: tsl2583: Fix division by a zero lux_val
Date:   Mon, 24 May 2021 17:25:21 +0200
Message-Id: <20210524152325.329346979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
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
[Colin Ian King: minor context adjustments for 4.9.y]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/light/tsl2583.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -382,6 +382,15 @@ static int taos_als_calibrate(struct iio
 		dev_err(&chip->client->dev, "taos_als_calibrate failed to get lux\n");
 		return lux_val;
 	}
+
+	/* Avoid division by zero of lux_value later on */
+	if (lux_val == 0) {
+		dev_err(&chip->client->dev,
+			"%s: lux_val of 0 will produce out of range trim_value\n",
+			__func__);
+		return -ENODATA;
+	}
+
 	gain_trim_val = (unsigned int)(((chip->taos_settings.als_cal_target)
 			* chip->taos_settings.als_gain_trim) / lux_val);
 


