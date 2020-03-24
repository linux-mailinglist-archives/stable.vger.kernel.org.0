Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC14191026
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgCXNZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgCXNZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F10208CA;
        Tue, 24 Mar 2020 13:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056339;
        bh=DP409ajFviKMx013wmdRjhrUduVC9VtoO0DR9ctjHH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVqYKUWgE0C6hgE0Qi24er1hkazT9kc0k6FpRZ8GxkWEN9FWZvp61kWJRhNEnxDtP
         7eSk2fCZbd27rkK4YYICVX87AnEO8xOCsls9CNYMo4dhzBOFYy/CvKGUes3C7Sc18t
         EbznLCUm+CkMZCj9BU0TsOJ7KwCrQQ2koqokAjxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 095/119] mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case
Date:   Tue, 24 Mar 2020 14:11:20 +0100
Message-Id: <20200324130817.665452833@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit d41e2f3bd54699f85b3d6f45abd09fa24a222cb9 upstream.

In section_deactivate(), pfn_to_page() doesn't work any more after
ms->section_mem_map is resetting to NULL in SPARSEMEM|!VMEMMAP case.  It
causes a hot remove failure:

  kernel BUG at mm/page_alloc.c:4806!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 3 PID: 8 Comm: kworker/u16:0 Tainted: G        W         5.5.0-next-20200205+ #340
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
  RIP: 0010:free_pages+0x85/0xa0
  Call Trace:
   __remove_pages+0x99/0xc0
   arch_remove_memory+0x23/0x4d
   try_remove_memory+0xc8/0x130
   __remove_memory+0xa/0x11
   acpi_memory_device_remove+0x72/0x100
   acpi_bus_trim+0x55/0x90
   acpi_device_hotplug+0x2eb/0x3d0
   acpi_hotplug_work_fn+0x1a/0x30
   process_one_work+0x1a7/0x370
   worker_thread+0x30/0x380
   kthread+0x112/0x130
   ret_from_fork+0x35/0x40

Let's move the ->section_mem_map resetting after
depopulate_section_memmap() to fix it.

[akpm@linux-foundation.org: remove unneeded initialization, per David]
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200307084229.28251-2-bhe@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/sparse.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -744,6 +744,7 @@ static void section_deactivate(unsigned
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
 	struct page *memmap = NULL;
+	bool empty;
 	unsigned long *subsection_map = ms->usage
 		? &ms->usage->subsection_map[0] : NULL;
 
@@ -774,7 +775,8 @@ static void section_deactivate(unsigned
 	 * For 2/ and 3/ the SPARSEMEM_VMEMMAP={y,n} cases are unified
 	 */
 	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
-	if (bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION)) {
+	empty = bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION);
+	if (empty) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
 		/*
@@ -789,13 +791,15 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)
 		free_map_bootmem(memmap);
 	else
 		depopulate_section_memmap(pfn, nr_pages, altmap);
+
+	if (empty)
+		ms->section_mem_map = (unsigned long)NULL;
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,


