Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1178434C7A0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhC2IQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232685AbhC2IPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:15:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C33361974;
        Mon, 29 Mar 2021 08:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005708;
        bh=kK8ElrojeNKi00+pQIDeLXnDZcQGyjJ3LPdgRMVtKh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/uNdK9KyZv+LrxOmAcRR2ECo9BTeCqfcoCy/n+jYEza0Zkbs6jC0pfBdNrzUcMOp
         fbbeEJb8k9/OkU9Xz65HfUN7aJaM1Y7wUfTxKSAOwt0ojK3nYbepN8P/Yg8qUZ90zH
         3ZsuMibxVl7fNOJnRTLI97bV54V/uifIhD8zAeZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Angelo Dureghello <angelo@kernel-space.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/111] can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate
Date:   Mon, 29 Mar 2021 09:58:19 +0200
Message-Id: <20210329075617.577997837@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo@kernel-space.org>

[ Upstream commit 47c5e474bc1e1061fb037d13b5000b38967eb070 ]

For cases when flexcan is built-in, bitrate is still not set at
registering. So flexcan_chip_freeze() generates:

[    1.860000] *** ZERO DIVIDE ***   FORMAT=4
[    1.860000] Current process id is 1
[    1.860000] BAD KERNEL TRAP: 00000000
[    1.860000] PC: [<402e70c8>] flexcan_chip_freeze+0x1a/0xa8

To allow chip freeze, using an hardcoded timeout when bitrate is still
not set.

Fixes: ec15e27cc890 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
Link: https://lore.kernel.org/r/20210315231510.650593-1-angelo@kernel-space.org
Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
[mkl: use if instead of ? operator]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index b6d00dfa8b8f..7ec15cb356c0 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -544,9 +544,15 @@ static int flexcan_chip_disable(struct flexcan_priv *priv)
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = 1000 * 1000 * 10 / priv->can.bittiming.bitrate;
+	unsigned int timeout;
+	u32 bitrate = priv->can.bittiming.bitrate;
 	u32 reg;
 
+	if (bitrate)
+		timeout = 1000 * 1000 * 10 / bitrate;
+	else
+		timeout = FLEXCAN_TIMEOUT_US / 10;
+
 	reg = priv->read(&regs->mcr);
 	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
 	priv->write(reg, &regs->mcr);
-- 
2.30.1



