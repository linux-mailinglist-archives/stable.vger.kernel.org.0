Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D6B1EF22
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfEOLaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731730AbfEOLaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEAB20843;
        Wed, 15 May 2019 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919815;
        bh=65IKoUZNXVPF67/475Vnhey3/pmbGHM3rpBodDdc3BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqQr+gTJ0VVkLoVKA6dDDXSqFS5xCS2tq+9Hw7yOGOtDgI07OXrZ6LXDo4HRikThs
         y+Rra0eeP6/h1h8HeNIFbIpwloERwnUEcZ7klNmwuVXIjxGiJEHUvXVxZ8r5Nb7tYu
         3E2T4op6Waoc3WTSfpVraXWm55FqMCeol1bhe5I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Michal Soltys <soltys@ziu.info>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 077/137] netfilter: never get/set skb->tstamp
Date:   Wed, 15 May 2019 12:55:58 +0200
Message-Id: <20190515090659.027066676@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 916f6efae62305796e012e7c3a7884a267cbacbf ]

setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
but fq expects CLOCK_MONOTONIC.

This patch removes all places in netfilter that check/set skb->tstamp:

1. To fix the bogus "start" time seen with conntrack timestamping for
   outgoing packets, never use skb->tstamp and always use current time.
2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
   as determined by current hook (prerouting, input, forward).
3. xt_time has to use system clock as well rather than skb->tstamp.
   We could still use skb->tstamp for prerouting/input/foward, but
   I see no advantage to make this conditional.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c |  7 ++-----
 net/netfilter/nfnetlink_log.c     |  2 +-
 net/netfilter/nfnetlink_queue.c   |  2 +-
 net/netfilter/xt_time.c           | 23 ++++++++++++++---------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1982faf21ebb5..d7ac2f82bb6d8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -983,12 +983,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 	/* set conntrack timestamp, if enabled. */
 	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp) {
-		if (skb->tstamp == 0)
-			__net_timestamp(skb);
+	if (tstamp)
+		tstamp->start = ktime_get_real_ns();
 
-		tstamp->start = ktime_to_ns(skb->tstamp);
-	}
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
 	 * guarantee that no other CPU can find the conntrack before the above
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b1f9c5303f026..0b3347570265c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -540,7 +540,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 	}
 
-	if (skb->tstamp) {
+	if (hooknum <= NF_INET_FORWARD && skb->tstamp) {
 		struct nfulnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
 		ts.sec = cpu_to_be64(kts.tv_sec);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0dcc3592d053f..e057b2961d313 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -582,7 +582,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (nfqnl_put_bridge(entry, skb) < 0)
 		goto nla_put_failure;
 
-	if (entskb->tstamp) {
+	if (entry->state.hook <= NF_INET_FORWARD && entskb->tstamp) {
 		struct nfqnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(entskb->tstamp);
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index c13bcd0ab4913..8dbb4d48f2ed5 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -163,19 +163,24 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	s64 stamp;
 
 	/*
-	 * We cannot use get_seconds() instead of __net_timestamp() here.
+	 * We need real time here, but we can neither use skb->tstamp
+	 * nor __net_timestamp().
+	 *
+	 * skb->tstamp and skb->skb_mstamp_ns overlap, however, they
+	 * use different clock types (real vs monotonic).
+	 *
 	 * Suppose you have two rules:
-	 * 	1. match before 13:00
-	 * 	2. match after 13:00
+	 *	1. match before 13:00
+	 *	2. match after 13:00
+	 *
 	 * If you match against processing time (get_seconds) it
 	 * may happen that the same packet matches both rules if
-	 * it arrived at the right moment before 13:00.
+	 * it arrived at the right moment before 13:00, so it would be
+	 * better to check skb->tstamp and set it via __net_timestamp()
+	 * if needed.  This however breaks outgoing packets tx timestamp,
+	 * and causes them to get delayed forever by fq packet scheduler.
 	 */
-	if (skb->tstamp == 0)
-		__net_timestamp((struct sk_buff *)skb);
-
-	stamp = ktime_to_ns(skb->tstamp);
-	stamp = div_s64(stamp, NSEC_PER_SEC);
+	stamp = get_seconds();
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
-- 
2.20.1



