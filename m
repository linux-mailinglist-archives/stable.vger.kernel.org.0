Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7FE3B5567
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhF0V4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE62261C31;
        Sun, 27 Jun 2021 21:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830856;
        bh=vFck+MhBGJ25PTdPs/LqMtIrPmEww1AaQzNKm1SVLz0=;
        h=Date:From:To:Subject:From;
        b=pfllxv5QSjN35AeszwvrLf2TETo6B3rQBIrhpB/SzPip4wZEapgioQf9NTlpuU0OQ
         zsXVJbs4LTQfftdZ5ruFUpW0/3G7hVSwFXTD316Vdrk76oECAbzF8llqXBBIpjt4Q9
         skbWe6eBOMpchg2u00tJmNrBVHjV0oslxzI3w8PQ=
Date:   Sun, 27 Jun 2021 14:54:15 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com, yaoaili@kingsoft.com
Subject:  [merged]
 =?US-ASCII?Q?mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-alr?=
 =?US-ASCII?Q?eady-been-poisoned.patch?= removed from -mm tree
Message-ID: <20210627215415.opi8ksG8r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return -EHWPOISON to denote that the page has already been poisoned
has been removed from the -mm tree.  Its filename was
     mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aili Yao <yaoaili@kingsoft.com>
Subject: mm,hwpoison: return -EHWPOISON to denote that the page has already been poisoned

When memory_failure() is called with MF_ACTION_REQUIRED on the page that
has already been hwpoisoned, memory_failure() could fail to send SIGBUS to
the affected process, which results in infinite loop of MCEs.

Currently memory_failure() returns 0 if it's called for already hwpoisoned
page, then the caller, kill_me_maybe(), could return without sending
SIGBUS to current process.  An action required MCE is raised when the
current process accesses to the broken memory, so no SIGBUS means that the
current process continues to run and access to the error page again soon,
so running into MCE loop.

This issue can arise for example in the following scenarios:

- Two or more threads access to the poisoned page concurrently.  If
  local MCE is enabled, MCE handler independently handles the MCE events. 
  So there's a race among MCE events, and the second or latter threads
  fall into the situation in question.

- If there was a precedent memory error event and memory_failure() for
  the event failed to unmap the error page for some reason, the subsequent
  memory access to the error page triggers the MCE loop situation.

To fix the issue, make memory_failure() return an error code when the
error page has already been hwpoisoned.  This allows memory error handler
to control how it sends signals to userspace.  And make sure that any
process touching a hwpoisoned page should get a SIGBUS even in "already
hwpoisoned" path of memory_failure() as is done in page fault path.

Link: https://lkml.kernel.org/r/20210521030156.2612074-3-nao.horiguchi@gmail.com
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned
+++ a/mm/memory-failure.c
@@ -1253,7 +1253,7 @@ static int memory_failure_hugetlb(unsign
 	if (TestSetPageHWPoison(head)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 		       pfn);
-		return 0;
+		return -EHWPOISON;
 	}
 
 	num_poisoned_pages_inc();
@@ -1461,6 +1461,7 @@ try_again:
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
+		res = -EHWPOISON;
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from yaoaili@kingsoft.com are


