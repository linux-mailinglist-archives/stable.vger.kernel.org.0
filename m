Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACD3CDDB9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345333AbhGSPAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242714AbhGSO63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A04760E0C;
        Mon, 19 Jul 2021 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708967;
        bh=UWK4/zr5ZrVbbtkGNiIgPDOwUyqRc1kXZ6w3sfBNic8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvao/d0DV2zeFwfwscBhkgFlPXnuhGSvx1lI82HT/OUyVQzA50iZ19ySs/BF9FS1A
         gjb19deBO2ic4tpFIFRlFiy4THNLPXodL4tPSU2hEpPNMeh8aWF9Tgro8VOhy22Vgi
         bFk3Gl66lryHUPBIt5F4UCtheJEgqwvEg4uRmPjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 201/421] iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:12 +0200
Message-Id: <20210719144953.345986553@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 7f16c77b99fb..9bcb05897c9d 100644
--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -386,7 +386,8 @@ static irqreturn_t ads8688_trigger_handler(int irq, void *p)
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



