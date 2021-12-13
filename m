Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682F472663
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhLMJvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbhLMJt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:49:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90F8C08E9BA;
        Mon, 13 Dec 2021 01:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FEBB80E20;
        Mon, 13 Dec 2021 09:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8979C00446;
        Mon, 13 Dec 2021 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388607;
        bh=H0FAacyZRZXXBxm2iWy3+HR1A0BKUuckAm6QSJ+DAkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHsa+nw8613Y6SsyEM4GLcNVSrGmy0WMt1x0TIAPzTvAX6vBZleUkD7GEIYCi4y5/
         LoDH28asrmO5iSeeQQPcn0RqcD1dUWOJdI5WO8w4xzlcF2Hga1Am3dKG07c2OrcGe3
         Un/JfYI5w2QsZYGYPVMhZSETQt/uC/dsimZM6tog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 17/88] vrf: dont run conntrack on vrf with !dflt qdisc
Date:   Mon, 13 Dec 2021 10:29:47 +0100
Message-Id: <20211213092933.802352177@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit d43b75fbc23f0ac1ef9c14a5a166d3ccb761a451 upstream.

After the below patch, the conntrack attached to skb is set to "notrack" in
the context of vrf device, for locally generated packets.
But this is true only when the default qdisc is set to the vrf device. When
changing the qdisc, notrack is not set anymore.
In fact, there is a shortcut in the vrf driver, when the default qdisc is
set, see commit dcdd43c41e60 ("net: vrf: performance improvements for
IPv4") for more details.

This patch ensures that the behavior is always the same, whatever the qdisc
is.

To demonstrate the difference, a new test is added in conntrack_vrf.sh.

Fixes: 8c9c296adfae ("vrf: run conntrack only in context of lower/physdev for locally generated packets")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c                                  |    8 ++---
 tools/testing/selftests/netfilter/conntrack_vrf.sh |   30 ++++++++++++++++++---
 2 files changed, 30 insertions(+), 8 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -495,8 +495,6 @@ static struct sk_buff *vrf_ip6_out_direc
 
 	skb->dev = vrf_dev;
 
-	vrf_nf_set_untracked(skb);
-
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
@@ -517,6 +515,8 @@ static struct sk_buff *vrf_ip6_out(struc
 	if (rt6_need_strict(&ipv6_hdr(skb)->daddr))
 		return skb;
 
+	vrf_nf_set_untracked(skb);
+
 	if (qdisc_tx_is_default(vrf_dev) ||
 	    IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
 		return vrf_ip6_out_direct(vrf_dev, sk, skb);
@@ -732,8 +732,6 @@ static struct sk_buff *vrf_ip_out_direct
 
 	skb->dev = vrf_dev;
 
-	vrf_nf_set_untracked(skb);
-
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
@@ -755,6 +753,8 @@ static struct sk_buff *vrf_ip_out(struct
 	    ipv4_is_lbcast(ip_hdr(skb)->daddr))
 		return skb;
 
+	vrf_nf_set_untracked(skb);
+
 	if (qdisc_tx_is_default(vrf_dev) ||
 	    IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
 		return vrf_ip_out_direct(vrf_dev, sk, skb);
--- a/tools/testing/selftests/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -150,11 +150,27 @@ EOF
 # oifname is the vrf device.
 test_masquerade_vrf()
 {
+	local qdisc=$1
+
+	if [ "$qdisc" != "default" ]; then
+		tc -net $ns0 qdisc add dev tvrf root $qdisc
+	fi
+
 	ip netns exec $ns0 conntrack -F 2>/dev/null
 
 ip netns exec $ns0 nft -f - <<EOF
 flush ruleset
 table ip nat {
+	chain rawout {
+		type filter hook output priority raw;
+
+		oif tvrf ct state untracked counter
+	}
+	chain postrouting2 {
+		type filter hook postrouting priority mangle;
+
+		oif tvrf ct state untracked counter
+	}
 	chain postrouting {
 		type nat hook postrouting priority 0;
 		# NB: masquerade should always be combined with 'oif(name) bla',
@@ -171,13 +187,18 @@ EOF
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
+	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2' &&
+	ip netns exec $ns0 nft list table ip nat |grep -q 'untracked counter packets [1-9]'
 	if [ $? -eq 0 ]; then
-		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device"
+		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
-		echo "FAIL: vrf masq rule has unexpected counter value"
+		echo "FAIL: vrf rules have unexpected counter value"
 		ret=1
 	fi
+
+	if [ "$qdisc" != "default" ]; then
+		tc -net $ns0 qdisc del dev tvrf root
+	fi
 }
 
 # add masq rule that gets evaluated w. outif set to veth device.
@@ -213,7 +234,8 @@ EOF
 }
 
 test_ct_zone_in
-test_masquerade_vrf
+test_masquerade_vrf "default"
+test_masquerade_vrf "pfifo"
 test_masquerade_veth
 
 exit $ret


