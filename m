Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F722FDBD
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgG0X3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgG0XYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC76920786;
        Mon, 27 Jul 2020 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892249;
        bh=wU/TN71rTvgaJrmEbzOri9vKXRrQfz4CqDUk8J6+y90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epI28L6CIfTtm1ZwEbu/JpzBWlSCB2//QWnTfT271GNbvpJZkRMJMD0y+AxNCc6Je
         F/DSRYQ3YcPiFMNLwW4+0hHOw8tFMN7VeH3rIHDghq/DURqb404Pp4RuZ4HGeJInhk
         hVSTUc1ysdNpVxPpraI5sI6263MC1G++leRNtEvY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 17/25] i2c: cadence: Clear HOLD bit at correct time in Rx path
Date:   Mon, 27 Jul 2020 19:23:37 -0400
Message-Id: <20200727232345.717432-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>

[ Upstream commit 12d4d9ec5eeecd712c73772e422b6d082e66b046 ]

There are few issues on Zynq SOC observed in the stress tests causing
timeout errors. Even though all the data is received, timeout error
is thrown. This is due to an IP bug in which the COMP bit in ISR is
not set at end of transfer and completion interrupt is not generated.

This bug is seen on Zynq platforms when the following condition occurs:
Master read & HOLD bit set & Transfer size register reaches '0'.

One workaround is to clear the HOLD bit before the transfer size
register reaches '0'. The current implementation checks for this at
the start of the loop and also only for less than FIFO DEPTH case
(ignoring the equal to case).

So clear the HOLD bit when the data yet to receive is less than or
equal to the FIFO DEPTH. This avoids the IP bug condition.

Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 97a0bd6ea31f1..1efdabb5adca0 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -230,20 +230,21 @@ static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
 		/* Read data if receive data valid is set */
 		while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
 		       CDNS_I2C_SR_RXDV) {
-			/*
-			 * Clear hold bit that was set for FIFO control if
-			 * RX data left is less than FIFO depth, unless
-			 * repeated start is selected.
-			 */
-			if ((id->recv_count < CDNS_I2C_FIFO_DEPTH) &&
-			    !id->bus_hold_flag)
-				cdns_i2c_clear_bus_hold(id);
-
 			if (id->recv_count > 0) {
 				*(id->p_recv_buf)++ =
 					cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
 				id->recv_count--;
 				id->curr_recv_count--;
+
+				/*
+				 * Clear hold bit that was set for FIFO control
+				 * if RX data left is less than or equal to
+				 * FIFO DEPTH unless repeated start is selected
+				 */
+				if (id->recv_count <= CDNS_I2C_FIFO_DEPTH &&
+				    !id->bus_hold_flag)
+					cdns_i2c_clear_bus_hold(id);
+
 			} else {
 				dev_err(id->adap.dev.parent,
 					"xfer_size reg rollover. xfer aborted!\n");
-- 
2.25.1

