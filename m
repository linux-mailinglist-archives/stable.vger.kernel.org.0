Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC22300FCE
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbhAVT5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:57:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbhAVOMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:12:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09A7123A81;
        Fri, 22 Jan 2021 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324590;
        bh=Ej/CKyexzaT97IQj04YS66GMd2TLojvTdgMwjrPfiYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f33WuRqVSwcEYEfb7HKOwuiQZnc0FQT42oBgBlip1SCT7lxxoZgoXVup1kuAZ3dCa
         gikeZXcGWCu3cySt8bneTjGzZpEEtHqjtSb+EfNQRS5Mo9jp/5ElrE5bjwWc3pL5+J
         t1g4eAS78Lwhb6g34PNjLMJHFAGjOVGN+6DqSCQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 30/31] net: avoid 32 x truesize under-estimation for tiny skbs
Date:   Fri, 22 Jan 2021 15:08:44 +0100
Message-Id: <20210122135733.077196420@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3226b158e67cfaa677fd180152bfb28989cb2fac ]

Both virtio net and napi_get_frags() allocate skbs
with a very small skb->head

While using page fragments instead of a kmalloc backed skb->head might give
a small performance improvement in some cases, there is a huge risk of
under estimating memory usage.

For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
per page (order-3 page in x86), or even 64 on PowerPC

We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
but consuming far more memory for TCP buffers than instructed in tcp_mem[2]

Even if we force napi_alloc_skb() to only use order-0 pages, the issue
would still be there on arches with PAGE_SIZE >= 32768

This patch makes sure that small skb head are kmalloc backed, so that
other objects in the slab page can be reused instead of being held as long
as skbs are sitting in socket queues.

Note that we might in the future use the sk_buff napi cache,
instead of going through a more expensive __alloc_skb()

Another idea would be to use separate page sizes depending
on the allocated length (to never have more than 4 frags per page)

I would like to thank Greg Thelen for his precious help on this matter,
analysing crash dumps is always a time consuming task.

Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20210113161819.1155526-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -480,13 +480,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 				 gfp_t gfp_mask)
 {
-	struct page_frag_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+	struct page_frag_cache *nc;
 	struct sk_buff *skb;
 	void *data;
 
 	len += NET_SKB_PAD + NET_IP_ALIGN;
 
-	if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
+	/* If requested length is either too small or too big,
+	 * we use kmalloc() for skb->head allocation.
+	 */
+	if (len <= SKB_WITH_OVERHEAD(1024) ||
+	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 		if (!skb)
@@ -494,6 +498,7 @@ struct sk_buff *__napi_alloc_skb(struct
 		goto skb_success;
 	}
 
+	nc = this_cpu_ptr(&napi_alloc_cache);
 	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	len = SKB_DATA_ALIGN(len);
 


