Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D591FAB1F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFPI1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:27:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:49366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgFPI1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 04:27:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F6DFAD7B;
        Tue, 16 Jun 2020 08:27:15 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     vbabka@suse.cz
Cc:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        liwang@redhat.com, mgorman@techsingularity.net,
        stable@vger.kernel.org
Subject: [PATCH 1/2] mm, compaction: make capture control handling safe wrt interrupts
Date:   Tue, 16 Jun 2020 10:26:48 +0200
Message-Id: <20200616082649.27173-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <b17acf5b-5e8a-3edf-5a64-603bf6177312@suse.cz>
References: <b17acf5b-5e8a-3edf-5a64-603bf6177312@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hugh reports:

=====
While stressing compaction, one run oopsed on NULL capc->cc in
__free_one_page()'s task_capc(zone): compact_zone_order() had been
interrupted, and a page was being freed in the return from interrupt.

Though you would not expect it from the source, both gccs I was using
(a 4.8.1 and a 7.5.0) had chosen to compile compact_zone_order() with
the ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before
callq compact_zone - long after the "current->capture_control = &capc".
An interrupt in between those finds capc->cc NULL (zeroed by an earlier
rep stos).

This could presumably be fixed by a barrier() before setting
current->capture_control in compact_zone_order(); but would also need
more care on return from compact_zone(), in order not to risk leaking
a page captured by interrupt just before capture_control is reset.

Maybe that is the preferable fix, but I felt safer for task_capc() to
exclude the rather surprising possibility of capture at interrupt time.
=====

I have checked that gcc10 also behaves the same.

The advantage of fix in compact_zone_order() is that we don't add another
test in the page freeing hot path, and that it might prevent future problems
if we stop exposing pointers to unitialized structures in current task.

So this patch implements the suggestion for compact_zone_order() with barrier()
(and WRITE_ONCE() to prevent store tearing) for setting
current->capture_control, and prevents page leaking with WRITE_ONCE/READ_ONCE
in the proper order.

Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
Cc: stable@vger.kernel.org # 5.1+
Reported-by: Hugh Dickins <hughd@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index fd988b7e5f2b..86375605faa9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2316,15 +2316,26 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
 		.page = NULL,
 	};
 
-	current->capture_control = &capc;
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
 
 	ret = compact_zone(&cc, &capc);
 
 	VM_BUG_ON(!list_empty(&cc.freepages));
 	VM_BUG_ON(!list_empty(&cc.migratepages));
 
-	*capture = capc.page;
-	current->capture_control = NULL;
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	*capture = READ_ONCE(capc.page);
 
 	return ret;
 }
-- 
2.27.0

