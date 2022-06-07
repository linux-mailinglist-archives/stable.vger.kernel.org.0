Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F3541576
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376470AbiFGUgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377786AbiFGUeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A35B1E73DE;
        Tue,  7 Jun 2022 11:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D3DB8237B;
        Tue,  7 Jun 2022 18:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D2FC385A2;
        Tue,  7 Jun 2022 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626956;
        bh=MU2+vNNvD/C4Et7c0mjGwxnPA8RogRxCydOV6Jl+oY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzWgxKGChLMGJu3K3KCSgxdPwcCj86nbPlKNcxQCBcHTW88lhD/O8mgy9+Sxc1IrG
         NCLIf1XRFqj4ynQmY+l0BqJA3+wxE+xvxqYK8p3zTUUtt5f4AsobZnqNkqHyi6OAO3
         L1Nu/Xmk6MC36nWf4oidvvFPhwhHGGeRnLIyAtpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20Ard=C3=B6?= <bjorn.ardo@axis.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 558/772] mailbox: forward the hrtimer if not queued and under a lock
Date:   Tue,  7 Jun 2022 19:02:30 +0200
Message-Id: <20220607165005.402323026@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Ardö <bjorn.ardo@axis.com>

[ Upstream commit bca1a1004615efe141fd78f360ecc48c60bc4ad5 ]

This reverts commit c7dacf5b0f32957b24ef29df1207dc2cd8307743,
"mailbox: avoid timer start from callback"

The previous commit was reverted since it lead to a race that
caused the hrtimer to not be started at all. The check for
hrtimer_active() in msg_submit() will return true if the
callback function txdone_hrtimer() is currently running. This
function could return HRTIMER_NORESTART and then the timer
will not be restarted, and also msg_submit() will not start
the timer. This will lead to a message actually being submitted
but no timer will start to check for its compleation.

The original fix that added checking hrtimer_active() was added to
avoid a warning with hrtimer_forward. Looking in the kernel
another solution to avoid this warning is to check hrtimer_is_queued()
before calling hrtimer_forward_now() instead. This however requires a
lock so the timer is not started by msg_submit() inbetween this check
and the hrtimer_forward() call.

Fixes: c7dacf5b0f32 ("mailbox: avoid timer start from callback")
Signed-off-by: Björn Ardö <bjorn.ardo@axis.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c          | 19 +++++++++++++------
 include/linux/mailbox_controller.h |  1 +
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 3e7d4b20ab34..4229b9b5da98 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -82,11 +82,11 @@ static void msg_submit(struct mbox_chan *chan)
 exit:
 	spin_unlock_irqrestore(&chan->lock, flags);
 
-	/* kick start the timer immediately to avoid delays */
 	if (!err && (chan->txdone_method & TXDONE_BY_POLL)) {
-		/* but only if not already active */
-		if (!hrtimer_active(&chan->mbox->poll_hrt))
-			hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+		/* kick start the timer immediately to avoid delays */
+		spin_lock_irqsave(&chan->mbox->poll_hrt_lock, flags);
+		hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+		spin_unlock_irqrestore(&chan->mbox->poll_hrt_lock, flags);
 	}
 }
 
@@ -120,20 +120,26 @@ static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
 		container_of(hrtimer, struct mbox_controller, poll_hrt);
 	bool txdone, resched = false;
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < mbox->num_chans; i++) {
 		struct mbox_chan *chan = &mbox->chans[i];
 
 		if (chan->active_req && chan->cl) {
-			resched = true;
 			txdone = chan->mbox->ops->last_tx_done(chan);
 			if (txdone)
 				tx_tick(chan, 0);
+			else
+				resched = true;
 		}
 	}
 
 	if (resched) {
-		hrtimer_forward_now(hrtimer, ms_to_ktime(mbox->txpoll_period));
+		spin_lock_irqsave(&mbox->poll_hrt_lock, flags);
+		if (!hrtimer_is_queued(hrtimer))
+			hrtimer_forward_now(hrtimer, ms_to_ktime(mbox->txpoll_period));
+		spin_unlock_irqrestore(&mbox->poll_hrt_lock, flags);
+
 		return HRTIMER_RESTART;
 	}
 	return HRTIMER_NORESTART;
@@ -500,6 +506,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 		hrtimer_init(&mbox->poll_hrt, CLOCK_MONOTONIC,
 			     HRTIMER_MODE_REL);
 		mbox->poll_hrt.function = txdone_hrtimer;
+		spin_lock_init(&mbox->poll_hrt_lock);
 	}
 
 	for (i = 0; i < mbox->num_chans; i++) {
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index 36d6ce673503..6fee33cb52f5 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -83,6 +83,7 @@ struct mbox_controller {
 				      const struct of_phandle_args *sp);
 	/* Internal to API */
 	struct hrtimer poll_hrt;
+	spinlock_t poll_hrt_lock;
 	struct list_head node;
 };
 
-- 
2.35.1



