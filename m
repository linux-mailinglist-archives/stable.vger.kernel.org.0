Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF3582B84
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiG0QfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbiG0QeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFA654CBE;
        Wed, 27 Jul 2022 09:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFBC661A1E;
        Wed, 27 Jul 2022 16:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B35C433D6;
        Wed, 27 Jul 2022 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939190;
        bh=4a07L9FAYE6Hy2yov2eTzQtFHuUk6iOwB8T/ZXIwaEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBNyOCag7oJOH4C3PjZgwSP051CEMMSZGYPJxuqyRXGpOO/GGFjxr3I0kZK+A3fKc
         TCjP8YcdalBoZ+xYMYqjl1kXOiRMo/HR1L8vsg7EhLgxB0fKUq8tmSnN4SQ+vNRuJg
         Rl6GCtjj4sy4Frr1q4xcEd86jtBqeXnUegBwcSrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/62] igmp: Fix data-races around sysctl_igmp_llm_reports.
Date:   Wed, 27 Jul 2022 18:10:26 +0200
Message-Id: <20220727161004.870745121@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit f6da2267e71106474fbc0943dc24928b9cb79119 ]

While reading sysctl_igmp_llm_reports, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

This test can be packed into a helper, so such changes will be in the
follow-up series after net is merged into net-next.

  if (ipv4_is_local_multicast(pmc->multiaddr) &&
      !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))

Fixes: df2cf4a78e48 ("IGMP: Inhibit reports for local multicast groups")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index ee179e08dd20..957e1170a8a3 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -471,7 +471,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ip_mc_list *pmc,
 
 	if (pmc->multiaddr == IGMP_ALL_HOSTS)
 		return skb;
-	if (ipv4_is_local_multicast(pmc->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(pmc->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -597,7 +598,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			if (ipv4_is_local_multicast(pmc->multiaddr) &&
-			     !net->ipv4.sysctl_igmp_llm_reports)
+			    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 				continue;
 			spin_lock_bh(&pmc->lock);
 			if (pmc->sfcount[MCAST_EXCLUDE])
@@ -740,7 +741,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	if (type == IGMPV3_HOST_MEMBERSHIP_REPORT)
 		return igmpv3_send_report(in_dev, pmc);
 
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return 0;
 
 	if (type == IGMP_HOST_LEAVE_MESSAGE)
@@ -924,7 +926,8 @@ static bool igmp_heard_report(struct in_device *in_dev, __be32 group)
 
 	if (group == IGMP_ALL_HOSTS)
 		return false;
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return false;
 
 	rcu_read_lock();
@@ -1049,7 +1052,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 		spin_lock_bh(&im->lock);
 		if (im->tm_running)
@@ -1299,7 +1302,8 @@ static void igmp_group_dropped(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	reporter = im->reporter;
@@ -1336,7 +1340,8 @@ static void igmp_group_added(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	if (in_dev->dead)
@@ -1657,7 +1662,7 @@ static void ip_mc_rejoin_groups(struct in_device *in_dev)
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 
 		/* a failover is happening and switches
-- 
2.35.1



