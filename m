Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD493642E4
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhDSNMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237650AbhDSNLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50EFA613AB;
        Mon, 19 Apr 2021 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837843;
        bh=7xl4TdoAtQT6CSqGl1sQFY79fuIGdtBZBDRgc1uwCLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9XpA70bHK6THxOmY/74xkOd9MBB4WiYxRlFIVy606r5d8nB1oeoujT78JjZO9kw/
         8a4Hzy8bInyKlPtMkXNqGrIhcuDaIn4l3FAvYsuqdz7EaKgw4WqrsQedAk8T6goPwP
         mXP6977AK74IVtlmnk53lb8t7X56AaR0qbEGkF+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.11 075/122] netfilter: bridge: add pre_exit hooks for ebtable unregistration
Date:   Mon, 19 Apr 2021 15:05:55 +0200
Message-Id: <20210419130532.717922202@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 7ee3c61dcd28bf6e290e06ad382f13511dc790e9 upstream.

Just like ip/ip6/arptables, the hooks have to be removed, then
synchronize_rcu() has to be called to make sure no more packets are being
processed before the ruleset data is released.

Place the hook unregistration in the pre_exit hook, then call the new
ebtables pre_exit function from there.

Years ago, when first netns support got added for netfilter+ebtables,
this used an older (now removed) netfilter hook unregister API, that did
a unconditional synchronize_rcu().

Now that all is done with call_rcu, ebtable_{filter,nat,broute} pernet exit
handlers may free the ebtable ruleset while packets are still in flight.

This can only happens on module removal, not during netns exit.

The new function expects the table name, not the table struct.

This is because upcoming patch set (targeting -next) will remove all
net->xt.{nat,filter,broute}_table instances, this makes it necessary
to avoid external references to those member variables.

The existing APIs will be converted, so follow the upcoming scheme of
passing name + hook type instead.

Fixes: aee12a0a3727e ("ebtables: remove nf_hook_register usage")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter_bridge/ebtables.h |    5 +++--
 net/bridge/netfilter/ebtable_broute.c     |    8 +++++++-
 net/bridge/netfilter/ebtable_filter.c     |    8 +++++++-
 net/bridge/netfilter/ebtable_nat.c        |    8 +++++++-
 net/bridge/netfilter/ebtables.c           |   30 +++++++++++++++++++++++++++---
 5 files changed, 51 insertions(+), 8 deletions(-)

--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -110,8 +110,9 @@ extern int ebt_register_table(struct net
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
 			      struct ebt_table **res);
-extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
-				 const struct nf_hook_ops *);
+extern void ebt_unregister_table(struct net *net, struct ebt_table *table);
+void ebt_unregister_table_pre_exit(struct net *net, const char *tablename,
+				   const struct nf_hook_ops *ops);
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -105,14 +105,20 @@ static int __net_init broute_net_init(st
 				  &net->xt.broute_table);
 }
 
+static void __net_exit broute_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "broute", &ebt_ops_broute);
+}
+
 static void __net_exit broute_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.broute_table, &ebt_ops_broute);
+	ebt_unregister_table(net, net->xt.broute_table);
 }
 
 static struct pernet_operations broute_net_ops = {
 	.init = broute_net_init,
 	.exit = broute_net_exit,
+	.pre_exit = broute_net_pre_exit,
 };
 
 static int __init ebtable_broute_init(void)
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -99,14 +99,20 @@ static int __net_init frame_filter_net_i
 				  &net->xt.frame_filter);
 }
 
+static void __net_exit frame_filter_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "filter", ebt_ops_filter);
+}
+
 static void __net_exit frame_filter_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_filter, ebt_ops_filter);
+	ebt_unregister_table(net, net->xt.frame_filter);
 }
 
 static struct pernet_operations frame_filter_net_ops = {
 	.init = frame_filter_net_init,
 	.exit = frame_filter_net_exit,
+	.pre_exit = frame_filter_net_pre_exit,
 };
 
 static int __init ebtable_filter_init(void)
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -99,14 +99,20 @@ static int __net_init frame_nat_net_init
 				  &net->xt.frame_nat);
 }
 
+static void __net_exit frame_nat_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "nat", ebt_ops_nat);
+}
+
 static void __net_exit frame_nat_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_nat, ebt_ops_nat);
+	ebt_unregister_table(net, net->xt.frame_nat);
 }
 
 static struct pernet_operations frame_nat_net_ops = {
 	.init = frame_nat_net_init,
 	.exit = frame_nat_net_exit,
+	.pre_exit = frame_nat_net_pre_exit,
 };
 
 static int __init ebtable_nat_init(void)
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1232,10 +1232,34 @@ out:
 	return ret;
 }
 
-void ebt_unregister_table(struct net *net, struct ebt_table *table,
-			  const struct nf_hook_ops *ops)
+static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+{
+	struct ebt_table *t;
+
+	mutex_lock(&ebt_mutex);
+
+	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return t;
+		}
+	}
+
+	mutex_unlock(&ebt_mutex);
+	return NULL;
+}
+
+void ebt_unregister_table_pre_exit(struct net *net, const char *name, const struct nf_hook_ops *ops)
+{
+	struct ebt_table *table = __ebt_find_table(net, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
+
+void ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ebt_unregister_table(net, table);
 }
 


