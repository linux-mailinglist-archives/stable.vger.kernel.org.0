Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEB54CF8E8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiCGKCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbiCGKBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E05DA6E;
        Mon,  7 Mar 2022 01:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 772DCB810DE;
        Mon,  7 Mar 2022 09:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5FDC36AF5;
        Mon,  7 Mar 2022 09:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646639;
        bh=/5pjPf/Q167xASu8frBTkFDu0yqWHL7d+R+n4kIFb0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RP1D4IJhO5FR6dtpv2LEWoKGYwBkcce3KzFVXO0jXFRxGGJ48CZJvtShL8fEtyQ1V
         RqYPo36JI+gFzqh8ZBXRfQum06GHW/d+jl78PFap9CSETBr/cVhdTz4Ve+/dsleK7s
         dZyrLxwVjxUL/YT+i/R7DTeUVLo/GJ2N6UUZ4IxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 045/186] ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
Date:   Mon,  7 Mar 2022 10:18:03 +0100
Message-Id: <20220307091655.355746704@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d3916f3189172d5c69d33065c3c21119fe539fc ]

While investigating on why a synchronize_net() has been added recently
in ipv6_mc_down(), I found that igmp6_event_query() and igmp6_event_report()
might drop skbs in some cases.

Discussion about removing synchronize_net() from ipv6_mc_down()
will happen in a different thread.

Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220303173728.937869-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ndisc.h |  4 ++--
 net/ipv6/mcast.c    | 32 ++++++++++++--------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 04341d86585de..5e37e58586796 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -487,9 +487,9 @@ int igmp6_late_init(void);
 void igmp6_cleanup(void);
 void igmp6_late_cleanup(void);
 
-int igmp6_event_query(struct sk_buff *skb);
+void igmp6_event_query(struct sk_buff *skb);
 
-int igmp6_event_report(struct sk_buff *skb);
+void igmp6_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index a8861db52c187..909f937befd71 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1371,27 +1371,23 @@ static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_query(struct sk_buff *skb)
+void igmp6_event_query(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_query_lock);
 	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_query_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_query_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_query_work(struct sk_buff *skb)
@@ -1542,27 +1538,23 @@ static void mld_query_work(struct work_struct *work)
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_report(struct sk_buff *skb)
+void igmp6_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_report_lock);
 	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_report_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_report_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_report_work(struct sk_buff *skb)
-- 
2.34.1



