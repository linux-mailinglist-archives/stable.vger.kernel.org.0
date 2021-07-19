Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB13CD9E4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245323AbhGSOcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241866AbhGSO2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:28:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6263261264;
        Mon, 19 Jul 2021 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707307;
        bh=PxyD3vuui0Czt6+qLbgM1PyCIZ5V3NELgEMkjmqlK9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGddbtpinxEDKll32WRDMnRfkwZE5uWp6jDNAJtHQDq16iFflP+EgAyiIJNbHqnym
         7JP0E3evuqRWcYHlinbKBcWP9dSMlGZGMiY2EFzjKX8KfjpO9zBb5i795b7rTDMe5m
         zgiaIL9QvCWVwJPFgZfkh6VtUulkWxAiguqhbm8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stefan-Gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 100/245] iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:42 +0200
Message-Id: <20210719144943.655497708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 7765dfaa22ea08abf0c175e7553826ba2a939632 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 0010d6b44406 ("iio: adc: vf610: Add IIO buffer support for Vybrid ADC")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Stefan-Gabriel Mirea <stefan-gabriel.mirea@nxp.com>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-10-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/vf610_adc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
index d1bde6d2721e..2a14800e6514 100644
--- a/drivers/iio/adc/vf610_adc.c
+++ b/drivers/iio/adc/vf610_adc.c
@@ -180,7 +180,11 @@ struct vf610_adc {
 	u32 sample_freq_avail[5];
 
 	struct completion completion;
-	u16 buffer[8];
+	/* Ensure the timestamp is naturally aligned */
+	struct {
+		u16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static const u32 vf610_hw_avgs[] = { 1, 4, 8, 16, 32 };
@@ -592,9 +596,9 @@ static irqreturn_t vf610_adc_isr(int irq, void *dev_id)
 	if (coco & VF610_ADC_HS_COCO0) {
 		info->value = vf610_adc_read_data(info);
 		if (iio_buffer_enabled(indio_dev)) {
-			info->buffer[0] = info->value;
+			info->scan.chan = info->value;
 			iio_push_to_buffers_with_timestamp(indio_dev,
-					info->buffer,
+					&info->scan,
 					iio_get_time_ns(indio_dev));
 			iio_trigger_notify_done(indio_dev->trig);
 		} else
-- 
2.30.2



