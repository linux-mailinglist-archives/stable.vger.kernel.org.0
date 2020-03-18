Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC03F189937
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCRKYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYV (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852AB20775;
        Wed, 18 Mar 2020 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527061;
        bh=eqHeqNl1HlFbd5mde/1Q+XVsbLWNlDLg3v6tB7z+M5g=;
        h=Subject:To:From:Date:From;
        b=onN4ZCg4mdlIIovawZZsUdG/lPfnCX6LMPeDNoLTlxi33enw1QX5iQAyQDkyuTkdu
         5LqH8GCfUHZpAIw/8McAklKXvrGGFEe+GwyFsM8hsedSr9SSmLzmMEY+IzRDQu4DgA
         mawTeS+JXZxySJU6n5+IgNx9WBJf164MTZjUzV4o=
Subject: patch "iio: adc: at91-sama5d2_adc: fix differential channels in triggered" added to staging-linus
To:     eugen.hristev@microchip.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:18 +0100
Message-ID: <1584527058101181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: at91-sama5d2_adc: fix differential channels in triggered

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a500f3bd787f8224341e44b238f318c407b10897 Mon Sep 17 00:00:00 2001
From: Eugen Hristev <eugen.hristev@microchip.com>
Date: Tue, 28 Jan 2020 12:57:39 +0000
Subject: iio: adc: at91-sama5d2_adc: fix differential channels in triggered
 mode

The differential channels require writing the channel offset register (COR).
Otherwise they do not work in differential mode.
The configuration of COR is missing in triggered mode.

Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index a5c7771227d5..9d96f7d08b95 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -723,6 +723,7 @@ static int at91_adc_configure_trigger(struct iio_trigger *trig, bool state)
 
 	for_each_set_bit(bit, indio->active_scan_mask, indio->num_channels) {
 		struct iio_chan_spec const *chan = at91_adc_chan_get(indio, bit);
+		u32 cor;
 
 		if (!chan)
 			continue;
@@ -731,6 +732,20 @@ static int at91_adc_configure_trigger(struct iio_trigger *trig, bool state)
 		    chan->type == IIO_PRESSURE)
 			continue;
 
+		if (state) {
+			cor = at91_adc_readl(st, AT91_SAMA5D2_COR);
+
+			if (chan->differential)
+				cor |= (BIT(chan->channel) |
+					BIT(chan->channel2)) <<
+					AT91_SAMA5D2_COR_DIFF_OFFSET;
+			else
+				cor &= ~(BIT(chan->channel) <<
+				       AT91_SAMA5D2_COR_DIFF_OFFSET);
+
+			at91_adc_writel(st, AT91_SAMA5D2_COR, cor);
+		}
+
 		if (state) {
 			at91_adc_writel(st, AT91_SAMA5D2_CHER,
 					BIT(chan->channel));
-- 
2.25.1


