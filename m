Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD939616A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhEaOk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233980AbhEaOhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16A161C55;
        Mon, 31 May 2021 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469121;
        bh=CnVjX5vT2irg3av9FDImDH3Pys1rwVPHHG4quadwNt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uT3gajvOXLGuXmYwPowBMz6fwU+xPozLUT1kmUY1QkPSayg9kpn5Gutx9FFX8z5QT
         pmx0RK1rnbM5585fHLTxzXrM+OSU+uwGTskpKaxh5+Q5dvWXDt8eS5afMk+PhuJ9j1
         QNRfNRp3e3c2qBzLcM7GAEQjDGRdmy0NWn+NFyeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 077/296] iio: dac: ad5770r: Put fwnode in error case during ->probe()
Date:   Mon, 31 May 2021 15:12:12 +0200
Message-Id: <20210531130706.440210824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

commit 98b7b0ca0828907dbb706387c11356a45463e2ea upstream.

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210510095649.3302835-1-andy.shevchenko@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -524,23 +524,29 @@ static int ad5770r_channel_config(struct
 	device_for_each_child_node(&st->spi->dev, child) {
 		ret = fwnode_property_read_u32(child, "num", &num);
 		if (ret)
-			return ret;
-		if (num >= AD5770R_MAX_CHANNELS)
-			return -EINVAL;
+			goto err_child_out;
+		if (num >= AD5770R_MAX_CHANNELS) {
+			ret = -EINVAL;
+			goto err_child_out;
+		}
 
 		ret = fwnode_property_read_u32_array(child,
 						     "adi,range-microamp",
 						     tmp, 2);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		min = tmp[0] / 1000;
 		max = tmp[1] / 1000;
 		ret = ad5770r_store_output_range(st, min, max, num);
 		if (ret)
-			return ret;
+			goto err_child_out;
 	}
 
+	return 0;
+
+err_child_out:
+	fwnode_handle_put(child);
 	return ret;
 }
 


