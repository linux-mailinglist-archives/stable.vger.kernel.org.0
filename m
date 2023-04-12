Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51F6DECE8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjDLHt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjDLHtW (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 12 Apr 2023 03:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617E86597
        for <Stable@vger.kernel.org>; Wed, 12 Apr 2023 00:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAA63616C2
        for <Stable@vger.kernel.org>; Wed, 12 Apr 2023 07:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6F1C433EF;
        Wed, 12 Apr 2023 07:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681285756;
        bh=wCiPRboT9YFE3wrwYA+mT8ouI9hoZPlPSX7MwyVtnMc=;
        h=Subject:To:From:Date:From;
        b=naeQmXUC/tZE+zzfVXV0xEwMOqu1K/IP+NzDMGfQqMa3+gJiDqV9yuzDc2g3f8rj1
         5tYl6dJksly0rl1X7KzX7snUI0AeOwM4xa9F0tX5TXDPrZQ/jNclO+G7sid8wYabGJ
         b7XMzyuTOFWeciJsD3ki3bHxyX5c/suvKdX8Dc3M=
Subject: patch "iio: addac: stx104: Fix race condition for stx104_write_raw()" added to char-misc-testing
To:     william.gray@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Apr 2023 09:47:38 +0200
Message-ID: <2023041238-engraved-pursuant-8b45@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: addac: stx104: Fix race condition for stx104_write_raw()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9740827468cea80c42db29e7171a50e99acf7328 Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <william.gray@linaro.org>
Date: Thu, 6 Apr 2023 10:40:10 -0400
Subject: iio: addac: stx104: Fix race condition for stx104_write_raw()

The priv->chan_out_states array and actual DAC value can become
mismatched if stx104_write_raw() is called concurrently. Prevent such a
race condition by utilizing a mutex.

Fixes: 97a445dad37a ("iio: Add IIO support for the DAC on the Apex Embedded Systems STX104")
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/c95c9a77fcef36b2a052282146950f23bbc1ebdc.1680790580.git.william.gray@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/addac/stx104.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/addac/stx104.c b/drivers/iio/addac/stx104.c
index e45b70aa5bb7..4239aafe42fc 100644
--- a/drivers/iio/addac/stx104.c
+++ b/drivers/iio/addac/stx104.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
@@ -69,10 +70,12 @@ struct stx104_reg {
 
 /**
  * struct stx104_iio - IIO device private data structure
+ * @lock: synchronization lock to prevent I/O race conditions
  * @chan_out_states:	channels' output states
  * @reg:		I/O address offset for the device registers
  */
 struct stx104_iio {
+	struct mutex lock;
 	unsigned int chan_out_states[STX104_NUM_OUT_CHAN];
 	struct stx104_reg __iomem *reg;
 };
@@ -178,9 +181,12 @@ static int stx104_write_raw(struct iio_dev *indio_dev,
 			if ((unsigned int)val > 65535)
 				return -EINVAL;
 
+			mutex_lock(&priv->lock);
+
 			priv->chan_out_states[chan->channel] = val;
 			iowrite16(val, &priv->reg->dac[chan->channel]);
 
+			mutex_unlock(&priv->lock);
 			return 0;
 		}
 		return -EINVAL;
@@ -351,6 +357,8 @@ static int stx104_probe(struct device *dev, unsigned int id)
 
 	indio_dev->name = dev_name(dev);
 
+	mutex_init(&priv->lock);
+
 	/* configure device for software trigger operation */
 	iowrite8(0, &priv->reg->acr);
 
-- 
2.40.0


