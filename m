Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D813642E6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbhDSNMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239710AbhDSNLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A44F61288;
        Mon, 19 Apr 2021 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837846;
        bh=Lbk80MNig+UIuRJUxCC3+Dw+4iJ7T+KUui0Vdx35Osg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDjIfat7Y/BWc3QaCLBF+lVzfSmsKCEX8E7Qn4ko2ldYQ62CtQ9diIrYBjTXjLbv/
         5p//nJi8NLS+YOaiTFgI8a9ozCDhlDfz0aQYP7RLVY8rFpYzQdBjlB49OozPRswPch
         0oNAcD045vjM/45QjjLVyCkgOq3moiyfu+JOm8Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.11 076/122] netfilter: arp_tables: add pre_exit hook for table unregister
Date:   Mon, 19 Apr 2021 15:05:56 +0200
Message-Id: <20210419130532.757166072@linuxfoundation.org>
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

commit d163a925ebbc6eb5b562b0f1d72c7e817aa75c40 upstream.

Same problem that also existed in iptables/ip(6)tables, when
arptable_filter is removed there is no longer a wait period before the
table/ruleset is free'd.

Unregister the hook in pre_exit, then remove the table in the exit
function.
This used to work correctly because the old nf_hook_unregister API
did unconditional synchronize_net.

The per-net hook unregister function uses call_rcu instead.

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter_arp/arp_tables.h |    5 +++--
 net/ipv4/netfilter/arp_tables.c          |    9 +++++++--
 net/ipv4/netfilter/arptable_filter.c     |   10 +++++++++-
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -52,8 +52,9 @@ extern void *arpt_alloc_initial_table(co
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops);
+void arpt_unregister_table(struct net *net, struct xt_table *table);
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1541,10 +1541,15 @@ out_free:
 	return ret;
 }
 
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops)
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops)
 {
 	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
+
+void arpt_unregister_table(struct net *net, struct xt_table *table)
+{
 	__arpt_unregister_table(net, table);
 }
 
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -56,16 +56,24 @@ static int __net_init arptable_filter_ta
 	return err;
 }
 
+static void __net_exit arptable_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.arptable_filter)
+		arpt_unregister_table_pre_exit(net, net->ipv4.arptable_filter,
+					       arpfilter_ops);
+}
+
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
 	if (!net->ipv4.arptable_filter)
 		return;
-	arpt_unregister_table(net, net->ipv4.arptable_filter, arpfilter_ops);
+	arpt_unregister_table(net, net->ipv4.arptable_filter);
 	net->ipv4.arptable_filter = NULL;
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
 	.exit = arptable_filter_net_exit,
+	.pre_exit = arptable_filter_net_pre_exit,
 };
 
 static int __init arptable_filter_init(void)


