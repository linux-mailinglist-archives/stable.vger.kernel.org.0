Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2E6328E92
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbhCATds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241698AbhCAT2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE6965049;
        Mon,  1 Mar 2021 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619109;
        bh=Lh3KcIpt1rlEQPrwCoRqVQixD8turhgQ73SDjrYTb0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSfUO7rzRsJVYwgRJhsOMtS7Cu8uv6OdlatLwJEZaZmtST3XrjZRz9u2cAgq9/NBz
         KvRDAI9F8Nustrcq/eMWaWL83r5OIW2reSIAgrd+l2NeJ9Z7fxtlnXenTgSGa+0dNs
         HFgaISjdB0h5LvllevQxuHHtQm8w7Csg46Ze/C2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roja Rani Yarubandi <rojay@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/663] i2c: i2c-qcom-geni: Add shutdown callback for i2c
Date:   Mon,  1 Mar 2021 17:09:43 +0100
Message-Id: <20210301161158.425253438@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roja Rani Yarubandi <rojay@codeaurora.org>

[ Upstream commit e0371298ddc51761be257698554ea507ac8bf831 ]

If the hardware is still accessing memory after SMMU translation
is disabled (as part of smmu shutdown callback), then the
IOVAs (I/O virtual address) which it was using will go on the bus
as the physical addresses which will result in unknown crashes
like NoC/interconnect errors.

So, implement shutdown callback to i2c driver to stop on-going transfer
and unmap DMA mappings during system "reboot" or "shutdown".

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Signed-off-by: Roja Rani Yarubandi <rojay@codeaurora.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 4a6dd05d6dbf9..221cba687fe02 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -375,6 +375,32 @@ static void geni_i2c_tx_msg_cleanup(struct geni_i2c_dev *gi2c,
 	}
 }
 
+static void geni_i2c_stop_xfer(struct geni_i2c_dev *gi2c)
+{
+	int ret;
+	u32 geni_status;
+	struct i2c_msg *cur;
+
+	/* Resume device, as runtime suspend can happen anytime during transfer */
+	ret = pm_runtime_get_sync(gi2c->se.dev);
+	if (ret < 0) {
+		dev_err(gi2c->se.dev, "Failed to resume device: %d\n", ret);
+		return;
+	}
+
+	geni_status = readl_relaxed(gi2c->se.base + SE_GENI_STATUS);
+	if (geni_status & M_GENI_CMD_ACTIVE) {
+		cur = gi2c->cur;
+		geni_i2c_abort_xfer(gi2c);
+		if (cur->flags & I2C_M_RD)
+			geni_i2c_rx_msg_cleanup(gi2c, cur);
+		else
+			geni_i2c_tx_msg_cleanup(gi2c, cur);
+	}
+
+	pm_runtime_put_sync_suspend(gi2c->se.dev);
+}
+
 static int geni_i2c_rx_one_msg(struct geni_i2c_dev *gi2c, struct i2c_msg *msg,
 				u32 m_param)
 {
@@ -654,6 +680,13 @@ static int geni_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void  geni_i2c_shutdown(struct platform_device *pdev)
+{
+	struct geni_i2c_dev *gi2c = platform_get_drvdata(pdev);
+
+	geni_i2c_stop_xfer(gi2c);
+}
+
 static int __maybe_unused geni_i2c_runtime_suspend(struct device *dev)
 {
 	int ret;
@@ -718,6 +751,7 @@ MODULE_DEVICE_TABLE(of, geni_i2c_dt_match);
 static struct platform_driver geni_i2c_driver = {
 	.probe  = geni_i2c_probe,
 	.remove = geni_i2c_remove,
+	.shutdown = geni_i2c_shutdown,
 	.driver = {
 		.name = "geni_i2c",
 		.pm = &geni_i2c_pm_ops,
-- 
2.27.0



