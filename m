Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433F4431CD1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhJRNo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233455AbhJRNm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 274C761503;
        Mon, 18 Oct 2021 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564072;
        bh=d4mqd3nmx/pe/KPLfNiqal5aAW2JmfUWtp/RMsjIN7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKulyVQIS0/I9FfC8RYFjtvl3zN9thENTxzQthHfI+lcytL41YcpOgSPTfXmPi8kV
         LJbexPP+g5cT5o9Br3yt2kBlB2VeElR6+5ssyOtM90APLdNRv5tcGrw8pKPwlr1DZy
         nLmYhG4WckuFu5O8QkbmoVAtTfZQVVcn7FjS74Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 055/103] iio: adc: max1027: Fix wrong shift with 12-bit devices
Date:   Mon, 18 Oct 2021 15:24:31 +0200
Message-Id: <20211018132336.609640048@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
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


