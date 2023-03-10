Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695D06B41E4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCJN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCJN5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8871115B5D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F6D617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5956CC433D2;
        Fri, 10 Mar 2023 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456632;
        bh=kYhV3wnT7fuYbfYEGiwkZ36vZ9VdMUCtUpvcDiOuSGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipSlpzlo43NSpLZwKPGWc3qU4zXv9mv9wJr8HO+lKfTvb1K8qKSQyvGKVKvfx09aZ
         xKcbQGRB72EtkxxesYdRAFKH9ng/S5s/xc2lkTkH7WXfPtvTxwC//TrX4KqOO9UJ5w
         DL/Ym4+eLnhLzXY3uS+lwk1D2Nk8SnoRU37SlDQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+f61594de72d6705aea03@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 069/211] netfilter: ebtables: fix table blob use-after-free
Date:   Fri, 10 Mar 2023 14:37:29 +0100
Message-Id: <20230310133720.864582667@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e58a171d35e32e6e8c37cfe0e8a94406732a331f ]

We are not allowed to return an error at this point.
Looking at the code it looks like ret is always 0 at this
point, but its not.

t = find_table_lock(net, repl->name, &ret, &ebt_mutex);

... this can return a valid table, with ret != 0.

This bug causes update of table->private with the new
blob, but then frees the blob right away in the caller.

Syzbot report:

BUG: KASAN: vmalloc-out-of-bounds in __ebt_unregister_table+0xc00/0xcd0 net/bridge/netfilter/ebtables.c:1168
Read of size 4 at addr ffffc90005425000 by task kworker/u4:4/74
Workqueue: netns cleanup_net
Call Trace:
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 __ebt_unregister_table+0xc00/0xcd0 net/bridge/netfilter/ebtables.c:1168
 ebt_unregister_table+0x35/0x40 net/bridge/netfilter/ebtables.c:1372
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
...

ip(6)tables appears to be ok (ret should be 0 at this point) but make
this more obvious.

Fixes: c58dd2dd443c ("netfilter: Can't fail and free after table replacement")
Reported-by: syzbot+f61594de72d6705aea03@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 3 +--
 net/ipv6/netfilter/ip6_tables.c | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ce5dfa3babd26..757ec46fc45a0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1090,7 +1090,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REPLACE, GFP_KERNEL);
-	return ret;
+	return 0;
 
 free_unlock:
 	mutex_unlock(&ebt_mutex);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2ed7c58b471ac..aae5fd51dfd74 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1045,7 +1045,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ipt_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1091,7 +1090,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2d816277f2c5a..ac902f7bca477 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1062,7 +1062,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ip6t_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1108,7 +1107,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
-- 
2.39.2



