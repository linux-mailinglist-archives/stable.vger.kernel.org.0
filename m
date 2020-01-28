Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66B714B1FE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgA1Juj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:50:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgA1Juj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb21frneBKCPtY6/Ao0Hpt7MkysrHYEly3KQNa5STJw=;
        b=gAYQd3QjDZxTQ11VrNrbBVaxoLYgvOFKOa0yMNFUFfsy5L63xSVeZ0+CHCig5hBkJtT2eR
        r6v+NqU3toAbb+J1pHnYhDy2MTXQxpjgYK1Iz1hChEwCRgczEvQKmGggOP5Hpl/O6tAEQm
        aRLVzrQ0cm1Xs6RQHRpL73733t2TnGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-uJQ4rmnaMM2lUBsN96-rIQ-1; Tue, 28 Jan 2020 04:50:33 -0500
X-MC-Unique: uJQ4rmnaMM2lUBsN96-rIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC6CE800D48;
        Tue, 28 Jan 2020 09:50:31 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D59C60C05;
        Tue, 28 Jan 2020 09:50:29 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v3 02/24] mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()
Date:   Tue, 28 Jan 2020 10:49:59 +0100
Message-Id: <20200128095021.8076-3-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
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

These code paths are currently protected by mem_hotplug_lock currently bu=
t
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
  Link: http://lkml.kernel.org/r/20181204085657.20472-1-richard.weiyang@g=
mail.com
[mhocko@suse.com: changelog suggestion]
Link: http://lkml.kernel.org/r/20181128091243.19249-1-richard.weiyang@gma=
il.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mmzone.h | 3 +--
 mm/sparse.c            | 9 +--------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d4b0c79d2924..d6791e2df30a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,8 +637,7 @@ typedef struct pglist_data {
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAG=
E_INIT)
 	/*
 	 * Must be held any time you expect node_start_pfn, node_present_pages
-	 * or node_spanned_pages stay constant.  Holding this will also
-	 * guarantee that any pfn_valid() stays that way.
+	 * or node_spanned_pages stay constant.
 	 *
 	 * pgdat_resize_lock() and pgdat_resize_unlock() are provided to
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
diff --git a/mm/sparse.c b/mm/sparse.c
index 45950a074bdb..9aca9f24bdc5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -668,7 +668,6 @@ int __meminit sparse_add_one_section(struct pglist_da=
ta *pgdat,
 	struct mem_section *ms;
 	struct page *memmap;
 	unsigned long *usemap;
-	unsigned long flags;
 	int ret;
=20
 	/*
@@ -688,8 +687,6 @@ int __meminit sparse_add_one_section(struct pglist_da=
ta *pgdat,
 		return -ENOMEM;
 	}
=20
-	pgdat_resize_lock(pgdat, &flags);
-
 	ms =3D __pfn_to_section(start_pfn);
 	if (ms->section_mem_map & SECTION_MARKED_PRESENT) {
 		ret =3D -EEXIST;
@@ -708,7 +705,6 @@ int __meminit sparse_add_one_section(struct pglist_da=
ta *pgdat,
 	sparse_init_one_section(ms, section_nr, memmap, usemap);
=20
 out:
-	pgdat_resize_unlock(pgdat, &flags);
 	if (ret < 0) {
 		kfree(usemap);
 		__kfree_section_memmap(memmap, altmap);
@@ -770,10 +766,8 @@ void sparse_remove_one_section(struct zone *zone, st=
ruct mem_section *ms,
 		unsigned long map_offset, struct vmem_altmap *altmap)
 {
 	struct page *memmap =3D NULL;
-	unsigned long *usemap =3D NULL, flags;
-	struct pglist_data *pgdat =3D zone->zone_pgdat;
+	unsigned long *usemap =3D NULL;
=20
-	pgdat_resize_lock(pgdat, &flags);
 	if (ms->section_mem_map) {
 		usemap =3D ms->pageblock_flags;
 		memmap =3D sparse_decode_mem_map(ms->section_mem_map,
@@ -781,7 +775,6 @@ void sparse_remove_one_section(struct zone *zone, str=
uct mem_section *ms,
 		ms->section_mem_map =3D 0;
 		ms->pageblock_flags =3D NULL;
 	}
-	pgdat_resize_unlock(pgdat, &flags);
=20
 	clear_hwpoisoned_pages(memmap + map_offset,
 			PAGES_PER_SECTION - map_offset);
--=20
2.24.1

