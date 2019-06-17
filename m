Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52F949167
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfFQUdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfFQUdC (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 17 Jun 2019 16:33:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3909208C4;
        Mon, 17 Jun 2019 20:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560803581;
        bh=Kc3Kc6lpx4bpKMRqzf1gqZLvTAzraoqQ2adK8qNICaI=;
        h=Subject:To:From:Date:From;
        b=gjG6fTgw0lpOs1GPEPWvkPM/yvAG01M98mTui56H4jH6zdxkdQ+C+HXw5AS0W+24Y
         CLyMFro979wF39K6WHO8Qm8LydgPLATt6kDqca4mon9w/kZcuM5gr5FdNz72QYjsFn
         /Nmi82IiDnnq0ldkcknSBpsKN+7Lxzgvhbuv6OSI=
Subject: patch "iio: temperature: mlx90632 Relax the compatibility check" added to staging-linus
To:     cmo@melexis.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 22:32:43 +0200
Message-ID: <1560803563109159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: temperature: mlx90632 Relax the compatibility check

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 389fc70b60f534d679aea9a3f05146040ce20d77 Mon Sep 17 00:00:00 2001
From: Crt Mori <cmo@melexis.com>
Date: Thu, 23 May 2019 14:07:22 +0200
Subject: iio: temperature: mlx90632 Relax the compatibility check

Register EE_VERSION contains mixture of calibration information and DSP
version. So far, because calibrations were definite, the driver
compatibility depended on whole contents, but in the newer production
process the calibration part changes. Because of that, value in EE_VERSION
will be changed and to avoid that calibration value is same as DSP version
the MSB in calibration part was fixed to 1.
That means existing calibrations (medical and consumer) will now have
hex values (bits 8 to 15) of 83 and 84 respectively. Driver compatibility
should be based only on DSP version part of the EE_VERSION (bits 0 to 7)
register.

Signed-off-by: Crt Mori <cmo@melexis.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/temperature/mlx90632.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/temperature/mlx90632.c b/drivers/iio/temperature/mlx90632.c
index be03be719efe..eaca6ba06864 100644
--- a/drivers/iio/temperature/mlx90632.c
+++ b/drivers/iio/temperature/mlx90632.c
@@ -81,6 +81,8 @@
 /* Magic constants */
 #define MLX90632_ID_MEDICAL	0x0105 /* EEPROM DSPv5 Medical device id */
 #define MLX90632_ID_CONSUMER	0x0205 /* EEPROM DSPv5 Consumer device id */
+#define MLX90632_DSP_VERSION	5 /* DSP version */
+#define MLX90632_DSP_MASK	GENMASK(7, 0) /* DSP version in EE_VERSION */
 #define MLX90632_RESET_CMD	0x0006 /* Reset sensor (address or global) */
 #define MLX90632_REF_12		12LL /**< ResCtrlRef value of Ch 1 or Ch 2 */
 #define MLX90632_REF_3		12LL /**< ResCtrlRef value of Channel 3 */
@@ -667,10 +669,13 @@ static int mlx90632_probe(struct i2c_client *client,
 	} else if (read == MLX90632_ID_CONSUMER) {
 		dev_dbg(&client->dev,
 			"Detected Consumer EEPROM calibration %x\n", read);
+	} else if ((read & MLX90632_DSP_MASK) == MLX90632_DSP_VERSION) {
+		dev_dbg(&client->dev,
+			"Detected Unknown EEPROM calibration %x\n", read);	
 	} else {
 		dev_err(&client->dev,
-			"EEPROM version mismatch %x (expected %x or %x)\n",
-			read, MLX90632_ID_CONSUMER, MLX90632_ID_MEDICAL);
+			"Wrong DSP version %x (expected %x)\n",
+			read, MLX90632_DSP_VERSION);
 		return -EPROTONOSUPPORT;
 	}
 
-- 
2.22.0


