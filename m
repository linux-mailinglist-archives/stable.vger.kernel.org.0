Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0E120AAAD
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 05:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgFZD3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 23:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbgFZD3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 23:29:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E41342084D;
        Fri, 26 Jun 2020 03:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593142165;
        bh=BOOtNScon/F8RSvOC5TUchukW1Vi8hVtCQbXchQ1dOQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sRprRrBw/9EDVnMNdWctQPhoi3O8zHvwTGASoW5AT5SJhIWFPBirb3Wgu6g48S58v
         0EqwezipKb4zBuKLVJyruPUyxkt0O6f4NxZD8U91ZD4+CkICaR/Iu4bYUaXHUMqzNc
         Gcr7S2riV8pzpWxhT6IwA57626zHpuNEOVAcYNAA=
Date:   Thu, 25 Jun 2020 20:29:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, liwang@redhat.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 03/32] mm, compaction: make capture control
 handling safe wrt interrupts
Message-ID: <20200626032924.PiPdcjulX%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: make capture control handling safe wrt interrupts

Hugh reports:

: While stressing compaction, one run oopsed on NULL capc->cc in
: __free_one_page()'s task_capc(zone): compact_zone_order() had been
: interrupted, and a page was being freed in the return from interrupt.
: 
: Though you would not expect it from the source, both gccs I was using (a
: 4.8.1 and a 7.5.0) had chosen to compile compact_zone_order() with the
: ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before callq
: compact_zone - long after the "current->capture_control = &capc".  An
: interrupt in between those finds capc->cc NULL (zeroed by an earlier rep
: stos).
: 
: This could presumably be fixed by a barrier() before setting
: current->capture_control in compact_zone_order(); but would also need more
: care on return from compact_zone(), in order not to risk leaking a page
: captured by interrupt just before capture_control is reset.
: 
: Maybe that is the preferable fix, but I felt safer for task_capc() to
: exclude the rather surprising possibility of capture at interrupt time.

I have checked that gcc10 also behaves the same.

The advantage of fix in compact_zone_order() is that we don't add another
test in the page freeing hot path, and that it might prevent future
problems if we stop exposing pointers to uninitialized structures in
current task.

So this patch implements the suggestion for compact_zone_order() with
barrier() (and WRITE_ONCE() to prevent store tearing) for setting
current->capture_control, and prevents page leaking with
WRITE_ONCE/READ_ONCE in the proper order.

Link: http://lkml.kernel.org/r/20200616082649.27173-1-vbabka@suse.cz
Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-make-capture-control-handling-safe-wrt-interrupts
+++ a/mm/compaction.c
@@ -2316,15 +2316,26 @@ static enum compact_result compact_zone_
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
_
