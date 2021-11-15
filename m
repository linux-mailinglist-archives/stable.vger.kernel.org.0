Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCF7450FA0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242370AbhKOSfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241962AbhKOSbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9904861C12;
        Mon, 15 Nov 2021 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999155;
        bh=EB+iKJh/yyi/sv+iR3UpJvKhL6oH2KY/99lvOZII0TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/oDIyH5duAoLtGeMsleBGNLt8jX1OUDvnvP/FydO01ESzao0ilyWOkp+AiIdKlHp
         N056c8mpnp50Dkl2QeaW8F4Eb99nl9NHmHS0d+18ruwoAgADmrZznRnyLvnIk5cy3A
         SFtkJsEsTVYWi9l0DmTbkvOWI+ctDu1fiVHfNQUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 196/849] iio: ad5770r: make devicetree property reading consistent
Date:   Mon, 15 Nov 2021 17:54:39 +0100
Message-Id: <20211115165426.827990912@linuxfoundation.org>
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

From: Nuno Sá <nuno.sa@analog.com>

commit 26df977a909f818b7d346b3990735513e7e0bf93 upstream.

The bindings file for this driver is defining the property as 'reg' but
the driver was reading it with the 'num' name. The bindings actually had
the 'num' property when added in
commit ea52c21268e6 ("dt-bindings: iio: dac: Add docs for AD5770R DAC")
and then changed it to 'reg' in
commit 2cf3818f18b2 ("dt-bindings: iio: dac: AD5570R fix bindings errors").
However, both these commits landed in v5.7 so the assumption is
that either 'num' is not being used or if it is, the validations were not
done.

Anyways, if someone comes back yelling about this, we might just support
both of the properties in the future. Not ideal, but that's life...

Fixes: 2cf3818f18b2 ("dt-bindings: iio: dac: AD5570R fix bindings errors")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210818080525.62790-1-nuno.sa@analog.com
Cc: Stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -522,7 +522,7 @@ static int ad5770r_channel_config(struct
 		return -EINVAL;
 
 	device_for_each_child_node(&st->spi->dev, child) {
-		ret = fwnode_property_read_u32(child, "num", &num);
+		ret = fwnode_property_read_u32(child, "reg", &num);
 		if (ret)
 			goto err_child_out;
 		if (num >= AD5770R_MAX_CHANNELS) {


