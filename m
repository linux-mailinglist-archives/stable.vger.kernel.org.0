Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B94BE309
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351470AbiBUJt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352902AbiBUJsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6841193E7;
        Mon, 21 Feb 2022 01:21:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567A060F4E;
        Mon, 21 Feb 2022 09:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C462C340E9;
        Mon, 21 Feb 2022 09:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435272;
        bh=lO9+SfRYxZy7LfpZ9kZoV+XdWXmb8YWDq3BsOi5WrkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciS78LNanpAgj67Efyw40P9mmncYXwYAYeVs3+iOmgGjy8VQyvJsh1KQaUVYw3BpB
         SRJ7YVR/GUE/3swUHIe3RNKiQuWa1tT8xr4vp9aPeLJxN1s3vq7xYFU5TiuciND/nJ
         hR6DHVyrQfkU6K4+RZpBmsPE0uZNx+8G3b7DL8IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Congyu Liu <liu3101@purdue.edu>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 104/227] ipv6: per-netns exclusive flowlabel checks
Date:   Mon, 21 Feb 2022 09:48:43 +0100
Message-Id: <20220221084938.336077170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Willem de Bruijn <willemb@google.com>

commit 0b0dff5b3b98c5c7ce848151df9da0b3cdf0cc8b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h       |    5 ++++-
 include/net/netns/ipv6.h |    3 ++-
 net/ipv6/ip6_flowlabel.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -391,17 +391,20 @@ static inline void txopt_put(struct ipv6
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
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *
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


