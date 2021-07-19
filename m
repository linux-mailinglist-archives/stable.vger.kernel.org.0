Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B2F3CDDBB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbhGSPAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237865AbhGSO63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940866121F;
        Mon, 19 Jul 2021 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708965;
        bh=xvrPnt3oh4IiGi8A6X9ogL7z4HopxPWHmJHDk2Mr23s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcHYnddYKvO6u5cvjuF9zAa85WCyY8sF1w37c2Co1RAGNaPd/5NJxtO/yv9br7WI0
         GEvbapUK3phe5TjiIYFwmPl4OUJQV7HvTXHzoHp/JR3Qfwk0NtYn5VDqHV6Iimqfxq
         QIVlMrFJz7qBF7qoZ+S+vvH0rM2VcF28rsFuHF5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/421] iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:11 +0200
Message-Id: <20210719144953.316215281@linuxfoundation.org>
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

[ Upstream commit 6a6be221b8bd561b053f0701ec752a5ed9007f69 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.
Add a comment on why the buffer is the size it is as not immediately
obvious.

Found during an audit of all calls of this function.

Fixes: 6dd112b9f85e ("iio: adc: mxs-lradc: Add support for ADC driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andreas Klinger <ak@it-klinger.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-4-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mxs-lradc-adc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mxs-lradc-adc.c b/drivers/iio/adc/mxs-lradc-adc.c
index c627513d9f0f..fc8b70d8d64c 100644
--- a/drivers/iio/adc/mxs-lradc-adc.c
+++ b/drivers/iio/adc/mxs-lradc-adc.c
@@ -124,7 +124,8 @@ struct mxs_lradc_adc {
 	struct device		*dev;
 
 	void __iomem		*base;
-	u32			buffer[10];
+	/* Maximum of 8 channels + 8 byte ts */
+	u32			buffer[10] __aligned(8);
 	struct iio_trigger	*trig;
 	struct completion	completion;
 	spinlock_t		lock;
-- 
2.30.2



