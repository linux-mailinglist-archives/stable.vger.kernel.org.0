Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBBD3C476F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhGLGcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235984AbhGLG3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107DB61222;
        Mon, 12 Jul 2021 06:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071186;
        bh=ZgDVehS7PBXEkbIjEtENsGlp/DtIxWkRC5NHO99WNQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdvOjOLjhwJq42rN6SdGsqyCjUY1WCEQWUzKUkHpvY8wiqsNE5XR2ltspbrwWp10g
         Ey+sw1j+dE+gIXCxHLbcKxrItCmt9MA6OoGxP5QwV49ewP7x+6ZQ6hz1aDWo4aMk9Y
         5uCihZ+dUQLCvwS/w1oo2FL4X72brPNbu2nNnbj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 312/348] iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:36 +0200
Message-Id: <20210712060745.264509521@linuxfoundation.org>
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

[ Upstream commit 61fa5dfa5f52806f5ce37a0ba5712c271eb22f98 ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Fixes: f214ff521fb1 ("iio: ti-ads8688: Update buffer allocation for timestamps")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-5-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads8688.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads8688.c b/drivers/iio/adc/ti-ads8688.c
index 14fe7c320b52..55a2d619d6dd 100644
--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -383,7 +383,8 @@ static irqreturn_t ads8688_trigger_handler(int irq, void *p)
 {
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)];
+	/* Ensure naturally aligned timestamp */
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
 	int i, j = 0;
 
 	for (i = 0; i < indio_dev->masklength; i++) {
-- 
2.30.2



