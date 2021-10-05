Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16D2422227
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhJEJXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhJEJXg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2269561108;
        Tue,  5 Oct 2021 09:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425706;
        bh=4qNzUV7Cw8/rERBNuI3PNvHdY7MfCANPCExNymYIHa0=;
        h=Subject:To:From:Date:From;
        b=XUEZfj/rVn0LNtHAfbHBWvMcCu6mw261M4clQ5Bo8YeLeuIxvppCHVnUwBrXY8qbG
         wFg9HOBsoTpd9y/DFdKn67esrs1M5XRrd08xtGeoxtFN8GonEzmlQsMWjfs2ePlTH+
         +f7DeZDhPvWK9E6nSIEaJRkc44h5foj94D4zS2aA=
Subject: patch "iio: adc: ad7793: Fix IRQ flag" added to staging-linus
To:     alexandru.tachici@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:24 +0200
Message-ID: <163342568420671@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7793: Fix IRQ flag

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1a913270e57a8e7f1e3789802f1f64e6d0654626 Mon Sep 17 00:00:00 2001
From: Alexandru Tachici <alexandru.tachici@analog.com>
Date: Mon, 6 Sep 2021 09:56:30 +0300
Subject: iio: adc: ad7793: Fix IRQ flag

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
---
 drivers/iio/adc/ad7793.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7793.c b/drivers/iio/adc/ad7793.c
index ef3e2d3ecb0c..0e7ab3fb072a 100644
--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -206,7 +206,7 @@ static const struct ad_sigma_delta_info ad7793_sigma_delta_info = {
 	.has_registers = true,
 	.addr_shift = 3,
 	.read_mask = BIT(6),
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static const struct ad_sd_calib_data ad7793_calib_arr[6] = {
-- 
2.33.0


