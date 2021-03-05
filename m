Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DF932E88B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhCEM1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhCEM1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:27:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30FAE65029;
        Fri,  5 Mar 2021 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947230;
        bh=G80eKNMqk+J+q5wvs2LWGwmOXh5IjT2rjcuv5l+YbQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYRpbq14VM4FDPGyCv1C7EZ+rtifq4+KfBolbs3dg7UdQO40G6AHuwGoArvAuPaPk
         d0CV0PJJMNXzWRPok7YOz5qgl+6lDUU+2WbUyN+7UrSa/THOjsqHfJn9zgA/JndnC6
         qDfdWFc48m8YKGG4eXAYYBbsPHtGe0EelzF7Xh/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.11 094/104] xen: fix p2m size in dom0 for disabled memory hotplug case
Date:   Fri,  5 Mar 2021 13:21:39 +0100
Message-Id: <20210305120907.780121361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 882213990d32fd224340a4533f6318dd152be4b2 upstream.

Since commit 9e2369c06c8a18 ("xen: add helpers to allocate unpopulated
memory") foreign mappings are using guest physical addresses allocated
via ZONE_DEVICE functionality.

This will result in problems for the case of no balloon memory hotplug
being configured, as the p2m list will only cover the initial memory
size of the domain. Any ZONE_DEVICE allocated address will be outside
the p2m range and thus a mapping can't be established with that memory
address.

Fix that by extending the p2m size for that case. At the same time add
a check for a to be created mapping to be within the p2m limits in
order to detect errors early.

While changing a comment, remove some 32-bit leftovers.

This is XSA-369.

Fixes: 9e2369c06c8a18 ("xen: add helpers to allocate unpopulated memory")
Cc: <stable@vger.kernel.org> # 5.9
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/xen/page.h |   12 ++++++++++++
 arch/x86/xen/p2m.c              |   10 ++++++----
 arch/x86/xen/setup.c            |   25 +++----------------------
 3 files changed, 21 insertions(+), 26 deletions(-)

--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -87,6 +87,18 @@ clear_foreign_p2m_mapping(struct gnttab_
 #endif
 
 /*
+ * The maximum amount of extra memory compared to the base size.  The
+ * main scaling factor is the size of struct page.  At extreme ratios
+ * of base:extra, all the base memory can be filled with page
+ * structures for the extra memory, leaving no space for anything
+ * else.
+ *
+ * 10x seems like a reasonable balance between scaling flexibility and
+ * leaving a practically usable system.
+ */
+#define XEN_EXTRA_MEM_RATIO	(10)
+
+/*
  * Helper functions to write or read unsigned long values to/from
  * memory, when the access may fault.
  */
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -416,6 +416,9 @@ void __init xen_vmalloc_p2m_tree(void)
 	xen_p2m_last_pfn = xen_max_p2m_pfn;
 
 	p2m_limit = (phys_addr_t)P2M_LIMIT * 1024 * 1024 * 1024 / PAGE_SIZE;
+	if (!p2m_limit && IS_ENABLED(CONFIG_XEN_UNPOPULATED_ALLOC))
+		p2m_limit = xen_start_info->nr_pages * XEN_EXTRA_MEM_RATIO;
+
 	vm.flags = VM_ALLOC;
 	vm.size = ALIGN(sizeof(unsigned long) * max(xen_max_p2m_pfn, p2m_limit),
 			PMD_SIZE * PMDS_PER_MID_PAGE);
@@ -652,10 +655,9 @@ bool __set_phys_to_machine(unsigned long
 	pte_t *ptep;
 	unsigned int level;
 
-	if (unlikely(pfn >= xen_p2m_size)) {
-		BUG_ON(mfn != INVALID_P2M_ENTRY);
-		return true;
-	}
+	/* Only invalid entries allowed above the highest p2m covered frame. */
+	if (unlikely(pfn >= xen_p2m_size))
+		return mfn == INVALID_P2M_ENTRY;
 
 	/*
 	 * The interface requires atomic updates on p2m elements.
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -59,18 +59,6 @@ static struct {
 } xen_remap_buf __initdata __aligned(PAGE_SIZE);
 static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
 
-/* 
- * The maximum amount of extra memory compared to the base size.  The
- * main scaling factor is the size of struct page.  At extreme ratios
- * of base:extra, all the base memory can be filled with page
- * structures for the extra memory, leaving no space for anything
- * else.
- * 
- * 10x seems like a reasonable balance between scaling flexibility and
- * leaving a practically usable system.
- */
-#define EXTRA_MEM_RATIO		(10)
-
 static bool xen_512gb_limit __initdata = IS_ENABLED(CONFIG_XEN_512GB);
 
 static void __init xen_parse_512gb(void)
@@ -790,20 +778,13 @@ char * __init xen_memory_setup(void)
 		extra_pages += max_pages - max_pfn;
 
 	/*
-	 * Clamp the amount of extra memory to a EXTRA_MEM_RATIO
-	 * factor the base size.  On non-highmem systems, the base
-	 * size is the full initial memory allocation; on highmem it
-	 * is limited to the max size of lowmem, so that it doesn't
-	 * get completely filled.
+	 * Clamp the amount of extra memory to a XEN_EXTRA_MEM_RATIO
+	 * factor the base size.
 	 *
 	 * Make sure we have no memory above max_pages, as this area
 	 * isn't handled by the p2m management.
-	 *
-	 * In principle there could be a problem in lowmem systems if
-	 * the initial memory is also very large with respect to
-	 * lowmem, but we won't try to deal with that here.
 	 */
-	extra_pages = min3(EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM)),
+	extra_pages = min3(XEN_EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM)),
 			   extra_pages, max_pages - max_pfn);
 	i = 0;
 	addr = xen_e820_table.entries[0].addr;


