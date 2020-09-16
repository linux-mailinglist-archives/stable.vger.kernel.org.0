Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C526B6B5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgIPAJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgIPAJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 20:09:54 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A34A20756;
        Wed, 16 Sep 2020 00:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600214993;
        bh=TF6V1bxq21EUIMwY2MmEe3lgZQi/mJ3atRjPsoIDF24=;
        h=Date:From:To:Subject:From;
        b=osQPsSWI5m2Xmm9xY8QFCtFmpwCq42Xc6VvGhAIHcolBGaofBp8rqhXD1nUGl2cNh
         Um9Ackm6obWbJCXnP0z/7tkwQbbhgtJl08Q7OXroLaMpOWX3F13SgyijR0D9AhWBl1
         vXqNOBWlhV5elCw6QWTZY3pMe5DpEgMjTXiCV+tY=
Date:   Tue, 15 Sep 2020 17:09:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, pasha.tatashin@soleen.com, oleg@redhat.com,
        mhocko@suse.com, kirill.shutemov@linux.intel.com,
        apais@microsoft.com, aarcange@redhat.com,
        vijayb@linux.microsoft.com
Subject:  +
 mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch added to -mm
 tree
Message-ID: <20200916000952.tEvho%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: avoid overriding min_free_kbytes set by user
has been added to the -mm tree.  Its filename is
     mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: mm: khugepaged: avoid overriding min_free_kbytes set by user

set_recommended_min_free_kbytes need to honor min_free_kbytes set by the
user.  Post start-of-day THP enable or memory hotplug operations can lose
user specified min_free_kbytes, in particular when it is higher than
calculated recommended value.  Also modifying "recommended_min" variable
type to "int" from "unsigned long" to avoid undesired result noticed
during testing.  It is due to comparing "unsigned long" with "int" type.

Link: https://lkml.kernel.org/r/1600204258-13683-2-git-send-email-vijayb@linux.microsoft.com
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Allen Pais <apais@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user
+++ a/mm/khugepaged.c
@@ -2253,7 +2253,7 @@ static void set_recommended_min_free_kby
 {
 	struct zone *zone;
 	int nr_zones = 0;
-	unsigned long recommended_min;
+	int recommended_min;
 
 	for_each_populated_zone(zone) {
 		/*
@@ -2280,12 +2280,12 @@ static void set_recommended_min_free_kby
 
 	/* don't ever allow to reserve more than 5% of the lowmem */
 	recommended_min = min(recommended_min,
-			      (unsigned long) nr_free_buffer_pages() / 20);
+			      (int) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes) {
+	if (recommended_min > user_min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+			pr_info("raising min_free_kbytes from %d to %d to help transparent hugepage allocations\n",
 				min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
_

Patches currently in -mm which might be from vijayb@linux.microsoft.com are

mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

