Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBA611B8D9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfLKQcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:32:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730072AbfLKQcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576081936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gJwfxwyql/ZBro6j3PHhc8Sr1IUHu9YKmw5lChLB3M=;
        b=daY8v31nrKGKBIER7p03AU48nvvcv1VOH2iZSNzYUAu81TVlzdb9CM/FhKZtzj3LPTNrJN
        sQUN9KVyhXkbpVugThntoTgHL4UQ9wjot+XnINFbC13WnpPgSNFVR17UfMmgOU7YmqEHoY
        pvteBYJQY0hiAr5/71qv/iw3L5+qxQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-wmcTqCOIMYGjeEvJ5IZrFg-1; Wed, 11 Dec 2019 11:32:12 -0500
X-MC-Unique: wmcTqCOIMYGjeEvJ5IZrFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2568E8C2B48;
        Wed, 11 Dec 2019 16:32:11 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-148.ams2.redhat.com [10.36.117.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89B7F605FF;
        Wed, 11 Dec 2019 16:32:08 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Sistare <steven.sistare@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Bob Picco <bob.picco@oracle.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v2 1/3] mm: fix uninitialized memmaps on a partially populated last section
Date:   Wed, 11 Dec 2019 17:31:59 +0100
Message-Id: <20191211163201.17179-2-david@redhat.com>
In-Reply-To: <20191211163201.17179-1-david@redhat.com>
References: <20191211163201.17179-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If max_pfn is not aligned to a section boundary, we can easily run into
BUGs. This can e.g., be triggered on x86-64 under QEMU by specifying a
memory size that is not a multiple of 128MB (e.g., 4097MB, but also
4160MB). I was told that on real HW, we can easily have this scenario
(esp., one of the main reasons sub-section hotadd of devmem was added).

The issue is, that we have a valid memmap (pfn_valid()) for the
whole section, and the whole section will be marked "online".
pfn_to_online_page() will succeed, but the memmap contains garbage.

E.g., doing a "./page-types -r -a 0x144001" when QEMU was started with
"-m 4160M" - (see tools/vm/page-types.c):

[  200.476376] BUG: unable to handle page fault for address: ffffffffffff=
fffe
[  200.477500] #PF: supervisor read access in kernel mode
[  200.478334] #PF: error_code(0x0000) - not-present page
[  200.479076] PGD 59614067 P4D 59614067 PUD 59616067 PMD 0
[  200.479557] Oops: 0000 [#4] SMP NOPTI
[  200.479875] CPU: 0 PID: 603 Comm: page-types Tainted: G      D W      =
   5.5.0-rc1-next-20191209 #93
[  200.480646] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
[  200.481648] RIP: 0010:stable_page_flags+0x4d/0x410
[  200.482061] Code: f3 ff 41 89 c0 48 b8 00 00 00 00 01 00 00 00 45 84 c=
0 0f 85 cd 02 00 00 48 8b 53 08 48 8b 2b 48f
[  200.483644] RSP: 0018:ffffb139401cbe60 EFLAGS: 00010202
[  200.484091] RAX: fffffffffffffffe RBX: fffffbeec5100040 RCX: 000000000=
0000000
[  200.484697] RDX: 0000000000000001 RSI: ffffffff9535c7cd RDI: 000000000=
0000246
[  200.485313] RBP: ffffffffffffffff R08: 0000000000000000 R09: 000000000=
0000000
[  200.485917] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0144001
[  200.486523] R13: 00007ffd6ba55f48 R14: 00007ffd6ba55f40 R15: ffffb1394=
01cbf08
[  200.487130] FS:  00007f68df717580(0000) GS:ffff9ec77fa00000(0000) knlG=
S:0000000000000000
[  200.487804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  200.488295] CR2: fffffffffffffffe CR3: 0000000135d48000 CR4: 000000000=
00006f0
[  200.488897] Call Trace:
[  200.489115]  kpageflags_read+0xe9/0x140
[  200.489447]  proc_reg_read+0x3c/0x60
[  200.489755]  vfs_read+0xc2/0x170
[  200.490037]  ksys_pread64+0x65/0xa0
[  200.490352]  do_syscall_64+0x5c/0xa0
[  200.490665]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

But it can be triggered much easier via "cat /proc/kpageflags > /dev/null=
"
after cold/hot plugging a DIMM to such a system:

[root@localhost ~]# cat /proc/kpageflags > /dev/null
[  111.517275] BUG: unable to handle page fault for address: ffffffffffff=
fffe
[  111.517907] #PF: supervisor read access in kernel mode
[  111.518333] #PF: error_code(0x0000) - not-present page
[  111.518771] PGD a240e067 P4D a240e067 PUD a2410067 PMD 0

This patch fixes that by at least zero-ing out that memmap (so e.g.,
page_to_pfn() will not crash). Commit 907ec5fca3dc ("mm: zero remaining
unavailable struct pages") tried to fix a similar issue, but forgot to
consider this special case.

After this patch, there are still problems to solve. E.g., not all of the=
se
pages falling into a memory hole will actually get initialized later
and set PageReserved - they are only zeroed out - but at least the
immediate crashes are gone. A follow-up patch will take care of this.

Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemma=
p")
Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: <stable@vger.kernel.org> # v4.15+
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 62dcd6b76c80..1eb2ce7c79e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6932,7 +6932,8 @@ static u64 zero_pfn_range(unsigned long spfn, unsig=
ned long epfn)
  * This function also addresses a similar issue where struct pages are l=
eft
  * uninitialized because the physical address range is not covered by
  * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=3D.
+ * layout is manually configured via memmap=3D, or when the highest phys=
ical
+ * address (max_pfn) does not end on a section boundary.
  */
 void __init zero_resv_unavail(void)
 {
@@ -6950,7 +6951,16 @@ void __init zero_resv_unavail(void)
 			pgcnt +=3D zero_pfn_range(PFN_DOWN(next), PFN_UP(start));
 		next =3D end;
 	}
-	pgcnt +=3D zero_pfn_range(PFN_DOWN(next), max_pfn);
+
+	/*
+	 * Early sections always have a fully populated memmap for the whole
+	 * section - see pfn_valid(). If the last section has holes at the
+	 * end and that section is marked "online", the memmap will be
+	 * considered initialized. Make sure that memmap has a well defined
+	 * state.
+	 */
+	pgcnt +=3D zero_pfn_range(PFN_DOWN(next),
+				round_up(max_pfn, PAGES_PER_SECTION));
=20
 	/*
 	 * Struct pages that do not have backing memory. This could be because
--=20
2.23.0

