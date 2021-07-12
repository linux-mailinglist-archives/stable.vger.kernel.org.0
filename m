Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF413C5539
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355418AbhGLIJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353300AbhGLIBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA97A613E8;
        Mon, 12 Jul 2021 07:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076471;
        bh=jYP6sDeYG6JsKKBw40HW2tKk3HSdwE11BKrWAIEyvto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0IpUHakDb7z35G2Pe6ZCd7+BMTcOuWJe2TNjHoU25cRHzgxsnDj5AplfwWgSKWNl
         xMjBkaij7QmLEyN8WgKZAgm31Xct7YbDRw9LBcRQqYPFQhPT/i8E6IJbM393v+hGjk
         uEgHenwtTfx4vIk4MMvAubA6tPY8mnroFae0+GXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 614/800] iio: adis16400: do not return ints in irq handlers
Date:   Mon, 12 Jul 2021 08:10:37 +0200
Message-Id: <20210712061032.709414953@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit ab3df79782e7d8a27a58576c9b4e8c6c4879ad79 ]

On an IRQ handler we should not return normal error codes as 'irqreturn_t'
is expected.

Not necessary to apply to stable as the original check cannot fail and
as such the bug cannot actually occur.

Fixes: 5eda3550a3cc1 ("staging:iio:adis16400: Preallocate transfer message")
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210422101911.135630-3-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index 768aa493a1a6..b2f92b55b910 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -645,9 +645,6 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 	void *buffer;
 	int ret;
 
-	if (!adis->buffer)
-		return -ENOMEM;
-
 	if (!(st->variant->flags & ADIS16400_NO_BURST) &&
 		st->adis.spi->max_speed_hz > ADIS16400_SPI_BURST) {
 		st->adis.spi->max_speed_hz = ADIS16400_SPI_BURST;
-- 
2.30.2



