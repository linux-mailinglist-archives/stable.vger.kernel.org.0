Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700273287EA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhCARan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238353AbhCARYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1391465077;
        Mon,  1 Mar 2021 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617395;
        bh=tm5dzMweYDJXeK5saW+xlG+ayMHfzUnqxq9LQEYCF6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdkI4MZuf6fvRkn2WRvBBskeXzg/u9EbAcFvLsKDEq4SyjJbrbnh13vWl43rpKZxx
         kVnWDdXwyQskiYh6I58u4OSEyBb0tJs5K3I+fdNXNQuodmORE7i6cyGkcuLxNnFfQs
         P2mJ9YfRefJLURXvMaqK1Nv2VtBgltdeZr6f5GOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlo Carraro <colrack@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/340] bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx
Date:   Mon,  1 Mar 2021 17:10:02 +0100
Message-Id: <20210301161051.174061587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 2c0a10af688c02adcf127aad29e923e0056c6b69 ]

BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
by adjusting fib_params 'tot_len' with the packet length plus the expected
encap size. (Just like the bpf_check_mtu helper supports). He discovered
that for SKB ctx the param->tot_len was not used, instead skb->len was used
(via MTU check in is_skb_forwardable() that checks against netdev MTU).

Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
check is done like XDP code-path, which checks against FIB-dst MTU.

V16:
- Revert V13 optimization, 2nd lookup is against egress/resulting netdev

V13:
- Only do ifindex lookup one time, calling dev_get_by_index_rcu().

V10:
- Use same method as XDP for 'tot_len' MTU check

Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
Reported-by: Carlo Carraro <colrack@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/161287789444.790810.15247494756551413508.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2fa10fdcf6b1d..524f3364f8a05 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4880,6 +4880,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 {
 	struct net *net = dev_net(skb->dev);
 	int rc = -EAFNOSUPPORT;
+	bool check_mtu = false;
 
 	if (plen < sizeof(*params))
 		return -EINVAL;
@@ -4887,22 +4888,28 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
 		return -EINVAL;
 
+	if (params->tot_len)
+		check_mtu = true;
+
 	switch (params->family) {
 #if IS_ENABLED(CONFIG_INET)
 	case AF_INET:
-		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
+		rc = bpf_ipv4_fib_lookup(net, params, flags, check_mtu);
 		break;
 #endif
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
+		rc = bpf_ipv6_fib_lookup(net, params, flags, check_mtu);
 		break;
 #endif
 	}
 
-	if (!rc) {
+	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
 		struct net_device *dev;
 
+		/* When tot_len isn't provided by user, check skb
+		 * against MTU of FIB lookup resulting net_device
+		 */
 		dev = dev_get_by_index_rcu(net, params->ifindex);
 		if (!is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
-- 
2.27.0



