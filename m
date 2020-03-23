Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9718F6A9
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCWORu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:17:50 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50501 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728359AbgCWORu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 23 Mar 2020 10:17:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 764FF4F7;
        Mon, 23 Mar 2020 10:17:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nAKw5D
        Xeket/iWyfHeULInNfgLW3Jbdhtq/qZgHwj9Y=; b=MqL7FxXdI6V/ZUUSvu7wIl
        wM8KjnYfuwDjkCkEgf6VtQalG5eVkGL97Skv9QQQpxPCWwVPoZxkfmdm5yJnDiz+
        yvZE5Sro4EE8cyY/2nuFijV4RNm6y1/gWZ/q/qlWfvLBShuxR5jije+2uWkFG/3T
        klINIAmg/n8AVmAQlJu9O/NEz/B3U/LU3QCvhoHPvfm0U4j8RP+gDF693YCyDR/7
        Hw58wfQX6MwIHROvMFEWnWEVTJMQ+TrNOwoEKkpineLrl6awiS1cTwNWcp5I0um+
        4I3OWJnuPD999cmR/VSkiOV2vHSv+w2WCQcImPlNWWioothGpmWCXo7epC9PRc2g
        ==
X-ME-Sender: <xms:DMV4XgP7HodEZ4Sn6OEOIYyvlW8_amYiM1GwMo2ocABNk6qrm09HTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DMV4XsbXJDL92AoVwJYoNPHbu2YIT4RyyDLW91t1dpxxJjv6sBH0zg>
    <xmx:DMV4XgZdJH-Zy4jtXPamX0_YZjTu1O88YVcCKYrU9QPlMTdixWK0HQ>
    <xmx:DMV4Xj04B8x32jPPu9RNU0k2_jTp7A1zwZ0tWjwQCgzQfXS-ExYrTg>
    <xmx:DcV4XhhsF7_mLOUPOLhozdMyT9YIiuvurq6EhcJ_yqgUHnzVpvmHOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 169B53061856;
        Mon, 23 Mar 2020 10:17:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: at91-sama5d2_adc: fix differential channels in" failed to apply to 4.14-stable tree
To:     eugen.hristev@microchip.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:17:46 +0100
Message-ID: <1584973066113204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a500f3bd787f8224341e44b238f318c407b10897 Mon Sep 17 00:00:00 2001
From: Eugen Hristev <eugen.hristev@microchip.com>
Date: Tue, 28 Jan 2020 12:57:39 +0000
Subject: [PATCH] iio: adc: at91-sama5d2_adc: fix differential channels in
 triggered mode

The differential channels require writing the channel offset register (COR).
Otherwise they do not work in differential mode.
The configuration of COR is missing in triggered mode.

Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

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

