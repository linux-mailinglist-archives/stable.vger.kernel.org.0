Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA813C7D3
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgAOPd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:33:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgAOPd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xouwvrgb9om+SdRVos7b4oALgOeF1wG6WhY9MhFAPfM=;
        b=JS5Jl4dmar62BHwzfwuFBl4bY5Yx0qIAcZrlxGML6UxQji7rae+O1fv6t71k96IoaTr722
        NePa3GHz/cqVvWG7owAkSDy9V7w88mvfUs/ETQH/SsmiDi+W2ePOAleJFCbg8DQ2U6lJYQ
        WYfzDN/vEqh79zM4O0BQjbs8uwNELok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-dSiSfgeDO4iSSN-MK1IFiw-1; Wed, 15 Jan 2020 10:33:53 -0500
X-MC-Unique: dSiSfgeDO4iSSN-MK1IFiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3CFC8DB0FF;
        Wed, 15 Jan 2020 15:33:51 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5FFC8888F;
        Wed, 15 Jan 2020 15:33:49 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 03/25] mm, sparse: pass nid instead of pgdat to sparse_add_one_section()
Date:   Wed, 15 Jan 2020 16:33:17 +0100
Message-Id: <20200115153339.36409-4-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4e0d2e7ef14d9e1c900dac909db45263822b824f upstream.

Since the information needed in sparse_add_one_section() is node id to
allocate proper memory, it is not necessary to pass its pgdat.

This patch changes the prototype of sparse_add_one_section() to pass node
id directly.  This is intended to reduce misleading that
sparse_add_one_section() would touch pgdat.

Link: http://lkml.kernel.org/r/20181204085657.20472-2-richard.weiyang@gma=
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
 include/linux/memory_hotplug.h | 4 ++--
 mm/memory_hotplug.c            | 2 +-
 mm/sparse.c                    | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplu=
g.h
index 6f13a5a33b51..008e5281e7d7 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -335,8 +335,8 @@ extern void move_pfn_range_to_zone(struct zone *zone,=
 unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages=
);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern int sparse_add_one_section(struct pglist_data *pgdat,
-		unsigned long start_pfn, struct vmem_altmap *altmap);
+extern int sparse_add_one_section(int nid, unsigned long start_pfn,
+				  struct vmem_altmap *altmap);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_sect=
ion *ms,
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e2e2cf7014ee..c109e3f0bc16 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -255,7 +255,7 @@ static int __meminit __add_section(int nid, unsigned =
long phys_start_pfn,
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
=20
-	ret =3D sparse_add_one_section(NODE_DATA(nid), phys_start_pfn, altmap);
+	ret =3D sparse_add_one_section(nid, phys_start_pfn, altmap);
 	if (ret < 0)
 		return ret;
=20
diff --git a/mm/sparse.c b/mm/sparse.c
index 9aca9f24bdc5..f52e8c328761 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -661,8 +661,8 @@ static void free_map_bootmem(struct page *memmap)
  * set.  If this is <=3D0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(struct pglist_data *pgdat,
-		unsigned long start_pfn, struct vmem_altmap *altmap)
+int __meminit sparse_add_one_section(int nid, unsigned long start_pfn,
+				     struct vmem_altmap *altmap)
 {
 	unsigned long section_nr =3D pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -674,11 +674,11 @@ int __meminit sparse_add_one_section(struct pglist_=
data *pgdat,
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	ret =3D sparse_index_init(section_nr, pgdat->node_id);
+	ret =3D sparse_index_init(section_nr, nid);
 	if (ret < 0 && ret !=3D -EEXIST)
 		return ret;
 	ret =3D 0;
-	memmap =3D kmalloc_section_memmap(section_nr, pgdat->node_id, altmap);
+	memmap =3D kmalloc_section_memmap(section_nr, nid, altmap);
 	if (!memmap)
 		return -ENOMEM;
 	usemap =3D __kmalloc_section_usemap();
--=20
2.24.1

