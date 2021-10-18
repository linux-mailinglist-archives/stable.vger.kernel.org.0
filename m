Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFFB431E55
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhJROAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234577AbhJRN6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:58:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C635561391;
        Mon, 18 Oct 2021 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564484;
        bh=d4mqd3nmx/pe/KPLfNiqal5aAW2JmfUWtp/RMsjIN7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ib0beblPaqJZAMJgv9GNoGzk7TXFYTkXBUfjBDupv5RQ43orIA7FqoLN6oNdfppWo
         Ia8ycQ8snJJc9bm9cNMbkZR4uQMIMQrWnIvWO7p8Av46kSWkRU6OzrKt0Fdkks+AvP
         kIop2oWkArZxix9RmcrXDrETf4dPd4l7y3qRx1lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 073/151] iio: adc: max1027: Fix wrong shift with 12-bit devices
Date:   Mon, 18 Oct 2021 15:24:12 +0200
Message-Id: <20211018132343.058624724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 732ae19ee8f58ecaf30cbc1bbbda5cbee6a45043 upstream.

10-bit devices must shift the value twice.
This is not needed anymore on 12-bit devices.

Fixes: ae47d009b508 ("iio: adc: max1027: Introduce 12-bit devices support")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210818111139.330636-2-miquel.raynal@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1027.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -103,7 +103,7 @@ MODULE_DEVICE_TABLE(of, max1027_adc_dt_i
 			.sign = 'u',					\
 			.realbits = depth,				\
 			.storagebits = 16,				\
-			.shift = 2,					\
+			.shift = (depth == 10) ? 2 : 0,			\
 			.endianness = IIO_BE,				\
 		},							\
 	}


