Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2836214B8F0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbgA1O3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbgA1O3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AFBB2468D;
        Tue, 28 Jan 2020 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221740;
        bh=pmH3pqwquri/97YKTJEYZAwFtUYiOj88w6HvPfcMfoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj68Uz43xckdoOdHWxNKPV6ks2YXfT1Yqt83PjSqW9otV5B2im9fu1HCIkKjHcudp
         7ZbLp3rtqIAc+pZJE7WMwCGi40ZAj6ddBweEkPiyMYh4A4h/PALZhBot8M9Q1IqL7r
         LY+3/WS+PsPxBC7SuhIrkErnSVVWpuMmKtq68LL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 71/92] mm, sparse: pass nid instead of pgdat to sparse_add_one_section()
Date:   Tue, 28 Jan 2020 15:08:39 +0100
Message-Id: <20200128135818.493866712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>

commit 4e0d2e7ef14d9e1c900dac909db45263822b824f upstream.

Since the information needed in sparse_add_one_section() is node id to
allocate proper memory, it is not necessary to pass its pgdat.

This patch changes the prototype of sparse_add_one_section() to pass node
id directly.  This is intended to reduce misleading that
sparse_add_one_section() would touch pgdat.

Link: http://lkml.kernel.org/r/20181204085657.20472-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memory_hotplug.h |    4 ++--
 mm/memory_hotplug.c            |    2 +-
 mm/sparse.c                    |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -335,8 +335,8 @@ extern void move_pfn_range_to_zone(struc
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern int sparse_add_one_section(struct pglist_data *pgdat,
-		unsigned long start_pfn, struct vmem_altmap *altmap);
+extern int sparse_add_one_section(int nid, unsigned long start_pfn,
+				  struct vmem_altmap *altmap);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -255,7 +255,7 @@ static int __meminit __add_section(int n
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(NODE_DATA(nid), phys_start_pfn, altmap);
+	ret = sparse_add_one_section(nid, phys_start_pfn, altmap);
 	if (ret < 0)
 		return ret;
 
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -661,8 +661,8 @@ static void free_map_bootmem(struct page
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(struct pglist_data *pgdat,
-		unsigned long start_pfn, struct vmem_altmap *altmap)
+int __meminit sparse_add_one_section(int nid, unsigned long start_pfn,
+				     struct vmem_altmap *altmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -674,11 +674,11 @@ int __meminit sparse_add_one_section(str
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	ret = sparse_index_init(section_nr, pgdat->node_id);
+	ret = sparse_index_init(section_nr, nid);
 	if (ret < 0 && ret != -EEXIST)
 		return ret;
 	ret = 0;
-	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, altmap);
+	memmap = kmalloc_section_memmap(section_nr, nid, altmap);
 	if (!memmap)
 		return -ENOMEM;
 	usemap = __kmalloc_section_usemap();


