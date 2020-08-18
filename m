Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ECB249119
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 00:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHRWkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 18:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgHRWkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F1620786;
        Tue, 18 Aug 2020 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790411;
        bh=cDLWWX3e2FLJRHIegVhtEOVgqRr16LxMVl5U2IsMXeo=;
        h=Date:From:To:Subject:From;
        b=FsyCjypkbqxnfCoxR3gmZVvyFdTIojMIs4ITRx/40tIZ+vS6VgRqNFEu+75LfJzFE
         nlc7DZ1bOzNaOwZWDgrIUT22QuZFoa9trfDNXU3F6loZYTruD4Z+jCw11MtXRJx/2E
         wsyVtjNYyn9SpUOrY5Jq0AJHZhqC/ANvMURnacrE=
Date:   Tue, 18 Aug 2020 15:40:11 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mm-commits@vger.kernel.org,
        rientjes@google.com, sonnyrao@chromium.org, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-inf?=
 =?US-ASCII?Q?ormation-of-empty-zone.patch?= removed from -mm tree
Message-ID: <20200818224011.mhWqdwXXl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: Revert "mm/vmstat.c: do not show lowmem reserve protection information of empty zone"

This reverts commit 26e7deadaae175.

Sonny reported that one of their tests started failing on the latest
kernel on their Chrome OS platform.  The root cause is that the above
commit removed the protection line of empty zone, while the parser used in
the test relies on the protection line to mark the end of each zone.

Let's revert it to avoid breaking userspace testing or applications.

Link: http://lkml.kernel.org/r/20200811075412.12872-1-bhe@redhat.com
Fixes: 26e7deadaae175 ("mm/vmstat.c: do not show lowmem reserve protection information of empty zone)"
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Sonny Rao <sonnyrao@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[5.8.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~revert-mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone
+++ a/mm/vmstat.c
@@ -1642,12 +1642,6 @@ static void zoneinfo_show_print(struct s
 		   zone->present_pages,
 		   zone_managed_pages(zone));
 
-	/* If unpopulated, no other information is useful */
-	if (!populated_zone(zone)) {
-		seq_putc(m, '\n');
-		return;
-	}
-
 	seq_printf(m,
 		   "\n        protection: (%ld",
 		   zone->lowmem_reserve[0]);
@@ -1655,6 +1649,12 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, ", %ld", zone->lowmem_reserve[i]);
 	seq_putc(m, ')');
 
+	/* If unpopulated, no other information is useful */
+	if (!populated_zone(zone)) {
+		seq_putc(m, '\n');
+		return;
+	}
+
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		seq_printf(m, "\n      %-12s %lu", zone_stat_name(i),
 			   zone_page_state(zone, i));
_

Patches currently in -mm which might be from bhe@redhat.com are


