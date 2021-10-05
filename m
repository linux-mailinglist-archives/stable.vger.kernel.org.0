Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19AC422220
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhJEJXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233545AbhJEJXa (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CC4610C9;
        Tue,  5 Oct 2021 09:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425700;
        bh=7swB6iR25V2j3TJ9PIxQelTQxWPbjoFo3ZVB6DnZWuc=;
        h=Subject:To:From:Date:From;
        b=sn2bKvl1PietLnoE4IBupnobpkZe5QnfbtMJoZPgQSOJ71pMaDViW6qo2hTBRRxZb
         OhgnZj/eOAwBSvkcnX/QBL+WT7S5GLMWrAslz0M0mvM/b5QD7obpRJZjxOvv5zJft2
         jASIwSYttpxL6Mr3TwVUGD81V/IL81tyKtDHiUAU=
Subject: patch "iio: adc: ad7780: Fix IRQ flag" added to staging-linus
To:     alexandru.tachici@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:23 +0200
Message-ID: <163342568362141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7780: Fix IRQ flag

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e081102f3077aa716974ccebec97003c890d5641 Mon Sep 17 00:00:00 2001
From: Alexandru Tachici <alexandru.tachici@analog.com>
Date: Mon, 6 Sep 2021 09:56:29 +0300
Subject: iio: adc: ad7780: Fix IRQ flag

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
---
 drivers/iio/adc/ad7780.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7780.c b/drivers/iio/adc/ad7780.c
index 42bb952f4738..b6e8c8abf6f4 100644
--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -203,7 +203,7 @@ static const struct ad_sigma_delta_info ad7780_sigma_delta_info = {
 	.set_mode = ad7780_set_mode,
 	.postprocess_sample = ad7780_postprocess_sample,
 	.has_registers = false,
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 #define _AD7780_CHANNEL(_bits, _wordsize, _mask_all)		\
-- 
2.33.0


