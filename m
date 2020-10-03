Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291D92823B2
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 12:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCKya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 06:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgJCKy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Oct 2020 06:54:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9E5206C3;
        Sat,  3 Oct 2020 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601722469;
        bh=L1g//ZMJNynLlDvEIZWsvs8FPBKM3iivnOv568gIqLU=;
        h=Subject:To:From:Date:From;
        b=zHpUe8UQcniDGUOo1jebY7UdKxqtPfB7bRjDsHbzjEZrsILWbESRMn4UKpf4lU3OB
         XnGasiY61dy+p/68fJxo/qO2BnPUl+PPQC7QaWwh0YCyHUXexCeE4SoZuQmKI2eioJ
         ChBtXw8JaQNGnUS7mbOznYIIiOfCCObiOrmfDBeA=
Subject: patch "w1: mxc_w1: Fix timeout resolution problem leading to bus error" added to char-misc-next
To:     martin.fuzzey@flowbird.group, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Oct 2020 12:54:26 +0200
Message-ID: <160172246675243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    w1: mxc_w1: Fix timeout resolution problem leading to bus error

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c9723750a699c3bd465493ac2be8992b72ccb105 Mon Sep 17 00:00:00 2001
From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Wed, 30 Sep 2020 10:36:46 +0200
Subject: w1: mxc_w1: Fix timeout resolution problem leading to bus error

On my platform (i.MX53) bus access sometimes fails with
	w1_search: max_slave_count 64 reached, will continue next search.

The reason is the use of jiffies to implement a 200us timeout in
mxc_w1_ds2_touch_bit().
On some platforms the jiffies timer resolution is insufficient for this.

Fix by replacing jiffies by ktime_get().

For consistency apply the same change to the other use of jiffies in
mxc_w1_ds2_reset_bus().

Fixes: f80b2581a706 ("w1: mxc_w1: Optimize mxc_w1_ds2_touch_bit()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Link: https://lore.kernel.org/r/1601455030-6607-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/masters/mxc_w1.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1ca880e01476..090cbbf9e1e2 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -7,7 +7,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
@@ -40,12 +40,12 @@ struct mxc_w1_device {
 static u8 mxc_w1_ds2_reset_bus(void *data)
 {
 	struct mxc_w1_device *dev = data;
-	unsigned long timeout;
+	ktime_t timeout;
 
 	writeb(MXC_W1_CONTROL_RPP, dev->regs + MXC_W1_CONTROL);
 
 	/* Wait for reset sequence 511+512us, use 1500us for sure */
-	timeout = jiffies + usecs_to_jiffies(1500);
+	timeout = ktime_add_us(ktime_get(), 1500);
 
 	udelay(511 + 512);
 
@@ -55,7 +55,7 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 		/* PST bit is valid after the RPP bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_RPP))
 			return !(ctrl & MXC_W1_CONTROL_PST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 1;
 }
@@ -68,12 +68,12 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
 	struct mxc_w1_device *dev = data;
-	unsigned long timeout;
+	ktime_t timeout;
 
 	writeb(MXC_W1_CONTROL_WR(bit), dev->regs + MXC_W1_CONTROL);
 
 	/* Wait for read/write bit (60us, Max 120us), use 200us for sure */
-	timeout = jiffies + usecs_to_jiffies(200);
+	timeout = ktime_add_us(ktime_get(), 200);
 
 	udelay(60);
 
@@ -83,7 +83,7 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 		/* RDST bit is valid after the WR1/RD bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_WR(bit)))
 			return !!(ctrl & MXC_W1_CONTROL_RDST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 0;
 }
-- 
2.28.0


