Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF1B689543
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjBCKSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjBCKRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:17:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E555992C3F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D6E8B82A64
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8584FC433D2;
        Fri,  3 Feb 2023 10:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419445;
        bh=Bau3BWS3C+C9QMoFxhoB/+98Sb0baew2Z1cyUR+Jwnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS4x/tL5+S8/68r30ADTP2DKBLdctIPRGl2IvFWwE+enhGJKFBVS4sgCzOmH2+X1G
         V0s6sh9nZsX6Ccxi9aUViZCm3C5eel4G4ojxNPcqSa3Zdi29y02C+xgowrwvuqe3+K
         hEmhYWSVRIyMkeOj2PxK+QMZPTKbRglQmDIOwMR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 4.14 61/62] ipv6: ensure sane device mtu in tunnels
Date:   Fri,  3 Feb 2023 11:12:57 +0100
Message-Id: <20230203101015.589836367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit d89d7ff01235f218dad37de84457717f699dee79 upstream.

Another syzbot report [1] with no reproducer hints
at a bug in ip6_gre tunnel (dev:ip6gretap0)

Since ipv6 mcast code makes sure to read dev->mtu once
and applies a sanity check on it (see commit b9b312a7a451
"ipv6: mcast: better catch silly mtu values"), a remaining
possibility is that a layer is able to set dev->mtu to
an underflowed value (high order bit set).

This could happen indeed in ip6gre_tnl_link_config_route(),
ip6_tnl_link_config() and ipip6_tunnel_bind_dev()

Make sure to sanitize mtu value in a local variable before
it is written once on dev->mtu, as lockless readers could
catch wrong temporary value.

[1]
skbuff: skb_over_panic: text:ffff80000b7a2f38 len:40 put:40 head:ffff000149dcf200 data:ffff000149dcf2b0 tail:0xd8 end:0xc0 dev:ip6gretap0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:120
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 10241 Comm: kworker/1:1 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: mld mld_ifc_work
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_panic+0x4c/0x50 net/core/skbuff.c:116
lr : skb_panic+0x4c/0x50 net/core/skbuff.c:116
sp : ffff800020dd3b60
x29: ffff800020dd3b70 x28: 0000000000000000 x27: ffff00010df2a800
x26: 00000000000000c0 x25: 00000000000000b0 x24: ffff000149dcf200
x23: 00000000000000c0 x22: 00000000000000d8 x21: ffff80000b7a2f38
x20: ffff00014c2f7800 x19: 0000000000000028 x18: 00000000000001a9
x17: 0000000000000000 x16: ffff80000db49158 x15: ffff000113bf1a80
x14: 0000000000000000 x13: 00000000ffffffff x12: ffff000113bf1a80
x11: ff808000081c0d5c x10: 0000000000000000 x9 : 73f125dc5c63ba00
x8 : 73f125dc5c63ba00 x7 : ffff800008161d1c x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefddcd0 x1 : 0000000100000000 x0 : 0000000000000089
Call trace:
skb_panic+0x4c/0x50 net/core/skbuff.c:116
skb_over_panic net/core/skbuff.c:125 [inline]
skb_put+0xd4/0xdc net/core/skbuff.c:2049
ip6_mc_hdr net/ipv6/mcast.c:1714 [inline]
mld_newpack+0x14c/0x270 net/ipv6/mcast.c:1765
add_grhead net/ipv6/mcast.c:1851 [inline]
add_grec+0xa20/0xae0 net/ipv6/mcast.c:1989
mld_send_cr+0x438/0x5a8 net/ipv6/mcast.c:2115
mld_ifc_work+0x38/0x290 net/ipv6/mcast.c:2653
process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
worker_thread+0x340/0x610 kernel/workqueue.c:2436
kthread+0x12c/0x158 kernel/kthread.c:376
ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
Code: 91011400 aa0803e1 a90027ea 94373093 (d4210000)

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221024020124.3756833-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ta: Backport patch for stable kernels < 5.10.y. Fix conflict in
net/ipv6/ip6_tunnel.c, mtu initialized with:
mtu = rt->dst.dev->mtu - t_hlen;]
Cc: <stable@vger.kernel.org> # 4.14.y, 4.19.y, 5.4.y
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c    |   12 +++++++-----
 net/ipv6/ip6_tunnel.c |   10 ++++++----
 net/ipv6/sit.c        |    8 +++++---
 3 files changed, 18 insertions(+), 12 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -771,14 +771,16 @@ static void ip6gre_tnl_link_config(struc
 					       t_hlen;
 
 			if (set_mtu) {
-				dev->mtu = rt->dst.dev->mtu - t_hlen;
+				int mtu = rt->dst.dev->mtu - t_hlen;
+
 				if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-					dev->mtu -= 8;
+					mtu -= 8;
 				if (dev->type == ARPHRD_ETHER)
-					dev->mtu -= ETH_HLEN;
+					mtu -= ETH_HLEN;
 
-				if (dev->mtu < IPV6_MIN_MTU)
-					dev->mtu = IPV6_MIN_MTU;
+				if (mtu < IPV6_MIN_MTU)
+					mtu = IPV6_MIN_MTU;
+				WRITE_ONCE(dev->mtu, mtu);
 			}
 		}
 		ip6_rt_put(rt);
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1431,6 +1431,7 @@ static void ip6_tnl_link_config(struct i
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 	int t_hlen;
+	int mtu;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1473,12 +1474,13 @@ static void ip6_tnl_link_config(struct i
 			dev->hard_header_len = rt->dst.dev->hard_header_len +
 				t_hlen;
 
-			dev->mtu = rt->dst.dev->mtu - t_hlen;
+			mtu = rt->dst.dev->mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 		ip6_rt_put(rt);
 	}
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1068,10 +1068,12 @@ static void ipip6_tunnel_bind_dev(struct
 
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+		int mtu;
 
-		dev->mtu = tdev->mtu - t_hlen;
-		if (dev->mtu < IPV6_MIN_MTU)
-			dev->mtu = IPV6_MIN_MTU;
+		mtu = tdev->mtu - t_hlen;
+		if (mtu < IPV6_MIN_MTU)
+			mtu = IPV6_MIN_MTU;
+		WRITE_ONCE(dev->mtu, mtu);
 	}
 }
 


