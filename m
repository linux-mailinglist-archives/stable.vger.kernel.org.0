Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BC840DFAD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbhIPQM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237354AbhIPQKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D476561350;
        Thu, 16 Sep 2021 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808514;
        bh=l5v/rb/8ioYC6MGBYgVUaNFI8j0ENAXTj6L18sSOvjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBKL6b9G+xPbSfS/Rz7CsH92eLdVYuRGRp34mcA/wfaVC5psRhJmAMbTiarvSpczs
         W9Svvr0tEhNuqu5AY9IF3RDKDZQp7xL4FVKHAaKPAb79nLOSS+3sIf7vs/39QocdQl
         PvxVoMt89grArNCAsEeBLvrKtIpVaLXSnF6deCT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/306] iio: dac: ad5624r: Fix incorrect handling of an optional regulator.
Date:   Thu, 16 Sep 2021 17:57:45 +0200
Message-Id: <20210916155758.160862677@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 2b2b8edfd258..ab4997bfd6d4 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -229,7 +229,7 @@ static int ad5624r_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	st->reg = devm_regulator_get(&spi->dev, "vcc");
+	st->reg = devm_regulator_get_optional(&spi->dev, "vref");
 	if (!IS_ERR(st->reg)) {
 		ret = regulator_enable(st->reg);
 		if (ret)
@@ -240,6 +240,22 @@ static int ad5624r_probe(struct spi_device *spi)
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



