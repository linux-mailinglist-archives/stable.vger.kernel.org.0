Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE639601D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhEaOW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232848AbhEaORn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5F9619B0;
        Mon, 31 May 2021 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468631;
        bh=hGubpCKZPgrK5s3MemOHKJXhP02/GL9Hd5ohu+KxcPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYsrImr7kLv0LsMhVWEzuy+THnY3UW6p7om/1udjMqDgEmqDH/JsUNNviaIqmEwm7
         dRZz6f1woKvBu5zHI8vqiAhHbBtKdPjpWLKq5slaBrFp8vfkeOmBnvxl2LQjD/A9yi
         FqXuXWXvcZAHR1rOYLTqTRoBA2FUHePU0FnKKkrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 048/177] iio: adc: ad7793: Add missing error code in ad7793_setup()
Date:   Mon, 31 May 2021 15:13:25 +0200
Message-Id: <20210531130649.582445660@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 4ed243b1da169bcbc1ec5507867e56250c5f1ff9 upstream.

Set error code while device ID query failed.

Fixes: 88bc30548aae ("IIO: ADC: New driver for AD7792/AD7793 3 Channel SPI ADC")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7793.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -278,6 +278,7 @@ static int ad7793_setup(struct iio_dev *
 	id &= AD7793_ID_MASK;
 
 	if (id != st->chip_info->id) {
+		ret = -ENODEV;
 		dev_err(&st->sd.spi->dev, "device ID query failed\n");
 		goto out;
 	}


