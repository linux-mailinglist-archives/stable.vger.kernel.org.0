Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FDA8BD13
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 17:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfHMP2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 11:28:20 -0400
Received: from 8bytes.org ([81.169.241.247]:49064 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfHMP2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 11:28:19 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C319C391; Tue, 13 Aug 2019 17:28:17 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/3] mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()
Date:   Tue, 13 Aug 2019 17:28:14 +0200
Message-Id: <20190813152814.5354-4-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813152814.5354-1-joro@8bytes.org>
References: <20190813152814.5354-1-joro@8bytes.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 3f8fd02b1bf1d7ba964485a56f2f4b53ae88c167 upstream.

On x86-32 with PTI enabled, parts of the kernel page-tables are not shared
between processes. This can cause mappings in the vmalloc/ioremap area to
persist in some page-tables after the region is unmapped and released.

When the region is re-used the processes with the old mappings do not fault
in the new mappings but still access the old ones.

This causes undefined behavior, in reality often data corruption, kernel
oopses and panics and even spontaneous reboots.

Fix this problem by activly syncing unmaps in the vmalloc/ioremap area to
all page-tables in the system before the regions can be re-used.

References: https://bugzilla.suse.com/show_bug.cgi?id=1118689
Fixes: 5d72b4fba40ef ('x86, mm: support huge I/O mapping capability I/F')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20190719184652.11391-4-joro@8bytes.org
---
 mm/vmalloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0f76cca32a1c..080d30408ce3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1213,6 +1213,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 	if (unlikely(valist == NULL))
 		return false;
 
+	/*
+	 * First make sure the mappings are removed from all page-tables
+	 * before they are freed.
+	 */
+	vmalloc_sync_all();
+
 	/*
 	 * TODO: to calculate a flush range without looping.
 	 * The list can be up to lazy_max_pages() elements.
@@ -3001,6 +3007,9 @@ EXPORT_SYMBOL(remap_vmalloc_range);
 /*
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
+ *
+ * The purpose of this function is to make sure the vmalloc area
+ * mappings are identical in all page-tables in the system.
  */
 void __weak vmalloc_sync_all(void)
 {
-- 
2.16.4

