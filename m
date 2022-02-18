Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9EF4BBA9F
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiBROa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:30:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235491AbiBROa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:30:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983F6B0E8A
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51016B8265D
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDEC340E9;
        Fri, 18 Feb 2022 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194609;
        bh=H4p9cu7s5fXSYL8+TbOv0b6fWRxFU5cVcMHctV7Bvl0=;
        h=Subject:To:Cc:From:Date:From;
        b=pAmlV7F3xFL7tMlZLqiQ/OwPC3der+vmFQ2x+klQuMmNmTkykGgIKY/BBZXc1UjyE
         ooBWVfQ1tL4Mx4giSV5saaN+U5+zwRmbrpam24WMXBF7Nzcm6Jhqpv4g2oHxmwr03S
         qhCM5eM6lUSMHiQGYu8n4EBF6eEArRzqTaVJOm24=
Subject: FAILED: patch "[PATCH] ipv6: per-netns exclusive flowlabel checks" failed to apply to 5.4-stable tree
To:     willemb@google.com, kuba@kernel.org, liu3101@purdue.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:30:06 +0100
Message-ID: <164519460610840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b0dff5b3b98c5c7ce848151df9da0b3cdf0cc8b Mon Sep 17 00:00:00 2001
From: Willem de Bruijn <willemb@google.com>
Date: Tue, 15 Feb 2022 11:00:37 -0500
Subject: [PATCH] ipv6: per-netns exclusive flowlabel checks

Ipv6 flowlabels historically require a reservation before use.
Optionally in exclusive mode (e.g., user-private).

Commit 59c820b2317f ("ipv6: elide flowlabel check if no exclusive
leases exist") introduced a fastpath that avoids this check when no
exclusive leases exist in the system, and thus any flowlabel use
will be granted.

That allows skipping the control operation to reserve a flowlabel
entirely. Though with a warning if the fast path fails:

  This is an optimization. Robust applications still have to revert to
  requesting leases if the fast path fails due to an exclusive lease.

Still, this is subtle. Better isolate network namespaces from each
other. Flowlabels are per-netns. Also record per-netns whether
exclusive leases are in use. Then behavior does not change based on
activity in other netns.

Changes
  v2
    - wrap in IS_ENABLED(CONFIG_IPV6) to avoid breakage if disabled

Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
Link: https://lore.kernel.org/netdev/MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com/
Reported-by: Congyu Liu <liu3101@purdue.edu>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Tested-by: Congyu Liu <liu3101@purdue.edu>
Link: https://lore.kernel.org/r/20220215160037.1976072-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3afcb128e064..92eec13d1693 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -393,17 +393,20 @@ static inline void txopt_put(struct ipv6_txoptions *opt)
 		kfree_rcu(opt, rcu);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 struct ip6_flowlabel *__fl6_sock_lookup(struct sock *sk, __be32 label);
 
 extern struct static_key_false_deferred ipv6_flowlabel_exclusive;
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
 						    __be32 label)
 {
-	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))
+	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
+	    READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
 		return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);
 
 	return NULL;
 }
+#endif
 
 struct ipv6_txoptions *fl6_merge_options(struct ipv6_txoptions *opt_space,
 					 struct ip6_flowlabel *fl,
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a4b550380316..6bd7e5a85ce7 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -77,9 +77,10 @@ struct netns_ipv6 {
 	spinlock_t		fib6_gc_lock;
 	unsigned int		 ip6_rt_gc_expire;
 	unsigned long		 ip6_rt_last_gc;
+	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
-	unsigned int		fib6_rules_require_fldissect;
 	bool			fib6_has_custom_rules;
+	unsigned int		fib6_rules_require_fldissect;
 #ifdef CONFIG_IPV6_SUBTREES
 	unsigned int		fib6_routes_require_src;
 #endif
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index aa673a6a7e43..ceb85c67ce39 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 		err = -EINVAL;
 		goto done;
 	}
-	if (fl_shared_exclusive(fl) || fl->opt)
+	if (fl_shared_exclusive(fl) || fl->opt) {
+		WRITE_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl, 1);
 		static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
+	}
 	return fl;
 
 done:

