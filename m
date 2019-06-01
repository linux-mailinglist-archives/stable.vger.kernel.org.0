Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA3031EB6
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfFANUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbfFANUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:20:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A191D272DE;
        Sat,  1 Jun 2019 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395229;
        bh=DHR7kqRzoj0p2zUAiXG+aU4DQZFfXRciLoxmjLkKDQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+hU3+pd/Vc6FNGedGcso1ElgcqREezAShbeqlEzN8/y/3TiPWOxo3Qlh4rmFflXi
         oRYY0lFQtiKOuk6cV2q7865DlUoEZJ4n06gXXn1jGBjCnXovMZYqX49f45mZOQOdDD
         EpU9dJsgNn6zjJ/9YIKpMEvCC8pR6QyqJhWfmsp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baoquan He <bhe@redhat.com>, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.0 016/173] mm/memory_hotplug.c: fix the wrong usage of N_HIGH_MEMORY
Date:   Sat,  1 Jun 2019 09:16:48 -0400
Message-Id: <20190601131934.25053-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

[ Upstream commit d3ba3ae19751e476b0840a0c9a673a5766fa3219 ]

In node_states_check_changes_online(), N_HIGH_MEMORY is used to substitute
ZONE_HIGHMEM directly.  This is not right.  N_HIGH_MEMORY is to mark the
memory state of node.  Here zone index is checked, which should be
compared with 'ZONE_HIGHMEM' accordingly.

Replace it with ZONE_HIGHMEM.

This is a code cleanup - no known runtime effects.

Link: http://lkml.kernel.org/r/20190320080732.14933-1-bhe@redhat.com
Fixes: 8efe33f40f3e ("mm/memory_hotplug.c: simplify node_states_check_changes_online")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e06e7a89d0e5b..33f1b8d307e64 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -684,7 +684,7 @@ static void node_states_check_changes_online(unsigned long nr_pages,
 	if (zone_idx(zone) <= ZONE_NORMAL && !node_state(nid, N_NORMAL_MEMORY))
 		arg->status_change_nid_normal = nid;
 #ifdef CONFIG_HIGHMEM
-	if (zone_idx(zone) <= N_HIGH_MEMORY && !node_state(nid, N_HIGH_MEMORY))
+	if (zone_idx(zone) <= ZONE_HIGHMEM && !node_state(nid, N_HIGH_MEMORY))
 		arg->status_change_nid_high = nid;
 #endif
 }
-- 
2.20.1

