Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F3F33BABB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhCOOKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232538AbhCON7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3666264F16;
        Mon, 15 Mar 2021 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816726;
        bh=voN5GC2jBVqqyGZqVEMLRnsVMzQyPZ27Qf1ySvlWgEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FThO0avml35lrGCaxgWNGsKHcLx5cM79GBatffaDyCpq17VCeRj4RRTfl5fJNziZC
         Y3bmlZD/XQo7H9vR/T6Hiu/6wrF5EDs1eV2lIgHolE73IZaOmCx45y/3iwvuUeAwm6
         Et1AXqIGgPniykuzJGIuqbHGoCpC+JgFgMmBaCZg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 030/120] net: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Mon, 15 Mar 2021 14:56:21 +0100
Message-Id: <20210315135720.975291411@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit c511819d138de38e1637eedb645c207e09680d0f upstream.

stmmac_xmit() call stmmac_tx_timer_arm() at the end to modify tx timer to
do the transmission cleanup work. Imagine such a situation, stmmac enters
suspend immediately after tx timer modified, it's expire callback
stmmac_tx_clean() would not be invoked. This could affect BQL, since
netdev_tx_sent_queue() has been called, but netdev_tx_completed_queue()
have not been involved, as a result, dql_avail(&dev_queue->dql) finally
always return a negative value.

__dev_queue_xmit->__dev_xmit_skb->qdisc_run->__qdisc_run->qdisc_restart->dequeue_skb:
	if ((q->flags & TCQ_F_ONETXQUEUE) &&
		netif_xmit_frozen_or_stopped(txq)) // __QUEUE_STATE_STACK_XOFF is set

Net core will stop transmitting any more. Finillay, net watchdong would timeout.
To fix this issue, we should call netdev_tx_reset_queue() in stmmac_resume().

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4566,6 +4566,8 @@ static void stmmac_reset_queues_param(st
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 


