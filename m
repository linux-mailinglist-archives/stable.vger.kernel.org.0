Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7231422221
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhJEJXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhJEJXc (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C741F61108;
        Tue,  5 Oct 2021 09:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425702;
        bh=8EPDW2dSPd0JpWAiea+oqz8GnpRj939KEOS5+oynvbk=;
        h=Subject:To:From:Date:From;
        b=kWHKtg8nbZDis/5kjHwkFCPlbzG6+e2brKFW+3hlfW+NK27mKwGQjtMg6crcgdTfh
         bhXmkxDIY+DgnqBY/tcCJvVpfsW6b4V0igrhZ6r/FhsikKuDiCGZdf3K2RSLyJUpgw
         lfgqQ2oyAxzw90khQ1DpkIxNhh3GvdoScOH56GLA=
Subject: patch "iio: adc: ad7192: Add IRQ flag" added to staging-linus
To:     alexandru.tachici@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:23 +0200
Message-ID: <163342568311332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7192: Add IRQ flag

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 89a86da5cb8e0ee153111fb68a719d31582c206b Mon Sep 17 00:00:00 2001
From: Alexandru Tachici <alexandru.tachici@analog.com>
Date: Mon, 6 Sep 2021 09:56:28 +0300
Subject: iio: adc: ad7192: Add IRQ flag

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
---
 drivers/iio/adc/ad7192.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index ee8ed9481025..2121a812b0c3 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -293,6 +293,7 @@ static const struct ad_sigma_delta_info ad7192_sigma_delta_info = {
 	.has_registers = true,
 	.addr_shift = 3,
 	.read_mask = BIT(6),
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static const struct ad_sd_calib_data ad7192_calib_arr[8] = {
-- 
2.33.0


