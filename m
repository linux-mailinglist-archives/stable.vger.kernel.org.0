Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C01D304A72
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbhAZFEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731252AbhAYSxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0186622D50;
        Mon, 25 Jan 2021 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600759;
        bh=aTJz/WVm/EALmbVU9iwnvntpZG+mAZ9u3t1ZTMygO9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGB8gS8uhXSCpQsAR6vUrvcEszALaKGI68unsjxDqO7G+9W8icrsuGO7qBlsWH3G9
         d/9wyErYqh7KZ3V/SsrqepcFWhlkMcxev+NnNktlafbrSBzC2nCp517AXedXSr56R+
         xxVms+KAYT2VeH4XSBeuLoPNDHD9I1qycMZ9gmxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Imran Khan <imran.f.khan@oracle.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Koutn <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 123/199] mm: memcg/slab: optimize objcg stock draining
Date:   Mon, 25 Jan 2021 19:39:05 +0100
Message-Id: <20210125183221.413841627@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 3de7d4f25a7438f09fef4e71ef111f1805cd8e7c upstream.

Imran Khan reported a 16% regression in hackbench results caused by the
commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
instead of pages").  The regression is noticeable in the case of a
consequent allocation of several relatively large slab objects, e.g.
skb's.  As soon as the amount of stocked bytes exceeds PAGE_SIZE,
drain_obj_stock() and __memcg_kmem_uncharge() are called, and it leads
to a number of atomic operations in page_counter_uncharge().

The corresponding call graph is below (provided by Imran Khan):

  |__alloc_skb
  |    |
  |    |__kmalloc_reserve.isra.61
  |    |    |
  |    |    |__kmalloc_node_track_caller
  |    |    |    |
  |    |    |    |slab_pre_alloc_hook.constprop.88
  |    |    |     obj_cgroup_charge
  |    |    |    |    |
  |    |    |    |    |__memcg_kmem_charge
  |    |    |    |    |    |
  |    |    |    |    |    |page_counter_try_charge
  |    |    |    |    |
  |    |    |    |    |refill_obj_stock
  |    |    |    |    |    |
  |    |    |    |    |    |drain_obj_stock.isra.68
  |    |    |    |    |    |    |
  |    |    |    |    |    |    |__memcg_kmem_uncharge
  |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |page_counter_uncharge
  |    |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |    |page_counter_cancel
  |    |    |    |
  |    |    |    |
  |    |    |    |__slab_alloc
  |    |    |    |    |
  |    |    |    |    |___slab_alloc
  |    |    |    |    |
  |    |    |    |slab_post_alloc_hook

Instead of directly uncharging the accounted kernel memory, it's
possible to refill the generic page-sized per-cpu stock instead.  It's a
much faster operation, especially on a default hierarchy.  As a bonus,
__memcg_kmem_uncharge_page() will also get faster, so the freeing of
page-sized kernel allocations (e.g.  large kmallocs) will become faster.

A similar change has been done earlier for the socket memory by the
commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
memory uncharging").

Link: https://lkml.kernel.org/r/20210106042239.2860107-1-guro@fb.com
Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects instead of pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Imran Khan <imran.f.khan@oracle.com>
Tested-by: Imran Khan <imran.f.khan@oracle.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutn <mkoutny@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3083,9 +3083,7 @@ void __memcg_kmem_uncharge(struct mem_cg
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		page_counter_uncharge(&memcg->kmem, nr_pages);
 
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
+	refill_stock(memcg, nr_pages);
 }
 
 /**


