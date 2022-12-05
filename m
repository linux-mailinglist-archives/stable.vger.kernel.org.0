Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2B643414
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiLETmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiLETlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:41:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C12E20199
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4DF1DCE139F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D5DC433D6;
        Mon,  5 Dec 2022 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269133;
        bh=JODpgBCq16X/gi/Ru6zvD83AxvADc7n8VSdvV+sftKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkWWTfb8Vu/VjN5fokqt8BXYr2zwsZD9A3GR3wFeBZTT18x38fMjbcbnAYePCtZjX
         eXNXvhtwa+V167Qrp2IP+Fm5sk5BrkglPM3DJFbZyFfiC8I4jc4jZHI6wqDtv3/x7r
         lJipO6JrA3TMmKcNuCJIB+HH8hoO6ed/1eETl+z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/153] bus: sunxi-rsb: Support atomic transfers
Date:   Mon,  5 Dec 2022 20:09:00 +0100
Message-Id: <20221205190809.216106638@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 077686da0e2162c4ea5ae0df205849c2a7a84479 ]

When communicating with a PMIC during system poweroff (pm_power_off()),
IRQs are disabled and we are in a RCU read-side critical section, so we
cannot use wait_for_completion_io_timeout(). Instead, poll the status
register for transfer completion.

Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221114015749.28490-3-samuel@sholland.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 9b1a5e62417c..f8c29b888e6b 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -268,6 +268,9 @@ EXPORT_SYMBOL_GPL(sunxi_rsb_driver_register);
 /* common code that starts a transfer */
 static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 {
+	u32 int_mask, status;
+	bool timeout;
+
 	if (readl(rsb->regs + RSB_CTRL) & RSB_CTRL_START_TRANS) {
 		dev_dbg(rsb->dev, "RSB transfer still in progress\n");
 		return -EBUSY;
@@ -275,13 +278,23 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 
 	reinit_completion(&rsb->complete);
 
-	writel(RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER,
-	       rsb->regs + RSB_INTE);
+	int_mask = RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER;
+	writel(int_mask, rsb->regs + RSB_INTE);
 	writel(RSB_CTRL_START_TRANS | RSB_CTRL_GLOBAL_INT_ENB,
 	       rsb->regs + RSB_CTRL);
 
-	if (!wait_for_completion_io_timeout(&rsb->complete,
-					    msecs_to_jiffies(100))) {
+	if (irqs_disabled()) {
+		timeout = readl_poll_timeout_atomic(rsb->regs + RSB_INTS,
+						    status, (status & int_mask),
+						    10, 100000);
+		writel(status, rsb->regs + RSB_INTS);
+	} else {
+		timeout = !wait_for_completion_io_timeout(&rsb->complete,
+							  msecs_to_jiffies(100));
+		status = rsb->status;
+	}
+
+	if (timeout) {
 		dev_dbg(rsb->dev, "RSB timeout\n");
 
 		/* abort the transfer */
@@ -293,18 +306,18 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 		return -ETIMEDOUT;
 	}
 
-	if (rsb->status & RSB_INTS_LOAD_BSY) {
+	if (status & RSB_INTS_LOAD_BSY) {
 		dev_dbg(rsb->dev, "RSB busy\n");
 		return -EBUSY;
 	}
 
-	if (rsb->status & RSB_INTS_TRANS_ERR) {
-		if (rsb->status & RSB_INTS_TRANS_ERR_ACK) {
+	if (status & RSB_INTS_TRANS_ERR) {
+		if (status & RSB_INTS_TRANS_ERR_ACK) {
 			dev_dbg(rsb->dev, "RSB slave nack\n");
 			return -EINVAL;
 		}
 
-		if (rsb->status & RSB_INTS_TRANS_ERR_DATA) {
+		if (status & RSB_INTS_TRANS_ERR_DATA) {
 			dev_dbg(rsb->dev, "RSB transfer data error\n");
 			return -EIO;
 		}
-- 
2.35.1



