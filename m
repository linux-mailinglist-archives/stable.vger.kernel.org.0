Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59B5077C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfFXKHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbfFXKHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:24 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC4E205C9;
        Mon, 24 Jun 2019 10:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370843;
        bh=eqDiC7uw4aHI9ltVmJT8s7BR2BPcj1F4cyesq98jjX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Be69bap9EVS+miKjuCYy85WtY8oGXlb0p7Vu8M0/0pfpZOqm/3WoQBnJaRcDxMOWT
         pHusdRr0CFsVC96iB5Q1dYHkQUex2FfzWtRRPCB8OZrBgbUW5jFCwOceOPoSNB3IMN
         q1y1Yrfqw6XwcSRv+tdbYrYZH/MvuyNKsBOAaQRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Crt Mori <cmo@melexis.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.1 021/121] iio: temperature: mlx90632 Relax the compatibility check
Date:   Mon, 24 Jun 2019 17:55:53 +0800
Message-Id: <20190624092321.716751808@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Crt Mori <cmo@melexis.com>

commit 389fc70b60f534d679aea9a3f05146040ce20d77 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/temperature/mlx90632.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -667,10 +669,13 @@ static int mlx90632_probe(struct i2c_cli
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
 


