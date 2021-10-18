Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865D5431E2B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhJRN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234481AbhJRN4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89A761A2E;
        Mon, 18 Oct 2021 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564430;
        bh=arOuavtSGezhyOzRSIbU4OJWoNzqOS8N+i+b0aA6J/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsMDlrj6gJL15A4PyxK8GovWDlwq9mIJnwOM1Es0VtndZE9Ng8ParrZmkUy2PEfwg
         B+gC8VA+tK9WJLpnlAWl7R0Zos+pN5ZSb2g51kU58oH9+fPe7in0JLRhNTbF4qgQVT
         wz2D2wi1zZ8GObPtdGPh/lOtShI+gmAjzEa4dZmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 069/151] iio: adc: ad7780: Fix IRQ flag
Date:   Mon, 18 Oct 2021 15:24:08 +0200
Message-Id: <20211018132342.933028240@linuxfoundation.org>
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

commit e081102f3077aa716974ccebec97003c890d5641 upstream.

Correct IRQ flag here is falling.

In Sigma-Delta devices the SDO line is also used as an interrupt.
Leaving IRQ on level instead of falling might trigger a sample read
when the IRQ is enabled, as the SDO line is already low. Not sure
if SDO line will always immediately go high in ad_sd_buffer_postenable
before the IRQ is enabled.

Also the datasheet seem to explicitly say the falling edge of the SDO
should be used as an interrupt:
>From the AD7780 datasheet: " The DOUT/Figure 22 RDY falling edge
can be used as an interrupt to a processor"

Fixes: da4d3d6bb9f6 ("iio: adc: ad-sigma-delta: Allow custom IRQ flags")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210906065630.16325-3-alexandru.tachici@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -203,7 +203,7 @@ static const struct ad_sigma_delta_info
 	.set_mode = ad7780_set_mode,
 	.postprocess_sample = ad7780_postprocess_sample,
 	.has_registers = false,
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 #define _AD7780_CHANNEL(_bits, _wordsize, _mask_all)		\


