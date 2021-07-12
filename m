Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA663C50FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345024AbhGLHgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346676AbhGLHeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB006613AB;
        Mon, 12 Jul 2021 07:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075069;
        bh=Y7MBsejTqP5jbUJzRJcT4hEOWtadSAMUvNkusXB/BjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCwCfPepY3kPJ9kCgBFBssJ1VGnIvlyztRFgFJx7Bl+GKDQUAbW93rA08VIT9dBeF
         vtqova0Gux0rTkd3kWp4cuVehXIEn3wFatABdbzW3YtwATyduIuwEYDivs92v4N2zL
         h9bVAwT1ItY+nOOBXD3UHBwl7gZKYrE9gMO7ZBE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Lang <Oliver.Lang@gossenmetrawatt.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 5.13 095/800] iio: ltr501: ltr501_read_ps(): add missing endianness conversion
Date:   Mon, 12 Jul 2021 08:01:58 +0200
Message-Id: <20210712060926.425220894@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>

commit 71b33f6f93ef9462c84560e2236ed22209d26a58 upstream.

The PS ADC Channel data is spread over 2 registers in little-endian
form. This patch adds the missing endianness conversion.

Fixes: 2690be905123 ("iio: Add Lite-On ltr501 ambient light / proximity sensor driver")
Signed-off-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Nikita Travkin <nikita@trvn.ru> # ltr559
Link: https://lore.kernel.org/r/20210610134619.2101372-4-mkl@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/ltr501.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -409,18 +409,19 @@ static int ltr501_read_als(const struct
 
 static int ltr501_read_ps(const struct ltr501_data *data)
 {
-	int ret, status;
+	__le16 status;
+	int ret;
 
 	ret = ltr501_drdy(data, LTR501_STATUS_PS_RDY);
 	if (ret < 0)
 		return ret;
 
 	ret = regmap_bulk_read(data->regmap, LTR501_PS_DATA,
-			       &status, 2);
+			       &status, sizeof(status));
 	if (ret < 0)
 		return ret;
 
-	return status;
+	return le16_to_cpu(status);
 }
 
 static int ltr501_read_intr_prst(const struct ltr501_data *data,


