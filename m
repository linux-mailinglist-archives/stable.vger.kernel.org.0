Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D8C6B42F9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjCJOJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCJOI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D720A7DD39
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F570B822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF9EC433D2;
        Fri, 10 Mar 2023 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457308;
        bh=5RsrH0SoHdPRpxsqEvjNXkQpPKlHdLmZcp2Ggcc96dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IocZJDfEPSd9QjuxGexGthtBvebfminTgMn4OcS2E52UuS2CtuoUibpP1AaqaZGTM
         ONdF3f2zg5DNQUI46965c4Py819a3IHNLR5I7AFvWTDbQcgsjBbUMvX33zOpd5MxdC
         jY75EoJBfKsOd4jPzAMMaeQYaHnY9k3ZFmt4vWsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bryce Kahle <bryce.kahle@datadoghq.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/200] netfilter: ctnetlink: make event listener tracking global
Date:   Fri, 10 Mar 2023 14:37:52 +0100
Message-Id: <20230310133719.122515134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit fdf6491193e411087ae77bcbc6468e3e1cff99ed ]

pernet tracking doesn't work correctly because other netns might have
set NETLINK_LISTEN_ALL_NSID on its event socket.

In this case its expected that events originating in other net
namespaces are also received.

Making pernet-tracking work while also honoring NETLINK_LISTEN_ALL_NSID
requires much more intrusive changes both in netlink and nfnetlink,
f.e. adding a 'setsockopt' callback that lets nfnetlink know that the
event socket entered (or left) ALL_NSID mode.

Move to global tracking instead: if there is an event socket anywhere
on the system, all net namespaces which have conntrack enabled and
use autobind mode will allocate the ecache extension.

netlink_has_listeners() returns false only if the given group has no
subscribers in any net namespace, the 'net' argument passed to
nfnetlink_has_listeners is only used to derive the protocol (nfnetlink),
it has no other effect.

For proper NETLINK_LISTEN_ALL_NSID-aware pernet tracking of event
listeners a new netlink_has_net_listeners() is also needed.

Fixes: 90d1daa45849 ("netfilter: conntrack: add nf_conntrack_events autodetect mode")
Reported-by: Bryce Kahle <bryce.kahle@datadoghq.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h           | 5 +++++
 include/net/netns/conntrack.h       | 1 -
 net/netfilter/core.c                | 3 +++
 net/netfilter/nf_conntrack_ecache.c | 2 +-
 net/netfilter/nfnetlink.c           | 9 +++++----
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d8817d381c14b..bef8db9d6c085 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -488,4 +488,9 @@ extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
+/**
+ * Contains bitmask of ctnetlink event subscribers, if any.
+ * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
+ */
+extern u8 nf_ctnetlink_has_listener;
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e1290c159184a..1f463b3957c78 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,7 +95,6 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	u8 ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5a6705a0e4ecf..6e80f0f6149ea 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -669,6 +669,9 @@ const struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+u8 nf_ctnetlink_has_listener;
+EXPORT_SYMBOL_GPL(nf_ctnetlink_has_listener);
+
 const struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 8698b34246460..69948e1d6974e 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -309,7 +309,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 			break;
 		return true;
 	case 2: /* autodetect: no event listener, don't allocate extension. */
-		if (!READ_ONCE(net->ct.ctnetlink_has_listener))
+		if (!READ_ONCE(nf_ctnetlink_has_listener))
 			return true;
 		fallthrough;
 	case 1:
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 6d18fb3468683..81c7737c803a6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -29,6 +29,7 @@
 
 #include <net/netlink.h>
 #include <net/netns/generic.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 
 MODULE_LICENSE("GPL");
@@ -685,12 +686,12 @@ static void nfnetlink_bind_event(struct net *net, unsigned int group)
 	group_bit = (1 << group);
 
 	spin_lock(&nfnl_grp_active_lock);
-	v = READ_ONCE(net->ct.ctnetlink_has_listener);
+	v = READ_ONCE(nf_ctnetlink_has_listener);
 	if ((v & group_bit) == 0) {
 		v |= group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 
 	spin_unlock(&nfnl_grp_active_lock);
@@ -744,12 +745,12 @@ static void nfnetlink_unbind(struct net *net, int group)
 
 	spin_lock(&nfnl_grp_active_lock);
 	if (!nfnetlink_has_listeners(net, group)) {
-		u8 v = READ_ONCE(net->ct.ctnetlink_has_listener);
+		u8 v = READ_ONCE(nf_ctnetlink_has_listener);
 
 		v &= ~group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 	spin_unlock(&nfnl_grp_active_lock);
 #endif
-- 
2.39.2



