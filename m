Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596C15AAF1F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbiIBMeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbiIBMdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:33:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0422D1F2;
        Fri,  2 Sep 2022 05:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AABBB82A9B;
        Fri,  2 Sep 2022 12:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF4CC433C1;
        Fri,  2 Sep 2022 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121650;
        bh=pmq28BXMj4Tdpb6qQ51Uy3s38O2jMo6EChWRxf7GiOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXGDSvTKMBtjqBOC6RTCM3rbECMrRzvYA+IDIidOZb104lx1/dK7gwywq5WWg9i7i
         XDXNUByyQqxFpW1NM3fgr4Rym8YVyYVR2PmlJcKjL2JQOCvsvx1rnDzv4zz/zqtALp
         3BMC1/qQOIYoYrCHiG+5AGc4pTYM66lFfOjnGHIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/77] netfilter: ebtables: reject blobs that dont provide all entry points
Date:   Fri,  2 Sep 2022 14:18:29 +0200
Message-Id: <20220902121404.317136695@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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

[ Upstream commit 7997eff82828304b780dc0a39707e1946d6f1ebf ]

Harshit Mogalapalli says:
 In ebt_do_table() function dereferencing 'private->hook_entry[hook]'
 can lead to NULL pointer dereference. [..] Kernel panic:

general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[..]
RIP: 0010:ebt_do_table+0x1dc/0x1ce0
Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 5c 16 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 6c df 08 48 8d 7d 2c 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 88
[..]
Call Trace:
 nf_hook_slow+0xb1/0x170
 __br_forward+0x289/0x730
 maybe_deliver+0x24b/0x380
 br_flood+0xc6/0x390
 br_dev_xmit+0xa2e/0x12c0

For some reason ebtables rejects blobs that provide entry points that are
not supported by the table, but what it should instead reject is the
opposite: blobs that DO NOT provide an entry point supported by the table.

t->valid_hooks is the bitmask of hooks (input, forward ...) that will see
packets.  Providing an entry point that is not support is harmless
(never called/used), but the inverse isn't: it results in a crash
because the ebtables traverser doesn't expect a NULL blob for a location
its receiving packets for.

Instead of fixing all the individual checks, do what iptables is doing and
reject all blobs that differ from the expected hooks.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_bridge/ebtables.h | 4 ----
 net/bridge/netfilter/ebtable_broute.c     | 8 --------
 net/bridge/netfilter/ebtable_filter.c     | 8 --------
 net/bridge/netfilter/ebtable_nat.c        | 8 --------
 net/bridge/netfilter/ebtables.c           | 8 +-------
 5 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index db472c9cd8e9d..f0d846df3a424 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -94,10 +94,6 @@ struct ebt_table {
 	struct ebt_replace_kernel *table;
 	unsigned int valid_hooks;
 	rwlock_t lock;
-	/* e.g. could be the table explicitly only allows certain
-	 * matches, targets, ... 0 == let it in */
-	int (*check)(const struct ebt_table_info *info,
-	   unsigned int valid_hooks);
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
 	struct module *me;
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 32bc2821027f3..57f91efce0f73 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)&initial_chain,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~(1 << NF_BR_BROUTING))
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table broute_table = {
 	.name		= "broute",
 	.table		= &initial_table,
 	.valid_hooks	= 1 << NF_BR_BROUTING,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index bcf982e12f16b..7f2e620f4978f 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~FILTER_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_filter = {
 	.name		= "filter",
 	.table		= &initial_table,
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 0d092773f8161..1743a105485c4 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
 	.entries	= (char *)initial_chains,
 };
 
-static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
-{
-	if (valid_hooks & ~NAT_VALID_HOOKS)
-		return -EINVAL;
-	return 0;
-}
-
 static const struct ebt_table frame_nat = {
 	.name		= "nat",
 	.table		= &initial_table,
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.check		= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d9375c52f50e6..ddb988c339c17 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -999,8 +999,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	/* the table doesn't like it */
-	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
+	if (repl->valid_hooks != t->valid_hooks)
 		goto free_unlock;
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
@@ -1193,11 +1192,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	if (ret != 0)
 		goto free_chainstack;
 
-	if (table->check && table->check(newinfo, table->valid_hooks)) {
-		ret = -EINVAL;
-		goto free_chainstack;
-	}
-
 	table->private = newinfo;
 	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
-- 
2.35.1



