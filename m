Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3399F23A5F1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgHCMaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgHCMaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6D12086A;
        Mon,  3 Aug 2020 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457801;
        bh=+J6fOoLK985RugK/lghNk9b0GLsZJS34xZ+SIvL3Gdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgfbiCw8ipELJwgM6IqARFAPje+rdMMAsH/yv3DhCIWbei/F/vCfllX3LCcRfVeEs
         QZ1ImOHHUxW9qlGMkGkkJJ8nY0bSroKnoajMgYuiJt8/avwFORt3K4SYNnCJpHp1bz
         7l7jA/r9GeDMP5ny0Zuw9+w87bt0eooibCQEyjEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 78/90] Revert "i2c: cadence: Fix the hold bit setting"
Date:   Mon,  3 Aug 2020 14:19:40 +0200
Message-Id: <20200803121901.393294334@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
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
index 9d71ce15db050..a51d3b7957701 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -377,10 +377,8 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
 	 */
-	if ((id->recv_count > CDNS_I2C_FIFO_DEPTH)  || id->bus_hold_flag)
+	if (id->recv_count > CDNS_I2C_FIFO_DEPTH)
 		ctrl_reg |= CDNS_I2C_CR_HOLD;
-	else
-		ctrl_reg = ctrl_reg & ~CDNS_I2C_CR_HOLD;
 
 	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
 
@@ -437,11 +435,8 @@ static void cdns_i2c_msend(struct cdns_i2c *id)
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



