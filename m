Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B9CE5651
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfJYV6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 17:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJYV6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 17:58:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C51421D81;
        Fri, 25 Oct 2019 21:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572040716;
        bh=pmeQEHgG0RJxKthreJtG3rpwf51KqbGumNfRo6fQoGg=;
        h=Date:From:To:Subject:From;
        b=q2SexUW95ceCqBmsOjRiPXOlJRrLVbdOEBLtImuQMhz3q2Cil9XQuU/Qe1HE7itef
         hKnGAE5zMpooampVr5iBNSSihrSZ+TWbadY2zOXwAdj/6NtsAZ2D/odtqiNQtRUEJa
         ExWKh8MgnvsEQWFhxSmKIJ7HDt4jC+BFN/mZeQIk=
Date:   Fri, 25 Oct 2019 14:58:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, aquini@redhat.com, david@redhat.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        jannh@google.com, khlebnikov@yandex-team.ru, longman@redhat.com,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songliubraving@fb.com, stable@vger.kernel.org,
        vbabka@suse.cz
Subject:  +
 mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch added to -mm tree
Message-ID: <20191025215835.5xawORM5h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, vmstat: hide /proc/pagetypeinfo from normal users
has been added to the -mm tree.  Its filename is
     mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmstat: hide /proc/pagetypeinfo from normal users

/proc/pagetypeinfo is a debugging tool to examine internal page allocator
state wrt to fragmentation.  It is not very useful for any other use so
normal users really do not need to read this file.

Waiman Long has noticed that reading this file can have negative side
effects because zone->lock is necessary for gathering data and that a)
interferes with the page allocator and its users and b) can lead to hard
lockups on large machines which have very long free_list.

Reduce both issues by simply not exporting the file to regular users.

Link: http://lkml.kernel.org/r/20191025072610.18526-2-mhocko@kernel.org
Fixes: 467c996c1e19 ("Print out statistics in relation to fragmentation avoidance to /proc/pagetypeinfo")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Waiman Long <longman@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jann Horn <jannh@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-hide-proc-pagetypeinfo-from-normal-users
+++ a/mm/vmstat.c
@@ -1972,7 +1972,7 @@ void __init init_mm_internals(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
-	proc_create_seq("pagetypeinfo", 0444, NULL, &pagetypeinfo_op);
+	proc_create_seq("pagetypeinfo", 0400, NULL, &pagetypeinfo_op);
 	proc_create_seq("vmstat", 0444, NULL, &vmstat_op);
 	proc_create_seq("zoneinfo", 0444, NULL, &zoneinfo_op);
 #endif
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
mm-vmstat-reduce-zone-lock-holding-time-by-proc-pagetypeinfo.patch

