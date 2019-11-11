Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596BDF7E33
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfKKSsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbfKKSsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F73721655;
        Mon, 11 Nov 2019 18:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498130;
        bh=07Q+lzMyYk4HtvmcIj0qU3vfd9YyAh8FYBnRoE5cFiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zu4h8dgZcQ/6T9V8jJ5wfcAg5qfoVYUVvNMPqyIure6A0uTUrFJUKRokO2iGPW/37
         f+l8qMM4xK+nbcAznBysNLXghEBGM4p5IrOPlCidwzk8vEDh9mIuuvYXC01dLVzG6+
         CMduEHQn/6LRwYkXAq1U6FsHBhmNNdLZYa6U5r3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Waiman Long <longman@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rafael Aquini <aquini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 032/193] mm, vmstat: hide /proc/pagetypeinfo from normal users
Date:   Mon, 11 Nov 2019 19:26:54 +0100
Message-Id: <20191111181502.739487567@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit abaed0112c1db08be15a784a2c5c8a8b3063cdd3 upstream.

/proc/pagetypeinfo is a debugging tool to examine internal page
allocator state wrt to fragmentation.  It is not very useful for any
other use so normal users really do not need to read this file.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1970,7 +1970,7 @@ void __init init_mm_internals(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
-	proc_create_seq("pagetypeinfo", 0444, NULL, &pagetypeinfo_op);
+	proc_create_seq("pagetypeinfo", 0400, NULL, &pagetypeinfo_op);
 	proc_create_seq("vmstat", 0444, NULL, &vmstat_op);
 	proc_create_seq("zoneinfo", 0444, NULL, &zoneinfo_op);
 #endif


