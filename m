Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D10199168
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgCaJRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731263AbgCaJRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2462C208E0;
        Tue, 31 Mar 2020 09:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646241;
        bh=bZoCsEb7wD0uIXnpD9U+XVKOmILOUBspGxL7skoOLsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P89Eqxl2fdukausmtFKsn/UkQ+KcGV4oItSTuOSLqYzBVzmWPSDnlqihNyBoEwK2v
         4xsejXMdDZ8qibUstHdWnPG5KjhBLqaIsKLgoDCZpzl5rVlMQvfxpsiRkcCsIni/px
         09aNVWKP1V03HqNUlqaAIkO0MhhA+PNFg0GI2LTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Ajay Gupta <ajayg@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 127/155] i2c: nvidia-gpu: Handle timeout correctly in gpu_i2c_check_status()
Date:   Tue, 31 Mar 2020 10:59:27 +0200
Message-Id: <20200331085432.566364288@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit d944b27df121e2ee854a6c2fad13d6c6300792d4 upstream.

Nvidia card may come with a "phantom" UCSI device, and its driver gets
stuck in probe routine, prevents any system PM operations like suspend.

There's an unaccounted case that the target time can equal to jiffies in
gpu_i2c_check_status(), let's solve that by using readl_poll_timeout()
instead of jiffies comparison functions.

Fixes: c71bcdcb42a7 ("i2c: add i2c bus driver for NVIDIA GPU")
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Ajay Gupta <ajayg@nvidia.com>
Tested-by: Ajay Gupta <ajayg@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-nvidia-gpu.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -8,6 +8,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
@@ -75,20 +76,15 @@ static void gpu_enable_i2c_bus(struct gp
 
 static int gpu_i2c_check_status(struct gpu_i2c_dev *i2cd)
 {
-	unsigned long target = jiffies + msecs_to_jiffies(1000);
 	u32 val;
+	int ret;
 
-	do {
-		val = readl(i2cd->regs + I2C_MST_CNTL);
-		if (!(val & I2C_MST_CNTL_CYCLE_TRIGGER))
-			break;
-		if ((val & I2C_MST_CNTL_STATUS) !=
-				I2C_MST_CNTL_STATUS_BUS_BUSY)
-			break;
-		usleep_range(500, 600);
-	} while (time_is_after_jiffies(target));
+	ret = readl_poll_timeout(i2cd->regs + I2C_MST_CNTL, val,
+				 !(val & I2C_MST_CNTL_CYCLE_TRIGGER) ||
+				 (val & I2C_MST_CNTL_STATUS) != I2C_MST_CNTL_STATUS_BUS_BUSY,
+				 500, 1000 * USEC_PER_MSEC);
 
-	if (time_is_before_jiffies(target)) {
+	if (ret) {
 		dev_err(i2cd->dev, "i2c timeout error %x\n", val);
 		return -ETIMEDOUT;
 	}


