Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D07190E92
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCXNNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgCXNNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C687208CA;
        Tue, 24 Mar 2020 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055591;
        bh=azruGpgbX4jKYBM0MnFTfpjG8pACRmPSnXbxvFF/byM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ8b7U/9x9uN0Wx8M3XmX5dPAA6oICue5FbHPcibOBOQpww5G+TqTouBiyiJQv+ma
         MrJlGZZCnxWQb5VnyvaXoS6DK3aWrPNcNvVGHnhJEqy9KEBcvXlKtm4J7cWKfOV5ua
         wfOSuxgLZbhBCPl3dRehXCmW369KyEKpM5l9WgvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 34/65] iio: adc: at91-sama5d2_adc: fix differential channels in triggered mode
Date:   Tue, 24 Mar 2020 14:10:55 +0100
Message-Id: <20200324130801.515328876@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit a500f3bd787f8224341e44b238f318c407b10897 upstream.

The differential channels require writing the channel offset register (COR).
Otherwise they do not work in differential mode.
The configuration of COR is missing in triggered mode.

Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/at91-sama5d2_adc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -731,6 +731,7 @@ static int at91_adc_configure_trigger(st
 
 	for_each_set_bit(bit, indio->active_scan_mask, indio->num_channels) {
 		struct iio_chan_spec const *chan = at91_adc_chan_get(indio, bit);
+		u32 cor;
 
 		if (!chan)
 			continue;
@@ -740,6 +741,20 @@ static int at91_adc_configure_trigger(st
 			continue;
 
 		if (state) {
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
+		if (state) {
 			at91_adc_writel(st, AT91_SAMA5D2_CHER,
 					BIT(chan->channel));
 			/* enable irq only if not using DMA */


