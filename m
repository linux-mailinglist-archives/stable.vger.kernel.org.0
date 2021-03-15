Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2679333BAE0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbhCOOKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234347AbhCOODP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C3964DAD;
        Mon, 15 Mar 2021 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816995;
        bh=GT23MI2WT8PQhaf0Bt8mf+eRN5Gc0SR/mz72E4QscaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDE/EdXi/kUkdxSCfyP9L/UWzdv7F4UUJDHZpxMs3bcHoKqkvTcHRG3nbr7DwM31l
         Z3OqtuaEb1MZtTUm5kw+dnNpTgl7UXFnVuQZu5wr0mg8/eDsa4ii2rDBz8HUYKdMO0
         UWDytwbM43i0ZaT8uOf8FyucNCUb5fpBPyMyZKZI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony DeRossi <ajderossi@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 250/306] drm/ttm: Fix TTM page pool accounting
Date:   Mon, 15 Mar 2021 14:55:13 +0100
Message-Id: <20210315135516.095878997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Anthony DeRossi <ajderossi@gmail.com>

[ Upstream commit ca63d76fd2319db984f2875992643f900caf2c72 ]

Freed pages are not subtracted from the allocated_pages counter in
ttm_pool_type_fini(), causing a leak in the count on device removal.
The next shrinker invocation loops forever trying to free pages that are
no longer in the pool:

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu:  3-....: (9998 ticks this GP) idle=54e/1/0x4000000000000000 softirq=434857/434857 fqs=2237
    (t=10001 jiffies g=2194533 q=49211)
  NMI backtrace for cpu 3
  CPU: 3 PID: 1034 Comm: kswapd0 Tainted: P           O      5.11.0-com #1
  Hardware name: System manufacturer System Product Name/PRIME X570-PRO, BIOS 1405 11/19/2019
  Call Trace:
   <IRQ>
   ...
   </IRQ>
   sysvec_apic_timer_interrupt+0x77/0x80
   asm_sysvec_apic_timer_interrupt+0x12/0x20
  RIP: 0010:mutex_unlock+0x16/0x20
  Code: e7 48 8b 70 10 e8 7a 53 77 ff eb aa e8 43 6c ff ff 0f 1f 00 65 48 8b 14 25 00 6d 01 00 31 c9 48 89 d0 f0 48 0f b1 0f 48 39 c2 <74> 05 e9 e3 fe ff ff c3 66 90 48 8b 47 20 48 85 c0 74 0f 8b 50 10
  RSP: 0018:ffffbdb840797be8 EFLAGS: 00000246
  RAX: ffff9ff445a41c00 RBX: ffffffffc02a9ef8 RCX: 0000000000000000
  RDX: ffff9ff445a41c00 RSI: ffffbdb840797c78 RDI: ffffffffc02a9ac0
  RBP: 0000000000000080 R08: 0000000000000000 R09: ffffbdb840797c80
  R10: 0000000000000000 R11: fffffffffffffff5 R12: 0000000000000000
  R13: 0000000000000000 R14: 0000000000000084 R15: ffffffffc02a9a60
   ttm_pool_shrink+0x7d/0x90 [ttm]
   ttm_pool_shrinker_scan+0x5/0x20 [ttm]
   do_shrink_slab+0x13a/0x1a0
...

debugfs shows the incorrect total:

  $ cat /sys/kernel/debug/dri/0/ttm_page_pool
            --- 0--- --- 1--- --- 2--- --- 3--- --- 4--- --- 5--- --- 6--- --- 7--- --- 8--- --- 9--- ---10---
  wc      :        0        0        0        0        0        0        0        0        0        0        0
  uc      :        0        0        0        0        0        0        0        0        0        0        0
  wc 32   :        0        0        0        0        0        0        0        0        0        0        0
  uc 32   :        0        0        0        0        0        0        0        0        0        0        0
  DMA uc  :        0        0        0        0        0        0        0        0        0        0        0
  DMA wc  :        0        0        0        0        0        0        0        0        0        0        0
  DMA     :        0        0        0        0        0        0        0        0        0        0        0

  total   :     3029 of  8244261

Using ttm_pool_type_take() to remove pages from the pool before freeing
them correctly accounts for the freed pages.

Fixes: d099fc8f540a ("drm/ttm: new TT backend allocation pool v3")
Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210303011723.22512-1-ajderossi@gmail.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 6e27cb1bf48b..4eb6efb8b8c0 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -268,13 +268,13 @@ static void ttm_pool_type_init(struct ttm_pool_type *pt, struct ttm_pool *pool,
 /* Remove a pool_type from the global shrinker list and free all pages */
 static void ttm_pool_type_fini(struct ttm_pool_type *pt)
 {
-	struct page *p, *tmp;
+	struct page *p;
 
 	mutex_lock(&shrinker_lock);
 	list_del(&pt->shrinker_list);
 	mutex_unlock(&shrinker_lock);
 
-	list_for_each_entry_safe(p, tmp, &pt->pages, lru)
+	while ((p = ttm_pool_type_take(pt)))
 		ttm_pool_free_page(pt->pool, pt->caching, pt->order, p);
 }
 
-- 
2.30.1



