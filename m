Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74887118CA4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLJPg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:36:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727178AbfLJPg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575992215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=7dpW9d11847jfsxZ9sK7hOZD//f0JkCe9lLIXxJ4mr4=;
        b=b7Ik8P3fM607t+QV8Z/FKU1BfuoRAGbOk5bE5o58M8NyAQkG7/UNcWC8YW/RZHQa0CjGGA
        lDVUfHEX8yafNLFMtsvdi0euCMpaqr1IzqAgWVO68K2EW+MYgi7fo+oPWYBOfdw/oH68Z6
        WPCpvz8mL9YnW7w5pKIpTwnhkP6flhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-1Bzw8FUsPMeOSqpxVLGV6g-1; Tue, 10 Dec 2019 10:36:51 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C635801E77;
        Tue, 10 Dec 2019 15:36:50 +0000 (UTC)
Received: from [10.36.117.41] (ovpn-117-41.ams2.redhat.com [10.36.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9E575C1B0;
        Tue, 10 Dec 2019 15:36:45 +0000 (UTC)
Subject: Re: [PATCH v2] virtio-balloon: fix managed page counts when migrating
 pages between zones
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yumei Huang <yuhuang@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        Igor Mammedov <imammedo@redhat.com>
References: <20191205092420.6934-1-david@redhat.com>
 <13e33ff9-22f2-c02a-811e-2d087e42e1ce@redhat.com>
 <20191210102353-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <e4f2eef1-b75c-6c40-0dfd-44a076ada260@redhat.com>
Date:   Tue, 10 Dec 2019 16:36:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191210102353-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 1Bzw8FUsPMeOSqpxVLGV6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.12.19 16:24, Michael S. Tsirkin wrote:
> On Tue, Dec 10, 2019 at 02:44:38PM +0100, David Hildenbrand wrote:
>> On 05.12.19 10:24, David Hildenbrand wrote:
>>> In case we have to migrate a ballon page to a newpage of another zone, =
the
>>> managed page count of both zones is wrong. Paired with memory offlining
>>> (which will adjust the managed page count), we can trigger kernel crash=
es
>>> and all kinds of different symptoms.
>>>
>>> One way to reproduce:
>>> 1. Start a QEMU guest with 4GB, no NUMA
>>> 2. Hotplug a 1GB DIMM and only the memory to ZONE_NORMAL
>>
>> s/only/online/
>>
>> as requested by Igor.
>>
>>> 3. Inflate the balloon to 1GB
>>> 4. Unplug the DIMM (be quick, otherwise unmovable data ends up on it)
>>> 5. Observe /proc/zoneinfo
>>>   Node 0, zone   Normal
>>>     pages free     16810
>>>           min      24848885473806
>>>           low      18471592959183339
>>>           high     36918337032892872
>>>           spanned  262144
>>>           present  262144
>>>           managed  18446744073709533486
>>> 6. Do anything that requires some memory (e.g., inflate the balloon som=
e
>>> more). The OOM goes crazy and the system crashes
>>>   [  238.324946] Out of memory: Killed process 537 (login) total-vm:275=
84kB, anon-rss:860kB, file-rss:0kB, shmem-rss:00
>>>   [  238.338585] systemd invoked oom-killer: gfp_mask=3D0x100cca(GFP_HI=
GHUSER_MOVABLE), order=3D0, oom_score_adj=3D0
>>>   [  238.339420] CPU: 0 PID: 1 Comm: systemd Tainted: G      D W       =
  5.4.0-next-20191204+ #75
>>>   [  238.340139] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),=
 BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
>>>   [  238.341121] Call Trace:
>>>   [  238.341337]  dump_stack+0x8f/0xd0
>>>   [  238.341630]  dump_header+0x61/0x5ea
>>>   [  238.341942]  oom_kill_process.cold+0xb/0x10
>>>   [  238.342299]  out_of_memory+0x24d/0x5a0
>>>   [  238.342625]  __alloc_pages_slowpath+0xd12/0x1020
>>>   [  238.343024]  __alloc_pages_nodemask+0x391/0x410
>>>   [  238.343407]  pagecache_get_page+0xc3/0x3a0
>>>   [  238.343757]  filemap_fault+0x804/0xc30
>>>   [  238.344083]  ? ext4_filemap_fault+0x28/0x42
>>>   [  238.344444]  ext4_filemap_fault+0x30/0x42
>>>   [  238.344789]  __do_fault+0x37/0x1a0
>>>   [  238.345087]  __handle_mm_fault+0x104d/0x1ab0
>>>   [  238.345450]  handle_mm_fault+0x169/0x360
>>>   [  238.345790]  do_user_addr_fault+0x20d/0x490
>>>   [  238.346154]  do_page_fault+0x31/0x210
>>>   [  238.346468]  async_page_fault+0x43/0x50
>>>   [  238.346797] RIP: 0033:0x7f47eba4197e
>>>   [  238.347110] Code: Bad RIP value.
>>>   [  238.347387] RSP: 002b:00007ffd7c0c1890 EFLAGS: 00010293
>>>   [  238.347834] RAX: 0000000000000002 RBX: 000055d196a20a20 RCX: 00007=
f47eba4197e
>>>   [  238.348437] RDX: 0000000000000033 RSI: 00007ffd7c0c18c0 RDI: 00000=
00000000004
>>>   [  238.349047] RBP: 00007ffd7c0c1c20 R08: 0000000000000000 R09: 00000=
00000000033
>>>   [  238.349660] R10: 00000000ffffffff R11: 0000000000000293 R12: 00000=
00000000001
>>>   [  238.350261] R13: ffffffffffffffff R14: 0000000000000000 R15: 00007=
ffd7c0c18c0
>>>   [  238.350878] Mem-Info:
>>>   [  238.351085] active_anon:3121 inactive_anon:51 isolated_anon:0
>>>   [  238.351085]  active_file:12 inactive_file:7 isolated_file:0
>>>   [  238.351085]  unevictable:0 dirty:0 writeback:0 unstable:0
>>>   [  238.351085]  slab_reclaimable:5565 slab_unreclaimable:10170
>>>   [  238.351085]  mapped:3 shmem:111 pagetables:155 bounce:0
>>>   [  238.351085]  free:720717 free_pcp:2 free_cma:0
>>>   [  238.353757] Node 0 active_anon:12484kB inactive_anon:204kB active_=
file:48kB inactive_file:28kB unevictable:0kB iss
>>>   [  238.355979] Node 0 DMA free:11556kB min:36kB low:48kB high:60kB re=
served_highatomic:0KB active_anon:152kB inactivB
>>>   [  238.358345] lowmem_reserve[]: 0 2955 2884 2884 2884
>>>   [  238.358761] Node 0 DMA32 free:2677864kB min:7004kB low:10028kB hig=
h:13052kB reserved_highatomic:0KB active_anon:0B
>>>   [  238.361202] lowmem_reserve[]: 0 0 72057594037927865 72057594037927=
865 72057594037927865
>>>   [  238.361888] Node 0 Normal free:193448kB min:99395541895224kB low:7=
3886371836733356kB high:147673348131571488kB reB
>>>   [  238.364765] lowmem_reserve[]: 0 0 0 0 0
>>>   [  238.365101] Node 0 DMA: 7*4kB (U) 5*8kB (UE) 6*16kB (UME) 2*32kB (=
UM) 1*64kB (U) 2*128kB (UE) 3*256kB (UME) 2*512B
>>>   [  238.366379] Node 0 DMA32: 0*4kB 1*8kB (U) 2*16kB (UM) 2*32kB (UM) =
2*64kB (UM) 1*128kB (U) 1*256kB (U) 1*512kB (U)B
>>>   [  238.367654] Node 0 Normal: 1985*4kB (UME) 1321*8kB (UME) 844*16kB =
(UME) 524*32kB (UME) 300*64kB (UME) 138*128kB (B
>>>   [  238.369184] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepage=
s_surp=3D0 hugepages_size=3D2048kB
>>>   [  238.369915] 130 total pagecache pages
>>>   [  238.370241] 0 pages in swap cache
>>>   [  238.370533] Swap cache stats: add 0, delete 0, find 0/0
>>>   [  238.370981] Free swap  =3D 0kB
>>>   [  238.371239] Total swap =3D 0kB
>>>   [  238.371488] 1048445 pages RAM
>>>   [  238.371756] 0 pages HighMem/MovableOnly
>>>   [  238.372090] 306992 pages reserved
>>>   [  238.372376] 0 pages cma reserved
>>>   [  238.372661] 0 pages hwpoisoned
>>>
>>> In another instance (older kernel), I was able to observe this
>>> (negative page count :/):
>>>   [  180.896971] Offlined Pages 32768
>>>   [  182.667462] Offlined Pages 32768
>>>   [  184.408117] Offlined Pages 32768
>>>   [  186.026321] Offlined Pages 32768
>>>   [  187.684861] Offlined Pages 32768
>>>   [  189.227013] Offlined Pages 32768
>>>   [  190.830303] Offlined Pages 32768
>>>   [  190.833071] Built 1 zonelists, mobility grouping on.  Total pages:=
 -36920272750453009
>>>
>>> In another instance (older kernel), I was no longer able to start any
>>> process:
>>>   [root@vm ~]# [  214.348068] Offlined Pages 32768
>>>   [  215.973009] Offlined Pages 32768
>>>   cat /proc/meminfo
>>>   -bash: fork: Cannot allocate memory
>>>   [root@vm ~]# cat /proc/meminfo
>>>   -bash: fork: Cannot allocate memory
>>>
>>> Fix it by properly adjusting the managed page count when migrating if
>>> the zone changed. The managed page count of the zones now looks after
>>> unplug of the DIMM (and after deflating the balloon) just like before
>>> inflating the balloon (and plugging+onlining the DIMM).
>>>
>>> We'll temporarily modify the totalram page count. If this ever becomes =
a
>>> problem, we can fine tune by providing helpers that don't touch
>>> the totalram pages (e.g., adjust_zone_managed_page_count()).
>>>
>>> Reported-by: Yumei Huang <yuhuang@redhat.com>
>>> Fixes: 3dcc0571cd64 ("mm: correctly update zone->managed_pages")
>>> Cc: <stable@vger.kernel.org> # v3.11+
>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Cc: Jiang Liu <liuj97@gmail.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: virtualization@lists.linux-foundation.org
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>
>>> v1 -> v2:
>>> - Adjust count before enquing newpage (and it possibly gets free form t=
he
>>>   balloon)
>>> - Check if the zone changed
>>>
>>> ---
>>>  drivers/virtio/virtio_balloon.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ba=
lloon.c
>>> index 15b7f1d8c334..3078e1ac2a8f 100644
>>> --- a/drivers/virtio/virtio_balloon.c
>>> +++ b/drivers/virtio/virtio_balloon.c
>>> @@ -722,6 +722,13 @@ static int virtballoon_migratepage(struct balloon_=
dev_info *vb_dev_info,
>>> =20
>>>  =09get_page(newpage); /* balloon reference */
>>> =20
>>> +=09/* fixup the managed page count (esp. of the zone) */
>>
>> /*
>>  * When we migrate to a different zone, we have to adjust the managed
>>  * page count of both involved zones.
>>  */
>>
>> as requested by Michael.
>>
>>
>> @Michael, if there are no further comments, shall I resend?
>=20
> Also, what does it have to do with deflate on oom?
> Why is it true we don't need to do it then?

Let's have a look at the other users in this file:

t460s: ~/git/linux memory_holes $ git grep -C3 adjust_man drivers/virtio/vi=
rtio_balloon.c
drivers/virtio/virtio_balloon.c-                vb->num_pages +=3D VIRTIO_B=
ALLOON_PAGES_PER_PAGE;
drivers/virtio/virtio_balloon.c-                if (!virtio_has_feature(vb-=
>vdev,
drivers/virtio/virtio_balloon.c-                                        VIR=
TIO_BALLOON_F_DEFLATE_ON_OOM))
drivers/virtio/virtio_balloon.c:                        adjust_managed_page=
_count(page, -1);
drivers/virtio/virtio_balloon.c-                vb->num_pfns +=3D VIRTIO_BA=
LLOON_PAGES_PER_PAGE;
drivers/virtio/virtio_balloon.c-        }
drivers/virtio/virtio_balloon.c-
--
drivers/virtio/virtio_balloon.c-        list_for_each_entry_safe(page, next=
, pages, lru) {
drivers/virtio/virtio_balloon.c-                if (!virtio_has_feature(vb-=
>vdev,
drivers/virtio/virtio_balloon.c-                                        VIR=
TIO_BALLOON_F_DEFLATE_ON_OOM))
drivers/virtio/virtio_balloon.c:                        adjust_managed_page=
_count(page, 1);
drivers/virtio/virtio_balloon.c-                list_del(&page->lru);
drivers/virtio/virtio_balloon.c-                put_page(page); /* balloon =
reference */
drivers/virtio/virtio_balloon.c-        }

In case we don't have VIRTIO_BALLOON_F_DEFLATE_ON_OOM, we don't touch the m=
anaged
page count when inflating/deflating, therefore, there is nothing to do when=
 migrating
a page between zones.

Why? Because the designers of VIRTIO_BALLOON_F_DEFLATE_ON_OOM decided to ma=
ke
it look like the VM has all RAM available (and make it look like it's only
allocated, not "unplugged"). With VIRTIO_BALLOON_F_DEFLATE_ON_OOM, the syst=
em
will reclaim memory from the balloon when OOM and, therefore, "shrink" the
balloon automatically.

E.g., with VIRTIO_BALLOON_F_DEFLATE_ON_OOM neither "MemToal" under
/proc/meminfo, nor the managed page count under /proc/zoneinfo will change.
Without VIRTIO_BALLOON_F_DEFLATE_ON_OOM, it will, therefore we have to fixu=
p
only without VIRTIO_BALLOON_F_DEFLATE_ON_OOM.


--=20
Thanks,

David / dhildenb

