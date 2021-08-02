Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7213DD9B3
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbhHBODN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235760AbhHBOBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6175B6120A;
        Mon,  2 Aug 2021 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912585;
        bh=99hvyO5qMVk98AqKl/fF4u+qk5kGAoJmDIq+Qk8jPuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcU6krjo+uoMW4w6l8snnwbiDgDGumg5OxAxwZYr/8jA2Lq2FImZfpdZ38VMoEnoa
         4/I3LAEfek9bvB0fpxfqkY958u6rUE67utyzMlWrRrxi5lIEE+bMRh07x2r7s+bHhp
         0CfD/Z/UkPFErowEWfMH0cHy4XIdEoEusdekPssw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 060/104] can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ
Date:   Mon,  2 Aug 2021 15:44:57 +0200
Message-Id: <20210802134345.976601792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ef68a717960658e6a1e5f08adb0574326e9a12c2 ]

In case an error occurred in the IRQ handler, the chip status is
dumped via devcoredump and all IRQs are disabled, but the chip stays
powered for further analysis.

The chip is in an undefined state and will not receive any CAN frames,
so shut down the timestamping worker, which reads the TBC register
regularly, too. This avoids any CRC read error messages if there is a
communication problem with the chip.

Fixes: efd8d98dfb90 ("can: mcp251xfd: add HW timestamp infrastructure")
Link: https://lore.kernel.org/r/20210724155131.471303-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e0ae00e34c7b..d371af7ab496 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2300,6 +2300,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 		   err, priv->regs_status.intf);
 	mcp251xfd_dump(priv);
 	mcp251xfd_chip_interrupts_disable(priv);
+	mcp251xfd_timestamp_stop(priv);
 
 	return handled;
 }
-- 
2.30.2



