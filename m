Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D11468AE7
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhLENEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:04:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41622 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLENEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:04:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0558D60FDB
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B9C341C5;
        Sun,  5 Dec 2021 13:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638709266;
        bh=WU/xmm6c5sooUONWUPiUlwEDVn21IhYcoaMRg6Knmek=;
        h=Subject:To:Cc:From:Date:From;
        b=wZJ0kcafa5SSm9Az9WgIANqlpZ2KfLtpVrPZLO1CGrUN4Zb+FeNfHmrtevwff9gEH
         ENhTyY+ZZk/4tIoebBkk/x8caMbY9Tj5uTtWI6Ec9avsbz7usg981N9DyUWdqzbVHx
         JXHTckAjwXu1oUAK5a+XrS8FlyROBIKb9LKvrn64=
Subject: FAILED: patch "[PATCH] i2c: stm32f7: flush TX FIFO upon transfer errors" failed to apply to 4.19-stable tree
To:     alain.volmat@foss.st.com, pierre-yves.mordret@foss.st.com,
        wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:00:55 +0100
Message-ID: <163870925569146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 0c21d02ca469574d2082379db52d1a27b99eed0c Mon Sep 17 00:00:00 2001
From: Alain Volmat <alain.volmat@foss.st.com>
Date: Mon, 20 Sep 2021 17:21:29 +0200
Subject: [PATCH] i2c: stm32f7: flush TX FIFO upon transfer errors

While handling an error during transfer (ex: NACK), it could
happen that the driver has already written data into TXDR
before the transfer get stopped.
This commit add TXDR Flush after end of transfer in case of error to
avoid sending a wrong data on any other slave upon next transfer.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index b9b19a2a2ffa..ed977b6f7ab6 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1696,6 +1696,16 @@ static int stm32f7_i2c_xfer(struct i2c_adapter *i2c_adap,
 	time_left = wait_for_completion_timeout(&i2c_dev->complete,
 						i2c_dev->adap.timeout);
 	ret = f7_msg->result;
+	if (ret) {
+		/*
+		 * It is possible that some unsent data have already been
+		 * written into TXDR. To avoid sending old data in a
+		 * further transfer, flush TXDR in case of any error
+		 */
+		writel_relaxed(STM32F7_I2C_ISR_TXE,
+			       i2c_dev->base + STM32F7_I2C_ISR);
+		goto pm_free;
+	}
 
 	if (!time_left) {
 		dev_dbg(i2c_dev->dev, "Access to slave 0x%x timed out\n",
@@ -1744,8 +1754,16 @@ static int stm32f7_i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 	timeout = wait_for_completion_timeout(&i2c_dev->complete,
 					      i2c_dev->adap.timeout);
 	ret = f7_msg->result;
-	if (ret)
+	if (ret) {
+		/*
+		 * It is possible that some unsent data have already been
+		 * written into TXDR. To avoid sending old data in a
+		 * further transfer, flush TXDR in case of any error
+		 */
+		writel_relaxed(STM32F7_I2C_ISR_TXE,
+			       i2c_dev->base + STM32F7_I2C_ISR);
 		goto pm_free;
+	}
 
 	if (!timeout) {
 		dev_dbg(dev, "Access to slave 0x%x timed out\n", f7_msg->addr);

