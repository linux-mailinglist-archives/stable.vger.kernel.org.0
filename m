Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86EF7EEC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfKKShR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbfKKShR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA7B204FD;
        Mon, 11 Nov 2019 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497436;
        bh=qQ5L4rfGHyWCFEcxEHYJAqF8P0ll5C/kHsoR9YbzQ1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvsbFIkdQJ1k0jeuqUcch/lnrUDLFqTXIadVeMse7q1dK6kxA4XWqJLn0KUGhdFtK
         MILE9n1i54wTj+ZebmkOKlkv+c4kSlby36QibIKO32ZXQyhf8Dkl5Nn8wFT/lXxcTq
         ZQxLDjLOIX1KS0NGX8UikGj5NZIyXwBOoFk+hjls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Klimov <alexey.klimov@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 054/105] mailbox: reset txdone_method TXDONE_BY_POLL if client knows_txdone
Date:   Mon, 11 Nov 2019 19:28:24 +0100
Message-Id: <20191111181443.524703978@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 33cd7123ac0ba5360656ae27db453de5b9aa711f upstream

Currently the mailbox framework sets txdone_method to TXDONE_BY_POLL if
the controller sets txdone_by_poll. However some clients can have a
mechanism to do TXDONE_BY_ACK which they can specify by knows_txdone.
However, we endup setting both TXDONE_BY_POLL and TXDONE_BY_ACK in that
case. In such scenario, we may end up with below warnings as the tx
ticker is run both by mailbox framework and the client.

WARNING: CPU: 1 PID: 0 at kernel/time/hrtimer.c:805 hrtimer_forward+0x88/0xd8
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.12.0-rc5 #242
Hardware name: ARM LTD ARM Juno Development Platform
task: ffff8009768ca700 task.stack: ffff8009768f8000
PC is at hrtimer_forward+0x88/0xd8
LR is at txdone_hrtimer+0xd4/0xf8
Call trace:
 hrtimer_forward+0x88/0xd8
 __hrtimer_run_queues+0xe4/0x158
 hrtimer_interrupt+0xa4/0x220
 arch_timer_handler_phys+0x30/0x40
 handle_percpu_devid_irq+0x78/0x130
 generic_handle_irq+0x24/0x38
 __handle_domain_irq+0x5c/0xb8
 gic_handle_irq+0x54/0xa8

This patch fixes the issue by resetting TXDONE_BY_POLL if client has set
knows_txdone.

Cc: Alexey Klimov <alexey.klimov@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/mailbox.c |    4 ++--
 drivers/mailbox/pcc.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -351,7 +351,7 @@ struct mbox_chan *mbox_request_channel(s
 	init_completion(&chan->tx_complete);
 
 	if (chan->txdone_method	== TXDONE_BY_POLL && cl->knows_txdone)
-		chan->txdone_method |= TXDONE_BY_ACK;
+		chan->txdone_method = TXDONE_BY_ACK;
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 
@@ -420,7 +420,7 @@ void mbox_free_channel(struct mbox_chan
 	spin_lock_irqsave(&chan->lock, flags);
 	chan->cl = NULL;
 	chan->active_req = NULL;
-	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
 	module_put(chan->mbox->dev->driver->owner);
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -266,7 +266,7 @@ struct mbox_chan *pcc_mbox_request_chann
 	init_completion(&chan->tx_complete);
 
 	if (chan->txdone_method == TXDONE_BY_POLL && cl->knows_txdone)
-		chan->txdone_method |= TXDONE_BY_ACK;
+		chan->txdone_method = TXDONE_BY_ACK;
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 
@@ -312,7 +312,7 @@ void pcc_mbox_free_channel(struct mbox_c
 	spin_lock_irqsave(&chan->lock, flags);
 	chan->cl = NULL;
 	chan->active_req = NULL;
-	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
 	spin_unlock_irqrestore(&chan->lock, flags);


