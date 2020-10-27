Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A329B0A8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408214AbgJ0OWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758677AbgJ0OWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:22:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA287206D4;
        Tue, 27 Oct 2020 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808529;
        bh=42CjmCMb+AeqTpHeBHAItavK9suHhyNVpT4eyETsJoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MX3Z6GYibHeDbhy8VU29zH68hjbv8iy3lfjuTKcs3Rf3XdPAQyP3maMR8N73Soijp
         +yEbX8aE0ZRbYxgsVxvz12hXKr1TR9q2X2jA4mhciiq13hz8xA3fLLWcELUUi9gLU7
         /fYd+y+zMcQCW0dzPL2S0YoBiUWSvOGKLA9DVQYY=
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
Subject: [PATCH 4.19 127/264] mm/memcg: fix device private memcg accounting
Date:   Tue, 27 Oct 2020 14:53:05 +0100
Message-Id: <20201027135436.650469259@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index aa730a3d5c258..87cd5bf1b4874 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4780,7 +4780,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
 
 	/*
@@ -4799,6 +4799,9 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
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



