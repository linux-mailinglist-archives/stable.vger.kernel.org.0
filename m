Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBE840E418
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbhIPQzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237688AbhIPQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C76E6135E;
        Thu, 16 Sep 2021 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809771;
        bh=vltmrNgN+E0W7LKarKrqHmP9bA245YK9RPBi7h2Hvrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIlGtmN957C3TL7s5d5GrxqK4DaLHGsoFI3tSZLX2MoqehxB7fk3d/NRz+Dg6oil8
         Eu0GSp56oVqlBAEo+YHkDTx+qhjAm894IzjUsLuKrt8EvRG0mhGun/zKbUR8feN1UR
         HtHsJMRJVXjR3r/leZSUGFztiV0Luh/9wuVi8Thw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulrich Hecht <uli+renesas@fpond.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 276/380] serial: sh-sci: fix break handling for sysrq
Date:   Thu, 16 Sep 2021 18:00:33 +0200
Message-Id: <20210916155813.468148963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>

[ Upstream commit 87b8061bad9bd4b549b2daf36ffbaa57be2789a2 ]

This fixes two issues that cause the sysrq sequence to be inadvertently
aborted on SCIF serial consoles:

- a NUL character remains in the RX queue after a break has been detected,
  which is then passed on to uart_handle_sysrq_char()
- the break interrupt is handled twice on controllers with multiplexed ERI
  and BRI interrupts

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Link: https://lore.kernel.org/r/20210816162201.28801-1-uli+renesas@fpond.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 2d5487bf6855..a2e62f372e10 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1760,6 +1760,10 @@ static irqreturn_t sci_br_interrupt(int irq, void *ptr)
 
 	/* Handle BREAKs */
 	sci_handle_breaks(port);
+
+	/* drop invalid character received before break was detected */
+	serial_port_in(port, SCxRDR);
+
 	sci_clear_SCxSR(port, SCxSR_BREAK_CLEAR(port));
 
 	return IRQ_HANDLED;
@@ -1839,7 +1843,8 @@ static irqreturn_t sci_mpxed_interrupt(int irq, void *ptr)
 		ret = sci_er_interrupt(irq, ptr);
 
 	/* Break Interrupt */
-	if ((ssr_status & SCxSR_BRK(port)) && err_enabled)
+	if (s->irqs[SCIx_ERI_IRQ] != s->irqs[SCIx_BRI_IRQ] &&
+	    (ssr_status & SCxSR_BRK(port)) && err_enabled)
 		ret = sci_br_interrupt(irq, ptr);
 
 	/* Overrun Interrupt */
-- 
2.30.2



