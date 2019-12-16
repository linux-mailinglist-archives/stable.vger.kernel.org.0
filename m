Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA312158B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbfLPSUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbfLPSUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BCB206EC;
        Mon, 16 Dec 2019 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520450;
        bh=LE/ojb96WAFFLYu4wiJQJxjpbgtNDSnCSubFzAS8OmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohtGMv5A6MxsQXmIrNfJdiwnby3Y0nMUj3M4DhauX0nmifO902y0oQjctmuThTJzP
         R8MfyFK09i03HAJgUi5OKV9uFLsUOIhmoNWZmMdbb+gJsVvXN4KzkJPs9jI4sFdr0/
         vWXgeKVqotGmdT/pzUFxyGvO3wGb0XmZgK4oyT8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Merello <andrea.merello@gmail.com>,
        Charles-Antoine Couret <charles-antoine.couret@essensium.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/177] iio: ad7949: fix channels mixups
Date:   Mon, 16 Dec 2019 18:50:15 +0100
Message-Id: <20191216174848.954422354@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Merello <andrea.merello@gmail.com>

[ Upstream commit 3b71f6b59508b1c9befcb43de434866aafc76520 ]

Each time we need to read a sample (from the sysfs interface, since the
driver supports only it) the driver writes the configuration register
with the proper settings needed to perform the said read, then it runs
another xfer to actually read the resulting value. Most notably the
configuration register is updated to set the ADC internal MUX depending by
which channel the read targets.

Unfortunately this seems not enough to ensure correct operation because
the ADC works in a pipelined-like fashion and the new configuration isn't
applied in time.

The ADC alternates two phases: acquisition and conversion. During the
acquisition phase the ADC samples the analog signal in an internal
capacitor; in the conversion phase the ADC performs the actual analog to
digital conversion of the stored voltage. Note that of course the MUX
needs to be set to the proper channel when the acquisition phase is
performed.

Once the conversion phase has been completed, the device automatically
switches back to a new acquisition; on the other hand the device switches
from acquisition to conversion on the rising edge of SPI cs signal (that
is when the xfer finishes).

Only after both two phases have been completed (with the proper settings
already written in the configuration register since the beginning) it is
possible to read the outcome from SPI bus.

With the current driver implementation, we end up in the following
situation:

        _______  1st xfer ____________  2nd xfer ___________________
SPI cs..       \_________/            \_________/
SPI rd.. idle  |(val N-2)+    idle    | val N-1 +   idle ...
SPI wr.. idle  |  cfg N  +    idle    |   (X)   +   idle ...
------------------------ + -------------------- + ------------------
  AD  ..   acq  N-1      + cnv N-1 |  acq N     +  cnv N  | acq N+1

As shown in the diagram above, the value we read in the Nth read belongs
to configuration setting N-1.

In case the configuration is not changed (config[N] == config[N-1]), then
we still get correct data, but in case the configuration changes (i.e.
switching the MUX on another channel), we get wrong data (data from the
previously selected channel).

This patch fixes this by performing one more "dummy" transfer in order to
ending up in reading the data when it's really ready, as per the following
timing diagram.

        _______  1st xfer ____________  2nd xfer ___________  3rd xfer ___
SPI cs..       \_________/            \_________/           \_________/
SPI rd.. idle  |(val N-2)+    idle    |(val N-1)+    idle   |  val N  + ..
SPI wr.. idle  |  cfg N  +    idle    |   (X)   +    idle   |   (X)   + ..
------------------------ + -------------------- + ------------------- + --
  AD  ..   acq  N-1      + cnv N-1 |  acq N     +  cnv N  | acq N+1   | ..

NOTE: in the latter case (cfg changes), the acquisition phase for the
value to be read begins after the 1st xfer, that is after the read request
has been issued on sysfs. On the other hand, if the cfg doesn't change,
then we can refer to the fist diagram assuming N == (N - 1); the
acquisition phase _begins_ before the 1st xfer (potentially a lot of time
before the read has been issued via sysfs, but it _ends_ after the 1st
xfer, that is _after_ the read has started. This should guarantee a
reasonably fresh data, which value represents the voltage that the sampled
signal has after the read start or maybe just around it.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
Reviewed-by: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7949.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
index 518044c31a73b..6b51bfcad0d04 100644
--- a/drivers/iio/adc/ad7949.c
+++ b/drivers/iio/adc/ad7949.c
@@ -89,6 +89,7 @@ static int ad7949_spi_read_channel(struct ad7949_adc_chip *ad7949_adc, int *val,
 				   unsigned int channel)
 {
 	int ret;
+	int i;
 	int bits_per_word = ad7949_adc->resolution;
 	int mask = GENMASK(ad7949_adc->resolution, 0);
 	struct spi_message msg;
@@ -100,12 +101,23 @@ static int ad7949_spi_read_channel(struct ad7949_adc_chip *ad7949_adc, int *val,
 		},
 	};
 
-	ret = ad7949_spi_write_cfg(ad7949_adc,
-				   channel << AD7949_OFFSET_CHANNEL_SEL,
-				   AD7949_MASK_CHANNEL_SEL);
-	if (ret)
-		return ret;
+	/*
+	 * 1: write CFG for sample N and read old data (sample N-2)
+	 * 2: if CFG was not changed since sample N-1 then we'll get good data
+	 *    at the next xfer, so we bail out now, otherwise we write something
+	 *    and we read garbage (sample N-1 configuration).
+	 */
+	for (i = 0; i < 2; i++) {
+		ret = ad7949_spi_write_cfg(ad7949_adc,
+					   channel << AD7949_OFFSET_CHANNEL_SEL,
+					   AD7949_MASK_CHANNEL_SEL);
+		if (ret)
+			return ret;
+		if (channel == ad7949_adc->current_channel)
+			break;
+	}
 
+	/* 3: write something and read actual data */
 	ad7949_adc->buffer = 0;
 	spi_message_init_with_transfers(&msg, tx, 1);
 	ret = spi_sync(ad7949_adc->spi, &msg);
-- 
2.20.1



