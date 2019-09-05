Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78F9AA84D
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbfIEQSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41857 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388465AbfIEQSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so1524461pls.8
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8QjjqDFW2as8gsE3MNwHPLPN76USmssxyGkKOBC9D3E=;
        b=HL27V+NYul1f+O0bmc6YkYSMF5euNDbYJl3hh04CdtFtjxmvNCYdhhn4rVKZ4mtbnC
         haoz4ZuRykOa1EVcbKBLOnulQom5g/1qMM4K3pUJqI9gyl8+8M7gUP3hdV27jiyNhaLP
         o/VZfks/pnLsAsEemsNEwt2UAy9aH5QMHPRsXyteaLVX8yuXtIU8Q7J3Kt0GHRGIjeu+
         6uqwAVSO0rrjztAQNUcFDtt/AS9X6aQBAlsAr+yR2VeRxvHvm5f4PTxaab1YLr0ySVHa
         WGR7mnvK9yLWmfNAcVoLZFMGqTS8ZaLoVAcycwWbcXSXF16pUzOt3ohlbzYqLRrORRPt
         DjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8QjjqDFW2as8gsE3MNwHPLPN76USmssxyGkKOBC9D3E=;
        b=WrSuvHv2Q19YPC85OuOZRvszysJKjWIReEBFkNqotTBGWBVH7F/SGEElCLtj9Hlivc
         g32sFChfJiac1V3nLeInICDs0RPan6rjQhbQMcWkXEAfua/vEMK0+TosXovZBkxFJdw8
         h4fBnJeehHyVt9VkOB1QtXd+Zh7I6V+YOVMEqXefBh5KpmYLKnlVj4QU3kQTfNB0yETp
         fx15keUrbXslpqFZF6vqXZumy1kYsBMD/j8d+RVnXxZstgOISKu63RjiV0liAkrkfro3
         t+L4rtVKUkEq1pq/mXhHLdFnW6SZ2rU1/aEhqxh4jNdWdXBoqx8hQbJA8k2RqMGAGGof
         YTEg==
X-Gm-Message-State: APjAAAXsUO8MLVFo80Na+cTzHLRpNkalT4vnQFWJnJEBnRJamX2sMaKc
        kZWY2frtXODrxCXJgeZtTjqYG/vukDM=
X-Google-Smtp-Source: APXvYqyin58dfoGmkrcR+0oj6G4rVylfKjqkSHZX5WE/1JHerRC2GQAUjkfl3U9yKFWbfii5zbbXyA==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr4384259plo.240.1567700295503;
        Thu, 05 Sep 2019 09:18:15 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:14 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 12/18] mailbox: reset txdone_method TXDONE_BY_POLL if client knows_txdone
Date:   Thu,  5 Sep 2019 10:17:53 -0600
Message-Id: <20190905161759.28036-13-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
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
---
 drivers/mailbox/mailbox.c | 4 ++--
 drivers/mailbox/pcc.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 44b49a2676f0..055c90b8253c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -351,7 +351,7 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 	init_completion(&chan->tx_complete);
 
 	if (chan->txdone_method	== TXDONE_BY_POLL && cl->knows_txdone)
-		chan->txdone_method |= TXDONE_BY_ACK;
+		chan->txdone_method = TXDONE_BY_ACK;
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 
@@ -420,7 +420,7 @@ void mbox_free_channel(struct mbox_chan *chan)
 	spin_lock_irqsave(&chan->lock, flags);
 	chan->cl = NULL;
 	chan->active_req = NULL;
-	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
 	module_put(chan->mbox->dev->driver->owner);
diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 9b7005e1345e..27c2294be51a 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -266,7 +266,7 @@ struct mbox_chan *pcc_mbox_request_channel(struct mbox_client *cl,
 	init_completion(&chan->tx_complete);
 
 	if (chan->txdone_method == TXDONE_BY_POLL && cl->knows_txdone)
-		chan->txdone_method |= TXDONE_BY_ACK;
+		chan->txdone_method = TXDONE_BY_ACK;
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 
@@ -312,7 +312,7 @@ void pcc_mbox_free_channel(struct mbox_chan *chan)
 	spin_lock_irqsave(&chan->lock, flags);
 	chan->cl = NULL;
 	chan->active_req = NULL;
-	if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
+	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
 	spin_unlock_irqrestore(&chan->lock, flags);
-- 
2.17.1

