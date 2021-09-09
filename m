Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF24054D5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351096AbhIINDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357130AbhIIM7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B53263279;
        Thu,  9 Sep 2021 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188745;
        bh=SY6y8U71EGd4aHjByJyQV570JiwGzg0mb0VxOk/josg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTzc3tBGdP6orfuvo+DCGV5zpGiHUs5w2AGsMqroQ6oBDD7pWV3rMnFkA4b1nRM47
         dm8eA3nMT1PIjZBqLEHQCCL3wsPZnyztbXmiQomjognNUlRY1IThXlKNsAvvo9gG1Q
         8/QPFvD772Cf1R7OCDgeaKh64HZUP3OiWujw3XkRcC6Xir7Vfl0Mrp5TKoSa8uq2Z0
         GB8BbPPWdN1BdHDR8PjwmpCN6fN0Dj9NKDO0ez4lVKq+tog98a4sVcB7Y50iHeS2Ie
         WZ9BFECmoHO9+qTSDQN4Qv9reEWo6Zxo+Nho5TUdakkLi05mrTZmQTCmgi7f6OMpiR
         EOCHUuh0c3iLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/59] iio: dac: ad5624r: Fix incorrect handling of an optional regulator.
Date:   Thu,  9 Sep 2021 07:58:05 -0400
Message-Id: <20210909115900.149795-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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

