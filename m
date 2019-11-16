Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF30FF27F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbfKPQT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:19:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbfKPPqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:09 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275CF2086A;
        Sat, 16 Nov 2019 15:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919168;
        bh=iLeu/7+A59mHww5wMPQ7+f/gfyrQdTMOJFAQRguBkd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKnIuVN5+bvLWzD2MSCnXJpfOgeMH2FO6qQ/ZfW2zvmu3H1sq+c+0QyPugSJqgyVw
         jOKcDOhWex0NbNfBv09PpiR1ESQHMY+a7qJHxpdhxkTDz4El9yKomOyS4FPPb5K+w8
         jy5FZvTOFDGZaCbNo/MfySuLuC0KcNlHhLVQ5oyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Gushchin <guro@fb.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@surriel.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 178/237] mm: handle no memcg case in memcg_kmem_charge() properly
Date:   Sat, 16 Nov 2019 10:40:13 -0500
Message-Id: <20191116154113.7417-178-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

[ Upstream commit e68599a3c3ad0f3171a7cb4e48aa6f9a69381902 ]

Mike Galbraith reported a regression caused by the commit 9b6f7e163cd0
("mm: rework memcg kernel stack accounting") on a system with
"cgroup_disable=memory" boot option: the system panics with the following
stack trace:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
  PGD 0 P4D 0
  Oops: 0002 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 1 Comm: systemd Not tainted 4.19.0-preempt+ #410
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20180531_142017-buildhw-08.phx2.fed4
  RIP: 0010:page_counter_try_charge+0x22/0xc0
  Code: 41 5d c3 c3 0f 1f 40 00 0f 1f 44 00 00 48 85 ff 0f 84 a7 00 00 00 41 56 48 89 f8 49 89 fe 49
  Call Trace:
   try_charge+0xcb/0x780
   memcg_kmem_charge_memcg+0x28/0x80
   memcg_kmem_charge+0x8b/0x1d0
   copy_process.part.41+0x1ca/0x2070
   _do_fork+0xd7/0x3d0
   do_syscall_64+0x5a/0x180
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

The problem occurs because get_mem_cgroup_from_current() returns the NULL
pointer if memory controller is disabled.  Let's check if this is a case
at the beginning of memcg_kmem_charge() and just return 0 if
mem_cgroup_disabled() returns true.  This is how we handle this case in
many other places in the memory controller code.

Link: http://lkml.kernel.org/r/20181029215123.17830-1-guro@fb.com
Fixes: 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Mike Galbraith <efault@gmx.de>
Acked-by: Rik van Riel <riel@surriel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e0f7b94a4e9bc..b3220d2102461 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2678,7 +2678,7 @@ int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 	struct mem_cgroup *memcg;
 	int ret = 0;
 
-	if (memcg_kmem_bypass())
+	if (mem_cgroup_disabled() || memcg_kmem_bypass())
 		return 0;
 
 	memcg = get_mem_cgroup_from_current();
-- 
2.20.1

