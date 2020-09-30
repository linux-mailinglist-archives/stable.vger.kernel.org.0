Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6243427E3E6
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgI3IhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 04:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3IhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 04:37:13 -0400
Received: from mail-wm1-x363.google.com (mail-wm1-x363.google.com [IPv6:2a00:1450:4864:20::363])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD7CC061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 01:37:13 -0700 (PDT)
Received: by mail-wm1-x363.google.com with SMTP id a9so782990wmm.2
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 01:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=umCDvoHS92WYFRuwfVxZMNhfWaiHknS4wbUC7gryG04=;
        b=UnmVqInnkaIedrnmIPkE3QV6FeOhxdSjDbkePDyLRzfUyZCDG1+6b2Vq5YV+dPQ3Zg
         83rICFA1CLGhiTCzGhceNh9uHrcdfw3zbRgv587hL6LtebVwX2v8fSjNTy7fAKGqAzG9
         FY0vmojfLITQc6+byDY+UGkgCVTlYM5+qL7zPHU0Zf38g4yX1Cbz5EwAqMLxb6ZUq0pl
         tXQQRSjg0BzdbMi5Ocrb+G0QSNh1SR1F/SY3WrfGCvGQ3XNmygsf76Tnq5740PuRTQM9
         6/1jWdkt14KboXqNQamKpra/5UnyFK13T5M4X0+724YfRdEsnIRYYIgKGM3kNmcxF0ng
         fezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=umCDvoHS92WYFRuwfVxZMNhfWaiHknS4wbUC7gryG04=;
        b=L7iS4FEzqAkxCUdpO0A9feYxAyJRfCJa1l6QEyAA53qdoujNj1MSY/F6qwYVB9sc6m
         0O0+pTzYnIp322G1hZgr0FsnYgwTYnyqP/qPhIeIcuHPQ8Lb9Osiy+3K09dQ+fKga6Kt
         2Nm4OfY+iaNnSMZkl2NWALd1LgyYHjSwBGSXL2RUKZHFBTcpN74oSNDGfl1iKCt5RkBL
         e7sI7+Qh0Urr5I6bpH+qLZQ7u25J9nqiHU4s3pMc6PAoL+LtaHfH1Aa6BUCht+gCRuSa
         hX+goL7hPIEyqBAsKrRC7d67ewWkP4uLi8e99gjcOcjLmIHEDihaijmZlbTnacrVhQIn
         rzAw==
X-Gm-Message-State: AOAM532S7UOFl+VEWA4sALgKLrKochH6efcy7Khry9irVlE/MYS0/Rm6
        SS1s8MLGa2hAf1yS65/QL+/L0PjilGw7OEtVPG1yQwJM+qSR
X-Google-Smtp-Source: ABdhPJys3IhSkM2Rv8Biqm47gfDDqB/yJ5bLf77N891hmn24e2/nLFDTU2zvT5DIvWoQ3vaYQPOHD2crF8uq
X-Received: by 2002:a1c:dd87:: with SMTP id u129mr1718447wmg.172.1601455031053;
        Wed, 30 Sep 2020 01:37:11 -0700 (PDT)
Received: from mta1.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id m7sm25035wrn.45.2020.09.30.01.37.10
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 30 Sep 2020 01:37:11 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.12.34] (port=47850 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mta1.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1kNXbq-0003VN-LL; Wed, 30 Sep 2020 10:37:10 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Evgeniy Polyakov <zbr@ioremap.net>
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        stable <stable@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] w1: mxc_w1: Fix timeout resolution problem leading to bus error
Date:   Wed, 30 Sep 2020 10:36:46 +0200
Message-Id: <1601455030-6607-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/w1/masters/mxc_w1.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1ca880e..090cbbf 100644
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
1.9.1

