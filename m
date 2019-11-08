Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5896F3CF7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKHAix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfKHAix (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:38:53 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABD021D7F;
        Fri,  8 Nov 2019 00:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173532;
        bh=fs34waKqDPxgtYq82kiC6y+YqIqgtbapn9OQ/SIkUuQ=;
        h=Date:From:To:Subject:From;
        b=0Lf9jbBvZXj4LzYvHTdpSGDbLhC6f2i1XUD2aQ6/ekUcGgXU2kh2YaCrID8wxy+zt
         4OgSSBRNP5zbUKFW6Cyllxxb3ijgzGordwXNsUddKsOymPWx+Ide5vel+x3uG8JJif
         +/PdxYHGy0W0Y44SLcxGr8K/Gip4Fw4wEfLMrwOk=
Date:   Thu, 07 Nov 2019 16:38:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, aquini@redhat.com, david@redhat.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        jannh@google.com, khlebnikov@yandex-team.ru, longman@redhat.com,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songliubraving@fb.com, stable@vger.kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch removed from -mm
 tree
Message-ID: <20191108003851.QLWTNUCy3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, vmstat: hide /proc/pagetypeinfo from normal users
has been removed from the -mm tree.  Its filename was
     mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


