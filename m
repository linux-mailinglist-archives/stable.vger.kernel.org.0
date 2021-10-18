Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874C3431E0C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhJRN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhJRNzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53A861357;
        Mon, 18 Oct 2021 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564401;
        bh=724jwHlAmbEEgNUE8PVb4/7KjMta1oNOQusosNNzaBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2vyx8MFApehnKKIvxSFYaZ88l6SuxodwcDkqz2521r/XKPOC9S6O50C3fb6OzdxD
         MBbLBWsEvM8Fd0svsgKEn/Yql8vJK4D2kekTsxr86IERrFfRmha7LetucU8bLol3/f
         hxJdK7bgSwbnt8YdiDHivShTyvE8mtAqmVpYB0QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 068/151] iio: adc: ad7192: Add IRQ flag
Date:   Mon, 18 Oct 2021 15:24:07 +0200
Message-Id: <20211018132342.901849295@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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


