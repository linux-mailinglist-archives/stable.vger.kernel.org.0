Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26778109BF1
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfKZKKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:10:08 -0500
Received: from 8bytes.org ([81.169.241.247]:52882 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbfKZKKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 05:10:08 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 72D5B3A4; Tue, 26 Nov 2019 11:10:06 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH -tip] x86/mm/32: Sync only to LDT_BASE_ADDR in vmalloc_sync_all()
Date:   Tue, 26 Nov 2019 11:09:42 +0100
Message-Id: <20191126100942.13059-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When vmalloc_sync_all() iterates over the address space until
FIX_ADDR_TOP it will sync the whole kernel address space starting from
VMALLOC_START.

This is not a problem when the kernel address range is identical in
all page-tables, but this is no longer the case when PTI is enabled on
x86-32. In that case the per-process LDT is mapped in the kernel
address range and vmalloc_sync_all() clears the LDT mapping for all
processes.

To make LDT working again vmalloc_sync_all() must only iterate over
the volatile parts of the kernel address range that are identical
between all processes. This includes the VMALLOC and the PKMAP areas
on x86-32.

The order of the ranges in the address space is:

	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR

So the right check in vmalloc_sync_all() is "address < LDT_BASE_ADDR"
to make sure the VMALLOC and PKMAP areas are synchronized and the LDT
mapping is not falsely overwritten. the CPU_ENTRY_AREA and
the FIXMAP area are no longer synced as well, but these
ranges are synchronized on page-table creation time and do
not change during runtime.

This change fixes the ldt_gdt selftest in my setup.

Fixes: 7757d607c6b3 ("x86/pti: AllowCONFIG_PAGE_TABLE_ISOLATION for x86_32")
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ceacd1156db..144329c44436 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -197,7 +197,7 @@ void vmalloc_sync_all(void)
 		return;
 
 	for (address = VMALLOC_START & PMD_MASK;
-	     address >= TASK_SIZE_MAX && address < FIXADDR_TOP;
+	     address >= TASK_SIZE_MAX && address < LDT_BASE_ADDR;
 	     address += PMD_SIZE) {
 		struct page *page;
 
-- 
2.16.4

