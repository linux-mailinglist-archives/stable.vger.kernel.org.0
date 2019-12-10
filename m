Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6824118481
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfLJKLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:11:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24027 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbfLJKLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 05:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575972669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/fNSAK93ztMW9L1B/NS00CbJs6KXG9nyQ8geCOXUcHA=;
        b=Bwk4k++zm7LmGa/EtzAXe0BTXsg6byqgazYd7A3bKaJT0FqVo6ePK6PjLJwWQWGyTpbaum
        oeoV+lzvYxoUgvOgBCOKA+TZStWoRinEG1DVvf9JSB+iI1KhTAU+5I82gJlMYk3itV9u2D
        6fUFlj1bfKSM34jkE4neDFQtBSSlK9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-laAmNaQoMZGmiLgtL7GHyQ-1; Tue, 10 Dec 2019 05:11:08 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B25F18AAFA2;
        Tue, 10 Dec 2019 10:11:06 +0000 (UTC)
Received: from [10.36.117.222] (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 450B75D6D4;
        Tue, 10 Dec 2019 10:11:04 +0000 (UTC)
Subject: Re: [PATCH v1 1/3] mm: fix uninitialized memmaps on a partially
 populated last section
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Sistare <steven.sistare@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Bob Picco <bob.picco@oracle.com>,
        Oscar Salvador <osalvador@suse.de>
References: <20191209174836.11063-1-david@redhat.com>
 <20191209174836.11063-2-david@redhat.com>
 <20191209211502.zhbvzv2qwbvcperm@ca-dmjordan1.us.oracle.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <c0733e11-bf06-8813-11de-019cdbddef34@redhat.com>
Date:   Tue, 10 Dec 2019 11:11:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191209211502.zhbvzv2qwbvcperm@ca-dmjordan1.us.oracle.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: laAmNaQoMZGmiLgtL7GHyQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.12.19 22:15, Daniel Jordan wrote:
> Hi David,
>=20
> On Mon, Dec 09, 2019 at 06:48:34PM +0100, David Hildenbrand wrote:
>> If max_pfn is not aligned to a section boundary, we can easily run into
>> BUGs. This can e.g., be triggered on x86-64 under QEMU by specifying a
>> memory size that is not a multiple of 128MB (e.g., 4097MB, but also
>> 4160MB). I was told that on real HW, we can easily have this scenario
>> (esp., one of the main reasons sub-section hotadd of devmem was added).
>>
>> The issue is, that we have a valid memmap (pfn_valid()) for the
>> whole section, and the whole section will be marked "online".
>> pfn_to_online_page() will succeed, but the memmap contains garbage.
>>
>> E.g., doing a "cat /proc/kpageflags > /dev/null" results in
>>
>> [  303.218313] BUG: unable to handle page fault for address: fffffffffff=
ffffe
>> [  303.218899] #PF: supervisor read access in kernel mode
>> [  303.219344] #PF: error_code(0x0000) - not-present page
>> [  303.219787] PGD 12614067 P4D 12614067 PUD 12616067 PMD 0
>> [  303.220266] Oops: 0000 [#1] SMP NOPTI
>> [  303.220587] CPU: 0 PID: 424 Comm: cat Not tainted 5.4.0-next-20191128=
+ #17
>=20

Hi Daniel,

> I can't reproduce this on x86-64 qemu, next-20191128 or mainline, with ei=
ther
> memory size.  What config are you using?  How often are you hitting it?

Thanks for verifying! Hah, there is one piece missing to reproduce via
"cat /proc/kpageflags > /dev/null" that I ignored on my QEMU cmdline (see b=
elow)

I can reproduce it reliably (QEMU with "-m 4160M") via

[root@localhost ~]# uname -a
Linux localhost 5.5.0-rc1-next-20191209 #93 SMP Tue Dec 10 10:46:19 CET 201=
9 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# ./page-types -r -a 0x144001
[  200.476376] BUG: unable to handle page fault for address: ffffffffffffff=
fe
[  200.477500] #PF: supervisor read access in kernel mode
[  200.478334] #PF: error_code(0x0000) - not-present page
[  200.479076] PGD 59614067 P4D 59614067 PUD 59616067 PMD 0=20
[  200.479557] Oops: 0000 [#4] SMP NOPTI
[  200.479875] CPU: 0 PID: 603 Comm: page-types Tainted: G      D W        =
 5.5.0-rc1-next-20191209 #93
[  200.480646] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
[  200.481648] RIP: 0010:stable_page_flags+0x4d/0x410
[  200.482061] Code: f3 ff 41 89 c0 48 b8 00 00 00 00 01 00 00 00 45 84 c0 =
0f 85 cd 02 00 00 48 8b 53 08 48 8b 2b 48f
[  200.483644] RSP: 0018:ffffb139401cbe60 EFLAGS: 00010202
[  200.484091] RAX: fffffffffffffffe RBX: fffffbeec5100040 RCX: 00000000000=
00000
[  200.484697] RDX: 0000000000000001 RSI: ffffffff9535c7cd RDI: 00000000000=
00246
[  200.485313] RBP: ffffffffffffffff R08: 0000000000000000 R09: 00000000000=
00000
[  200.485917] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000001=
44001
[  200.486523] R13: 00007ffd6ba55f48 R14: 00007ffd6ba55f40 R15: ffffb139401=
cbf08
[  200.487130] FS:  00007f68df717580(0000) GS:ffff9ec77fa00000(0000) knlGS:=
0000000000000000
[  200.487804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  200.488295] CR2: fffffffffffffffe CR3: 0000000135d48000 CR4: 00000000000=
006f0
[  200.488897] Call Trace:
[  200.489115]  kpageflags_read+0xe9/0x140
[  200.489447]  proc_reg_read+0x3c/0x60
[  200.489755]  vfs_read+0xc2/0x170
[  200.490037]  ksys_pread64+0x65/0xa0
[  200.490352]  do_syscall_64+0x5c/0xa0
[  200.490665]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

(tool located in tools/vm/page-types.c, see also patch #2)


To reproduce via "cat /proc/kpageflags > /dev/null", you have to
hot/coldplug one DIMM, to move max_pfn beyond the garbage memmap
(see also patch #2). My QEMU cmdline with Fedora 31:

qemu-system-x86_64 \
    --enable-kvm \
    -m 4160M,slots=3D4,maxmem=3D8G \
    -hda Fedora-Cloud-Base-31-1.9.x86_64.qcow2 \
    -machine pc \
    -nographic \
    -nodefaults \
    -chardev stdio,id=3Dserial,signal=3Doff \
    -device isa-serial,chardev=3Dserial \
    -object memory-backend-ram,id=3Dmem0,size=3D1024M \
    -device pc-dimm,id=3Ddimm0,memdev=3Dmem0

[root@localhost ~]# uname -a
Linux localhost 5.3.7-301.fc31.x86_64 #1 SMP Mon Oct 21 19:18:58 UTC 2019 x=
86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# cat /proc/kpageflags > /dev/null
[  111.517275] BUG: unable to handle page fault for address: ffffffffffffff=
fe
[  111.517907] #PF: supervisor read access in kernel mode
[  111.518333] #PF: error_code(0x0000) - not-present page
[  111.518771] PGD a240e067 P4D a240e067 PUD a2410067 PMD 0=20

>=20
> It may not have anything to do with the config, and I may be getting luck=
y with
> the garbage in my memory.
>=20

Some things that might be relevant from my config.

# CONFIG_PAGE_POISONING is not set
CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK_NODE_MAP=3Dy
CONFIG_MEMORY_HOTPLUG=3Dy
CONFIG_MEMORY_HOTPLUG_SPARSE=3Dy
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=3Dy

The F31 default config should make it trigger.


Will update this patch description - thanks!

...

--=20
Thanks,

David / dhildenb

