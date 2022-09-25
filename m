Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465855E915D
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIYHPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIYHPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9292F2A438
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EC4160F9C
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9D4C433C1;
        Sun, 25 Sep 2022 07:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664090135;
        bh=1An+z0kTlbai05xxYI1pf5jwHgMClKdVjXcNPaMWZ0Q=;
        h=Subject:To:From:Date:From;
        b=aHGaF2CYjQMBtsIvm/zK0KnxZ6q1b9ARpeUre3HtUGd06XNNGurBnKwaJCyJk0ctY
         uIm3Y3Y/hXQSysW6iZd3k4xp0q2sN51V/o96NjFMKBmZrLGesDHK/aadsct5Mi0L0P
         NkL+31M8U7mdX3OUff+8FZtKGuPgz4fcPYt9/kCI=
Subject: patch "iio: pressure: dps310: Reset chip after timeout" added to char-misc-next
To:     eajames@linux.ibm.com, Jonathan.Cameron@huawei.com,
        andy.shevchenko@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:10:59 +0200
Message-ID: <16640898595202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: pressure: dps310: Reset chip after timeout

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 7b4ab4abcea4c0c10b25187bf2569e5a07e9a20c Mon Sep 17 00:00:00 2001
From: Eddie James <eajames@linux.ibm.com>
Date: Thu, 15 Sep 2022 14:57:19 -0500
Subject: iio: pressure: dps310: Reset chip after timeout

The DPS310 chip has been observed to get "stuck" such that pressure
and temperature measurements are never indicated as "ready" in the
MEAS_CFG register. The only solution is to reset the device and try
again. In order to avoid continual failures, use a boolean flag to
only try the reset after timeout once if errors persist.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Cc: <stable@vger.kernel.org>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220915195719.136812-3-eajames@linux.ibm.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/pressure/dps310.c | 74 ++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index c706a8b423b5..984a3f511a1a 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -89,6 +89,7 @@ struct dps310_data {
 	s32 c00, c10, c20, c30, c01, c11, c21;
 	s32 pressure_raw;
 	s32 temp_raw;
+	bool timeout_recovery_failed;
 };
 
 static const struct iio_chan_spec dps310_channels[] = {
@@ -393,11 +394,69 @@ static int dps310_get_temp_k(struct dps310_data *data)
 	return scale_factors[ilog2(rc)];
 }
 
+static int dps310_reset_wait(struct dps310_data *data)
+{
+	int rc;
+
+	rc = regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	if (rc)
+		return rc;
+
+	/* Wait for device chip access: 2.5ms in specification */
+	usleep_range(2500, 12000);
+	return 0;
+}
+
+static int dps310_reset_reinit(struct dps310_data *data)
+{
+	int rc;
+
+	rc = dps310_reset_wait(data);
+	if (rc)
+		return rc;
+
+	return dps310_startup(data);
+}
+
+static int dps310_ready_status(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int sleep = DPS310_POLL_SLEEP_US(timeout);
+	int ready;
+
+	return regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready, ready & ready_bit,
+					sleep, timeout);
+}
+
+static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int rc;
+
+	rc = dps310_ready_status(data, ready_bit, timeout);
+	if (rc) {
+		if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {
+			/* Reset and reinitialize the chip. */
+			if (dps310_reset_reinit(data)) {
+				data->timeout_recovery_failed = true;
+			} else {
+				/* Try again to get sensor ready status. */
+				if (dps310_ready_status(data, ready_bit, timeout))
+					data->timeout_recovery_failed = true;
+				else
+					return 0;
+			}
+		}
+
+		return rc;
+	}
+
+	data->timeout_recovery_failed = false;
+	return 0;
+}
+
 static int dps310_read_pres_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 	s32 raw;
 	u8 val[3];
@@ -409,9 +468,7 @@ static int dps310_read_pres_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_PRS_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
+	rc = dps310_ready(data, DPS310_PRS_RDY, timeout);
 	if (rc)
 		goto done;
 
@@ -448,7 +505,6 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 
 	if (mutex_lock_interruptible(&data->lock))
@@ -458,10 +514,8 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_TMP_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
-	if (rc < 0)
+	rc = dps310_ready(data, DPS310_TMP_RDY, timeout);
+	if (rc)
 		goto done;
 
 	rc = dps310_read_temp_ready(data);
@@ -756,7 +810,7 @@ static void dps310_reset(void *action_data)
 {
 	struct dps310_data *data = action_data;
 
-	regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	dps310_reset_wait(data);
 }
 
 static const struct regmap_config dps310_regmap_config = {
-- 
2.37.3


