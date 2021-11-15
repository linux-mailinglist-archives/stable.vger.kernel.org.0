Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E410452476
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351625AbhKPBjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241740AbhKOS2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:28:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 879C163436;
        Mon, 15 Nov 2021 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999060;
        bh=Lvd5JfHFBPMAaNcT0VnsoZt2DRbytrOPPgGE/eR5nk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJxG7rUlQUpWs2a5DSHV6V0Ds+E6Hgj4SKpRIL9NcQd/OHEVoMhNgsSGxwSwi/Dqw
         FjTpX2XeK2/9THIRCT4PMilJB7sqFTrVd89Cl20rO5BYNUOgnW9061WWezEfUhl7D2
         XWWyH3rkZVCshPRj6GqCi4cjR644cFr10SHZ7B7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 161/849] iio: adc: tsc2046: fix scan interval warning
Date:   Mon, 15 Nov 2021 17:54:04 +0100
Message-Id: <20211115165425.612850792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 69b31fd7a61784692db6433c05d46915b1b1a680 upstream.

Sync if statement with the actual warning.

Fixes: 9504db5765e8 ("iio: adc: tsc2046: fix a warning message in tsc2046_adc_update_scan_mode()")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20211007093007.1466-2-o.rempel@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-tsc2046.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-tsc2046.c
+++ b/drivers/iio/adc/ti-tsc2046.c
@@ -398,7 +398,7 @@ static int tsc2046_adc_update_scan_mode(
 	priv->xfer.len = size;
 	priv->time_per_scan_us = size * 8 * priv->time_per_bit_ns / NSEC_PER_USEC;
 
-	if (priv->scan_interval_us > priv->time_per_scan_us)
+	if (priv->scan_interval_us < priv->time_per_scan_us)
 		dev_warn(&priv->spi->dev, "The scan interval (%d) is less then calculated scan time (%d)\n",
 			 priv->scan_interval_us, priv->time_per_scan_us);
 


