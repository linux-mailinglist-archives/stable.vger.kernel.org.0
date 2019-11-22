Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A366A106526
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVGWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfKVFwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C3B22075E;
        Fri, 22 Nov 2019 05:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401926;
        bh=7h6dwNVHY+1AQQph4vopgpi5NMKwVpbXI1hUGCpEHyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLobdi53F2bwPNJXQhWW+/PkqPuqwHCld5KxoMw+prl5t0Umfh8jXyi1xjIXZ5ydc
         9T8oktvS9iVHdj+HfJF5xadu5lO/M5gN+dNhGm3A44ofaLm/FM/fo8/FqTCkJNm8xe
         VuxrRnQ9tmtfnCOySA0MFCIBKFHI77l4fDBj18+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Lu <aaron.lu@intel.com>,
        Pawel Staszewski <pstaszewski@itcare.pl>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Pankaj gupta <pagupta@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 154/219] mm/page_alloc.c: free order-0 pages through PCP in page_frag_free()
Date:   Fri, 22 Nov 2019 00:48:06 -0500
Message-Id: <20191122054911.1750-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

[ Upstream commit 65895b67ad27df0f62bfaf82dd5622f95ea29196 ]

page_frag_free() calls __free_pages_ok() to free the page back to Buddy.
This is OK for high order page, but for order-0 pages, it misses the
optimization opportunity of using Per-Cpu-Pages and can cause zone lock
contention when called frequently.

Pawel Staszewski recently shared his result of 'how Linux kernel handles
normal traffic'[1] and from perf data, Jesper Dangaard Brouer found the
lock contention comes from page allocator:

  mlx5e_poll_tx_cq
  |
   --16.34%--napi_consume_skb
             |
             |--12.65%--__free_pages_ok
             |          |
             |           --11.86%--free_one_page
             |                     |
             |                     |--10.10%--queued_spin_lock_slowpath
             |                     |
             |                      --0.65%--_raw_spin_lock
             |
             |--1.55%--page_frag_free
             |
              --1.44%--skb_release_data

Jesper explained how it happened: mlx5 driver RX-page recycle mechanism is
not effective in this workload and pages have to go through the page
allocator.  The lock contention happens during mlx5 DMA TX completion
cycle.  And the page allocator cannot keep up at these speeds.[2]

I thought that __free_pages_ok() are mostly freeing high order pages and
thought this is an lock contention for high order pages but Jesper
explained in detail that __free_pages_ok() here are actually freeing
order-0 pages because mlx5 is using order-0 pages to satisfy its page pool
allocation request.[3]

The free path as pointed out by Jesper is:
skb_free_head()
  -> skb_free_frag()
    -> page_frag_free()
And the pages being freed on this path are order-0 pages.

Fix this by doing similar things as in __page_frag_cache_drain() - send
the being freed page to PCP if it's an order-0 page, or directly to Buddy
if it is a high order page.

With this change, Paweł hasn't noticed lock contention yet in his
workload and Jesper has noticed a 7% performance improvement using a micro
benchmark and lock contention is gone.  Ilias' test on a 'low' speed 1Gbit
interface on an cortex-a53 shows ~11% performance boost testing with
64byte packets and __free_pages_ok() disappeared from perf top.

[1]: https://www.spinics.net/lists/netdev/msg531362.html
[2]: https://www.spinics.net/lists/netdev/msg531421.html
[3]: https://www.spinics.net/lists/netdev/msg531556.html

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/20181120014544.GB10657@intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reported-by: Pawel Staszewski <pstaszewski@itcare.pl>
Analysed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Pankaj gupta <pagupta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b34348a41bfed..dcc46d955df2e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4581,8 +4581,14 @@ void page_frag_free(void *addr)
 {
 	struct page *page = virt_to_head_page(addr);
 
-	if (unlikely(put_page_testzero(page)))
-		__free_pages_ok(page, compound_order(page));
+	if (unlikely(put_page_testzero(page))) {
+		unsigned int order = compound_order(page);
+
+		if (order == 0)		/* Via pcp? */
+			free_unref_page(page);
+		else
+			__free_pages_ok(page, order);
+	}
 }
 EXPORT_SYMBOL(page_frag_free);
 
-- 
2.20.1

