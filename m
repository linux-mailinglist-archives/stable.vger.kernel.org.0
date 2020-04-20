Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205A21B09DA
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgDTMmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgDTMmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A68320724;
        Mon, 20 Apr 2020 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386565;
        bh=DSUepHg9aX4y6qRmRkTuw/85pmvXZiSkSb8A/au42ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv5fXTsmwjOf6t4keXfUxwX6HXN36pWNoUllpuhsVhb850Br6chO1LEqJpiWLCDkQ
         g5btrQAuI4/lJcwRiHCiFFHRev9Ojlpz8a7KRuBncWakOF93/iF3pby7VpGJ7wkINj
         9pW8nXyJNytURYzmMIwW43Hehdp/JvByJnc3niuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 01/71] amd-xgbe: Use __napi_schedule() in BH context
Date:   Mon, 20 Apr 2020 14:38:15 +0200
Message-Id: <20200420121508.772314251@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit d518691cbd3be3dae218e05cca3f3fc9b2f1aa77 ]

The driver uses __napi_schedule_irqoff() which is fine as long as it is
invoked with disabled interrupts by everybody. Since the commit
mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
context. This may lead to list corruption if another driver uses
__napi_schedule_irqoff() in IRQ context.

Use __napi_schedule() which safe to use from IRQ and softirq context.

Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -514,7 +514,7 @@ static void xgbe_isr_task(unsigned long
 				xgbe_disable_rx_tx_ints(pdata);
 
 				/* Turn on polling */
-				__napi_schedule_irqoff(&pdata->napi);
+				__napi_schedule(&pdata->napi);
 			}
 		} else {
 			/* Don't clear Rx/Tx status if doing per channel DMA


