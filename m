Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD714B204
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgA1Ju4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:50:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgA1Juz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INvVzhvRHbCGPZfOpT7NTXDjD6ax88XI5CXkCizD/uE=;
        b=Lu3RpUiTSVbFhDxlvlbBBE/7HnPhIuMW6PpMbNP73jmKVs1VyxDbhv9P03Ot5ZKOoDswxS
        7ArbXSjgedwuqlsDVf8Rgy2Dy84D5yyZuF1/8a/EvK/7jK2RIaO68F1Ujq+s+/MJBLXm6V
        PkDA0XmYVeGk23bYDupiJGK11bAhYkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-hstgQGQNPba7beNVr7XYXQ-1; Tue, 28 Jan 2020 04:50:44 -0500
X-MC-Unique: hstgQGQNPba7beNVr7XYXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF66618FF663;
        Tue, 28 Jan 2020 09:50:42 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9FDA60C05;
        Tue, 28 Jan 2020 09:50:40 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v3 06/24] mm/memory_hotplug: release memory resource after arch_remove_memory()
Date:   Tue, 28 Jan 2020 10:50:03 +0100
Message-Id: <20200128095021.8076-7-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d9eb1417c77df7ce19abd2e41619e9dceccbdf2a upstream.

Patch series "mm/memory_hotplug: Better error handling when removing
memory", v1.

Error handling when removing memory is somewhat messed up right now.  Som=
e
errors result in warnings, others are completely ignored.  Memory unplug
code can essentially not deal with errors properly as of now.
remove_memory() will never fail.

We have basically two choices:
1. Allow arch_remov_memory() and friends to fail, propagating errors via
   remove_memory(). Might be problematic (e.g. DIMMs consisting of multip=
le
   pieces added/removed separately).
2. Don't allow the functions to fail, handling errors in a nicer way.

It seems like most errors that can theoretically happen are really corner
cases and mostly theoretical (e.g.  "section not valid").  However e.g.
aborting removal of sections while all callers simply continue in case of
errors is not nice.

If we can gurantee that removal of memory always works (and WARN/skip in
case of theoretical errors so we can figure out what is going on), we can
go ahead and implement better error handling when adding memory.

E.g. via add_memory():

arch_add_memory()
ret =3D do_stuff()
if (ret) {
	arch_remove_memory();
	goto error;
}

Handling here that arch_remove_memory() might fail is basically
impossible.  So I suggest, let's avoid reporting errors while removing
memory, warning on theoretical errors instead and continuing instead of
aborting.

This patch (of 4):

__add_pages() doesn't add the memory resource, so __remove_pages()
shouldn't remove it.  Let's factor it out.  Especially as it is a special
case for memory used as system memory, added via add_memory() and friends=
.

We now remove the resource after removing the sections instead of doing i=
t
the other way around.  I don't think this change is problematic.

add_memory()
	register memory resource
	arch_add_memory()

remove_memory
	arch_remove_memory()
	release memory resource

While at it, explain why we ignore errors and that it only happeny if
we remove memory in a different granularity as we added it.

[david@redhat.com: fix printk warning]
  Link: http://lkml.kernel.org/r/20190417120204.6997-1-david@redhat.com
Link: http://lkml.kernel.org/r/20190409100148.24703-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory_hotplug.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a51e5ffdaa04..418d589552b3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -523,20 +523,6 @@ int __remove_pages(struct zone *zone, unsigned long =
phys_start_pfn,
 	if (is_dev_zone(zone)) {
 		if (altmap)
 			map_offset =3D vmem_altmap_offset(altmap);
-	} else {
-		resource_size_t start, size;
-
-		start =3D phys_start_pfn << PAGE_SHIFT;
-		size =3D nr_pages * PAGE_SIZE;
-
-		ret =3D release_mem_region_adjustable(&iomem_resource, start,
-					size);
-		if (ret) {
-			resource_size_t endres =3D start + size - 1;
-
-			pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
-					&start, &endres, ret);
-		}
 	}
=20
 	clear_zone_contiguous(zone);
@@ -1883,6 +1869,26 @@ void try_offline_node(int nid)
 }
 EXPORT_SYMBOL(try_offline_node);
=20
+static void __release_memory_resource(resource_size_t start,
+				      resource_size_t size)
+{
+	int ret;
+
+	/*
+	 * When removing memory in the same granularity as it was added,
+	 * this function never fails. It might only fail if resources
+	 * have to be adjusted or split. We'll ignore the error, as
+	 * removing of memory cannot fail.
+	 */
+	ret =3D release_mem_region_adjustable(&iomem_resource, start, size);
+	if (ret) {
+		resource_size_t endres =3D start + size - 1;
+
+		pr_warn("Unable to release resource <%pa-%pa> (%d)\n",
+			&start, &endres, ret);
+	}
+}
+
 /**
  * remove_memory
  * @nid: the node ID
@@ -1917,6 +1923,7 @@ void __ref __remove_memory(int nid, u64 start, u64 =
size)
 	memblock_remove(start, size);
=20
 	arch_remove_memory(nid, start, size, NULL);
+	__release_memory_resource(start, size);
=20
 	try_offline_node(nid);
=20
--=20
2.24.1

