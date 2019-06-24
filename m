Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6D50706
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfFXKDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbfFXKCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:47 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02268213F2;
        Mon, 24 Jun 2019 10:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370566;
        bh=Ri3bG5IiphU/t3EBOLoYDeW4xgMSWfxp02qg6ArUHqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0IxZGdnU2gL037uYCMe2vVOtDxmqUKlJjtTc7bU9OTs+ldHDyCKRDS8Sjgh1cR7k
         6cuCeGaJlKjGtsJ+Ws+CeFYNGEIqREVTTLoh20lZzZ7fo+19ZW62xWO/6310DZc5Ta
         jMDyFz02SncpbWQKPjMRmmC5kxeaS9VbbozGNj0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Crt Mori <cmo@melexis.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 22/90] iio: temperature: mlx90632 Relax the compatibility check
Date:   Mon, 24 Jun 2019 17:56:12 +0800
Message-Id: <20190624092315.510493018@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
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
@@ -666,10 +668,13 @@ static int mlx90632_probe(struct i2c_cli
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
 


