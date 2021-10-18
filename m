Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA6431D1C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhJRNsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhJRNqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:46:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F28615E0;
        Mon, 18 Oct 2021 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564151;
        bh=724jwHlAmbEEgNUE8PVb4/7KjMta1oNOQusosNNzaBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qeknaoh2x7LMcv9bgDIZh5CJ9XGlhnpxskg7UZFHhf4To6oMV/vOtCDNqihPtoZtr
         gJxQoiyedWWbQ1sbdduu4dPcYDz/ixvEbiTcXcQf/buVglJy5jv1amGSCz2e+gY8mk
         I4N0LYFcQ/+gjMrl5zPPwTI5rXUia7d8n+Q56KQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 051/103] iio: adc: ad7192: Add IRQ flag
Date:   Mon, 18 Oct 2021 15:24:27 +0200
Message-Id: <20211018132336.474311511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

commit 89a86da5cb8e0ee153111fb68a719d31582c206b upstream.

IRQ type in ad_sigma_delta_info struct was missing.

In Sigma-Delta devices the SDO line is also used as an interrupt.
Leaving IRQ on level instead of falling might trigger a sample read
when the IRQ is enabled, as the SDO line is already low. Not sure
if SDO line will always immediately go high in ad_sd_buffer_postenable
before the IRQ is enabled.

Also the datasheet seem to explicitly say the falling edge of the SDO
should be used as an interrupt:
>From the AD7192 datasheet: "The DOUT/RDY falling edge can be used
as an interrupt to a processor,"

Fixes: da4d3d6bb9f6 ("iio: adc: ad-sigma-delta: Allow custom IRQ flags")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210906065630.16325-2-alexandru.tachici@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -293,6 +293,7 @@ static const struct ad_sigma_delta_info
 	.has_registers = true,
 	.addr_shift = 3,
 	.read_mask = BIT(6),
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static const struct ad_sd_calib_data ad7192_calib_arr[8] = {


