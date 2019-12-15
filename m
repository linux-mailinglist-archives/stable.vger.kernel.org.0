Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B809D11F704
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfLOJbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:31:18 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54193 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfLOJbS (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 15 Dec 2019 04:31:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DC0126AA;
        Sun, 15 Dec 2019 04:31:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3zAJLT
        wQGZKMIBylsy4PaaYzemwhoEDPyF5TcyyzXOU=; b=HL4Ip85OJbfMuOCLGm48CC
        +/FwaYwlIrVGHVsdWXKSWxc0Jm+oeGR4zAzVrsfZo+6RpnycVsrlVaLpTv1Qk9Rx
        yPBVa62FdY1CN1cOr2Wc0aDyjTO+LEU85BEhNP9ZKDzBhuXNuGrVbiBw/01zfMPL
        tUjaBWpSt+NU/WQ8JgPpgohhftBmwSVFOQnvK3pz9IIf+pDHIJsVJhhVSKuvG7PK
        EWtt9rdKewxMfmfGsCkPiJPgR/JQGrVWqVGF2ZylfYXN//0TUsvYFcJdkztUVLee
        sPXfN5Ap++vdVnw1H3sE9KMUFrpsQtAvSp8pj07iyIBvLq91JVjGKnzVf9Hf2dOw
        ==
X-ME-Sender: <xms:ZP31Xa_OY0qGq3OT8M-6s1LE4SBconv71by7JkVgJbNKtr2rSgCA5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:ZP31XQ0XV0Ef4X4-tUIvNZ78u3Kig2uAXuwfNpsdxaKu647dac70hA>
    <xmx:ZP31XcwtFHxlE3jYODUUc4R_eZR_9Kfxjk7LSwdYiM8nHaLL0OiSWA>
    <xmx:ZP31XYVtV4Ubf8dEQhGJISZzE7ku_Gh8CzYi6N36tzM4HnaGXPBEOQ>
    <xmx:ZP31Xb1g4JCPr1GrpZwXMkqESDowpjPp6--6nKI1n0d1pzhq6JhaWA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F408F30600DC;
        Sun, 15 Dec 2019 04:31:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: ad7949: fix channels mixups" failed to apply to 5.4-stable tree
To:     andrea.merello@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, charles-antoine.couret@essensium.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:31:14 +0100
Message-ID: <157640227474124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b71f6b59508b1c9befcb43de434866aafc76520 Mon Sep 17 00:00:00 2001
From: Andrea Merello <andrea.merello@gmail.com>
Date: Mon, 2 Dec 2019 15:13:36 +0100
Subject: [PATCH] iio: ad7949: fix channels mixups

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

diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
index 5c2b3446fa4a..2c6f60edb7ce 100644
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

