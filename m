Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2203026CF40
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 01:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIPXKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 19:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 19:10:32 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC8020684;
        Wed, 16 Sep 2020 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600297831;
        bh=KU1FLyhR7YPynOalS5rLimjR8qUwXb4anHetwLyUkaU=;
        h=Date:From:To:Subject:From;
        b=eFHfoV6OnlngnFO+PljvLVkoXs1NN8eO96WExyN25+J5Cdp/V7HgbPZlrJzqGb4Zt
         QDhx6ybtEBXAwTI1unjPOd+t4mooikVRnIxSQVq4HFqH8NOIhmfDSLPQk64LfkgsBv
         dp+KUzMfEXa0tBkSbYiJjMhPU7vYWB3WKxPHIAWg=
Date:   Wed, 16 Sep 2020 16:10:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, pasha.tatashin@soleen.com, oleg@redhat.com,
        mhocko@suse.com, kirill.shutemov@linux.intel.com,
        apais@microsoft.com, aarcange@redhat.com,
        vijayb@linux.microsoft.com
Subject:  [to-be-updated]
 mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch removed from
 -mm tree
Message-ID: <20200916231030.7-D0Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: avoid overriding min_free_kbytes set by user
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

This patch was dropped because an updated version will be merged

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

