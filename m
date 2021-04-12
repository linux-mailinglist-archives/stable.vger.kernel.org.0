Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08635BC9C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbhDLIoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237103AbhDLIn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E363961220;
        Mon, 12 Apr 2021 08:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217021;
        bh=gBK3iylDQrckbLEAA2FRdPbgaHvMrUPheHbwqgJW+bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRcCwyfb49FN9esW7XMjD795dBpjd3pUt2aUZhrBA75EHIpEeyExtuvaZTWWAElJo
         2V1PGre8Wzpl1xSjPeF8zwL6J29Ipt5zwht0C/v6s6pL4dNbgNKOp2tfYmsZZfIPpm
         6qChQp7ZaEXQF3lEbHKP3cKSw75Ce39WP3AkyuvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milton Miller <miltonm@us.ibm.com>,
        Eddie James <eajames@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/66] net/ncsi: Avoid channel_monitor hrtimer deadlock
Date:   Mon, 12 Apr 2021 10:40:47 +0200
Message-Id: <20210412083959.452160115@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milton Miller <miltonm@us.ibm.com>

[ Upstream commit 03cb4d05b4ea9a3491674ca40952adb708d549fa ]

Calling ncsi_stop_channel_monitor from channel_monitor is a guaranteed
deadlock on SMP because stop calls del_timer_sync on the timer that
invoked channel_monitor as its timer function.

Recognise the inherent race of marking the monitor disabled before
deleting the timer by just returning if enable was cleared.  After
a timeout (the default case -- reset to START when response received)
just mark the monitor.enabled false.

If the channel has an entry on the channel_queue list, or if the
state is not ACTIVE or INACTIVE, then warn and mark the timer stopped
and don't restart, as the locking is broken somehow.

Fixes: 0795fb2021f0 ("net/ncsi: Stop monitor if channel times out or is inactive")
Signed-off-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-manage.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index f65afa7e7d28..9fd20fa90000 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -84,13 +84,20 @@ static void ncsi_channel_monitor(struct timer_list *t)
 	monitor_state = nc->monitor.state;
 	spin_unlock_irqrestore(&nc->lock, flags);
 
-	if (!enabled || chained) {
-		ncsi_stop_channel_monitor(nc);
-		return;
-	}
+	if (!enabled)
+		return;		/* expected race disabling timer */
+	if (WARN_ON_ONCE(chained))
+		goto bad_state;
+
 	if (state != NCSI_CHANNEL_INACTIVE &&
 	    state != NCSI_CHANNEL_ACTIVE) {
-		ncsi_stop_channel_monitor(nc);
+bad_state:
+		netdev_warn(ndp->ndev.dev,
+			    "Bad NCSI monitor state channel %d 0x%x %s queue\n",
+			    nc->id, state, chained ? "on" : "off");
+		spin_lock_irqsave(&nc->lock, flags);
+		nc->monitor.enabled = false;
+		spin_unlock_irqrestore(&nc->lock, flags);
 		return;
 	}
 
@@ -117,10 +124,9 @@ static void ncsi_channel_monitor(struct timer_list *t)
 			ndp->flags |= NCSI_DEV_RESHUFFLE;
 		}
 
-		ncsi_stop_channel_monitor(nc);
-
 		ncm = &nc->modes[NCSI_MODE_LINK];
 		spin_lock_irqsave(&nc->lock, flags);
+		nc->monitor.enabled = false;
 		nc->state = NCSI_CHANNEL_INVISIBLE;
 		ncm->data[2] &= ~0x1;
 		spin_unlock_irqrestore(&nc->lock, flags);
-- 
2.30.2



