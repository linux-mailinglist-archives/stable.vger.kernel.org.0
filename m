Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52AC593F07
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbiHOUwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347392AbiHOUvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:51:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7C0B876;
        Mon, 15 Aug 2022 12:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6429860BB5;
        Mon, 15 Aug 2022 19:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6923FC433D7;
        Mon, 15 Aug 2022 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590617;
        bh=Y9GDYJGTUHPrxHBpY+wSUMwQDWvSENsK0Fje2HaRYaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXfm54cJaQqY14HEiSlzv9r+ve3uero0bFueBwjSElaDXjVaLyDkrImTgyi2oQVn1
         zfABVPzve6ev4jk8IBVaI97mdkneWLRFiUhPdaGGve6iUZxBI0c5mC2OpG5lRqX67y
         wu33AMkRnfk8yWq4u1p//YrbPNh/XX5ieESUwKNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0316/1095] selftests/bpf: Fix tc_redirect_dtime
Date:   Mon, 15 Aug 2022 19:55:15 +0200
Message-Id: <20220815180442.863797763@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit e6ff92f41b65fce07365f1066fb13b5e42aca08d ]

tc_redirect_dtime was reported flaky from time to time.  It
always fails at the udp test and complains about the bpf@tc-ingress
got a skb->tstamp when handling udp packet.  It is unexpected
because the skb->tstamp should have been cleared when crossing
different netns.

The most likely cause is that the skb is actually a tcp packet
from the earlier tcp test.  It could be the final TCP_FIN handling.

This patch tightens the skb->tstamp check in the bpf prog.  It ensures
the skb is the current testing traffic.  First, it checks that skb
matches the IPPROTO of the running test (i.e. tcp vs udp).
Second, it checks the server port (dst_ns_port).  The server
port is unique for each test (50000 + test_enum).

Also fixed a typo in test_udp_dtime(): s/P100/P101/

Fixes: c803475fd8dd ("bpf: selftests: test skb->tstamp in redirect_neigh")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220601234050.2572671-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/tc_redirect.c    |  8 +--
 .../selftests/bpf/progs/test_tc_dtime.c       | 53 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 7ad66a247c02..b2e415647bd7 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -646,7 +646,7 @@ static void test_tcp_clear_dtime(struct test_tc_dtime *skel)
 	__u32 *errs = skel->bss->errs[t];
 
 	skel->bss->test = t;
-	test_inet_dtime(AF_INET6, SOCK_STREAM, IP6_DST, 0);
+	test_inet_dtime(AF_INET6, SOCK_STREAM, IP6_DST, 50000 + t);
 
 	ASSERT_EQ(dtimes[INGRESS_FWDNS_P100], 0,
 		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
@@ -683,7 +683,7 @@ static void test_tcp_dtime(struct test_tc_dtime *skel, int family, bool bpf_fwd)
 	errs = skel->bss->errs[t];
 
 	skel->bss->test = t;
-	test_inet_dtime(family, SOCK_STREAM, addr, 0);
+	test_inet_dtime(family, SOCK_STREAM, addr, 50000 + t);
 
 	/* fwdns_prio100 prog does not read delivery_time_type, so
 	 * kernel puts the (rcv) timetamp in __sk_buff->tstamp
@@ -715,13 +715,13 @@ static void test_udp_dtime(struct test_tc_dtime *skel, int family, bool bpf_fwd)
 	errs = skel->bss->errs[t];
 
 	skel->bss->test = t;
-	test_inet_dtime(family, SOCK_DGRAM, addr, 0);
+	test_inet_dtime(family, SOCK_DGRAM, addr, 50000 + t);
 
 	ASSERT_EQ(dtimes[INGRESS_FWDNS_P100], 0,
 		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
 	/* non mono delivery time is not forwarded */
 	ASSERT_EQ(dtimes[INGRESS_FWDNS_P101], 0,
-		  dtime_cnt_str(t, INGRESS_FWDNS_P100));
+		  dtime_cnt_str(t, INGRESS_FWDNS_P101));
 	for (i = EGRESS_FWDNS_P100; i < SET_DTIME; i++)
 		ASSERT_GT(dtimes[i], 0, dtime_cnt_str(t, i));
 
diff --git a/tools/testing/selftests/bpf/progs/test_tc_dtime.c b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
index 06f300d06dbd..b596479a9ebe 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_dtime.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
@@ -11,6 +11,8 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 #include <sys/socket.h>
@@ -115,6 +117,19 @@ static bool bpf_fwd(void)
 	return test < TCP_IP4_RT_FWD;
 }
 
+static __u8 get_proto(void)
+{
+	switch (test) {
+	case UDP_IP4:
+	case UDP_IP6:
+	case UDP_IP4_RT_FWD:
+	case UDP_IP6_RT_FWD:
+		return IPPROTO_UDP;
+	default:
+		return IPPROTO_TCP;
+	}
+}
+
 /* -1: parse error: TC_ACT_SHOT
  *  0: not testing traffic: TC_ACT_OK
  * >0: first byte is the inet_proto, second byte has the netns
@@ -122,11 +137,16 @@ static bool bpf_fwd(void)
  */
 static int skb_get_type(struct __sk_buff *skb)
 {
+	__u16 dst_ns_port = __bpf_htons(50000 + test);
 	void *data_end = ctx_ptr(skb->data_end);
 	void *data = ctx_ptr(skb->data);
 	__u8 inet_proto = 0, ns = 0;
 	struct ipv6hdr *ip6h;
+	__u16 sport, dport;
 	struct iphdr *iph;
+	struct tcphdr *th;
+	struct udphdr *uh;
+	void *trans;
 
 	switch (skb->protocol) {
 	case __bpf_htons(ETH_P_IP):
@@ -138,6 +158,7 @@ static int skb_get_type(struct __sk_buff *skb)
 		else if (iph->saddr == ip4_dst)
 			ns = DST_NS;
 		inet_proto = iph->protocol;
+		trans = iph + 1;
 		break;
 	case __bpf_htons(ETH_P_IPV6):
 		ip6h = data + sizeof(struct ethhdr);
@@ -148,15 +169,43 @@ static int skb_get_type(struct __sk_buff *skb)
 		else if (v6_equal(ip6h->saddr, (struct in6_addr)ip6_dst))
 			ns = DST_NS;
 		inet_proto = ip6h->nexthdr;
+		trans = ip6h + 1;
 		break;
 	default:
 		return 0;
 	}
 
-	if ((inet_proto != IPPROTO_TCP && inet_proto != IPPROTO_UDP) || !ns)
+	/* skb is not from src_ns or dst_ns.
+	 * skb is not the testing IPPROTO.
+	 */
+	if (!ns || inet_proto != get_proto())
 		return 0;
 
-	return (ns << 8 | inet_proto);
+	switch (inet_proto) {
+	case IPPROTO_TCP:
+		th = trans;
+		if (th + 1 > data_end)
+			return -1;
+		sport = th->source;
+		dport = th->dest;
+		break;
+	case IPPROTO_UDP:
+		uh = trans;
+		if (uh + 1 > data_end)
+			return -1;
+		sport = uh->source;
+		dport = uh->dest;
+		break;
+	default:
+		return 0;
+	}
+
+	/* The skb is the testing traffic */
+	if ((ns == SRC_NS && dport == dst_ns_port) ||
+	    (ns == DST_NS && sport == dst_ns_port))
+		return (ns << 8 | inet_proto);
+
+	return 0;
 }
 
 /* format: direction@iface@netns
-- 
2.35.1



