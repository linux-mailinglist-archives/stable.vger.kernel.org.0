Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEAF33B62E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhCON5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhCON4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 432C664EB6;
        Mon, 15 Mar 2021 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816610;
        bh=SlrC4om016WlI29WQ3wkSHEORrg+Jw0OzAcHnp3Y4z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiqHA7Nxzi6rppZcjGP643cfpb8Gd4ODqIGk5gZpY85BlJmA6xZ942lpHULbgqXWq
         YL9reG5LJprj3W3u8QJ1YxfusIcPxZvZ1ADjNvdqtUNX9YFKi4jsnXfc4M9n+zNP0g
         QfrZMBQPiUgNkqTw0HB05ezN+kzfWpjpC1Uvump4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.11 019/306] can: flexcan: assert FRZ bit in flexcan_chip_freeze()
Date:   Mon, 15 Mar 2021 14:51:22 +0100
Message-Id: <20210315135508.265217894@linuxfoundation.org>
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

commit 449052cfebf624b670faa040245d3feed770d22f upstream.

Assert HALT bit to enter freeze mode, there is a premise that FRZ bit is
asserted. This patch asserts FRZ bit in flexcan_chip_freeze, although
the reset value is 1b'1. This is a prepare patch, later patch will
invoke flexcan_chip_freeze() to enter freeze mode, which polling freeze
mode acknowledge.

Fixes: b1aa1c7a2165b ("can: flexcan: fix transition from and to freeze mode in chip_{,un}freeze")
Link: https://lore.kernel.org/r/20210218110037.16591-2-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -701,7 +701,7 @@ static int flexcan_chip_freeze(struct fl
 	u32 reg;
 
 	reg = priv->read(&regs->mcr);
-	reg |= FLEXCAN_MCR_HALT;
+	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
 	priv->write(reg, &regs->mcr);
 
 	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))


