Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8921217193
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgGGPWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbgGGPWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41BDF206E2;
        Tue,  7 Jul 2020 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135329;
        bh=SaU6faIfkLOai/TtYZSn8aYY+GDh7kDuUDRzTcFNcX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+QqFhK3h/n6edVHdEUpuKZ9KSaCxYiboj++nOiO+MMUsTkxshdeSdNhbdGVFpjN4
         m85mcIDplpaeiVyNupC01lTnZ9W1sU7TMZ6QqJevAoKhtDadBpRfBHYygYzvE6LYbs
         tDb5YFmfOmcfHiyNdNNARTTDR/UYDnSjzEDGYk5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Li Wang <liwang@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 62/65] mm, compaction: make capture control handling safe wrt interrupts
Date:   Tue,  7 Jul 2020 17:17:41 +0200
Message-Id: <20200707145755.470278154@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit b9e20f0da1f5c9c68689450a8cb436c9486434c8 upstream.

Hugh reports:

 "While stressing compaction, one run oopsed on NULL capc->cc in
  __free_one_page()'s task_capc(zone): compact_zone_order() had been
  interrupted, and a page was being freed in the return from interrupt.

  Though you would not expect it from the source, both gccs I was using
  (4.8.1 and 7.5.0) had chosen to compile compact_zone_order() with the
  ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before
  callq compact_zone - long after the "current->capture_control =
  &capc". An interrupt in between those finds capc->cc NULL (zeroed by
  an earlier rep stos).

  This could presumably be fixed by a barrier() before setting
  current->capture_control in compact_zone_order(); but would also need
  more care on return from compact_zone(), in order not to risk leaking
  a page captured by interrupt just before capture_control is reset.

  Maybe that is the preferable fix, but I felt safer for task_capc() to
  exclude the rather surprising possibility of capture at interrupt
  time"

I have checked that gcc10 also behaves the same.

The advantage of fix in compact_zone_order() is that we don't add
another test in the page freeing hot path, and that it might prevent
future problems if we stop exposing pointers to uninitialized structures
in current task.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2310,15 +2310,26 @@ static enum compact_result compact_zone_
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


