Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6834E3CDA80
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243744AbhGSOgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343528AbhGSOfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84BC5610D2;
        Mon, 19 Jul 2021 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707715;
        bh=PazBOLslw/82uRtt81dMn6xJFuEKCByV5auqxdYvnHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtg3Rn7f6HZXDo+H8yAHht1XRHrKhNKoAjB51LDoxnIdw0jq1Mt4GXWOhiCdcKIu+
         3IA+gWHw1isWw48q2cEqIy/5SmExuzNGDYUyojYGaKGK1s1dFy0OC1aNUp5JrzWjyI
         gYxP4yAv/2z6f+21Dlv72tTyP3/aDOIXcHKLuoC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Lang <Oliver.Lang@gossenmetrawatt.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 4.14 027/315] iio: ltr501: ltr559: fix initialization of LTR501_ALS_CONTR
Date:   Mon, 19 Jul 2021 16:48:36 +0200
Message-Id: <20210719144943.776093482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>

commit 421a26f3d7a7c3ca43f3a9dc0f3cb0f562d5bd95 upstream.

The ltr559 chip uses only the lowest bit of the ALS_CONTR register to
configure between active and stand-by mode. In the original driver
BIT(1) is used, which does a software reset instead.

This patch fixes the problem by using BIT(0) as als_mode_active for
the ltr559 chip.

Fixes: 8592a7eefa54 ("iio: ltr501: Add support for ltr559 chip")
Signed-off-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Nikita Travkin <nikita@trvn.ru> # ltr559
Link: https://lore.kernel.org/r/20210610134619.2101372-3-mkl@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/ltr501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1214,7 +1214,7 @@ static struct ltr501_chip_info ltr501_ch
 		.als_gain_tbl_size = ARRAY_SIZE(ltr559_als_gain_tbl),
 		.ps_gain = ltr559_ps_gain_tbl,
 		.ps_gain_tbl_size = ARRAY_SIZE(ltr559_ps_gain_tbl),
-		.als_mode_active = BIT(1),
+		.als_mode_active = BIT(0),
 		.als_gain_mask = BIT(2) | BIT(3) | BIT(4),
 		.als_gain_shift = 2,
 		.info = &ltr501_info,


