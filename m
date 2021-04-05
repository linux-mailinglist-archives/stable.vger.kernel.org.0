Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3409353DDA
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbhDEJCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237408AbhDEJCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAAE26139D;
        Mon,  5 Apr 2021 09:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613344;
        bh=YH7BtUL1/Sts+1XJuOEwWp35JBS6uwnILl+WcnDJ1Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PdbX/LbRUnDdpUFkDyXIwu3Eeh8a4aT421+/6XkBWicBQz/NC7Hd653KajSqSTzO
         k7D8UQdywcxXPuBeOJQ+RGLXqEtd1KAnqq3Rm6YM+uTglaJLyX9U4J8UcsAciXBLcZ
         DqMCsUMy+e4NlrhL+w0h1S2DWr4mnXPWM2fl8bRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 4.19 28/56] bpf: Remove MTU check in __bpf_skb_max_len
Date:   Mon,  5 Apr 2021 10:53:59 +0200
Message-Id: <20210405085023.438276296@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
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
 net/core/filter.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2836,18 +2836,14 @@ static int bpf_skb_net_shrink(struct sk_
 	return 0;
 }
 
-static u32 __bpf_skb_max_len(const struct sk_buff *skb)
-{
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
-}
+#define BPF_SKB_MAX_LEN SKB_MAX_ALLOC
 
 static int bpf_skb_adjust_net(struct sk_buff *skb, s32 len_diff)
 {
 	bool trans_same = skb->transport_header == skb->network_header;
 	u32 len_cur, len_diff_abs = abs(len_diff);
 	u32 len_min = bpf_skb_net_base_len(skb);
-	u32 len_max = __bpf_skb_max_len(skb);
+	u32 len_max = BPF_SKB_MAX_LEN;
 	__be16 proto = skb_protocol(skb, true);
 	bool shrink = len_diff < 0;
 	int ret;
@@ -2926,7 +2922,7 @@ static int bpf_skb_trim_rcsum(struct sk_
 static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
 					u64 flags)
 {
-	u32 max_len = __bpf_skb_max_len(skb);
+	u32 max_len = BPF_SKB_MAX_LEN;
 	u32 min_len = __bpf_skb_min_len(skb);
 	int ret;
 
@@ -3002,7 +2998,7 @@ static const struct bpf_func_proto sk_sk
 static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
 					u64 flags)
 {
-	u32 max_len = __bpf_skb_max_len(skb);
+	u32 max_len = BPF_SKB_MAX_LEN;
 	u32 new_len = skb->len + head_room;
 	int ret;
 


