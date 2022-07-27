Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F13582AFA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiG0Q0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbiG0QYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1754E856;
        Wed, 27 Jul 2022 09:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387E861995;
        Wed, 27 Jul 2022 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E6AC433C1;
        Wed, 27 Jul 2022 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939003;
        bh=CGwlmVA2bXXqQ4IQKLk5slznzE9EMe0rptGUrvhRg6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP4bKL8TZsJxpe7RR0ABBzuBnTN89+bD8UOE57ywwPOP7pt/w4uQC+o037XOAfZke
         jqRt1tKwQUx/UYpKuLC4FlQsHg47lanAZ6aCGJ2nq1cYeRyFagMxd0tqVVuo910vk+
         tFMcO0KvLEP1TDhwJk9fOI3/2K3SvbWFyHh/0pAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Shubhrajyoti Datta <Shubhrajyoti.datta@amd.com>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/37] i2c: cadence: Change large transfer count reset logic to be unconditional
Date:   Wed, 27 Jul 2022 18:10:35 +0200
Message-Id: <20220727161001.250570906@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 4ca8ca873d454635c20d508261bfc0081af75cf8 ]

Problems were observed on the Xilinx ZynqMP platform with large I2C reads.
When a read of 277 bytes was performed, the controller NAKed the transfer
after only 252 bytes were transferred and returned an ENXIO error on the
transfer.

There is some code in cdns_i2c_master_isr to handle this case by resetting
the transfer count in the controller before it reaches 0, to allow larger
transfers to work, but it was conditional on the CDNS_I2C_BROKEN_HOLD_BIT
quirk being set on the controller, and ZynqMP uses the r1p14 version of
the core where this quirk is not being set. The requirement to do this to
support larger reads seems like an inherently required workaround due to
the core only having an 8-bit transfer size register, so it does not
appear that this should be conditional on the broken HOLD bit quirk which
is used elsewhere in the driver.

Remove the dependency on the CDNS_I2C_BROKEN_HOLD_BIT for this transfer
size reset logic to fix this problem.

Fixes: 63cab195bf49 ("i2c: removed work arounds in i2c driver for Zynq Ultrascale+ MPSoC")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Shubhrajyoti Datta <Shubhrajyoti.datta@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 273f57e277b3..512c61d31fe5 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -203,9 +203,9 @@ static inline bool cdns_is_holdquirk(struct cdns_i2c *id, bool hold_wrkaround)
  */
 static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 {
-	unsigned int isr_status, avail_bytes, updatetx;
+	unsigned int isr_status, avail_bytes;
 	unsigned int bytes_to_send;
-	bool hold_quirk;
+	bool updatetx;
 	struct cdns_i2c *id = ptr;
 	/* Signal completion only after everything is updated */
 	int done_flag = 0;
@@ -224,11 +224,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 	 * Check if transfer size register needs to be updated again for a
 	 * large data receive operation.
 	 */
-	updatetx = 0;
-	if (id->recv_count > id->curr_recv_count)
-		updatetx = 1;
-
-	hold_quirk = (id->quirks & CDNS_I2C_BROKEN_HOLD_BIT) && updatetx;
+	updatetx = id->recv_count > id->curr_recv_count;
 
 	/* When receiving, handle data interrupt and completion interrupt */
 	if (id->p_recv_buf &&
@@ -251,7 +247,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 			id->recv_count--;
 			id->curr_recv_count--;
 
-			if (cdns_is_holdquirk(id, hold_quirk))
+			if (cdns_is_holdquirk(id, updatetx))
 				break;
 		}
 
@@ -262,7 +258,7 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 		 * maintain transfer size non-zero while performing a large
 		 * receive operation.
 		 */
-		if (cdns_is_holdquirk(id, hold_quirk)) {
+		if (cdns_is_holdquirk(id, updatetx)) {
 			/* wait while fifo is full */
 			while (cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET) !=
 			       (id->curr_recv_count - CDNS_I2C_FIFO_DEPTH))
@@ -284,22 +280,6 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 						  CDNS_I2C_XFER_SIZE_OFFSET);
 				id->curr_recv_count = id->recv_count;
 			}
-		} else if (id->recv_count && !hold_quirk &&
-						!id->curr_recv_count) {
-
-			/* Set the slave address in address register*/
-			cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
-						CDNS_I2C_ADDR_OFFSET);
-
-			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
-				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
-			} else {
-				cdns_i2c_writereg(id->recv_count,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = id->recv_count;
-			}
 		}
 
 		/* Clear hold (if not repeated start) and signal completion */
-- 
2.35.1



