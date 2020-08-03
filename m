Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661B023A558
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgHCMgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgHCMf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:35:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E019120678;
        Mon,  3 Aug 2020 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458156;
        bh=jgApG1A37oBtiR5CjwiKak+vQK6WNvNl+JWHPVFcpb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1For/mh8aR7rLVZKGXZ1J2r3ANtRu4j31/BODo2S7xfoWwvTOyiwYYBHk3tSTgMJ
         T1EnBwjMHoim6rFhE+79VadkuX5N/80V06A9gs1NGOadJSNh2u3TczwSkgh+FSAoP3
         KPSGhYxQFLapulEi6qfnUOJFzGByfBg5rCtuC5zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/51] Revert "i2c: cadence: Fix the hold bit setting"
Date:   Mon,  3 Aug 2020 14:20:31 +0200
Message-Id: <20200803121851.825133494@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>

[ Upstream commit 0db9254d6b896b587759e2c844c277fb1a6da5b9 ]

This reverts commit d358def706880defa4c9e87381c5bf086a97d5f9.

There are two issues with "i2c: cadence: Fix the hold bit setting" commit.

1. In case of combined message request from user space, when the HOLD
bit is cleared in cdns_i2c_mrecv function, a STOP condition is sent
on the bus even before the last message is started. This is because when
the HOLD bit is cleared, the FIFOS are empty and there is no pending
transfer. The STOP condition should occur only after the last message
is completed.

2. The code added by the commit is redundant. Driver is handling the
setting/clearing of HOLD bit in right way before the commit.

The setting of HOLD bit based on 'bus_hold_flag' is taken care in
cdns_i2c_master_xfer function even before cdns_i2c_msend/cdns_i2c_recv
functions.

The clearing of HOLD bit is taken care at the end of cdns_i2c_msend and
cdns_i2c_recv functions based on bus_hold_flag and byte count.
Since clearing of HOLD bit is done after the slave address is written to
the register (writing to address register triggers the message transfer),
it is ensured that STOP condition occurs at the right time after
completion of the pending transfer (last message).

Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index d917cefc5a19c..b136057182916 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -382,10 +382,8 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
 	 */
-	if ((id->recv_count > CDNS_I2C_FIFO_DEPTH)  || id->bus_hold_flag)
+	if (id->recv_count > CDNS_I2C_FIFO_DEPTH)
 		ctrl_reg |= CDNS_I2C_CR_HOLD;
-	else
-		ctrl_reg = ctrl_reg & ~CDNS_I2C_CR_HOLD;
 
 	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
 
@@ -442,11 +440,8 @@ static void cdns_i2c_msend(struct cdns_i2c *id)
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
 	 */
-	if ((id->send_count > CDNS_I2C_FIFO_DEPTH) || id->bus_hold_flag)
+	if (id->send_count > CDNS_I2C_FIFO_DEPTH)
 		ctrl_reg |= CDNS_I2C_CR_HOLD;
-	else
-		ctrl_reg = ctrl_reg & ~CDNS_I2C_CR_HOLD;
-
 	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
 
 	/* Clear the interrupts in interrupt status register. */
-- 
2.25.1



