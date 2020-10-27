Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26AF29B274
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762200AbgJ0Ol1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761725AbgJ0OkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:40:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EF4120773;
        Tue, 27 Oct 2020 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809614;
        bh=y0GFApQjWZe2gHBjOjdI0yRNIDYlQa3AZzDzTjZdvoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDBeBir/X32T91M5PRG6rASIvXUNa5Scsk8fD5XhmyydG9QpDrOP4aJUX7ayIfhHJ
         SBpdiOm1nbTSaUdfZM9lOO1SlTgHKPkDUAKTdhfgQdj+eCS9wTV7ynze2ZHrr4u75u
         xxzQwl5roS2t0wmH7Uw1hFmj0L0rj/YkyRXuUWIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Da Xue <da@libre.computer>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/408] mailbox: avoid timer start from callback
Date:   Tue, 27 Oct 2020 14:53:17 +0100
Message-Id: <20201027135507.056604428@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jassi Brar <jaswinder.singh@linaro.org>

[ Upstream commit c7dacf5b0f32957b24ef29df1207dc2cd8307743 ]

If the txdone is done by polling, it is possible for msg_submit() to start
the timer while txdone_hrtimer() callback is running. If the timer needs
recheduling, it could already be enqueued by the time hrtimer_forward_now()
is called, leading hrtimer to loudly complain.

WARNING: CPU: 3 PID: 74 at kernel/time/hrtimer.c:932 hrtimer_forward+0xc4/0x110
CPU: 3 PID: 74 Comm: kworker/u8:1 Not tainted 5.9.0-rc2-00236-gd3520067d01c-dirty #5
Hardware name: Libre Computer AML-S805X-AC (DT)
Workqueue: events_freezable_power_ thermal_zone_device_check
pstate: 20000085 (nzCv daIf -PAN -UAO BTYPE=--)
pc : hrtimer_forward+0xc4/0x110
lr : txdone_hrtimer+0xf8/0x118
[...]

This can be fixed by not starting the timer from the callback path. Which
requires the timer reloading as long as any message is queued on the
channel, and not just when current tx is not done yet.

Fixes: 0cc67945ea59 ("mailbox: switch to hrtimer for tx_complete polling")
Reported-by: Da Xue <da@libre.computer>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 0b821a5b2db84..3e7d4b20ab34f 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -82,9 +82,12 @@ static void msg_submit(struct mbox_chan *chan)
 exit:
 	spin_unlock_irqrestore(&chan->lock, flags);
 
-	if (!err && (chan->txdone_method & TXDONE_BY_POLL))
-		/* kick start the timer immediately to avoid delays */
-		hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+	/* kick start the timer immediately to avoid delays */
+	if (!err && (chan->txdone_method & TXDONE_BY_POLL)) {
+		/* but only if not already active */
+		if (!hrtimer_active(&chan->mbox->poll_hrt))
+			hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+	}
 }
 
 static void tx_tick(struct mbox_chan *chan, int r)
@@ -122,11 +125,10 @@ static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
 		struct mbox_chan *chan = &mbox->chans[i];
 
 		if (chan->active_req && chan->cl) {
+			resched = true;
 			txdone = chan->mbox->ops->last_tx_done(chan);
 			if (txdone)
 				tx_tick(chan, 0);
-			else
-				resched = true;
 		}
 	}
 
-- 
2.25.1



