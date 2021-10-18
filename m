Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D591C431E3F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhJRN73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234116AbhJRN5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E4A61A52;
        Mon, 18 Oct 2021 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564460;
        bh=J5hh4JfP+qOe5Gp7tcBGciG7iJE8Fdu59ov/wmhnTaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwYP4SU5HWrg8qI7LzkRzePWCYRxo27QCjsw5Ifqr/SdKf4W3MfL3fMzE+aK0qnEV
         yXfivNS1Zd5lYIqaoy4yv7jEJ8nISZWXsRkGdlqPFfCV6YYnsZUb4uFlwcQtXw4GQZ
         zjK45bLytqrXUkQSfzTarxHhbqIKl/W12KTgjphM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 070/151] iio: adc: ad7793: Fix IRQ flag
Date:   Mon, 18 Oct 2021 15:24:09 +0200
Message-Id: <20211018132342.965244028@linuxfoundation.org>
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

commit 1a913270e57a8e7f1e3789802f1f64e6d0654626 upstream.

In Sigma-Delta devices the SDO line is also used as an interrupt.
Leaving IRQ on level instead of falling might trigger a sample read
when the IRQ is enabled, as the SDO line is already low. Not sure
if SDO line will always immediately go high in ad_sd_buffer_postenable
before the IRQ is enabled.

Also the datasheet seem to explicitly say the falling edge of the SDO
should be used as an interrupt:
>From the AD7793 datasheet: " The DOUT/RDY falling edge can be
used as an interrupt to a processor"

Fixes: da4d3d6bb9f6 ("iio: adc: ad-sigma-delta: Allow custom IRQ flags")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210906065630.16325-4-alexandru.tachici@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7793.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -206,7 +206,7 @@ static const struct ad_sigma_delta_info
 	.has_registers = true,
 	.addr_shift = 3,
 	.read_mask = BIT(6),
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static const struct ad_sd_calib_data ad7793_calib_arr[6] = {


