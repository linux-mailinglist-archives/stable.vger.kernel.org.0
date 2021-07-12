Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493033C5572
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355724AbhGLIKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353649AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B002161628;
        Mon, 12 Jul 2021 07:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076601;
        bh=+TWCa/1EP/i47iU9MzyDA5w9btZJIJAT8zhNTtxO/7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQVc5M1XdE5XHamr8TBHHgAUISEKbfsJwATwaHgpAl9TGF+keA3RUlKtL+u8HTOa4
         rv28e3Lj7yvdew4tk258ACMy6r1aDJzA82wPJpvdq1f4ZvPpqFIqvgK7auUo/4XQok
         pdEcWrP+NttvxS8WS2edrjJFuNKQRma4y+cD/kTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mathieu Othacehe <m.othacehe@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 714/800] iio: light: vcnl4000: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:12:17 +0200
Message-Id: <20210712061042.712590433@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit dce793c0ab00c35039028fdcd5ce123805a01361 ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here an explicit structure is not used, because the holes would
necessitate the addition of an explict memset(), to avoid a kernel
data leak, making for a less minimal fix.

Found during an audit of all callers of iio_push_to_buffers_with_timestamp()

Fixes: 8fe78d5261e7 ("iio: vcnl4000: Add buffer support for VCNL4010/20.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mathieu Othacehe <m.othacehe@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-7-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 2f7916f95689..3b5e27053ef2 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -910,7 +910,7 @@ static irqreturn_t vcnl4010_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4000_data *data = iio_priv(indio_dev);
 	const unsigned long *active_scan_mask = indio_dev->active_scan_mask;
-	u16 buffer[8] = {0}; /* 1x16-bit + ts */
+	u16 buffer[8] __aligned(8) = {0}; /* 1x16-bit + naturally aligned ts */
 	bool data_read = false;
 	unsigned long isr;
 	int val = 0;
-- 
2.30.2



