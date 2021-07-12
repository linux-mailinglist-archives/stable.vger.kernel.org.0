Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868123C4A6F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbhGLGwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239042AbhGLGt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75FD61221;
        Mon, 12 Jul 2021 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072333;
        bh=0vtx1rzit57snHuBv4JPMsOTKelZthfIUK7q67ljMk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D92ZZQmSleVQF+nsggXPNSDXjmbSfIX6eAY6xCozESPQ27oRLqEtPquqjPavI8aO3
         9e09g7K7Ea4iDCPzfxpa1ADl/qgeVs+8Jt7Os9sSLksR4eO1gIXDJh8nFnhcV3NwSv
         35pG2+a/hPj9iWMjMfv/vaHbUCMs2GMDyFS/qYYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stefan-Gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 453/593] iio: adc: vf610: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:13 +0200
Message-Id: <20210712060939.175443067@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 1d794cf3e3f1..fd57fc43e8e5 100644
--- a/drivers/iio/adc/vf610_adc.c
+++ b/drivers/iio/adc/vf610_adc.c
@@ -167,7 +167,11 @@ struct vf610_adc {
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
@@ -579,9 +583,9 @@ static irqreturn_t vf610_adc_isr(int irq, void *dev_id)
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



