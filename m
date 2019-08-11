Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9534789210
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfHKOxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 10:53:53 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40969 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfHKOxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 10:53:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 67831377;
        Sun, 11 Aug 2019 10:53:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 11 Aug 2019 10:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eCns1B
        LDJJj/JrAnxoh252Sq9kRE3uVDQ07jDUx9MQU=; b=KAY6Mb/NB4+1wZr1nNdmc9
        xQ4KDSZHmorlxqVYNQqrf7AzPgHVWU83X5eYPNZ3gGi1aIlyYZA34uJ8iBqJOg6W
        9/uBW/ZNFcFU3wlMJWxdI5CsG/DlBeZpzWAwqtX6C0xk+6mNbSH5yX2+HdW026mo
        DMZYwqYoflDVVL/gki10wXQZKtrcTy1LWve1y2g92MmYPw1Xa34rASf8C6zP6WbM
        Cv6cWDmAx9vsw0cxiaaKL5EO4R3/c2OJsLr3yz0MvIzMCIpCeLTuVIWzMyx/vLRY
        xxlx4ujYwPUwytRKMd/9OtdKcei12VNcF0cr9SE3nSaw20IFHjFZEq+1/M/tMC+w
        ==
X-ME-Sender: <xms:_CtQXZW6EsM2suLxBpyLFiardbCXJr0rBYTSjxdGJrAHQriG6n2h8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvvddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_CtQXY3w83g6O0lVgzSjY5axr2U2jzy0YyZcoM1q6Y6I0EcfKz3XsQ>
    <xmx:_CtQXRmvWPAGkY1R7AZ20Mx8qhGTqAsV1hE0knmKwMlZBVfqdIurKg>
    <xmx:_CtQXXE8ELibWeRQgjxbKxDZ-xl3ZztmQAk5QZH3VsQx6wu68mUT-g>
    <xmx:_itQXahiPfGyzuEihLbKjdhfgLswPrNFcDUyBV19nhiqo1kL8jq-kQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BF1E380074;
        Sun, 11 Aug 2019 10:53:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: gyroadc: fix uninitialized return code" failed to apply to 4.19-stable tree
To:     arnd@arndb.de, Jonathan.Cameron@huawei.com,
        wsa+renesas@sang-engineering.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Aug 2019 16:53:46 +0200
Message-ID: <156553522611126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90c6260c1905a68fb596844087f2223bd4657fee Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 18 Jul 2019 15:57:49 +0200
Subject: [PATCH] iio: adc: gyroadc: fix uninitialized return code

gcc-9 complains about a blatant uninitialized variable use that
all earlier compiler versions missed:

drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Return -EINVAL instead here and a few lines above it where
we accidentally return 0 on failure.

Cc: stable@vger.kernel.org
Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index 2d685730f867..c37f201294b2 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -382,7 +382,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Only %i channels supported with %pOFn, but reg = <%i>.\n",
 					num_channels, child, reg);
-				return ret;
+				return -EINVAL;
 			}
 		}
 
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return ret;
+			return -EINVAL;
 		}
 
 		/* Channel is valid, grab the regulator. */

