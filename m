Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ABB245417
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgHOWMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729250AbgHOWK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3684E20885;
        Sat, 15 Aug 2020 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451408;
        bh=KRcdZYKBYDpbzRiT1KFMulPfq0YwNH+U+JnKO7So524=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HDUWH6Me5cyJ/mk5XCExM7YjBK4dwu7s5ZXuWA/DaYDAhgbcQLrjsPEnma7HQnFmB
         2ss0weBVc4loC9SOnPOdaQtL9e/uxQddhA+uLuzH37kg3CL87jUZd7NhgJ8/xKcKv+
         4CZzFIURmHR3qRL8pj16y2VVAGCzzXqDeJSwKNkE=
Date:   Fri, 14 Aug 2020 17:30:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, sonnyrao@chromium.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/39] Revert "mm/vmstat.c: do not show lowmem
 reserve protection information of empty zone"
Message-ID: <20200815003007.GWlu7N4q0%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
