Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3209614B938
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387585AbgA1O27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387553AbgA1O26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3292468F;
        Tue, 28 Jan 2020 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221737;
        bh=JAjAeDhx0S/90GrsL1jOsjUZ4BTjZmzFFrqi3twWyLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atc9t/lyVRPROPGRod4TlBWXx8f0x2uVqsxf5JJRdiCDYL/o/9u6Fmt4VFX2u75di
         rMkU9WaK6N8ILiAUHhp0D8n7EgkGzWQfxQLyE7T7MBba3/yVOAEX/xzmXeglfPpJxC
         7h8JMntvDTiC6+CUl1HENOFlBEYc/i7PKI+8GFQ4=
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
Subject: [PATCH 4.19 70/92] mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()
Date:   Tue, 28 Jan 2020 15:08:38 +0100
Message-Id: <20200128135818.356174370@linuxfoundation.org>
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

commit 83af658898cb292a32d8b6cd9b51266d7cfc4b6a upstream.

pgdat_resize_lock is used to protect pgdat's memory region information
like: node_start_pfn, node_present_pages, etc.  While in function
sparse_add/remove_one_section(), pgdat_resize_lock is used to protect
initialization/release of one mem_section.  This looks not proper.

These code paths are currently protected by mem_hotplug_lock currently but
should there ever be any reason for locking at the sparse layer a
dedicated lock should be introduced.

Following is the current call trace of sparse_add/remove_one_section()

    mem_hotplug_begin()
    arch_add_memory()
       add_pages()
           __add_pages()
               __add_section()
                   sparse_add_one_section()
    mem_hotplug_done()

    mem_hotplug_begin()
    arch_remove_memory()
        __remove_pages()
            __remove_section()
                sparse_remove_one_section()
    mem_hotplug_done()

The comment above the pgdat_resize_lock also mentions "Holding this will
also guarantee that any pfn_valid() stays that way.", which is true with
the current implementation and false after this patch.  But current
implementation doesn't meet this comment.  There isn't any pfn walkers to
take the lock so this looks like a relict from the past.  This patch also
removes this comment.

[richard.weiyang@gmail.com: v4]
  Link: http://lkml.kernel.org/r/20181204085657.20472-1-richard.weiyang@gmail.com
[mhocko@suse.com: changelog suggestion]
Link: http://lkml.kernel.org/r/20181128091243.19249-1-richard.weiyang@gmail.com
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
 include/linux/mmzone.h |    3 +--
 mm/sparse.c            |    9 +--------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,8 +637,7 @@ typedef struct pglist_data {
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 	/*
 	 * Must be held any time you expect node_start_pfn, node_present_pages
-	 * or node_spanned_pages stay constant.  Holding this will also
-	 * guarantee that any pfn_valid() stays that way.
+	 * or node_spanned_pages stay constant.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -668,7 +668,6 @@ int __meminit sparse_add_one_section(str
 	struct mem_section *ms;
 	struct page *memmap;
 	unsigned long *usemap;
-	unsigned long flags;
 	int ret;
 
 	/*
@@ -688,8 +687,6 @@ int __meminit sparse_add_one_section(str
 		return -ENOMEM;
 	}
 
-	pgdat_resize_lock(pgdat, &flags);
-
 	ms = __pfn_to_section(start_pfn);
 	if (ms->section_mem_map & SECTION_MARKED_PRESENT) {
 		ret = -EEXIST;
@@ -708,7 +705,6 @@ int __meminit sparse_add_one_section(str
 	sparse_init_one_section(ms, section_nr, memmap, usemap);
 
 out:
-	pgdat_resize_unlock(pgdat, &flags);
 	if (ret < 0) {
 		kfree(usemap);
 		__kfree_section_memmap(memmap, altmap);
@@ -770,10 +766,8 @@ void sparse_remove_one_section(struct zo
 		unsigned long map_offset, struct vmem_altmap *altmap)
 {
 	struct page *memmap = NULL;
-	unsigned long *usemap = NULL, flags;
-	struct pglist_data *pgdat = zone->zone_pgdat;
+	unsigned long *usemap = NULL;
 
-	pgdat_resize_lock(pgdat, &flags);
 	if (ms->section_mem_map) {
 		usemap = ms->pageblock_flags;
 		memmap = sparse_decode_mem_map(ms->section_mem_map,
@@ -781,7 +775,6 @@ void sparse_remove_one_section(struct zo
 		ms->section_mem_map = 0;
 		ms->pageblock_flags = NULL;
 	}
-	pgdat_resize_unlock(pgdat, &flags);
 
 	clear_hwpoisoned_pages(memmap + map_offset,
 			PAGES_PER_SECTION - map_offset);


