Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76187398B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbfGXTlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389559AbfGXTlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2258214AF;
        Wed, 24 Jul 2019 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997273;
        bh=Ii5Hng9bB7hkNR5FEREtXLqS8OrCl3P6l6VAqgsU6wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdMb9I+SK1GddRoGSKx9pmjH+gEL2shpThshvJd83u+Dw9H5oRAlpZnGO6Wr3LJa6
         kDse9QL+sQg8h8EQCpcA+QlyLfjTPDbhtMquNDJ6mqPXlLK8eU2NyolgL4pcHR0/vn
         FbbVMJXgURTzh1q5FpC30u0iHzuKCVy6khhzMiog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yafang Shao <shaoyafang@didiglobal.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 378/413] mm/memcontrol: fix wrong statistics in memory.stat
Date:   Wed, 24 Jul 2019 21:21:09 +0200
Message-Id: <20190724191802.201754427@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

commit dd9239900e12db84c198855b262ae7796db1123b upstream.

When we calculate total statistics for memcg1_stats and memcg1_events,
we use the the index 'i' in the for loop as the events index.  Actually
we should use memcg1_stats[i] and memcg1_events[i] as the events index.

Link: http://lkml.kernel.org/r/1562116978-19539-1-git-send-email-laoar.shao@gmail.com
Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty").
Signed-off-by: Yafang Shao <laoar.shao@gmail.com
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3530,12 +3530,13 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)memcg_page_state(memcg, i) * PAGE_SIZE);
+			   (u64)memcg_page_state(memcg, memcg1_stats[i]) *
+			   PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
 		seq_printf(m, "total_%s %llu\n", memcg1_event_names[i],
-			   (u64)memcg_events(memcg, i));
+			   (u64)memcg_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i],


