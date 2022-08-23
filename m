Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6359D518
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346817AbiHWImk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347540AbiHWIk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9B778BC2;
        Tue, 23 Aug 2022 01:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C47FB612FE;
        Tue, 23 Aug 2022 08:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98A3C433D6;
        Tue, 23 Aug 2022 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242749;
        bh=8S/L+ko8PXRVOng3sXlH05A8J8sOawPha2jooEBcrs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00FyDqoRLlOqdoOgfzVtfU4MjoOJQhBZ5jNud2bgWLXQv2hZuu5SuuxBfCON9oW3r
         EGlKEdobpoDwNoVWqBk30y9TQWhxZsMBZBhBKyzWZgPCzU1lvanYzLyfdwX4fsl6/V
         DobmzqDj4MYqRXAWFB250yq4VK45bDpVKxKTS45U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.19 188/365] netfilter: nfnetlink: re-enable conntrack expectation events
Date:   Tue, 23 Aug 2022 10:01:29 +0200
Message-Id: <20220823080126.092950775@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 0b2f3212b551a87fe936701fa0813032861a3308 upstream.

To avoid allocation of the conntrack extension area when possible,
the default behaviour was changed to only allocate the event extension
if a userspace program is subscribed to a notification group.

Problem is that while 'conntrack -E' does enable the event allocation
behind the scenes, 'conntrack -E expect' does not: no expectation events
are delivered unless user sets
"net.netfilter.nf_conntrack_events" back to 1 (always on).

Fix the autodetection to also consider EXP type group.

We need to track the 6 event groups (3+3, new/update/destroy for events and
for expectations each) independently, else we'd disable events again
if an expectation group becomes empty while there is still an active
event group.

Fixes: 2794cdb0b97b ("netfilter: nfnetlink: allow to detect if ctnetlink listeners exist")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netns/conntrack.h |    2 -
 net/netfilter/nfnetlink.c     |   83 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 72 insertions(+), 13 deletions(-)

--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,7 +95,7 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	bool ctnetlink_has_listener;
+	u8 ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -44,6 +44,10 @@ MODULE_DESCRIPTION("Netfilter messages v
 
 static unsigned int nfnetlink_pernet_id __read_mostly;
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+static DEFINE_SPINLOCK(nfnl_grp_active_lock);
+#endif
+
 struct nfnl_net {
 	struct sock *nfnl;
 };
@@ -654,6 +658,44 @@ static void nfnetlink_rcv(struct sk_buff
 		netlink_rcv_skb(skb, nfnetlink_rcv_msg);
 }
 
+static void nfnetlink_bind_event(struct net *net, unsigned int group)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	int type, group_bit;
+	u8 v;
+
+	/* All NFNLGRP_CONNTRACK_* group bits fit into u8.
+	 * The other groups are not relevant and can be ignored.
+	 */
+	if (group >= 8)
+		return;
+
+	type = nfnl_group2type[group];
+
+	switch (type) {
+	case NFNL_SUBSYS_CTNETLINK:
+		break;
+	case NFNL_SUBSYS_CTNETLINK_EXP:
+		break;
+	default:
+		return;
+	}
+
+	group_bit = (1 << group);
+
+	spin_lock(&nfnl_grp_active_lock);
+	v = READ_ONCE(net->ct.ctnetlink_has_listener);
+	if ((v & group_bit) == 0) {
+		v |= group_bit;
+
+		/* read concurrently without nfnl_grp_active_lock held. */
+		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+	}
+
+	spin_unlock(&nfnl_grp_active_lock);
+#endif
+}
+
 static int nfnetlink_bind(struct net *net, int group)
 {
 	const struct nfnetlink_subsystem *ss;
@@ -670,28 +712,45 @@ static int nfnetlink_bind(struct net *ne
 	if (!ss)
 		request_module_nowait("nfnetlink-subsys-%d", type);
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	if (type == NFNL_SUBSYS_CTNETLINK) {
-		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
-		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
-	}
-#endif
+	nfnetlink_bind_event(net, group);
 	return 0;
 }
 
 static void nfnetlink_unbind(struct net *net, int group)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+	int type, group_bit;
+
 	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
 		return;
 
-	if (nfnl_group2type[group] == NFNL_SUBSYS_CTNETLINK) {
-		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-		if (!nfnetlink_has_listeners(net, group))
-			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
-		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+	type = nfnl_group2type[group];
+
+	switch (type) {
+	case NFNL_SUBSYS_CTNETLINK:
+		break;
+	case NFNL_SUBSYS_CTNETLINK_EXP:
+		break;
+	default:
+		return;
+	}
+
+	/* ctnetlink_has_listener is u8 */
+	if (group >= 8)
+		return;
+
+	group_bit = (1 << group);
+
+	spin_lock(&nfnl_grp_active_lock);
+	if (!nfnetlink_has_listeners(net, group)) {
+		u8 v = READ_ONCE(net->ct.ctnetlink_has_listener);
+
+		v &= ~group_bit;
+
+		/* read concurrently without nfnl_grp_active_lock held. */
+		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
 	}
+	spin_unlock(&nfnl_grp_active_lock);
 #endif
 }
 


