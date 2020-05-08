Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C11CAECB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgEHMsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbgEHMr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73F6221F7;
        Fri,  8 May 2020 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942076;
        bh=1tUFM6fNGiDqtCHQbKjTGwJSyZBHktSvZBFVdBsQkYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh3QMsNop0zc3b4+YFrYG23DvWZJYPryeCwxNG014yHzaywwV54y8GUExBJ3aUC2Z
         8VbMomP0CJJXshX2aLEK0Lw1h1GzNBuxOOAT8ZtxNz1IWccDgL/pcfxf9HoJmHvPd7
         KHv4BE35xfn78EiwtHtHICSMT0x0NUTggbh9WkkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 288/312] net: macb: replace macb_writel() call by queue_writel() to update queue ISR
Date:   Fri,  8 May 2020 14:34:39 +0200
Message-Id: <20200508123144.643175909@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>

commit ba5049945421b8d2f3e2af786a15d13b82316503 upstream.

macb_interrupt() should not use macb_writel(bp, ISR, <value>) but only
queue_writel(queue, ISR, <value>).

There is one IRQ and one set of {ISR, IER, IDR, IMR} [1] registers per
queue on gem hardware, though only queue0 is actually used for now to
receive frames: other queues can already be used to transmit frames.

The queue_readl() and queue_writel() helper macros are designed to access
the relevant IRQ registers.

[1]
ISR: Interrupt Status Register
IER: Interrupt Enable Register
IDR: Interrupt Disable Register
IMR: Interrupt Mask Register

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Fixes: bfbb92c44670 ("net: macb: Handle the RXUBR interrupt on all devices")
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cadence/macb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1104,7 +1104,7 @@ static irqreturn_t macb_interrupt(int ir
 			macb_writel(bp, NCR, ctrl | MACB_BIT(RE));
 
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-				macb_writel(bp, ISR, MACB_BIT(RXUBR));
+				queue_writel(queue, ISR, MACB_BIT(RXUBR));
 		}
 
 		if (status & MACB_BIT(ISR_ROVR)) {


