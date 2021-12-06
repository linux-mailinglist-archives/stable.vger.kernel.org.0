Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7A469C01
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346825AbhLFPTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36496 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351777AbhLFPR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C7686131F;
        Mon,  6 Dec 2021 15:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA3C341C1;
        Mon,  6 Dec 2021 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803638;
        bh=8VF6VqRbeBIHq9H92PPGCogNg3e7CXkxPapy5T7e3a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRAL5Fg6VHcYNeFEGTtR4JJ8Q7w1nsh6Z6eXEalALF1ADZ7EQcP5he3S+60ZZSGtt
         /dbidioG5lsB6va7gOQbTbcCn+H9prGQ/ezhK3UBQaHyRLqFYZt0B5m2lTCJkmFCbX
         C9nGgZDr/PAko2KoqKH+KK4P2pFWkRxW44j1XUj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 32/70] i2c: stm32f7: flush TX FIFO upon transfer errors
Date:   Mon,  6 Dec 2021 15:56:36 +0100
Message-Id: <20211206145553.036366235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

commit 0c21d02ca469574d2082379db52d1a27b99eed0c upstream.

While handling an error during transfer (ex: NACK), it could
happen that the driver has already written data into TXDR
before the transfer get stopped.
This commit add TXDR Flush after end of transfer in case of error to
avoid sending a wrong data on any other slave upon next transfer.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1586,6 +1586,16 @@ static int stm32f7_i2c_xfer(struct i2c_a
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
@@ -1634,8 +1644,16 @@ static int stm32f7_i2c_smbus_xfer(struct
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


