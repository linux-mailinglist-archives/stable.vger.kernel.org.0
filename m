Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263722B64D9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgKQNuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732328AbgKQNcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B20621734;
        Tue, 17 Nov 2020 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619962;
        bh=he4KIhkkXcT7YqobN4HKFO1MI7XBPuzBlAVknM5R6SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLHVZvAUhYAKHtQFwRVb2awuCeHTlrUhnr1FObTmB9TNqsn1dGu+PuS8mhQMbcalf
         3XnO0IpUC3Y5OHTGPmad3cvZkcU/ablcrwWkeEatnpQHqOQ4iKQBrftmKvPUrhVMS7
         OkGJQ6ZoPgSfMk6eJSDhhRPA/YOSSTIUcyAaDF+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 032/255] mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg
Date:   Tue, 17 Nov 2020 14:02:52 +0100
Message-Id: <20201117122140.506848721@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>

[ Upstream commit 7de2e9f195b9cb27583c5c64deaaf5e6afcc163e ]

memcg_page_state will get the specified number in hierarchical memcg, It
should multiply by HPAGE_PMD_NR rather than an page if the item is
NR_ANON_THPS.

[akpm@linux-foundation.org: fix printk warning]
[akpm@linux-foundation.org: use u64 cast, per Michal]

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Link: https://lkml.kernel.org/r/1603722395-72443-1-git-send-email-zhongjiang-ali@linux.alibaba.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index de51787831728..51ce5d172855a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4068,11 +4068,17 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 			   (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
+		unsigned long nr;
+
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
+		nr = memcg_page_state(memcg, memcg1_stats[i]);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (memcg1_stats[i] == NR_ANON_THPS)
+			nr *= HPAGE_PMD_NR;
+#endif
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)memcg_page_state(memcg, memcg1_stats[i]) *
-			   PAGE_SIZE);
+						(u64)nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-- 
2.27.0



