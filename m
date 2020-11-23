Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D522C0798
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732936AbgKWMmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732930AbgKWMma (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2309A21D7A;
        Mon, 23 Nov 2020 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135349;
        bh=5sRT05j5UYL8dUuFjLXBr+J4MtGaD12i655VBY05fJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iytqLxM+rNtfbrf5Yr2JBT+hO9O34b0G2d/I2hLZ52iV67RFzFw2AGXsRJBMnOsPD
         D7ptGeCVM1+duXiW/WR5VLeb6rXGAB5CJUXptetUfLny7he4htelvHZhwGAXZHSeAF
         UR/sgELpvyjyAfS1XVuVMQgtwMnz2dkQSYwkNyzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 036/252] page_frag: Recover from memory pressure
Date:   Mon, 23 Nov 2020 13:19:46 +0100
Message-Id: <20201123121837.325261804@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit d8c19014bba8f565d8a2f1f46b4e38d1d97bf1a7 ]

The ethernet driver may allocate skb (and skb->data) via napi_alloc_skb().
This ends up to page_frag_alloc() to allocate skb->data from
page_frag_cache->va.

During the memory pressure, page_frag_cache->va may be allocated as
pfmemalloc page. As a result, the skb->pfmemalloc is always true as
skb->data is from page_frag_cache->va. The skb will be dropped if the
sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
under memory pressure.

However, once kernel is not under memory pressure any longer (suppose large
amount of memory pages are just reclaimed), the page_frag_alloc() may still
re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
result, the skb->pfmemalloc is always true unless page_frag_cache->va is
re-allocated, even if the kernel is not under memory pressure any longer.

Here is how kernel runs into issue.

1. The kernel is under memory pressure and allocation of
PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
the pfmemalloc page is allocated for page_frag_cache->va.

2: All skb->data from page_frag_cache->va (pfmemalloc) will have
skb->pfmemalloc=true. The skb will always be dropped by sock without
SOCK_MEMALLOC. This is an expected behaviour.

3. Suppose a large amount of pages are reclaimed and kernel is not under
memory pressure any longer. We expect skb->pfmemalloc drop will not happen.

4. Unfortunately, page_frag_alloc() does not proactively re-allocate
page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
skb->pfmemalloc is always true even kernel is not under memory pressure any
longer.

Fix this by freeing and re-allocating the page instead of recycling it.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bert Barbe <bert.barbe@oracle.com>
Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: SRINIVAS <srinivas.eeda@oracle.com>
Fixes: 79930f5892e1 ("net: do not deplete pfmemalloc reserve")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201115201029.11903-1-dongli.zhang@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5053,6 +5053,11 @@ refill:
 		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
 			goto refill;
 
+		if (unlikely(nc->pfmemalloc)) {
+			free_the_page(page, compound_order(page));
+			goto refill;
+		}
+
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
 		/* if size can vary use size else just use PAGE_SIZE */
 		size = nc->size;


