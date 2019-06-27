Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83043577FD
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfF0Agt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbfF0Ags (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:48 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2BA2186A;
        Thu, 27 Jun 2019 00:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595807;
        bh=XhgUEw50j3ASgiDFxtgMwIkcVr0dG28b+ZCnpZRiwNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krpJ4U+Cn4xg5S++RC8WEHy9tEKbhpXRbuLHjwaFYpJJPp/YH9256Po+Kd6DFCQ/R
         Wrju+zIKxpHlLG5nYtmi7xQw628Yw4nAq80sUjYhmrkAl5821EmbadP2GoH+3tDqkG
         CwXSF7/zdTGxVIKBloNk8M1+dYwCGPRuVRxGN3+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Crt Mori <cmo@melexis.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/60] iio: temperature: mlx90632 Relax the compatibility check
Date:   Wed, 26 Jun 2019 20:35:25 -0400
Message-Id: <20190627003616.20767-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Crt Mori <cmo@melexis.com>

[ Upstream commit 389fc70b60f534d679aea9a3f05146040ce20d77 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/mlx90632.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/temperature/mlx90632.c b/drivers/iio/temperature/mlx90632.c
index 9851311aa3fd..ebff17f194b2 100644
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
@@ -666,10 +668,13 @@ static int mlx90632_probe(struct i2c_client *client,
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
2.20.1

