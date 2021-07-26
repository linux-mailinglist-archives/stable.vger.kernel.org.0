Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BC53D5FE6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhGZPTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236607AbhGZPTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78ECB60F70;
        Mon, 26 Jul 2021 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315202;
        bh=ImrBO32MS2qKCVDbOawfWgCzi5qP45Uis/tZnRBB4Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDFW9IQxKQe1tFcloo7taszIYBmulY8iu1yX9fdTDbVfVIc89XoChWWVco3JkQgLd
         3CcM/+10KZ3jlXhbWqHQ8MfvyuD/6jZphodfG7tU0MIXi6dGp3i+KjNlBE0LtSwj9/
         Da6Tg+OTj9Iwls4BXcI81m7tUMMJ3auiFPzmu+Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 103/108] iio: accel: bma180: Use explicit member assignment
Date:   Mon, 26 Jul 2021 17:39:44 +0200
Message-Id: <20210726153834.981310767@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
@@ -633,32 +633,52 @@ static const struct iio_chan_spec bma250
 
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
 


