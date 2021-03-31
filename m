Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B73B34CABE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhC2Ijr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhC2Ih4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9975361580;
        Mon, 29 Mar 2021 08:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007076;
        bh=hnpor7IztdL54/dqqRQe7pND8hi8h6ZeOxhkV6P1OKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQZAPfb+QAK9Pgca5JXxbFBUVHOli7piw524nWCTJ4Wh/8I3eiw9uqX59g9qRu9dJ
         /Wdqx4MiiQWgNKxMh7kqrb4McnGm3alVAIVIS3aKzDXtk6ybFssnxCnjY3R4o/Blbs
         UjZshZl9Zy7zEMIHYr/Z//qROQvDu/TZJdAsVmxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 213/254] net, bpf: Fix ip6ip6 crash with collect_md populated skbs
Date:   Mon, 29 Mar 2021 09:58:49 +0200
Message-Id: <20210329075640.099950129@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit a188bb5638d41aa99090ebf2f85d3505ab13fba5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



