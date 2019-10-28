Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4580E7479
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 16:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbfJ1PIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 11:08:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726945AbfJ1PIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 11:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572275318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vEnxaTykMlNOFE8mPsoI1DOBUkdENjJ4vxl1KjWnhb4=;
        b=brNJ7W8JX6m9aJ9bxoY4pJ4I1h8Wwud34yZdhAqQgkkyPeGSAT/6b8lQBjKqE5BBehu5se
        rakIMizIt0TDJz+DdjFEeDi5QVmRGtOpKxCagZ5hl0r3ybWXNkE7G60xGOP6El/2FLDMyq
        SD/lnumIyXI0DW1cyhUYb2GWY9yZDsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-oofbZBZsMuqSiZTtKvUUvw-1; Mon, 28 Oct 2019 11:08:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DC891005510;
        Mon, 28 Oct 2019 15:08:31 +0000 (UTC)
Received: from [10.36.117.63] (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CADF2636C;
        Mon, 28 Oct 2019 15:08:21 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] mm/memory_hotplug: don't access
 uninitialized memmaps in" failed to apply to 4.19-stable tree
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        alexander.h.duyck@linux.intel.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, cai@lca.pw,
        catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org,
        damian.tometzki@gmail.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, fenghua.yu@intel.com,
        gerald.schaefer@de.ibm.com, glider@google.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org,
        mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@suse.com,
        mingo@redhat.com, mpe@ellerman.id.au, osalvador@suse.de,
        pagupta@redhat.com, pasha.tatashin@soleen.com, pasic@linux.ibm.com,
        paulus@samba.org, pavel.tatashin@microsoft.com,
        peterz@infradead.org, richard.weiyang@gmail.com,
        richardw.yang@linux.intel.com, robin.murphy@arm.com,
        rppt@linux.ibm.com, stable@vger.kernel.org, steve.capper@arm.com,
        tglx@linutronix.de, thomas.lendacky@amd.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, will@kernel.org,
        willy@infradead.org, yamada.masahiro@socionext.com,
        yaojun8558363@gmail.com, ysato@users.sourceforge.jp,
        yuzhao@google.com
References: <1572183819118174@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <38c8a759-85db-04c4-95d1-9268d36d1b94@redhat.com>
Date:   Mon, 28 Oct 2019 16:08:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572183819118174@kroah.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: oofbZBZsMuqSiZTtKvUUvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.10.19 14:43, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
>  From 00d6c019b5bc175cee3770e0e659f2b5f4804ea5 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Fri, 18 Oct 2019 20:19:33 -0700
> Subject: [PATCH] mm/memory_hotplug: don't access uninitialized memmaps in
>   shrink_pgdat_span()
>=20
> We might use the nid of memmaps that were never initialized.  For
> example, if the memmap was poisoned, we will crash the kernel in
> pfn_to_nid() right now.  Let's use the calculated boundaries of the
> separate zones instead.  This now also avoids having to iterate over a
> whole bunch of subsections again, after shrinking one zone.
>=20
> Before commit d0dc12e86b31 ("mm/memory_hotplug: optimize memory
> hotplug"), the memmap was initialized to 0 and the node was set to the
> right value.  After that commit, the node might be garbage.
>=20
> We'll have to fix shrink_zone_span() next.
>=20
> Link: http://lkml.kernel.org/r/20191006085646.5768-4-david@redhat.com
> Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memor=
y to zones until online")=09[d0dc12e86b319]
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Damian Tometzki <damian.tometzki@gmail.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jun Yao <yaojun8558363@gmail.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Pankaj Gupta <pagupta@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Steve Capper <steve.capper@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: <stable@vger.kernel.org>=09[4.13+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b1be791f772d..df570e5c71cc 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -436,67 +436,25 @@ static void shrink_zone_span(struct zone *zone, uns=
igned long start_pfn,
>   =09zone_span_writeunlock(zone);
>   }
>  =20
> -static void shrink_pgdat_span(struct pglist_data *pgdat,
> -=09=09=09      unsigned long start_pfn, unsigned long end_pfn)
> +static void update_pgdat_span(struct pglist_data *pgdat)
>   {
> -=09unsigned long pgdat_start_pfn =3D pgdat->node_start_pfn;
> -=09unsigned long p =3D pgdat_end_pfn(pgdat); /* pgdat_end_pfn namespace =
clash */
> -=09unsigned long pgdat_end_pfn =3D p;
> -=09unsigned long pfn;
> -=09int nid =3D pgdat->node_id;
> -
> -=09if (pgdat_start_pfn =3D=3D start_pfn) {
> -=09=09/*
> -=09=09 * If the section is smallest section in the pgdat, it need
> -=09=09 * shrink pgdat->node_start_pfn and pgdat->node_spanned_pages.
> -=09=09 * In this case, we find second smallest valid mem_section
> -=09=09 * for shrinking zone.
> -=09=09 */
> -=09=09pfn =3D find_smallest_section_pfn(nid, NULL, end_pfn,
> -=09=09=09=09=09=09pgdat_end_pfn);
> -=09=09if (pfn) {
> -=09=09=09pgdat->node_start_pfn =3D pfn;
> -=09=09=09pgdat->node_spanned_pages =3D pgdat_end_pfn - pfn;
> -=09=09}
> -=09} else if (pgdat_end_pfn =3D=3D end_pfn) {
> -=09=09/*
> -=09=09 * If the section is biggest section in the pgdat, it need
> -=09=09 * shrink pgdat->node_spanned_pages.
> -=09=09 * In this case, we find second biggest valid mem_section for
> -=09=09 * shrinking zone.
> -=09=09 */
> -=09=09pfn =3D find_biggest_section_pfn(nid, NULL, pgdat_start_pfn,
> -=09=09=09=09=09       start_pfn);
> -=09=09if (pfn)
> -=09=09=09pgdat->node_spanned_pages =3D pfn - pgdat_start_pfn + 1;
> -=09}
> -
> -=09/*
> -=09 * If the section is not biggest or smallest mem_section in the pgdat=
,
> -=09 * it only creates a hole in the pgdat. So in this case, we need not
> -=09 * change the pgdat.
> -=09 * But perhaps, the pgdat has only hole data. Thus it check the pgdat
> -=09 * has only hole or not.
> -=09 */
> -=09pfn =3D pgdat_start_pfn;
> -=09for (; pfn < pgdat_end_pfn; pfn +=3D PAGES_PER_SUBSECTION) {
> -=09=09if (unlikely(!pfn_valid(pfn)))
> -=09=09=09continue;
> -
> -=09=09if (pfn_to_nid(pfn) !=3D nid)
> -=09=09=09continue;
> +=09unsigned long node_start_pfn =3D 0, node_end_pfn =3D 0;
> +=09struct zone *zone;
>  =20
> -=09=09/* Skip range to be removed */
> -=09=09if (pfn >=3D start_pfn && pfn < end_pfn)
> -=09=09=09continue;
> +=09for (zone =3D pgdat->node_zones;
> +=09     zone < pgdat->node_zones + MAX_NR_ZONES; zone++) {
> +=09=09unsigned long zone_end_pfn =3D zone->zone_start_pfn +
> +=09=09=09=09=09     zone->spanned_pages;
>  =20
> -=09=09/* If we find valid section, we have nothing to do */
> -=09=09return;
> +=09=09/* No need to lock the zones, they can't change. */
> +=09=09if (zone_end_pfn > node_end_pfn)
> +=09=09=09node_end_pfn =3D zone_end_pfn;
> +=09=09if (zone->zone_start_pfn < node_start_pfn)
> +=09=09=09node_start_pfn =3D zone->zone_start_pfn;
>   =09}
>  =20
> -=09/* The pgdat has no valid section */
> -=09pgdat->node_start_pfn =3D 0;
> -=09pgdat->node_spanned_pages =3D 0;
> +=09pgdat->node_start_pfn =3D node_start_pfn;
> +=09pgdat->node_spanned_pages =3D node_end_pfn - node_start_pfn;
>   }
>  =20
>   static void __remove_zone(struct zone *zone, unsigned long start_pfn,
> @@ -507,7 +465,7 @@ static void __remove_zone(struct zone *zone, unsigned=
 long start_pfn,
>  =20
>   =09pgdat_resize_lock(zone->zone_pgdat, &flags);
>   =09shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
> -=09shrink_pgdat_span(pgdat, start_pfn, start_pfn + nr_pages);
> +=09update_pgdat_span(pgdat);
>   =09pgdat_resize_unlock(zone->zone_pgdat, &flags);
>   }
>  =20
>=20

We'll come back to this once we sorted out

https://lkml.org/lkml/2019/10/27/738

--=20

Thanks,

David / dhildenb

