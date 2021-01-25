Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1030333F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbhAZEtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbhAYSpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF23B22B3F;
        Mon, 25 Jan 2021 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600307;
        bh=pYY4Hw+FeNNXlhA/qwXAktZ/rmfmUgyV7qnaFeZ4De8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2y+lYsrCme5D4HiUMW1gKaBdUaPkZDmlkANl9WUcZI2lwl3BVmyscRPMaLEoLxyZ
         tPb5BSnaRN0VkUxGrkKuj06hUBoycJUoT1TvPXPwuDMYdg3yGW1HXpCkPVSr4k2rDu
         SYZ3XpLg8/qOjEPOIICcyaPwXhRWJcOG5yMGnjKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 52/86] iio: ad5504: Fix setting power-down state
Date:   Mon, 25 Jan 2021 19:39:34 +0100
Message-Id: <20210125183203.247995037@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit efd597b2839a9895e8a98fcb0b76d2f545802cd4 upstream.

The power-down mask of the ad5504 is actually a power-up mask. Meaning if
a bit is set the corresponding channel is powered up and if it is not set
the channel is powered down.

The driver currently has this the wrong way around, resulting in the
channel being powered up when requested to be powered down and vice versa.

Fixes: 3bbbf150ffde ("staging:iio:dac:ad5504: Use strtobool for boolean values")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201209104649.5794-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/dac/ad5504.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/ad5504.c
+++ b/drivers/iio/dac/ad5504.c
@@ -188,9 +188,9 @@ static ssize_t ad5504_write_dac_powerdow
 		return ret;
 
 	if (pwr_down)
-		st->pwr_down_mask |= (1 << chan->channel);
-	else
 		st->pwr_down_mask &= ~(1 << chan->channel);
+	else
+		st->pwr_down_mask |= (1 << chan->channel);
 
 	ret = ad5504_spi_write(st, AD5504_ADDR_CTRL,
 				AD5504_DAC_PWRDWN_MODE(st->pwr_down_mode) |


