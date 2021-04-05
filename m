Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D134353CD0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhDEI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232950AbhDEI4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4293861394;
        Mon,  5 Apr 2021 08:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613008;
        bh=4eVUD4Yn1dwPr0iZwZB5iNy4j2G3UwM1o9+BIme31k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxunZLdQBEX9dJn8ihN+GDJ77cAzaniw2MwSH3po8AGbQ5WnY+VX5sES4k59OguBB
         SRD6ycPW9ehUOucc/Hh54EFGDiCH91qGKlC+2ZMay19R4G3VGRKpnQgoFDsLKSGJJj
         evehlREPo2txCEChuwnBDpazxyro+zPqgRSz6P24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 4.9 18/35] bpf: Remove MTU check in __bpf_skb_max_len
Date:   Mon,  5 Apr 2021 10:53:53 +0200
Message-Id: <20210405085019.455875111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

commit 6306c1189e77a513bf02720450bb43bd4ba5d8ae upstream.

Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
__bpf_skb_max_len() as the max-length. This function limit size against
the current net_device MTU (skb->dev->mtu).

When a BPF-prog grow the packet size, then it should not be limited to the
MTU. The MTU is a transmit limitation, and software receiving this packet
should be allowed to increase the size. Further more, current MTU check in
__bpf_skb_max_len uses the MTU from ingress/current net_device, which in
case of redirects uses the wrong net_device.

This patch keeps a sanity max limit of SKB_MAX_ALLOC (16KiB). The real limit
is elsewhere in the system. Jesper's testing[1] showed it was not possible
to exceed 8KiB when expanding the SKB size via BPF-helper. The limiting
factor is the define KMALLOC_MAX_CACHE_SIZE which is 8192 for
SLUB-allocator (CONFIG_SLUB) in-case PAGE_SIZE is 4096. This define is
in-effect due to this being called from softirq context see code
__gfp_pfmemalloc_flags() and __do_kmalloc_node(). Jakub's testing showed
that frames above 16KiB can cause NICs to reset (but not crash). Keep this
sanity limit at this level as memory layer can differ based on kernel
config.

[1] https://github.com/xdp-project/bpf-examples/tree/master/MTU-tests

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/161287788936.790810.2937823995775097177.stgit@firesoul
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2120,10 +2120,7 @@ static u32 __bpf_skb_min_len(const struc
 	return min_len;
 }
 
-static u32 __bpf_skb_max_len(const struct sk_buff *skb)
-{
-	return skb->dev->mtu + skb->dev->hard_header_len;
-}
+#define BPF_SKB_MAX_LEN SKB_MAX_ALLOC
 
 static int bpf_skb_grow_rcsum(struct sk_buff *skb, unsigned int new_len)
 {
@@ -2144,7 +2141,7 @@ static int bpf_skb_trim_rcsum(struct sk_
 BPF_CALL_3(bpf_skb_change_tail, struct sk_buff *, skb, u32, new_len,
 	   u64, flags)
 {
-	u32 max_len = __bpf_skb_max_len(skb);
+	u32 max_len = BPF_SKB_MAX_LEN;
 	u32 min_len = __bpf_skb_min_len(skb);
 	int ret;
 


