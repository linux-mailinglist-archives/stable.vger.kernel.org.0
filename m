Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F0733B63C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhCON51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231820AbhCON4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E857964EB6;
        Mon, 15 Mar 2021 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816615;
        bh=Hh6bLwOHaaKuMgUMulZHgJrRFgg8MV3VXJXtKBYwGcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khv7x2FSG5vNlh/byEOvaQmhD14ID9pfzlHGlOnSSl+MoSmiuS0E3QaA/qCKKMZxd
         qiYyDar6AGoRn3TAr8peD+zJTD38k5N1vZHh0OPhsWVRJjHiLWhVTIrzX468U9nAxr
         BaBALbJBboaqdyg8BvA19VfsbfMeiMzeDCuUYwy8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 014/290] can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode
Date:   Mon, 15 Mar 2021 14:51:47 +0100
Message-Id: <20210315135542.429568171@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -1375,10 +1375,13 @@ static int flexcan_chip_start(struct net
 
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
@@ -1387,9 +1390,8 @@ static int flexcan_chip_start(struct net
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


