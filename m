Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DBB117323
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 18:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLIRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 12:48:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726598AbfLIRsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 12:48:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575913730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5j9y6uTzLH6AC77P2ufw4QrIfhyaBDvoWP5b6gJS+oc=;
        b=fR9binU0UU8PsjwemD+N7GlcTUGRDom3vaCWYaWIpRNwVhvuN9kXKJlWPMnFrnFKxkxkov
        4ZwIfT00HNtP7g7gfQcS6AaXZeKZmIMwhqWLZsGH7iejU1RP9OpTGGkMtj5XstVrycMvJ4
        2v7tBZV9Fz7mCwkLZWmHhXlb0EjvhBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-Fe-49BicNvahBHQY8FMnhg-1; Mon, 09 Dec 2019 12:48:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 872581005514;
        Mon,  9 Dec 2019 17:48:45 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-214.ams2.redhat.com [10.36.116.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143951001B03;
        Mon,  9 Dec 2019 17:48:42 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Sistare <steven.sistare@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Bob Picco <bob.picco@oracle.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v1 1/3] mm: fix uninitialized memmaps on a partially populated last section
Date:   Mon,  9 Dec 2019 18:48:34 +0100
Message-Id: <20191209174836.11063-2-david@redhat.com>
In-Reply-To: <20191209174836.11063-1-david@redhat.com>
References: <20191209174836.11063-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Fe-49BicNvahBHQY8FMnhg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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

E.g., doing a "cat /proc/kpageflags > /dev/null" results in

[  303.218313] BUG: unable to handle page fault for address: ffffffffffffff=
fe
[  303.218899] #PF: supervisor read access in kernel mode
[  303.219344] #PF: error_code(0x0000) - not-present page
[  303.219787] PGD 12614067 P4D 12614067 PUD 12616067 PMD 0
[  303.220266] Oops: 0000 [#1] SMP NOPTI
[  303.220587] CPU: 0 PID: 424 Comm: cat Not tainted 5.4.0-next-20191128+ #=
17
[  303.221169] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
[  303.222140] RIP: 0010:stable_page_flags+0x4d/0x410
[  303.222554] Code: f3 ff 41 89 c0 48 b8 00 00 00 00 01 00 00 00 45 84 c0 =
0f 85 cd 02 00 00 48 8b 53 08 48 8b 2b 48f
[  303.224135] RSP: 0018:ffff9f5980187e58 EFLAGS: 00010202
[  303.224576] RAX: fffffffffffffffe RBX: ffffda1285004000 RCX: ffff9f59801=
87dd4
[  303.225178] RDX: 0000000000000001 RSI: ffffffff92662420 RDI: 00000000000=
00246
[  303.225789] RBP: ffffffffffffffff R08: 0000000000000000 R09: 00000000000=
00000
[  303.226405] R10: 0000000000000000 R11: 0000000000000000 R12: 00007f31d07=
0e000
[  303.227012] R13: 0000000000140100 R14: 00007f31d070e800 R15: ffffda12850=
04000
[  303.227629] FS:  00007f31d08f6580(0000) GS:ffff90a6bba00000(0000) knlGS:=
0000000000000000
[  303.228329] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.228820] CR2: fffffffffffffffe CR3: 00000001332a2000 CR4: 00000000000=
006f0
[  303.229438] Call Trace:
[  303.229654]  kpageflags_read.cold+0x57/0xf0
[  303.230016]  proc_reg_read+0x3c/0x60
[  303.230332]  vfs_read+0xc2/0x170
[  303.230614]  ksys_read+0x65/0xe0
[  303.230898]  do_syscall_64+0x5c/0xa0
[  303.231216]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

This patch fixes that by at least zero-ing out that memmap (so e.g.,
page_to_pfn() will not crash). Commit 907ec5fca3dc ("mm: zero remaining
unavailable struct pages") tried to fix a similar issue, but forgot to
consider this special case.

After this patch, there are still problems to solve. E.g., not all of these
pages falling into a memory hole will actually get initialized later
and set PageReserved - they are only zeroed out - but at least the
immediate crashes are gone. A follow-up patch will take care of this.

Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap"=
)
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
@@ -6932,7 +6932,8 @@ static u64 zero_pfn_range(unsigned long spfn, unsigne=
d long epfn)
  * This function also addresses a similar issue where struct pages are lef=
t
  * uninitialized because the physical address range is not covered by
  * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=3D.
+ * layout is manually configured via memmap=3D, or when the highest physic=
al
+ * address (max_pfn) does not end on a section boundary.
  */
 void __init zero_resv_unavail(void)
 {
@@ -6950,7 +6951,16 @@ void __init zero_resv_unavail(void)
 =09=09=09pgcnt +=3D zero_pfn_range(PFN_DOWN(next), PFN_UP(start));
 =09=09next =3D end;
 =09}
-=09pgcnt +=3D zero_pfn_range(PFN_DOWN(next), max_pfn);
+
+=09/*
+=09 * Early sections always have a fully populated memmap for the whole
+=09 * section - see pfn_valid(). If the last section has holes at the
+=09 * end and that section is marked "online", the memmap will be
+=09 * considered initialized. Make sure that memmap has a well defined
+=09 * state.
+=09 */
+=09pgcnt +=3D zero_pfn_range(PFN_DOWN(next),
+=09=09=09=09round_up(max_pfn, PAGES_PER_SECTION));
=20
 =09/*
 =09 * Struct pages that do not have backing memory. This could be because
--=20
2.21.0

