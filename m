Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121D93CDC01
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbhGSOu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344904AbhGSOtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9708F60551;
        Mon, 19 Jul 2021 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708597;
        bh=FAzYmYsss1pbrGsEmD/nkM6Aop2UQEWpOl/NDVl0/hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCuh/1EAf2sZCYrxGyAOfifGGwifJa8gFWAwZAOrbLS9B2Fc0sV4cLIC5JJQ/bUNF
         gRM7jltLM46cvauZvLPPXsNLIEaGc115cbareaGjKf4jWjDpxzQaAk222TMR0jnNVL
         ZYVq5SdXsmDR5bpollHMxQe4TY63q5wh+Y/ziDvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Lang <Oliver.Lang@gossenmetrawatt.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 4.19 036/421] iio: ltr501: ltr501_read_ps(): add missing endianness conversion
Date:   Mon, 19 Jul 2021 16:47:27 +0200
Message-Id: <20210719144947.482084338@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -411,18 +411,19 @@ static int ltr501_read_als(struct ltr501
 
 static int ltr501_read_ps(struct ltr501_data *data)
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
 
 static int ltr501_read_intr_prst(struct ltr501_data *data,


