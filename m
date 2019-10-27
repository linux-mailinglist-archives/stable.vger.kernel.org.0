Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B661E6836
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbfJ0VXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732364AbfJ0VXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:34 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B39205C9;
        Sun, 27 Oct 2019 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211414;
        bh=lKgQpJ6lldb24qjFTVG9e/CiNh4+PFY2l5F0C51r+fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYeupQGG5I7HIVd303hZcG0mwHvReTW3bNUidNVRS6oxRdeTQEf17lRcmzFRtgqoR
         OgOCh7P3MvSgRM67qH+0FHqroetx62osIzoKPgSBUe4b5AFIT44G/TX4G7se6N8wUq
         umR3dlbgm44YTEfZb0K6CGtblkwB/009CrdnW2o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 144/197] mm/memory-failure.c: dont access uninitialized memmaps in memory_failure()
Date:   Sun, 27 Oct 2019 22:01:02 +0100
Message-Id: <20191027203359.469037864@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 96c804a6ae8c59a9092b3d5dd581198472063184 upstream.

We should check for pfn_to_online_page() to not access uninitialized
memmaps.  Reshuffle the code so we don't have to duplicate the error
message.

Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1253,17 +1253,19 @@ int memory_failure(unsigned long pfn, in
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
-	if (!pfn_valid(pfn)) {
+	p = pfn_to_online_page(pfn);
+	if (!p) {
+		if (pfn_valid(pfn)) {
+			pgmap = get_dev_pagemap(pfn, NULL);
+			if (pgmap)
+				return memory_failure_dev_pagemap(pfn, flags,
+								  pgmap);
+		}
 		pr_err("Memory failure: %#lx: memory outside kernel control\n",
 			pfn);
 		return -ENXIO;
 	}
 
-	pgmap = get_dev_pagemap(pfn, NULL);
-	if (pgmap)
-		return memory_failure_dev_pagemap(pfn, flags, pgmap);
-
-	p = pfn_to_page(pfn);
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {


