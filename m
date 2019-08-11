Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DD989211
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHKOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 10:53:57 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40019 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726453AbfHKOx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 10:53:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EE30F381;
        Sun, 11 Aug 2019 10:53:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 11 Aug 2019 10:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VPQE2u
        kLl6CXksKrH0s3ygW3FvPyBtekUgjQ73F0kQE=; b=bLjrOAUYDsQEeYFOguWUx4
        bT8JbQAov8uiR6js7rBxfQaoNIrtuC7gDxJznWUorXlKjjTADvbfm6sVE3Iq+gRQ
        QtqITCL0q12ggwAXkzCvXcecl5B02VDWHzGTe/7WLxMuxNp+hA2a/20G0z3AkAgA
        awlX/M5xx6i2xu3Jn4Lxc2IBmugmUiPhc1NM5HHqzSy4doglMW11jJOLz5pfKa2r
        yZb0eleG8UnTk3Us9KgmEVVU+0zsN0l5eFaNT06glSWlzsYO4uN/OmKta9duiohp
        xqStEKGJBzRyK38IewYDN0GhCJJNTw7eqGTnCepRrdS5RqsA9YXQAVMv09jxI8uA
        ==
X-ME-Sender: <xms:BCxQXUOXsT9SUV3Ar6zL5NyNNLl55_WlNJ7NTnyd3Z0r-FvfNIvApQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvvddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:BCxQXd370iZK9xyyknDGl7XdObsX19-EXCMaubeaCusRK4uLSMTvqw>
    <xmx:BCxQXcFqTc2yoCViwSj2B_VQJN75MNtKvChDYQuMknhdLRh7Vztx2g>
    <xmx:BCxQXeiviPFgd74S4xvbPVB4-LftjlNd1QCzhT25_Joj-Xy1JJ8ZUQ>
    <xmx:BCxQXUQCA-EOl5bD6KXmr9ze_u1o0VbrEI4L6MFsyfSfL8rA9mBfKA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE41B380085;
        Sun, 11 Aug 2019 10:53:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: gyroadc: fix uninitialized return code" failed to apply to 4.14-stable tree
To:     arnd@arndb.de, Jonathan.Cameron@huawei.com,
        wsa+renesas@sang-engineering.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Aug 2019 16:53:46 +0200
Message-ID: <156553522637155@kroah.com>
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

