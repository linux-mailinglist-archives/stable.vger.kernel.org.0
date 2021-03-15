Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C0B33B64F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhCON5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhCON5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E073F64EEC;
        Mon, 15 Mar 2021 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816626;
        bh=sujTiFdD43xDCjXbqoWEtCzs6XmK5ywQFXvpQXWecoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYTxbDui7/pqlhXu4B9ITe0Q/L8wZ93cFpCsbiot9hKKDKBMOR2AE6hY1Drvk8QBH
         6hWTr80NJW0ddIZ3ai069qb9fi8dr9wZcAZhABdVnfwma8xxy0BEJAhYH1V5Dw1qXj
         rbofJ1G1v7eGfWDPkPgVZYR1UMYwK36p9l97AsbA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 012/168] can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode
Date:   Mon, 15 Mar 2021 14:54:04 +0100
Message-Id: <20210315135550.744268606@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit c63820045e2000f05657467a08715c18c9f490d9 upstream.

Invoke flexcan_chip_freeze() to enter freeze mode, since need poll
freeze mode acknowledge.

Fixes: e955cead03117 ("CAN: Add Flexcan CAN controller driver")
Link: https://lore.kernel.org/r/20210218110037.16591-4-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1057,10 +1057,13 @@ static int flexcan_chip_start(struct net
 
 	flexcan_set_bittiming(dev);
 
+	/* set freeze, halt */
+	err = flexcan_chip_freeze(priv);
+	if (err)
+		goto out_chip_disable;
+
 	/* MCR
 	 *
-	 * enable freeze
-	 * halt now
 	 * only supervisor access
 	 * enable warning int
 	 * enable individual RX masking
@@ -1069,9 +1072,8 @@ static int flexcan_chip_start(struct net
 	 */
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_MAXMB(0xff);
-	reg_mcr |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT | FLEXCAN_MCR_SUPV |
-		FLEXCAN_MCR_WRN_EN | FLEXCAN_MCR_IRMQ | FLEXCAN_MCR_IDAM_C |
-		FLEXCAN_MCR_MAXMB(priv->tx_mb_idx);
+	reg_mcr |= FLEXCAN_MCR_SUPV | FLEXCAN_MCR_WRN_EN | FLEXCAN_MCR_IRMQ |
+		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_MAXMB(priv->tx_mb_idx);
 
 	/* MCR
 	 *


