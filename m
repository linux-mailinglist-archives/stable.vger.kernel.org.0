Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA8450E69
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240893AbhKOSOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240262AbhKOSH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF89F63253;
        Mon, 15 Nov 2021 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998250;
        bh=vyil6MPO+L96Lrg+3VAXUeQfZ8Yxw8zGBmJIpRdW6Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1gDRsaWx3hD4RYjfw36txuSL/FCIJpBVveuTBQ7WeP++OH+wTtk5XFVvKXDfHcEO
         ILp7XuC7cReEp435/lzZOIhze/739lXQ0h+/FWw8A2afrnvqjLbhHgD0uCg1CMMz2C
         k2dAVtz+xMtIgfzIR42Q1c/3VAKTcdCr2Gsw2iq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/575] iio: adis: do not disabe IRQs in adis_init()
Date:   Mon, 15 Nov 2021 18:02:48 +0100
Message-Id: <20211115165359.079796954@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b600bd7eb333554518b4dd36b882b2ae58a5149e ]

With commit ecb010d441088 ("iio: imu: adis: Refactor adis_initial_startup")
we are doing a HW or SW reset to the device which means that we'll get
the default state of the data ready pin (which is enabled). Hence there's
no point in disabling the IRQ in the init function. Moreover, this
function is intended to initialize internal data structures and not
really do anything on the device.

As a result of this, some devices were left with the data ready pin enabled
after probe which was not the desired behavior. Thus, we move the call to
'adis_enable_irq()' to the initial startup function where it makes more
sense for it to be.

Note that for devices that cannot mask/unmask the pin, it makes no sense
to call the function at this point since the IRQ should not have been
yet requested. This will be improved in a follow up change.

Fixes: ecb010d441088 ("iio: imu: adis: Refactor adis_initial_startup")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210903141423.517028-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index f8b7837d8b8f6..715eef81bc248 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -434,6 +434,8 @@ int __adis_initial_startup(struct adis *adis)
 	if (ret)
 		return ret;
 
+	adis_enable_irq(adis, false);
+
 	if (!adis->data->prod_id_reg)
 		return 0;
 
@@ -530,7 +532,7 @@ int adis_init(struct adis *adis, struct iio_dev *indio_dev,
 		adis->current_page = 0;
 	}
 
-	return adis_enable_irq(adis, false);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(adis_init);
 
-- 
2.33.0



