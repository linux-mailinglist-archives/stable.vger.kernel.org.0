Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1F12C8DE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbfL2R6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbfL2R6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C289A206A4;
        Sun, 29 Dec 2019 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642285;
        bh=u1xUVPSbajSdVquSn0p+XxUCG3BSguvRB7U0kTOJMsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhdFDU/e8q2MpfZ/ZDjQNHFFeltDp8cauY89xL3kQiaCSfrjCiqCZQxAMu8r1Lfm8
         P7I/SkwJL7hguYavDHztS5aitjg6A9JzpVB47/4n6kSohxlX9AgVwtiCQpoKwDFsua
         gEwocYziFbPZoQWwiM3cNh5nR4O9SptWn5wAnk14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 376/434] can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment
Date:   Sun, 29 Dec 2019 18:27:09 +0100
Message-Id: <20191229172727.051447498@linuxfoundation.org>
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

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 048e3a34a2e7669bf475eb56c7345ad9d8d2b8e3 upstream.

Stop Mode is entered when Stop Mode is requested at chip level and
MCR[LPM_ACK] is asserted by the FlexCAN.

Double check with IP owner, the MCR[LPM_ACK] bit should be polled for
stop mode acknowledgment, not the acknowledgment from chip level which
is used to gate flexcan clocks.

This patch depends on:

    b7603d080ffc ("can: flexcan: add low power enter/exit acknowledgment helper")

Fixes: 5f186c257fa4 (can: flexcan: fix stop mode acknowledgment)
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -407,7 +407,6 @@ static void flexcan_enable_wakeup_irq(st
 static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
 
 	reg_mcr = priv->read(&regs->mcr);
@@ -418,36 +417,24 @@ static inline int flexcan_enter_stop_mod
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
 
-	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, ackval & (1 << priv->stm.ack_bit),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_enter_ack(priv);
 }
 
 static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
 
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
 
-	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
 
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
 
-	return 0;
+	return flexcan_low_power_exit_ack(priv);
 }
 
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *priv)


