Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55800405558
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358801AbhIINJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357959AbhIINFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BA11632A4;
        Thu,  9 Sep 2021 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188820;
        bh=SY6y8U71EGd4aHjByJyQV570JiwGzg0mb0VxOk/josg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhAzSy8lZiLuA1rU26fGaW1BND9VZl85nUk424mQ2VII6rFfDbL1Jh0ZHgjl24fZE
         4iMxVNsbPA40Gwy5Tlb8nlbGDYjqYYq/40xFbu7roUTD7ZDznRfe9zXHo0CI27JSBX
         1T5GLT6GoqYQ27ZR8SZ90YSTWxB0FgC6LA73oI8Lr4EfJyroFRh3rHgWhpBOw8GNH6
         qt9UuqncDt+mqlBtXF/QGbi3QAXaJV7CYgOW+VpcIMuuNjdAM+xHhTVuUQSKKfIj9u
         1fJbT7sE190nxB9+rpFWL97PXIWEFPa8jEpxDJA7NSUrptCFequQK8Owv/rsMeD3ti
         YkR4NsbQrfQ7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/48] iio: dac: ad5624r: Fix incorrect handling of an optional regulator.
Date:   Thu,  9 Sep 2021 07:59:30 -0400
Message-Id: <20210909120015.150411-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5489ec43b95d..e5cefdb674f8 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -231,7 +231,7 @@ static int ad5624r_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
+	st->reg = devm_regulator_get_optional(&spi->dev, "vref");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
 		if (ret)
@@ -242,6 +242,22 @@ static int ad5624r_probe(struct spi_device *spi)
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

