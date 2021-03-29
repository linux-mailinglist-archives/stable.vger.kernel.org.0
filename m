Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3A934CADF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhC2Ikf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhC2Ijr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A24A61932;
        Mon, 29 Mar 2021 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007186;
        bh=/gQnNQRk1YgMl16NiS70nCo1pvUnpHlNXci7lYC3YBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx0RvO2VM24GY+HRlczNNa/sMq8V0RBorJRx4aaT1Kg9MAQu2hqoiztnQc7KCNMwn
         fVuPaIVaj0uEDGY47PCYltkzpkp/t1DynILJgOplfyXQBYEiZmzoMfVl+5SAB0yVMS
         +wf6k7tJWPh78Bl3lzHQYr35LSgpm1/ogT1PwnEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.11 251/254] Revert "xen: fix p2m size in dom0 for disabled memory hotplug case"
Date:   Mon, 29 Mar 2021 09:59:27 +0200
Message-Id: <20210329075641.313868473@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit af44a387e743ab7aa39d3fb5e29c0a973cf91bdc upstream.

This partially reverts commit 882213990d32 ("xen: fix p2m size in dom0
for disabled memory hotplug case")

There's no need to special case XEN_UNPOPULATED_ALLOC anymore in order
to correctly size the p2m. The generic memory hotplug option has
already been tied together with the Xen hotplug limit, so enabling
memory hotplug should already trigger a properly sized p2m on Xen PV.

Note that XEN_UNPOPULATED_ALLOC depends on ZONE_DEVICE which pulls in
MEMORY_HOTPLUG.

Leave the check added to __set_phys_to_machine and the adjusted
comment about EXTRA_MEM_RATIO.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210324122424.58685-3-roger.pau@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[boris: fixed formatting issues]
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/include/asm/xen/page.h |   12 ------------
 arch/x86/xen/p2m.c              |    3 ---
 arch/x86/xen/setup.c            |   16 ++++++++++++++--
 3 files changed, 14 insertions(+), 17 deletions(-)

--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -87,18 +87,6 @@ clear_foreign_p2m_mapping(struct gnttab_
 #endif
 
 /*
- * The maximum amount of extra memory compared to the base size.  The
- * main scaling factor is the size of struct page.  At extreme ratios
- * of base:extra, all the base memory can be filled with page
- * structures for the extra memory, leaving no space for anything
- * else.
- *
- * 10x seems like a reasonable balance between scaling flexibility and
- * leaving a practically usable system.
- */
-#define XEN_EXTRA_MEM_RATIO	(10)
-
-/*
  * Helper functions to write or read unsigned long values to/from
  * memory, when the access may fault.
  */
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -416,9 +416,6 @@ void __init xen_vmalloc_p2m_tree(void)
 	xen_p2m_last_pfn = xen_max_p2m_pfn;
 
 	p2m_limit = (phys_addr_t)P2M_LIMIT * 1024 * 1024 * 1024 / PAGE_SIZE;
-	if (!p2m_limit && IS_ENABLED(CONFIG_XEN_UNPOPULATED_ALLOC))
-		p2m_limit = xen_start_info->nr_pages * XEN_EXTRA_MEM_RATIO;
-
 	vm.flags = VM_ALLOC;
 	vm.size = ALIGN(sizeof(unsigned long) * max(xen_max_p2m_pfn, p2m_limit),
 			PMD_SIZE * PMDS_PER_MID_PAGE);
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -59,6 +59,18 @@ static struct {
 } xen_remap_buf __initdata __aligned(PAGE_SIZE);
 static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
 
+/*
+ * The maximum amount of extra memory compared to the base size.  The
+ * main scaling factor is the size of struct page.  At extreme ratios
+ * of base:extra, all the base memory can be filled with page
+ * structures for the extra memory, leaving no space for anything
+ * else.
+ *
+ * 10x seems like a reasonable balance between scaling flexibility and
+ * leaving a practically usable system.
+ */
+#define EXTRA_MEM_RATIO		(10)
+
 static bool xen_512gb_limit __initdata = IS_ENABLED(CONFIG_XEN_512GB);
 
 static void __init xen_parse_512gb(void)
@@ -778,13 +790,13 @@ char * __init xen_memory_setup(void)
 		extra_pages += max_pages - max_pfn;
 
 	/*
-	 * Clamp the amount of extra memory to a XEN_EXTRA_MEM_RATIO
+	 * Clamp the amount of extra memory to a EXTRA_MEM_RATIO
 	 * factor the base size.
 	 *
 	 * Make sure we have no memory above max_pages, as this area
 	 * isn't handled by the p2m management.
 	 */
-	extra_pages = min3(XEN_EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM)),
+	extra_pages = min3(EXTRA_MEM_RATIO * min(max_pfn, PFN_DOWN(MAXMEM)),
 			   extra_pages, max_pages - max_pfn);
 	i = 0;
 	addr = xen_e820_table.entries[0].addr;


