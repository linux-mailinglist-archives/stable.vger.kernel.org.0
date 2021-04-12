Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF7435BE59
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbhDLI5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238260AbhDLIzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E5661019;
        Mon, 12 Apr 2021 08:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217733;
        bh=JrfsyBDZZnDZ7gqBeGjqgGHNYnLUNS8dYhXSv4eAzqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1xoyeX7ij/CavzxMYZAVBXConblfbvn3qj/CdBQc+TMjjL2X5xkzcLTGPKnv7Qde
         X6zPqU+1eowlTodDw9hf+qt9HhfIpkM9SHcmqWqEVx/MDSYR8lc126fPpyHSEARI1l
         O71QVtm59adWKh98eDjw7kGmSK4xBo3J/M5uudzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milton Miller <miltonm@us.ibm.com>,
        Eddie James <eajames@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/188] net/ncsi: Avoid channel_monitor hrtimer deadlock
Date:   Mon, 12 Apr 2021 10:40:39 +0200
Message-Id: <20210412084017.804040894@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index a9cb355324d1..ffff8da707b8 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -105,13 +105,20 @@ static void ncsi_channel_monitor(struct timer_list *t)
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
 
@@ -136,10 +143,9 @@ static void ncsi_channel_monitor(struct timer_list *t)
 		ncsi_report_link(ndp, true);
 		ndp->flags |= NCSI_DEV_RESHUFFLE;
 
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



