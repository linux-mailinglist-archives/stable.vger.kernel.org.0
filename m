Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D7643A09C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhJYTcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhJYTaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BDE8600D3;
        Mon, 25 Oct 2021 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190043;
        bh=vLMDtiIQc3byFZ9GILvjob3+0iH6Z2PEnp0OgoYDEow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9FfRLg8hgWipAJNTsz0xYtkaSXOfGJAa/84SxHkddnvQ/NmiHGmReijIbL4E9ZMt
         9txGu5mcZzUVudFFNROGEMeAYbAEpUCx4spujW73CqzDNCG2sha9xB7h5Lr/j7zAWN
         RYGD1fiTYz7oxismKiNVAMkE9jFFhwdKiiZIRQSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 19/58] can: rcar_can: fix suspend/resume
Date:   Mon, 25 Oct 2021 21:14:36 +0200
Message-Id: <20211025190940.621863789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit f7c05c3987dcfde9a4e8c2d533db013fabebca0d upstream.

If the driver was not opened, rcar_can_suspend() should not call
clk_disable() because the clock was not enabled.

Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
Link: https://lore.kernel.org/all/20210924075556.223685-1-yoshihiro.shimoda.uh@renesas.com
Cc: stable@vger.kernel.org
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_can.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -848,10 +848,12 @@ static int __maybe_unused rcar_can_suspe
 	struct rcar_can_priv *priv = netdev_priv(ndev);
 	u16 ctlr;
 
-	if (netif_running(ndev)) {
-		netif_stop_queue(ndev);
-		netif_device_detach(ndev);
-	}
+	if (!netif_running(ndev))
+		return 0;
+
+	netif_stop_queue(ndev);
+	netif_device_detach(ndev);
+
 	ctlr = readw(&priv->regs->ctlr);
 	ctlr |= RCAR_CAN_CTLR_CANM_HALT;
 	writew(ctlr, &priv->regs->ctlr);
@@ -870,6 +872,9 @@ static int __maybe_unused rcar_can_resum
 	u16 ctlr;
 	int err;
 
+	if (!netif_running(ndev))
+		return 0;
+
 	err = clk_enable(priv->clk);
 	if (err) {
 		netdev_err(ndev, "clk_enable() failed, error %d\n", err);
@@ -883,10 +888,9 @@ static int __maybe_unused rcar_can_resum
 	writew(ctlr, &priv->regs->ctlr);
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	if (netif_running(ndev)) {
-		netif_device_attach(ndev);
-		netif_start_queue(ndev);
-	}
+	netif_device_attach(ndev);
+	netif_start_queue(ndev);
+
 	return 0;
 }
 


