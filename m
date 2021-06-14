Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A333A60C7
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhFNKhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhFNKf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BBBF613F9;
        Mon, 14 Jun 2021 10:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666766;
        bh=8cI2GQCcwiWpUNYxwfjD/OlLtOwURrfsWRh5piUmkvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr+R8/IgtKBYP6vg6+QGclTcVr4U9yUombL1SqxahEDnQ9t+7nShQHsGzxXbLA8mm
         LNpgXS9hwud3hbFDeuAFffiWQdXRhu7T4YlCLBv3nvoWJGs6PG+rVxF/0GZa3V6qWM
         DNAav88k9UfPHKftrSlCAFpLjvPY8KX4PWEZ5sc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/49] netlink: disable IRQs for netlink_lock_table()
Date:   Mon, 14 Jun 2021 12:26:59 +0200
Message-Id: <20210614102642.072102725@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1d482e666b8e74c7555dbdfbfb77205eeed3ff2d ]

Syzbot reports that in mac80211 we have a potential deadlock
between our "local->stop_queue_reasons_lock" (spinlock) and
netlink's nl_table_lock (rwlock). This is because there's at
least one situation in which we might try to send a netlink
message with this spinlock held while it is also possible to
take the spinlock from a hardirq context, resulting in the
following deadlock scenario reported by lockdep:

       CPU0                    CPU1
       ----                    ----
  lock(nl_table_lock);
                               local_irq_disable();
                               lock(&local->queue_stop_reason_lock);
                               lock(nl_table_lock);
  <Interrupt>
    lock(&local->queue_stop_reason_lock);

This seems valid, we can take the queue_stop_reason_lock in
any kind of context ("CPU0"), and call ieee80211_report_ack_skb()
with the spinlock held and IRQs disabled ("CPU1") in some
code path (ieee80211_do_stop() via ieee80211_free_txskb()).

Short of disallowing netlink use in scenarios like these
(which would be rather complex in mac80211's case due to
the deep callchain), it seems the only fix for this is to
disable IRQs while nl_table_lock is held to avoid hitting
this scenario, this disallows the "CPU0" portion of the
reported deadlock.

Note that the writer side (netlink_table_grab()) already
disables IRQs for this lock.

Unfortunately though, this seems like a huge hammer, and
maybe the whole netlink table locking should be reworked.

Reported-by: syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3e4e07559272..140bec3568ec 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -429,11 +429,13 @@ void netlink_table_ungrab(void)
 static inline void
 netlink_lock_table(void)
 {
+	unsigned long flags;
+
 	/* read_lock() synchronizes us to netlink_table_grab */
 
-	read_lock(&nl_table_lock);
+	read_lock_irqsave(&nl_table_lock, flags);
 	atomic_inc(&nl_table_users);
-	read_unlock(&nl_table_lock);
+	read_unlock_irqrestore(&nl_table_lock, flags);
 }
 
 static inline void
-- 
2.30.2



