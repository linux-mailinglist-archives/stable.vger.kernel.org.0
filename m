Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7841203E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354078AbhITRxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354387AbhITRtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50D361107;
        Mon, 20 Sep 2021 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157901;
        bh=ys93JIkJor0XQfcdfHsBQ3ju1Zsl222TxIT0neTqpJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ad0adb00jiZKYWCMY+Tg74ThwHSfq0lhBjzXmCOdJe4hbQZufqxBg9Lc6A1FDnLYG
         9029Ja8rK+WhvPUm2+ZuU3Bz4ldpHDBPCEzyy5Hw86rOD+tu61V+wMMUHUtAO+QKIc
         1+Pow2Ll7kRDZEPgClvnK6tcMl3koDZGS+hrgP5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/293] iio: dac: ad5624r: Fix incorrect handling of an optional regulator.
Date:   Mon, 20 Sep 2021 18:42:18 +0200
Message-Id: <20210920163939.303771935@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 97683c851f9cdbd3ea55697cbe2dcb6af4287bbd ]

The naming of the regulator is problematic.  VCC is usually a supply
voltage whereas these devices have a separate VREF pin.

Secondly, the regulator core might have provided a stub regulator if
a real regulator wasn't provided. That would in turn have failed to
provide a voltage when queried. So reality was that there was no way
to use the internal reference.

In order to avoid breaking any dts out in the wild, make sure to fallback
to the original vcc naming if vref is not available.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210627163244.1090296-9-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5624r_spi.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5624r_spi.c b/drivers/iio/dac/ad5624r_spi.c
index 13fdb4dfe356..cc3a24c43e57 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -230,7 +230,7 @@ static int ad5624r_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
+	st->reg = devm_regulator_get_optional(&spi->dev, "vref");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
 		if (ret)
@@ -241,6 +241,22 @@ static int ad5624r_probe(struct spi_device *spi)
 			goto error_disable_reg;
 
 		voltage_uv = ret;
+	} else {
+		if (PTR_ERR(st->reg) != -ENODEV)
+			return PTR_ERR(st->reg);
+		/* Backwards compatibility. This naming is not correct */
+		st->reg = devm_regulator_get_optional(&spi->dev, "vcc");
+		if (!IS_ERR(st->reg)) {
+			ret = regulator_enable(st->reg);
+			if (ret)
+				return ret;
+
+			ret = regulator_get_voltage(st->reg);
+			if (ret < 0)
+				goto error_disable_reg;
+
+			voltage_uv = ret;
+		}
 	}
 
 	spi_set_drvdata(spi, indio_dev);
-- 
2.30.2



