Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0459B38703B
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 05:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbhERDaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 23:30:23 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:42702 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbhERDaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 23:30:22 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 14I3SqCe021943; Tue, 18 May 2021 12:28:52 +0900
X-Iguazu-Qid: 2wGrbz1dNFmq3TPeug
X-Iguazu-QSIG: v=2; s=0; t=1621308532; q=2wGrbz1dNFmq3TPeug; m=og6vQ08l1pW/NN/EE02MDx+AK3gtKbLPn6L5CemYYDU=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 14I3Sp4E027895
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 May 2021 12:28:51 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 4E23B1000B4;
        Tue, 18 May 2021 12:28:51 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 14I3SoiG007553;
        Tue, 18 May 2021 12:28:51 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4,9] iio: tsl2583: Fix division by a zero lux_val
Date:   Tue, 18 May 2021 12:28:46 +0900
X-TSB-HOP: ON
Message-Id: <20210518032846.37859-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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
[iwamatsu: Change file path.]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/staging/iio/light/tsl2583.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index 3100d960fe2c6d..da2a2ff4cdb998 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -378,6 +378,15 @@ static int taos_als_calibrate(struct iio_dev *indio_dev)
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
 	gain_trim_val = (unsigned int) (((chip->taos_settings.als_cal_target)
 			* chip->taos_settings.als_gain_trim) / lux_val);
 
-- 
2.30.0

