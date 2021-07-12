Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC1F3C470B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhGLGbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236061AbhGLG3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B54D61004;
        Mon, 12 Jul 2021 06:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071207;
        bh=abkQn85XnalsqVeO5JJoffW6YRv5zu+z8YGtkRC7FDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL+N/y10zLr3NEeQffuBxp49d6TdpHfF7jlIWBUd1xrpHZ3Cv5Nwzi++TlKYb8W7M
         gBj/V3jZWyk/KMmA6P3miSpwH3c2AT6X9ud7DQMho9lhL4+LZ/k7x2mXEudE5R7Lll
         SXmrH1G4RVahE2IawWv5CG3GGR7xZI6pTsSpwBzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Parthiban Nallathambi <pn@denx.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 320/348] iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:44 +0200
Message-Id: <20210712060746.472357002@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit ec90b52c07c0403a6db60d752484ec08d605ead0 ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here an explicit structure is not used, because the holes would
necessitate the addition of an explict memset(), to avoid a potential
kernel data leak, making for a less minimal fix.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Parthiban Nallathambi <pn@denx.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-8-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4035.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4035.c b/drivers/iio/light/vcnl4035.c
index cca4db312bd3..234623ab3817 100644
--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -102,7 +102,8 @@ static irqreturn_t vcnl4035_trigger_consumer_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)];
+	/* Ensure naturally aligned timestamp */
+	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8);
 	int ret;
 
 	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);
-- 
2.30.2



