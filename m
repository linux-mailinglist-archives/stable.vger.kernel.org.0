Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D249D34D546
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhC2QkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhC2Qjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085C06157E;
        Mon, 29 Mar 2021 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617035975;
        bh=Yqe60TFRt/IILuS8fLMQTy/VuZ2P/I9D3r0qkjJFqB4=;
        h=From:To:Cc:Subject:Date:From;
        b=J43+8Q9gU3rxXEFKu3vcV9xiz2kItxw/JC3CpsJwPr6eDENEoydv7IQF/llpGVB8b
         SZhAoUUWa5E9HNoKhYIPyTVZsFX1aBLSa7vRTdL83NSZ8NOtrNYnChmNqj+odBpvSj
         kgsptLo8K2j4QV9K7g94ilzalcDvWajM5hJOhaXSvsHWo/GSLkHe0sRMsm8YDnQPa9
         OSbkBEompS7hi635bP/GJymmuVHOtmDWviaD2rnygI3yc7ZddrePcOinbVbc2tci0M
         eBzMgs2N2EvYJzQN4+ueqNRnS2CvnFN1CBsGn4ikQugN4WbIjZLQY2RPMbwEo0gQ0s
         HKykwWatryu4w==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, daniel@iogearbox.net
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: Patch "net, bpf: Fix ip6ip6 crash with collect_md populated skbs" failed to apply to 5.4-stable tree
Date:   Mon, 29 Mar 2021 12:39:31 -0400
Message-Id: <20210329163931.2358017-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a188bb5638d41aa99090ebf2f85d3505ab13fba5 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 10 Mar 2021 01:38:10 +0100
Subject: [PATCH] net, bpf: Fix ip6ip6 crash with collect_md populated skbs

I ran into a crash where setting up a ip6ip6 tunnel device which was /not/
set to collect_md mode was receiving collect_md populated skbs for xmit.

The BPF prog was populating the skb via bpf_skb_set_tunnel_key() which is
assigning special metadata dst entry and then redirecting the skb to the
device, taking ip6_tnl_start_xmit() -> ipxip6_tnl_xmit() -> ip6_tnl_xmit()
and in the latter it performs a neigh lookup based on skb_dst(skb) where
we trigger a NULL pointer dereference on dst->ops->neigh_lookup() since
the md_dst_ops do not populate neigh_lookup callback with a fake handler.

Transform the md_dst_ops into generic dst_blackhole_ops that can also be
reused elsewhere when needed, and use them for the metadata dst entries as
callback ops.

Also, remove the dst_md_discard{,_out}() ops and rely on dst_discard{,_out}()
from dst_init() which free the skb the same way modulo the splat. Given we
will be able to recover just fine from there, avoid any potential splats
iff this gets ever triggered in future (or worse, panic on warns when set).

Fixes: f38a9eb1f77b ("dst: Metadata destinations")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/dst.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 5f6315601776..fb3bcba87744 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -275,37 +275,24 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
-static struct dst_ops md_dst_ops = {
-	.family =		AF_UNSPEC,
+static struct dst_ops dst_blackhole_ops = {
+	.family		= AF_UNSPEC,
+	.neigh_lookup	= dst_blackhole_neigh_lookup,
+	.check		= dst_blackhole_check,
+	.cow_metrics	= dst_blackhole_cow_metrics,
+	.update_pmtu	= dst_blackhole_update_pmtu,
+	.redirect	= dst_blackhole_redirect,
+	.mtu		= dst_blackhole_mtu,
 };
 
-static int dst_md_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb)
-{
-	WARN_ONCE(1, "Attempting to call output on metadata dst\n");
-	kfree_skb(skb);
-	return 0;
-}
-
-static int dst_md_discard(struct sk_buff *skb)
-{
-	WARN_ONCE(1, "Attempting to call input on metadata dst\n");
-	kfree_skb(skb);
-	return 0;
-}
-
 static void __metadata_dst_init(struct metadata_dst *md_dst,
 				enum metadata_type type, u8 optslen)
-
 {
 	struct dst_entry *dst;
 
 	dst = &md_dst->dst;
-	dst_init(dst, &md_dst_ops, NULL, 1, DST_OBSOLETE_NONE,
+	dst_init(dst, &dst_blackhole_ops, NULL, 1, DST_OBSOLETE_NONE,
 		 DST_METADATA | DST_NOCOUNT);
-
-	dst->input = dst_md_discard;
-	dst->output = dst_md_discard_out;
-
 	memset(dst + 1, 0, sizeof(*md_dst) + optslen - sizeof(*dst));
 	md_dst->type = type;
 }
-- 
2.30.1




