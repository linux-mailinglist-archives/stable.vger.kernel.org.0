Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98D7356636
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbhDGIPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344451AbhDGIPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA40613A7;
        Wed,  7 Apr 2021 08:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783324;
        bh=sugoICY8iWs46Vr9CfNaRSGhpHzfYuwGQVQwQCUPbOs=;
        h=Subject:To:From:Date:From;
        b=m0HWSJMuLIoa0+wmAqKNAYWBuAFkbxUpgpofjL6OIDHJa2nCVelE60Velr6wNKklb
         xnfPyto3879NsyRhpqGVmO6dcQD5Y7CKle0tNiujIqHX6uq/tlpuP4XnC36/6zNY8s
         H3GZHAswBXBYE8N4lm46Pkx4RULnKvHSsAEEmDX4=
Subject: patch "iio: sx9310: Fix access to variable DT array" added to staging-next
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        andy.shevchenko@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:10:40 +0200
Message-ID: <161778304070114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: sx9310: Fix access to variable DT array

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 6f0078ae704d94b1a93e5f3d0a44cf3d8090fa91 Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Fri, 26 Mar 2021 11:46:02 -0700
Subject: iio: sx9310: Fix access to variable DT array

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
---
 drivers/iio/proximity/sx9310.c | 40 ++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/iio/proximity/sx9310.c b/drivers/iio/proximity/sx9310.c
index 394c2afe0f23..289c76bb3b02 100644
--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -1213,17 +1213,17 @@ static int sx9310_init_compensation(struct iio_dev *indio_dev)
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
 
@@ -1234,15 +1234,31 @@ sx9310_get_default_reg(struct sx9310_data *data, int i,
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
+		}
+		for (i = 0; i < count; i++) {
+			if (combined[i] >= SX9310_NUM_CHANNELS) {
+				/* Invalid sensor (invalid DT). */
+				break;
+			}
+			comb_mask |= BIT(combined[i]);
 		}
+		if (i < count)
+			break;
 
-		comb_mask &= 0xf;
+		reg_def->def &= ~SX9310_REG_PROX_CTRL2_COMBMODE_MASK;
 		if (comb_mask == (BIT(3) | BIT(2) | BIT(1) | BIT(0)))
 			reg_def->def |= SX9310_REG_PROX_CTRL2_COMBMODE_CS0_CS1_CS2_CS3;
 		else if (comb_mask == (BIT(1) | BIT(2)))
-- 
2.31.1


