Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD5A37CAEE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbhELQdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241305AbhELQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 807566162A;
        Wed, 12 May 2021 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834689;
        bh=dNBDmRVLWEf+T2YMip7beI75nQYpYaiIIkQ7sh/4L7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/CBPaniGLb3LfBYBuURaogDLgZVdfKFWZ1W1XvGvdWbOS0+qZ0En2pe5fIlb2ey0
         2+0RRo6f7WtbJlz3cAA9QwxOHO4l9tBoiQcGB1v+O3yD5YXocewCxb0ih1dtqbOd9d
         7qCAi/7nhucIvgfUZ4aBJUfWO9C99wp10KqpOASY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 045/677] iio: sx9310: Fix access to variable DT array
Date:   Wed, 12 May 2021 16:41:31 +0200
Message-Id: <20210512144838.705796293@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit 6f0078ae704d94b1a93e5f3d0a44cf3d8090fa91 upstream.

With the current code, we want to read 4 entries from DT array
"semtech,combined-sensors". If there are less, we silently fail as
of_property_read_u32_array() returns -EOVERFLOW.

First count the number of entries and if between 1 and 4, collect the
content of the array.

Fixes: 5b19ca2c78a0 ("iio: sx9310: Set various settings from DT")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210326184603.251683-2-gwendal@chromium.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9310.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -1221,17 +1221,17 @@ static int sx9310_init_compensation(stru
 }
 
 static const struct sx9310_reg_default *
-sx9310_get_default_reg(struct sx9310_data *data, int i,
+sx9310_get_default_reg(struct sx9310_data *data, int idx,
 		       struct sx9310_reg_default *reg_def)
 {
-	int ret;
 	const struct device_node *np = data->client->dev.of_node;
-	u32 combined[SX9310_NUM_CHANNELS] = { 4, 4, 4, 4 };
+	u32 combined[SX9310_NUM_CHANNELS];
+	u32 start = 0, raw = 0, pos = 0;
 	unsigned long comb_mask = 0;
+	int ret, i, count;
 	const char *res;
-	u32 start = 0, raw = 0, pos = 0;
 
-	memcpy(reg_def, &sx9310_default_regs[i], sizeof(*reg_def));
+	memcpy(reg_def, &sx9310_default_regs[idx], sizeof(*reg_def));
 	if (!np)
 		return reg_def;
 
@@ -1242,15 +1242,31 @@ sx9310_get_default_reg(struct sx9310_dat
 			reg_def->def |= SX9310_REG_PROX_CTRL2_SHIELDEN_GROUND;
 		}
 
-		reg_def->def &= ~SX9310_REG_PROX_CTRL2_COMBMODE_MASK;
-		of_property_read_u32_array(np, "semtech,combined-sensors",
-					   combined, ARRAY_SIZE(combined));
-		for (i = 0; i < ARRAY_SIZE(combined); i++) {
-			if (combined[i] <= SX9310_NUM_CHANNELS)
-				comb_mask |= BIT(combined[i]);
+		count = of_property_count_elems_of_size(np, "semtech,combined-sensors",
+							sizeof(u32));
+		if (count > 0 && count <= ARRAY_SIZE(combined)) {
+			ret = of_property_read_u32_array(np, "semtech,combined-sensors",
+							 combined, count);
+			if (ret)
+				break;
+		} else {
+			/*
+			 * Either the property does not exist in the DT or the
+			 * number of entries is incorrect.
+			 */
+			break;
 		}
+		for (i = 0; i < count; i++) {
+			if (combined[i] >= SX9310_NUM_CHANNELS) {
+				/* Invalid sensor (invalid DT). */
+				break;
+			}
+			comb_mask |= BIT(combined[i]);
+		}
+		if (i < count)
+			break;
 
-		comb_mask &= 0xf;
+		reg_def->def &= ~SX9310_REG_PROX_CTRL2_COMBMODE_MASK;
 		if (comb_mask == (BIT(3) | BIT(2) | BIT(1) | BIT(0)))
 			reg_def->def |= SX9310_REG_PROX_CTRL2_COMBMODE_CS0_CS1_CS2_CS3;
 		else if (comb_mask == (BIT(1) | BIT(2)))


