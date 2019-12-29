Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F83312C8A9
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733144AbfL2R4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733140AbfL2R4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F123E206DB;
        Sun, 29 Dec 2019 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642213;
        bh=DFBJQaHQrB4R7ln8IzQSWLM9FsWAF6QmiL8CvEW4J6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDZwSgDe/MzHYJuwQ2Trw9z1UfFyEQz1nvQ5IJ70wZi1DqWyBw5VqbPgk26XdQUir
         GbQ/trQrlWSPE/giH6GACyialANJil+G3Dg/Wdq0f0vegFRBFJ3YhTD+4CkNbUQgFp
         ncT/PZiUOl6rxdilbXOiXtHEVrsnBG0Kl5At7/NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 372/434] can: xilinx_can: Fix missing Rx can packets on CANFD2.0
Date:   Sun, 29 Dec 2019 18:27:05 +0100
Message-Id: <20191229172726.715381661@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

commit 9ab79b06ddf3cdf6484d60b3e5fe113e733145c8 upstream.

CANFD2.0 core uses BRAM for storing acceptance filter ID(AFID) and MASK
(AFMASK)registers. So by default AFID and AFMASK registers contain random
data. Due to random data, we are not able to receive all CAN ids.

Initializing AFID and AFMASK registers with Zero before enabling
acceptance filter to receive all packets irrespective of ID and Mask.

Fixes: 0db9071353a0 ("can: xilinx: add can 2.0 support")
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Reviewed-by: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/xilinx_can.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -60,6 +60,8 @@ enum xcan_reg {
 	XCAN_TXMSG_BASE_OFFSET	= 0x0100, /* TX Message Space */
 	XCAN_RXMSG_BASE_OFFSET	= 0x1100, /* RX Message Space */
 	XCAN_RXMSG_2_BASE_OFFSET	= 0x2100, /* RX Message Space */
+	XCAN_AFR_2_MASK_OFFSET	= 0x0A00, /* Acceptance Filter MASK */
+	XCAN_AFR_2_ID_OFFSET	= 0x0A04, /* Acceptance Filter ID */
 };
 
 #define XCAN_FRAME_ID_OFFSET(frame_base)	((frame_base) + 0x00)
@@ -1803,6 +1805,11 @@ static int xcan_probe(struct platform_de
 
 	pm_runtime_put(&pdev->dev);
 
+	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
+		priv->write_reg(priv, XCAN_AFR_2_ID_OFFSET, 0x00000000);
+		priv->write_reg(priv, XCAN_AFR_2_MASK_OFFSET, 0x00000000);
+	}
+
 	netdev_dbg(ndev, "reg_base=0x%p irq=%d clock=%d, tx buffers: actual %d, using %d\n",
 		   priv->reg_base, ndev->irq, priv->can.clock.freq,
 		   hw_tx_max, priv->tx_max);


