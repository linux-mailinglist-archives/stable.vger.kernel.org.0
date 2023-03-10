Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1486B41DE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjCJN5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjCJN5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA6115DE5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D5CB822C7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B63C433EF;
        Fri, 10 Mar 2023 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456627;
        bh=72tda5Bq54i/bgcXazaNCif40nUS7+6vbhfS2PnsuSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpEFF8KhTwPKkPmtZqmtW+oQsyI7q4iNZnL6VPxjkYaSH/6uh4tT5PpolBFFpXYtC
         aGrJAD/j8jwD/X6QcO62U/U856gH4ny3YIDzHR8yodyE53L6rfmaA8Tb2aLdeNLZMU
         UnFJL8kS081S7dZRjKnGgmxlOb8Wv4xMvd8fWTMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 068/211] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
Date:   Fri, 10 Mar 2023 14:37:28 +0100
Message-Id: <20230310133720.827759200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit efb056e5f1f0036179b2f92c1c15f5ea7a891d70 ]

When calling ip6_route_lookup() for the packet arriving on the VRF
interface, the result is always the real (slave) interface. Expect this
when validating the result.

Fixes: acc641ab95b66 ("netfilter: rpfilter/fib: Populate flowic_l3mdev field")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c         |  4 ++-
 tools/testing/selftests/netfilter/rpath.sh | 32 ++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index a01d9b842bd07..67c87a88cde4f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index f7311e66d2193..5289c8447a419 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -62,10 +62,16 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-[ -n "$iptables" ] && ip netns exec "$ns2" \
-	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-[ -n "$ip6tables" ] && ip netns exec "$ns2" \
-	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$iptables" ] && {
+	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
+}
+[ -n "$ip6tables" ] && {
+	common='-t raw -A PREROUTING -s fec0::/16'
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
+}
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
@@ -89,6 +95,11 @@ ipt_zero_rule() { # (command)
 	[ -n "$1" ] || return 0
 	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
 }
+ipt_zero_reverse_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | \
+		grep -q -- "-m rpfilter --invert -c 0 0"
+}
 nft_zero_rule() { # (family)
 	[ -n "$nft" ] || return 0
 	ip netns exec "$ns2" "$nft" list chain inet t c | \
@@ -101,8 +112,7 @@ netns_ping() { # (netns, args...)
 	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
 }
 
-testrun() {
-	# clear counters first
+clear_counters() {
 	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
 	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
 	if [ -n "$nft" ]; then
@@ -111,6 +121,10 @@ testrun() {
 			ip netns exec "$ns2" $nft -s list table inet t;
 		) | ip netns exec "$ns2" $nft -f -
 	fi
+}
+
+testrun() {
+	clear_counters
 
 	# test 1: martian traffic should fail rpfilter matches
 	netns_ping "$ns1" -I v0 192.168.42.1 && \
@@ -120,9 +134,13 @@ testrun() {
 
 	ipt_zero_rule "$iptables" || die "iptables matched martian"
 	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	ipt_zero_reverse_rule "$iptables" && die "iptables not matched martian"
+	ipt_zero_reverse_rule "$ip6tables" && die "ip6tables not matched martian"
 	nft_zero_rule ip || die "nft IPv4 matched martian"
 	nft_zero_rule ip6 || die "nft IPv6 matched martian"
 
+	clear_counters
+
 	# test 2: rpfilter match should pass for regular traffic
 	netns_ping "$ns1" 192.168.23.1 || \
 		die "regular ping 192.168.23.1 failed"
@@ -131,6 +149,8 @@ testrun() {
 
 	ipt_zero_rule "$iptables" && die "iptables match not effective"
 	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	ipt_zero_reverse_rule "$iptables" || die "iptables match over-effective"
+	ipt_zero_reverse_rule "$ip6tables" || die "ip6tables match over-effective"
 	nft_zero_rule ip && die "nft IPv4 match not effective"
 	nft_zero_rule ip6 && die "nft IPv6 match not effective"
 
-- 
2.39.2



