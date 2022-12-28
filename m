Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE3657EE7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiL1P7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiL1P7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5CC18B31
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060C261562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17049C433EF;
        Wed, 28 Dec 2022 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243138;
        bh=j70oovOAnzydGEjGIVxrDnsFcwXl8sgvwoJ4d4R1vzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDxzK85yO9Gz8bEytwtck1/3NYDynqYGwpzcGTbj+9cnhjN87cnUdklXPwPiwNNDg
         IslJ0hrkSFWG1l8pVKuURzaeYrtpP0/nWUkgYtKFr56WbEuHo2L/OQP/0T3Y5Txp4A
         D39VgzyOhpi8crUeFl2/t+OSi8dfync7vFElpUDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0443/1146] netfilter: conntrack: set icmpv6 redirects as RELATED
Date:   Wed, 28 Dec 2022 15:33:02 +0100
Message-Id: <20221228144342.213179123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7d7cfb48d81353e826493d24c7cec7360950968f ]

icmp conntrack will set icmp redirects as RELATED, but icmpv6 will not
do this.

For icmpv6, only icmp errors (code <= 128) are examined for RELATED state.
ICMPV6 Redirects are part of neighbour discovery mechanism, those are
handled by marking a selected subset (e.g.  neighbour solicitations) as
UNTRACKED, but not REDIRECT -- they will thus be flagged as INVALID.

Add minimal support for REDIRECTs.  No parsing of neighbour options is
added for simplicity, so this will only check that we have the embeeded
original header (ND_OPT_REDIRECT_HDR), and then attempt to do a flow
lookup for this tuple.

Also extend the existing test case to cover redirects.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Eric Garver <eric@garver.life>
Link: https://github.com/firewalld/firewalld/issues/1046
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_icmpv6.c     | 53 +++++++++++++++++++
 .../netfilter/conntrack_icmp_related.sh       | 36 ++++++++++++-
 2 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 61e3b05cf02c..1020d67600a9 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -129,6 +129,56 @@ static void icmpv6_error_log(const struct sk_buff *skb,
 	nf_l4proto_log_invalid(skb, state, IPPROTO_ICMPV6, "%s", msg);
 }
 
+static noinline_for_stack int
+nf_conntrack_icmpv6_redirect(struct nf_conn *tmpl, struct sk_buff *skb,
+			     unsigned int dataoff,
+			     const struct nf_hook_state *state)
+{
+	u8 hl = ipv6_hdr(skb)->hop_limit;
+	union nf_inet_addr outer_daddr;
+	union {
+		struct nd_opt_hdr nd_opt;
+		struct rd_msg rd_msg;
+	} tmp;
+	const struct nd_opt_hdr *nd_opt;
+	const struct rd_msg *rd_msg;
+
+	rd_msg = skb_header_pointer(skb, dataoff, sizeof(*rd_msg), &tmp.rd_msg);
+	if (!rd_msg) {
+		icmpv6_error_log(skb, state, "short redirect");
+		return -NF_ACCEPT;
+	}
+
+	if (rd_msg->icmph.icmp6_code != 0)
+		return NF_ACCEPT;
+
+	if (hl != 255 || !(ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)) {
+		icmpv6_error_log(skb, state, "invalid saddr or hoplimit for redirect");
+		return -NF_ACCEPT;
+	}
+
+	dataoff += sizeof(*rd_msg);
+
+	/* warning: rd_msg no longer usable after this call */
+	nd_opt = skb_header_pointer(skb, dataoff, sizeof(*nd_opt), &tmp.nd_opt);
+	if (!nd_opt || nd_opt->nd_opt_len == 0) {
+		icmpv6_error_log(skb, state, "redirect without options");
+		return -NF_ACCEPT;
+	}
+
+	/* We could call ndisc_parse_options(), but it would need
+	 * skb_linearize() and a bit more work.
+	 */
+	if (nd_opt->nd_opt_type != ND_OPT_REDIRECT_HDR)
+		return NF_ACCEPT;
+
+	memcpy(&outer_daddr.ip6, &ipv6_hdr(skb)->daddr,
+	       sizeof(outer_daddr.ip6));
+	dataoff += 8;
+	return nf_conntrack_inet_error(tmpl, skb, dataoff, state,
+				       IPPROTO_ICMPV6, &outer_daddr);
+}
+
 int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb,
 			      unsigned int dataoff,
@@ -159,6 +209,9 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 		return NF_ACCEPT;
 	}
 
+	if (icmp6h->icmp6_type == NDISC_REDIRECT)
+		return nf_conntrack_icmpv6_redirect(tmpl, skb, dataoff, state);
+
 	/* is not error message ? */
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
diff --git a/tools/testing/selftests/netfilter/conntrack_icmp_related.sh b/tools/testing/selftests/netfilter/conntrack_icmp_related.sh
index b48e1833bc89..76645aaf2b58 100755
--- a/tools/testing/selftests/netfilter/conntrack_icmp_related.sh
+++ b/tools/testing/selftests/netfilter/conntrack_icmp_related.sh
@@ -35,6 +35,8 @@ cleanup() {
 	for i in 1 2;do ip netns del nsrouter$i;done
 }
 
+trap cleanup EXIT
+
 ipv4() {
     echo -n 192.168.$1.2
 }
@@ -146,11 +148,17 @@ ip netns exec nsclient1 nft -f - <<EOF
 table inet filter {
 	counter unknown { }
 	counter related { }
+	counter redir4 { }
+	counter redir6 { }
 	chain input {
 		type filter hook input priority 0; policy accept;
-		meta l4proto { icmp, icmpv6 } ct state established,untracked accept
 
+		icmp type "redirect" ct state "related" counter name "redir4" accept
+		icmpv6 type "nd-redirect" ct state "related" counter name "redir6" accept
+
+		meta l4proto { icmp, icmpv6 } ct state established,untracked accept
 		meta l4proto { icmp, icmpv6 } ct state "related" counter name "related" accept
+
 		counter name "unknown" drop
 	}
 }
@@ -279,5 +287,29 @@ else
 	echo "ERROR: icmp error RELATED state test has failed"
 fi
 
-cleanup
+# add 'bad' route,  expect icmp REDIRECT to be generated
+ip netns exec nsclient1 ip route add 192.168.1.42 via 192.168.1.1
+ip netns exec nsclient1 ip route add dead:1::42 via dead:1::1
+
+ip netns exec "nsclient1" ping -q -c 2 192.168.1.42 > /dev/null
+
+expect="packets 1 bytes 112"
+check_counter nsclient1 "redir4" "$expect"
+if [ $? -ne 0 ];then
+	ret=1
+fi
+
+ip netns exec "nsclient1" ping -c 1 dead:1::42 > /dev/null
+expect="packets 1 bytes 192"
+check_counter nsclient1 "redir6" "$expect"
+if [ $? -ne 0 ];then
+	ret=1
+fi
+
+if [ $ret -eq 0 ];then
+	echo "PASS: icmp redirects had RELATED state"
+else
+	echo "ERROR: icmp redirect RELATED state test has failed"
+fi
+
 exit $ret
-- 
2.35.1



