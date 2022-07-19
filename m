Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC55D5799A7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbiGSMFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238403AbiGSMEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADD4C638;
        Tue, 19 Jul 2022 05:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D55E6163C;
        Tue, 19 Jul 2022 12:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B288C341C6;
        Tue, 19 Jul 2022 12:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232029;
        bh=mvb+Pnz5R7gA+DpzUV27ng0t5QwEHDHEUMFotMgG9EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZNbZKovzpsCqiKkl6MSvUgKBa++BGmxqyN+pxXkjku2O7Fb4Q1bXpp3M2HVs+/1c
         n6DNmkCLT2Cot5zv1l4Ay6NQhLlutD0iaZdI7OF2hCH4Ovgv2Q9S9l72aq2F+4fgas
         BoX3XcQ+d+/JVvrHf5fhxBSY4ukXOyXfVWKYKzFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radim Hrazdil <rhrazdil@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/48] netfilter: br_netfilter: do not skip all hooks with 0 priority
Date:   Tue, 19 Jul 2022 13:54:06 +0200
Message-Id: <20220719114522.486263920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c2577862eeb0be94f151f2f1fff662b028061b00 ]

When br_netfilter module is loaded, skbs may be diverted to the
ipv4/ipv6 hooks, just like as if we were routing.

Unfortunately, bridge filter hooks with priority 0 may be skipped
in this case.

Example:
1. an nftables bridge ruleset is loaded, with a prerouting
   hook that has priority 0.
2. interface is added to the bridge.
3. no tcp packet is ever seen by the bridge prerouting hook.
4. flush the ruleset
5. load the bridge ruleset again.
6. tcp packets are processed as expected.

After 1) the only registered hook is the bridge prerouting hook, but its
not called yet because the bridge hasn't been brought up yet.

After 2), hook order is:
   0 br_nf_pre_routing // br_netfilter internal hook
   0 chain bridge f prerouting // nftables bridge ruleset

The packet is diverted to br_nf_pre_routing.
If call-iptables is off, the nftables bridge ruleset is called as expected.

But if its enabled, br_nf_hook_thresh() will skip it because it assumes
that all 0-priority hooks had been called previously in bridge context.

To avoid this, check for the br_nf_pre_routing hook itself, we need to
resume directly after it, even if this hook has a priority of 0.

Unfortunately, this still results in different packet flow.
With this fix, the eval order after in 3) is:
1. br_nf_pre_routing
2. ip(6)tables (if enabled)
3. nftables bridge

but after 5 its the much saner:
1. nftables bridge
2. br_nf_pre_routing
3. ip(6)tables (if enabled)

Unfortunately I don't see a solution here:
It would be possible to move br_nf_pre_routing to a higher priority
so that it will be called later in the pipeline, but this also impacts
ebtables evaluation order, and would still result in this very ordering
problem for all nftables-bridge hooks with the same priority as the
br_nf_pre_routing one.

Searching back through the git history I don't think this has
ever behaved in any other way, hence, no fixes-tag.

Reported-by: Radim Hrazdil <rhrazdil@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 4b9d1d6bbf6f..55c7cdf5e7b8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1001,9 +1001,24 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 		return okfn(net, sk, skb);
 
 	ops = nf_hook_entries_get_hook_ops(e);
-	for (i = 0; i < e->num_hook_entries &&
-	      ops[i]->priority <= NF_BR_PRI_BRNF; i++)
-		;
+	for (i = 0; i < e->num_hook_entries; i++) {
+		/* These hooks have already been called */
+		if (ops[i]->priority < NF_BR_PRI_BRNF)
+			continue;
+
+		/* These hooks have not been called yet, run them. */
+		if (ops[i]->priority > NF_BR_PRI_BRNF)
+			break;
+
+		/* take a closer look at NF_BR_PRI_BRNF. */
+		if (ops[i]->hook == br_nf_pre_routing) {
+			/* This hook diverted the skb to this function,
+			 * hooks after this have not been run yet.
+			 */
+			i++;
+			break;
+		}
+	}
 
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
-- 
2.35.1



