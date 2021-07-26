Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BB43D5D82
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhGZPBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhGZPBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A450E60E08;
        Mon, 26 Jul 2021 15:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314135;
        bh=5curdIR+bNqRGV4cZzj01nkBW+pgeGBxHwDQaej//ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htdcz6bens+RPYt0XS375iBYq+kd9klIqtMqqA/A6qfQQubQnx/dDYuEqOuIVXLzd
         i0gS1hXvMoAcQqDH4nSIW884oJOahO90aNYN9dixr6f40zS5g6t/DI3NRB8HgNCdIX
         yO+ksJD1+1PJYwWwDxixNnT6PO3gi91g27YmJvqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 45/47] iio: accel: bma180: Use explicit member assignment
Date:   Mon, 26 Jul 2021 17:39:03 +0200
Message-Id: <20210726153824.391718698@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 9436abc40139503a7cea22a96437697d048f31c0 upstream

This uses the C99 explicit .member assignment for the
variant data in struct bma180_part_info. This makes it
easier to understand and add new variants.

Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bma180.c |   68 +++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 24 deletions(-)

--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -624,32 +624,52 @@ static const struct iio_chan_spec bma250
 
 static const struct bma180_part_info bma180_part_info[] = {
 	[BMA180] = {
-		bma180_channels, ARRAY_SIZE(bma180_channels),
-		bma180_scale_table, ARRAY_SIZE(bma180_scale_table),
-		bma180_bw_table, ARRAY_SIZE(bma180_bw_table),
-		BMA180_CTRL_REG0, BMA180_RESET_INT,
-		BMA180_CTRL_REG0, BMA180_SLEEP,
-		BMA180_BW_TCS, BMA180_BW,
-		BMA180_OFFSET_LSB1, BMA180_RANGE,
-		BMA180_TCO_Z, BMA180_MODE_CONFIG, BMA180_LOW_POWER,
-		BMA180_CTRL_REG3, BMA180_NEW_DATA_INT,
-		BMA180_RESET,
-		bma180_chip_config,
-		bma180_chip_disable,
+		.channels = bma180_channels,
+		.num_channels = ARRAY_SIZE(bma180_channels),
+		.scale_table = bma180_scale_table,
+		.num_scales = ARRAY_SIZE(bma180_scale_table),
+		.bw_table = bma180_bw_table,
+		.num_bw = ARRAY_SIZE(bma180_bw_table),
+		.int_reset_reg = BMA180_CTRL_REG0,
+		.int_reset_mask = BMA180_RESET_INT,
+		.sleep_reg = BMA180_CTRL_REG0,
+		.sleep_mask = BMA180_SLEEP,
+		.bw_reg = BMA180_BW_TCS,
+		.bw_mask = BMA180_BW,
+		.scale_reg = BMA180_OFFSET_LSB1,
+		.scale_mask = BMA180_RANGE,
+		.power_reg = BMA180_TCO_Z,
+		.power_mask = BMA180_MODE_CONFIG,
+		.lowpower_val = BMA180_LOW_POWER,
+		.int_enable_reg = BMA180_CTRL_REG3,
+		.int_enable_mask = BMA180_NEW_DATA_INT,
+		.softreset_reg = BMA180_RESET,
+		.chip_config = bma180_chip_config,
+		.chip_disable = bma180_chip_disable,
 	},
 	[BMA250] = {
-		bma250_channels, ARRAY_SIZE(bma250_channels),
-		bma250_scale_table, ARRAY_SIZE(bma250_scale_table),
-		bma250_bw_table, ARRAY_SIZE(bma250_bw_table),
-		BMA250_INT_RESET_REG, BMA250_INT_RESET_MASK,
-		BMA250_POWER_REG, BMA250_SUSPEND_MASK,
-		BMA250_BW_REG, BMA250_BW_MASK,
-		BMA250_RANGE_REG, BMA250_RANGE_MASK,
-		BMA250_POWER_REG, BMA250_LOWPOWER_MASK, 1,
-		BMA250_INT_ENABLE_REG, BMA250_DATA_INTEN_MASK,
-		BMA250_RESET_REG,
-		bma250_chip_config,
-		bma250_chip_disable,
+		.channels = bma250_channels,
+		.num_channels = ARRAY_SIZE(bma250_channels),
+		.scale_table = bma250_scale_table,
+		.num_scales = ARRAY_SIZE(bma250_scale_table),
+		.bw_table = bma250_bw_table,
+		.num_bw = ARRAY_SIZE(bma250_bw_table),
+		.int_reset_reg = BMA250_INT_RESET_REG,
+		.int_reset_mask = BMA250_INT_RESET_MASK,
+		.sleep_reg = BMA250_POWER_REG,
+		.sleep_mask = BMA250_SUSPEND_MASK,
+		.bw_reg = BMA250_BW_REG,
+		.bw_mask = BMA250_BW_MASK,
+		.scale_reg = BMA250_RANGE_REG,
+		.scale_mask = BMA250_RANGE_MASK,
+		.power_reg = BMA250_POWER_REG,
+		.power_mask = BMA250_LOWPOWER_MASK,
+		.lowpower_val = 1,
+		.int_enable_reg = BMA250_INT_ENABLE_REG,
+		.int_enable_mask = BMA250_DATA_INTEN_MASK,
+		.softreset_reg = BMA250_RESET_REG,
+		.chip_config = bma250_chip_config,
+		.chip_disable = bma250_chip_disable,
 	},
 };
 


