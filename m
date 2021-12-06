Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0C7469E09
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388543AbhLFPeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346005AbhLFP1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55FBA612C1;
        Mon,  6 Dec 2021 15:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378C0C341C5;
        Mon,  6 Dec 2021 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804263;
        bh=AcWqf8Sr5sS+4ubAhf4K4K1XoLCCwdFFc3Ulx2YA1TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLHzy+NNCimv8b6L4qLkMu3XeijeTGNgD1PUfMkhc+YqwXXc9xGFsBpCHBlb2fwBp
         H60fVSG42dAYGO+wtrKEqNlLEvoRLimn/WPNZych/bKiNliG2TZ6uQ92jyDI0YsEi+
         DEF4SufkEGt47GozWqwEPExSZ6NhSfkC90UI5tU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 067/207] ipv6: fix memory leak in fib6_rule_suppress
Date:   Mon,  6 Dec 2021 15:55:21 +0100
Message-Id: <20211206145612.555609557@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: msizanoen1 <msizanoen@qtmlabs.xyz>

commit cdef485217d30382f3bf6448c54b4401648fe3f1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/fib_rules.h |    4 +++-
 net/core/fib_rules.c    |    2 +-
 net/ipv4/fib_rules.c    |    1 +
 net/ipv6/fib6_rules.c   |    4 ++--
 4 files changed, 7 insertions(+), 4 deletions(-)

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
@@ -218,7 +218,9 @@ INDIRECT_CALLABLE_DECLARE(int fib4_rule_
 			    struct fib_lookup_arg *arg));
 
 INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg));
 INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg));
 #endif
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -323,7 +323,7 @@ jumped:
 		if (!err && ops->suppress && INDIRECT_CALL_MT(ops->suppress,
 							      fib6_rule_suppress,
 							      fib4_rule_suppress,
-							      rule, arg))
+							      rule, flags, arg))
 			continue;
 
 		if (err != -EAGAIN) {
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -141,6 +141,7 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_ac
 }
 
 INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg)
 {
 	struct fib_result *result = (struct fib_result *) arg->result;
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -267,6 +267,7 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_ac
 }
 
 INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
+						int flags,
 						struct fib_lookup_arg *arg)
 {
 	struct fib6_result *res = arg->result;
@@ -294,8 +295,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_s
 	return false;
 
 suppress_route:
-	if (!(arg->flags & FIB_LOOKUP_NOREF))
-		ip6_rt_put(rt);
+	ip6_rt_put_flags(rt, flags);
 	return true;
 }
 


