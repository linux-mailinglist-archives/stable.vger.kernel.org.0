Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22399468AB2
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhLEMMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhLEMMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:12:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC693C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 04:08:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 612C1B80E1D
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672AEC341C1;
        Sun,  5 Dec 2021 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638706113;
        bh=hOzYdWDBymMFyLTnpXC7z3iCc+PLdBRfrXCQ9+Am/gA=;
        h=Subject:To:Cc:From:Date:From;
        b=OXSZ+0Q31E2h/f5ZaeStE4qCv8DWzUV2kV9vO9R2CkR91PBVfdwuQGy8xvF0yhZFS
         rZcSlf8tadBEQxH/DbHdFY9Ns1gAhboIq8I31x52rbugrjmBePpl9oDZiOvEqGGBig
         czcFem0LAePHHFDbimLflFSNFZbmnk6U6sBPDOb8=
Subject: FAILED: patch "[PATCH] ipv6: fix memory leak in fib6_rule_suppress" failed to apply to 5.4-stable tree
To:     msizanoen@qtmlabs.xyz, Jason@zx2c4.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:08:30 +0100
Message-ID: <1638706110213156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From cdef485217d30382f3bf6448c54b4401648fe3f1 Mon Sep 17 00:00:00 2001
From: msizanoen1 <msizanoen@qtmlabs.xyz>
Date: Tue, 23 Nov 2021 13:48:32 +0100
Subject: [PATCH] ipv6: fix memory leak in fib6_rule_suppress

The kernel leaks memory when a `fib` rule is present in IPv6 nftables
firewall rules and a suppress_prefix rule is present in the IPv6 routing
rules (used by certain tools such as wg-quick). In such scenarios, every
incoming packet will leak an allocation in `ip6_dst_cache` slab cache.

After some hours of `bpftrace`-ing and source code reading, I tracked
down the issue to ca7a03c41753 ("ipv6: do not free rt if
FIB_LOOKUP_NOREF is set on suppress rule").

The problem with that change is that the generic `args->flags` always have
`FIB_LOOKUP_NOREF` set[1][2] but the IPv6-specific flag
`RT6_LOOKUP_F_DST_NOREF` might not be, leading to `fib6_rule_suppress` not
decreasing the refcount when needed.

How to reproduce:
 - Add the following nftables rule to a prerouting chain:
     meta nfproto ipv6 fib saddr . mark . iif oif missing drop
   This can be done with:
     sudo nft create table inet test
     sudo nft create chain inet test test_chain '{ type filter hook prerouting priority filter + 10; policy accept; }'
     sudo nft add rule inet test test_chain meta nfproto ipv6 fib saddr . mark . iif oif missing drop
 - Run:
     sudo ip -6 rule add table main suppress_prefixlength 0
 - Watch `sudo slabtop -o | grep ip6_dst_cache` to see memory usage increase
   with every incoming ipv6 packet.

This patch exposes the protocol-specific flags to the protocol
specific `suppress` function, and check the protocol-specific `flags`
argument for RT6_LOOKUP_F_DST_NOREF instead of the generic
FIB_LOOKUP_NOREF when decreasing the refcount, like this.

[1]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
[2]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215105
Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 4b10676c69d1..bd07484ab9dd 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -69,7 +69,7 @@ struct fib_rules_ops {
 	int			(*action)(struct fib_rule *,
 					  struct flowi *, int,
 					  struct fib_lookup_arg *);
-	bool			(*suppress)(struct fib_rule *,
+	bool			(*suppress)(struct fib_rule *, int,
 					    struct fib_lookup_arg *);
 	int			(*match)(struct fib_rule *,
 					 struct flowi *, int);
@@ -218,7 +218,9 @@ INDIRECT_CALLABLE_DECLARE(int fib4_rule_action(struct fib_rule *rule,
 			    struct fib_lookup_arg *arg));
 
 INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg));
 INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg));
 #endif
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 79df7cd9dbc1..1bb567a3b329 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -323,7 +323,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		if (!err && ops->suppress && INDIRECT_CALL_MT(ops->suppress,
 							      fib6_rule_suppress,
 							      fib4_rule_suppress,
-							      rule, arg))
+							      rule, flags, arg))
 			continue;
 
 		if (err != -EAGAIN) {
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index ce54a30c2ef1..364ad3446b2f 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -141,6 +141,7 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_action(struct fib_rule *rule,
 }
 
 INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg)
 {
 	struct fib_result *result = (struct fib_result *) arg->result;
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 40f3e4f9f33a..dcedfe29d9d9 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -267,6 +267,7 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_action(struct fib_rule *rule,
 }
 
 INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg)
 {
 	struct fib6_result *res = arg->result;
@@ -294,8 +295,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
 	return false;
 
 suppress_route:
-	if (!(arg->flags & FIB_LOOKUP_NOREF))
-		ip6_rt_put(rt);
+	ip6_rt_put_flags(rt, flags);
 	return true;
 }
 

