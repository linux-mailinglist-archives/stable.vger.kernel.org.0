Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682002F7394
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbhAOHRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbhAOHRv (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAB0D22DFA;
        Fri, 15 Jan 2021 07:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610695030;
        bh=RqbrQYxrk2s3U3yTYx5KsoQ2b4AQ0S4rsstqY8DjrWI=;
        h=Subject:To:From:Date:From;
        b=enAVwnSByCMqkTniAxYTTQSr7Z7e7DKs6dLmUOvQmC7TWtdLKKJte5JrcYxUVjJcv
         GqADMtBC1aA5a2LctBlcHYeFWIjLYQbO6Qy11j6WfowQx+eN8af5pQT9OA2ZD6ZO2O
         O25YcYcWCkKVghT8o60RVca/ajmiO9dmLyT74PFw=
Subject: patch "drivers: iio: temperature: Add delay after the addressed reset" added to staging-linus
To:     sis@melexis.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com, cmo@melexis.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 08:17:04 +0100
Message-ID: <1610695024235198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: iio: temperature: Add delay after the addressed reset

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cf5b1385d748b2f91b0c05bb301fcaf9bdbad385 Mon Sep 17 00:00:00 2001
From: Slaveyko Slaveykov <sis@melexis.com>
Date: Wed, 16 Dec 2020 13:57:20 +0200
Subject: drivers: iio: temperature: Add delay after the addressed reset
 command in mlx90632.c

After an I2C reset command, the mlx90632 needs some time before
responding to other I2C commands. Without that delay, there is a chance
that the I2C command(s) after the reset will not be accepted.

Signed-off-by: Slaveyko Slaveykov <sis@melexis.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Crt Mori <cmo@melexis.com>
Fixes: e02472f74a81 ("iio:temperature:mlx90632: Adding extended calibration option")
Link: https://lore.kernel.org/r/20201216115720.12404-2-sis@melexis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/temperature/mlx90632.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/temperature/mlx90632.c b/drivers/iio/temperature/mlx90632.c
index 503fe54a0bb9..608ccb1d8bc8 100644
--- a/drivers/iio/temperature/mlx90632.c
+++ b/drivers/iio/temperature/mlx90632.c
@@ -248,6 +248,12 @@ static int mlx90632_set_meas_type(struct regmap *regmap, u8 type)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Give the mlx90632 some time to reset properly before sending a new I2C command
+	 * if this is not done, the following I2C command(s) will not be accepted.
+	 */
+	usleep_range(150, 200);
+
 	ret = regmap_write_bits(regmap, MLX90632_REG_CONTROL,
 				 (MLX90632_CFG_MTYP_MASK | MLX90632_CFG_PWR_MASK),
 				 (MLX90632_MTYP_STATUS(type) | MLX90632_PWR_STATUS_HALT));
-- 
2.30.0


