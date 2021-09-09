Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A4440576C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376606AbhIINea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354430AbhIIM47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3AB6120C;
        Thu,  9 Sep 2021 11:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188709;
        bh=ZuvKr4oSXYZbhtOJp+5D1ACBKk8Hr0/2JvC6f1JF8xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfqW5jGP2LxboV0Ojj7oKmEch54n4xqxl+TmrGbhbwfWpUuaccmT+dpct8Jw7So2t
         ZN/TghbPeA4AZk4zW+aUmKaHR37E7DbT485eTfqZOIuIu7mDH2VChj3ub/MwogMWiC
         8FjiD2KLRG1pNTXzMRyGhCsKG+dMFN6bB/jmNLGWLXgD/7juCNtD4yh9hur+f9LtZN
         3OinGMpCGW5ocBcyFEJ+3LnlGgc4KUGJNmTuPzbyFNeFX0SQeBmzUhZfvlJ5KWN/y2
         gSJAMBPeuqq/cZhJ5WeYpkobPqG/yGAGShiWXPeYuJA/5vrL1CRbbD+YeKgG4NoxV5
         D7bcQ2nT7TPsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 50/74] serial: sh-sci: fix break handling for sysrq
Date:   Thu,  9 Sep 2021 07:57:02 -0400
Message-Id: <20210909115726.149004-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index db5b11879910..6f44c5f0ef3a 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1750,6 +1750,10 @@ static irqreturn_t sci_br_interrupt(int irq, void *ptr)
 
 	/* Handle BREAKs */
 	sci_handle_breaks(port);
+
+	/* drop invalid character received before break was detected */
+	serial_port_in(port, SCxRDR);
+
 	sci_clear_SCxSR(port, SCxSR_BREAK_CLEAR(port));
 
 	return IRQ_HANDLED;
@@ -1829,7 +1833,8 @@ static irqreturn_t sci_mpxed_interrupt(int irq, void *ptr)
 		ret = sci_er_interrupt(irq, ptr);
 
 	/* Break Interrupt */
-	if ((ssr_status & SCxSR_BRK(port)) && err_enabled)
+	if (s->irqs[SCIx_ERI_IRQ] != s->irqs[SCIx_BRI_IRQ] &&
+	    (ssr_status & SCxSR_BRK(port)) && err_enabled)
 		ret = sci_br_interrupt(irq, ptr);
 
 	/* Overrun Interrupt */
-- 
2.30.2

