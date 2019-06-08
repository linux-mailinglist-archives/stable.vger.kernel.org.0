Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079C939DA6
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfFHLmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfFHLmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11262214C6;
        Sat,  8 Jun 2019 11:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994157;
        bh=GN9fj8h0Z1VPlEI5dkPyZ16IY3nf3XZ6iJ2EyzKJuC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCN6YQymNBO3NIiAVn5TOAq/ezmVn0bAfb6x13wv77csSEsdfczDhPuR9XztHiovb
         ohku622jMgxSUfGZu8twtuBaFHyCyCmQyOsMKF9L9h4GuOUPEt8GMfrCbxcTy0Kq5/
         3zBgrr/k8mIEYUc8Ps/gfqU63Y/Um/9DQ7DjaAp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/49] iio: adc: ti-ads8688: fix timestamp is not updated in buffer
Date:   Sat,  8 Jun 2019 07:41:43 -0400
Message-Id: <20190608114232.8731-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit e6d12298310fa1dc11f1d747e05b168016057fdd ]

When using the hrtimer iio trigger timestamp isn't updated.
If we use iio_get_time_ns it is updated correctly.

Fixes: 2a86487786b5c ("iio: adc: ti-ads8688: add trigger and buffer support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads8688.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads8688.c b/drivers/iio/adc/ti-ads8688.c
index 8b4568edd5cb..7f16c77b99fb 100644
--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -397,7 +397,7 @@ static irqreturn_t ads8688_trigger_handler(int irq, void *p)
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
-			pf->timestamp);
+			iio_get_time_ns(indio_dev));
 
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.20.1

