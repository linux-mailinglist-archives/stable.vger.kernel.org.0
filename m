Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF233B634
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhCON5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhCON4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE4F64F01;
        Mon, 15 Mar 2021 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816612;
        bh=KGHQjxJBd9zAIgB5ToyD/wCfmUU61UCbM1eVEf9Fy7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9l9DrIrIHvsWW76bNUgb0xk3SrbOPxaskYb1u+CkC4sK85nw92gEow7TyjTWzC2E
         7m/esPUTmW36ASZIS8Te4PIwnvgHuJ8GEsrL/uO/UUaHvfVavRiLzh1FUHNuLq36m8
         t7vwp0sO9PYJ/V0WGmEHxOOMdFa2hXdIOkkUw/j4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.11 020/306] can: flexcan: enable RX FIFO after FRZ/HALT valid
Date:   Mon, 15 Mar 2021 14:51:23 +0100
Message-Id: <20210315135508.302097100@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit ec15e27cc8904605846a354bb1f808ea1432f853 upstream.

RX FIFO enable failed could happen when do system reboot stress test:

[    0.303958] flexcan 5a8d0000.can: 5a8d0000.can supply xceiver not found, using dummy regulator
[    0.304281] flexcan 5a8d0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.314640] flexcan 5a8d0000.can: registering netdev failed
[    0.320728] flexcan 5a8e0000.can: 5a8e0000.can supply xceiver not found, using dummy regulator
[    0.320991] flexcan 5a8e0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.331360] flexcan 5a8e0000.can: registering netdev failed
[    0.337444] flexcan 5a8f0000.can: 5a8f0000.can supply xceiver not found, using dummy regulator
[    0.337716] flexcan 5a8f0000.can (unnamed net_device) (uninitialized): Could not enable RX FIFO, unsupported core
[    0.348117] flexcan 5a8f0000.can: registering netdev failed

RX FIFO should be enabled after the FRZ/HALT are valid. But the current
code enable RX FIFO and FRZ/HALT at the same time.

Fixes: e955cead03117 ("CAN: Add Flexcan CAN controller driver")
Link: https://lore.kernel.org/r/20210218110037.16591-3-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1864,10 +1864,14 @@ static int register_flexcandev(struct ne
 	if (err)
 		goto out_chip_disable;
 
-	/* set freeze, halt and activate FIFO, restrict register access */
+	/* set freeze, halt */
+	err = flexcan_chip_freeze(priv);
+	if (err)
+		goto out_chip_disable;
+
+	/* activate FIFO, restrict register access */
 	reg = priv->read(&regs->mcr);
-	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT |
-		FLEXCAN_MCR_FEN | FLEXCAN_MCR_SUPV;
+	reg |=  FLEXCAN_MCR_FEN | FLEXCAN_MCR_SUPV;
 	priv->write(reg, &regs->mcr);
 
 	/* Currently we only support newer versions of this core


