Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C546E6494
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjDRMuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjDRMuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF015456
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609C56340D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F40CC4339B;
        Tue, 18 Apr 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822219;
        bh=V26JAyjDdHgLN/TnIpmRp3OAKzkjGSrx7oEYO2sxNGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vp6xV8ZT3gRzjvouenAipYUcPiSQ9+FTqsu9M7RyPLEBxAUC63ii6Ig4qbwhehHKp
         YvivOA4MjCvrFgt0KYIeU9yA1B1lG6ZzolRs0h1W6IpFJsOHoiGNZJQ8d6ZsKWGfXy
         KDbJbA1/K6rOSNM9pvD+oi3YuT/mPzp91eTxX/8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin Willi <martin@strongswan.org>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 066/139] rtnetlink: Restore RTM_NEW/DELLINK notification behavior
Date:   Tue, 18 Apr 2023 14:22:11 +0200
Message-Id: <20230418120316.297576918@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit 59d3efd27c11c59b32291e5ebc307bed2edb65ee ]

The commits referenced below allows userspace to use the NLM_F_ECHO flag
for RTM_NEW/DELLINK operations to receive unicast notifications for the
affected link. Prior to these changes, applications may have relied on
multicast notifications to learn the same information without specifying
the NLM_F_ECHO flag.

For such applications, the mentioned commits changed the behavior for
requests not using NLM_F_ECHO. Multicast notifications are still received,
but now use the portid of the requester and the sequence number of the
request instead of zero values used previously. For the application, this
message may be unexpected and likely handled as a response to the
NLM_F_ACKed request, especially if it uses the same socket to handle
requests and notifications.

To fix existing applications relying on the old notification behavior,
set the portid and sequence number in the notification only if the
request included the NLM_F_ECHO flag. This restores the old behavior
for applications not using it, but allows unicasted notifications for
others.

Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
Signed-off-by: Martin Willi <martin@strongswan.org>
Acked-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20230411074319.24133-1-martin@strongswan.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h |  3 ++-
 net/core/dev.c            |  2 +-
 net/core/rtnetlink.c      | 11 +++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 92ad75549e9cd..b6e6378dcbbd7 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -25,7 +25,8 @@ void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned change, u32 event,
 				       gfp_t flags, int *new_nsid,
-				       int new_ifindex, u32 portid, u32 seq);
+				       int new_ifindex, u32 portid,
+				       const struct nlmsghdr *nlh);
 void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
 		       gfp_t flags, u32 portid, const struct nlmsghdr *nlh);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 127815273ce3c..404125e7a57a5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10837,7 +10837,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
 						     GFP_KERNEL, NULL, 0,
-						     portid, nlmsg_seq(nlh));
+						     portid, nlh);
 
 		/*
 		 *	Flush the unicast and multicast chains
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 64289bc988878..f5114b2395ae3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3939,16 +3939,23 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned int change,
 				       u32 event, gfp_t flags, int *new_nsid,
-				       int new_ifindex, u32 portid, u32 seq)
+				       int new_ifindex, u32 portid,
+				       const struct nlmsghdr *nlh)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
+	u32 seq = 0;
 
 	skb = nlmsg_new(if_nlmsg_size(dev, 0), flags);
 	if (skb == NULL)
 		goto errout;
 
+	if (nlmsg_report(nlh))
+		seq = nlmsg_seq(nlh);
+	else
+		portid = 0;
+
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, portid, seq, change, 0, 0, event,
 			       new_nsid, new_ifindex, -1, flags);
@@ -3984,7 +3991,7 @@ static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 		return;
 
 	skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
-				     new_ifindex, portid, nlmsg_seq(nlh));
+				     new_ifindex, portid, nlh);
 	if (skb)
 		rtmsg_ifinfo_send(skb, dev, flags, portid, nlh);
 }
-- 
2.39.2



