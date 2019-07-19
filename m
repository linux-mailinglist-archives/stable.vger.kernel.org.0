Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0626DEE3
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbfGSEE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbfGSEEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C24218CA;
        Fri, 19 Jul 2019 04:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509064;
        bh=QeqbiBHLeOYnomZOPhjCcLO0gyl5URbYFXDGeDoVHTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axBedZw/m/Qk+VePddSXcN/ouT+qGAHHVL2IVLBe49pHLaw5Ec9DCumhQA5VmAgMi
         dtK7AYLIwUM71KNAh3KlLu0wEGhvfPWuNORUaVs6/4lze5HpHwfENQfg30SHSPIi7A
         DtIK3Gn3seAWuteFLyDGTR+racn0GGT6W96J6aKU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 048/141] iio: adxl372: fix iio_triggered_buffer_{pre,post}enable positions
Date:   Fri, 19 Jul 2019 00:01:13 -0400
Message-Id: <20190719040246.15945-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 0e4f0b42f42d88507b48282c8915f502551534e4 ]

The iio_triggered_buffer_{predisable,postenable} functions attach/detach
the poll functions.

For the predisable hook, the disable code should occur before detaching
the poll func, and for the postenable hook, the poll func should be
attached before the enable code.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl372.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index 3b84cb243a87..055227cb3d43 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -782,10 +782,14 @@ static int adxl372_buffer_postenable(struct iio_dev *indio_dev)
 	unsigned int mask;
 	int i, ret;
 
-	ret = adxl372_set_interrupts(st, ADXL372_INT1_MAP_FIFO_FULL_MSK, 0);
+	ret = iio_triggered_buffer_postenable(indio_dev);
 	if (ret < 0)
 		return ret;
 
+	ret = adxl372_set_interrupts(st, ADXL372_INT1_MAP_FIFO_FULL_MSK, 0);
+	if (ret < 0)
+		goto err;
+
 	mask = *indio_dev->active_scan_mask;
 
 	for (i = 0; i < ARRAY_SIZE(adxl372_axis_lookup_table); i++) {
@@ -793,8 +797,10 @@ static int adxl372_buffer_postenable(struct iio_dev *indio_dev)
 			break;
 	}
 
-	if (i == ARRAY_SIZE(adxl372_axis_lookup_table))
-		return -EINVAL;
+	if (i == ARRAY_SIZE(adxl372_axis_lookup_table)) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	st->fifo_format = adxl372_axis_lookup_table[i].fifo_format;
 	st->fifo_set_size = bitmap_weight(indio_dev->active_scan_mask,
@@ -814,26 +820,25 @@ static int adxl372_buffer_postenable(struct iio_dev *indio_dev)
 	if (ret < 0) {
 		st->fifo_mode = ADXL372_FIFO_BYPASSED;
 		adxl372_set_interrupts(st, 0, 0);
-		return ret;
+		goto err;
 	}
 
-	return iio_triggered_buffer_postenable(indio_dev);
+	return 0;
+
+err:
+	iio_triggered_buffer_predisable(indio_dev);
+	return ret;
 }
 
 static int adxl372_buffer_predisable(struct iio_dev *indio_dev)
 {
 	struct adxl372_state *st = iio_priv(indio_dev);
-	int ret;
-
-	ret = iio_triggered_buffer_predisable(indio_dev);
-	if (ret < 0)
-		return ret;
 
 	adxl372_set_interrupts(st, 0, 0);
 	st->fifo_mode = ADXL372_FIFO_BYPASSED;
 	adxl372_configure_fifo(st);
 
-	return 0;
+	return iio_triggered_buffer_predisable(indio_dev);
 }
 
 static const struct iio_buffer_setup_ops adxl372_buffer_ops = {
-- 
2.20.1

