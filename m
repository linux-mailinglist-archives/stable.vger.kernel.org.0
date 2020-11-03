Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15A72A550E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733224AbgKCVLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388361AbgKCVLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF54521534;
        Tue,  3 Nov 2020 21:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437877;
        bh=TG50nwkbsifVMv6k6jdz5GTFDBMqrGJndteAx42ttsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjFOdm1b/pVSy1Zhm0N7mRNVu6aNlU3i8za7aHJ/Hl2OE9SjEuTTrJG11BVCXdxSO
         9A324EfwRwBfV7kecUo7dHxYV2SUfj+GpLEGJ/QGjrt0RuNhO1aNRNsAmoYD/dQAuK
         orDE/mxsJYmbz9X0Kk+mad1PXZyxcUrZnCUZ8E9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: [PATCH 4.14 071/125] w1: mxc_w1: Fix timeout resolution problem leading to bus error
Date:   Tue,  3 Nov 2020 21:37:28 +0100
Message-Id: <20201103203207.265575603@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit c9723750a699c3bd465493ac2be8992b72ccb105 upstream.

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
 drivers/w1/masters/mxc_w1.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -15,7 +15,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
@@ -47,12 +47,12 @@ struct mxc_w1_device {
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
 
@@ -62,7 +62,7 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 		/* PST bit is valid after the RPP bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_RPP))
 			return !(ctrl & MXC_W1_CONTROL_PST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 1;
 }
@@ -75,12 +75,12 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
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
 
@@ -90,7 +90,7 @@ static u8 mxc_w1_ds2_touch_bit(void *dat
 		/* RDST bit is valid after the WR1/RD bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_WR(bit)))
 			return !!(ctrl & MXC_W1_CONTROL_RDST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 0;
 }


