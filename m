Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFCB3B3A8D
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhFYBmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhFYBmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0039F61220;
        Fri, 25 Jun 2021 01:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585199;
        bh=8c8w0TGUkRuQHCjjh8touhZDdnrgaWxcNkMAqxZi29I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QicPOIfMDIlfK8sNkiJ5APQGcnj8Jm1vHuhzIt/1zUka1EieFp7LNvfKPWl9UbIot
         LJqpMDhjPwFpr2QseeAu+KQ6wFDPc2VaNbcbFm6vWDP6RuLwqdJM8E/9zWd/KQ/b20
         KQNpd3mJGAEB4i0LrWoHfuPyKcU/nDtjZlgsFtBI=
Date:   Thu, 24 Jun 2021 18:39:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, bp@suse.de,
        david@redhat.com, juew@google.com, linux-mm@kvack.org,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        yaoaili@kingsoft.com
Subject:  [patch 19/24] mm,hwpoison: return -EHWPOISON to denote
 that the page has already been poisoned
Message-ID: <20210625013958.xJoXf1EqN%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
