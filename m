Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBA729B493
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790105AbgJ0PDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790086AbgJ0PDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89BD521D24;
        Tue, 27 Oct 2020 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811028;
        bh=D80V03VPGaG76jSy+VVayV2JruH9wDvQR5NoDcrqVfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8mSTbJAwvsTkPTmrX33UjmVJzkN52iNp7xi5CzbO08ggU+SC1jmOTvL2hOi0Wb3A
         T7G/IQY4k3aKkVXICPi5TPbDPXRk/jDmnGV00y6PQMd9sjghtVx7szo22yPaCPxCmM
         xCslE5kNKi0VkPYfME9zqaIteufsclumz6h+XQqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 317/633] mm/memcg: fix device private memcg accounting
Date:   Tue, 27 Oct 2020 14:51:00 +0100
Message-Id: <20201027135537.542097177@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit 9a137153fc8798a89d8fce895cd0a06ea5b8e37c ]

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages are
never handled.  Fix this by checking for non_swap_entry() after handling
device private swap PTEs.

I assume the memory cgroup accounting would be off somehow when moving
a process to another memory cgroup.  Currently, the device private page
is charged like a normal anonymous page when allocated and is uncharged
when the page is freed so I think that path is OK.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Link: https://lkml.kernel.org/r/20201009215952.2726-1-rcampbell@nvidia.com
xFixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 13f559af1ab6a..6795bdf662566 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5276,7 +5276,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
 
 	/*
@@ -5295,6 +5295,9 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 		return page;
 	}
 
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
-- 
2.25.1



