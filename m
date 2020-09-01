Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC225957D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgIAPrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgIAPrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F88B206EB;
        Tue,  1 Sep 2020 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975219;
        bh=HAHOxMSHdU6rneTM5WbVyXyKK7cvJRLLgO2eLJdQCb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBANgDTH8o+PCjUOc8u4BXB7dPdWv3bz8Zyw43wmG7iWM+wAweWYb4X2QHCH9ZKwD
         EQMDxZUFaSibY+dL3LUWaZiHne6q9cPwh71TeoRDz2IDSMuNgix0zZqHJsx9AlWIS2
         L3ylWCTEiD7dyYUcIf/mF6noa5KzgA6V+uKoY9nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f36cfe60b1006a94f9dc@syzkaller.appspotmail.com,
        Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 248/255] mm/page_counter: fix various data races at memsw
Date:   Tue,  1 Sep 2020 17:11:44 +0200
Message-Id: <20200901151012.651156551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 6e4bd50f3888fa8fea8bc66a0ad4ad5f1c862961 upstream.

Commit 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") could had
memcg->memsw->watermark and memcg->memsw->failcnt been accessed
concurrently as reported by KCSAN,

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

 read to 0xffff8fb18c4cd190 of 8 bytes by task 1081 on cpu 59:
  page_counter_try_charge+0x4d/0x150 mm/page_counter.c:138
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x58/0x140
  __memcg_kmem_charge+0xcc/0x280
  __alloc_pages_nodemask+0x1e1/0x450
  alloc_pages_current+0xa6/0x120
  pte_alloc_one+0x17/0xd0
  __pte_alloc+0x3a/0x1f0
  copy_p4d_range+0xc36/0x1990
  copy_page_range+0x21d/0x360
  dup_mmap+0x5f5/0x7a0
  dup_mm+0xa2/0x240
  copy_process+0x1b3f/0x3460
  _do_fork+0xaa/0xa20
  __x64_sys_clone+0x13b/0x170
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffff8fb18c4cd190 of 8 bytes by task 1153 on cpu 120:
  page_counter_try_charge+0x5b/0x150 mm/page_counter.c:139
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  mem_cgroup_try_charge+0x159/0x460
  mem_cgroup_try_charge_delay+0x3d/0xa0
  wp_page_copy+0x14d/0x930
  do_wp_page+0x107/0x7b0
  __handle_mm_fault+0xce6/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

 write to 0xffff88809bbf2158 of 8 bytes by task 11782 on cpu 0:
  page_counter_try_charge+0x100/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

 read to 0xffff88809bbf2158 of 8 bytes by task 11814 on cpu 1:
  page_counter_try_charge+0xef/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

Since watermark could be compared or set to garbage due to a data race
which would change the code logic, fix it by adding a pair of READ_ONCE()
and WRITE_ONCE() in those places.

The "failcnt" counter is tolerant of some degree of inaccuracy and is only
used to report stats, a data race will not be harmful, thus mark it as an
intentional data race using the data_race() macro.

Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Reported-by: syzbot+f36cfe60b1006a94f9dc@syzkaller.appspotmail.com
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Link: http://lkml.kernel.org/r/1581519682-23594-1-git-send-email-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_counter.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -77,8 +77,8 @@ void page_counter_charge(struct page_cou
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 }
 
@@ -119,9 +119,10 @@ bool page_counter_try_charge(struct page
 			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
-			 * inaccuracy in the failcnt.
+			 * inaccuracy in the failcnt which is only used
+			 * to report stats.
 			 */
-			c->failcnt++;
+			data_race(c->failcnt++);
 			*fail = c;
 			goto failed;
 		}
@@ -130,8 +131,8 @@ bool page_counter_try_charge(struct page
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 	return true;
 


