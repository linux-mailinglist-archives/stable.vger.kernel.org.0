Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862F6219B67
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGIIsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 04:48:19 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:16914
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgGIIsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 04:48:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h26acwBc+wdMsJ24ycB1t+di18uEFxDpR2XeKHw10mTLqSvg4wxYF8et+vBwiXeAQ9eIJO+D7QzpPy5o3pGoLTQcwUFJgiNRK1x+lH/t9AeCozyqMqCqR1M62ngmeAe5h6ha2P4HVvGWO8DkDp6Hrsy/vm1vl2vC8RbfpBVG4EFXl2/dOZqXJr5LWUvGvjynL57Rw7N6/VUeFlGnFD4uC0XNEm3LiUoAI9LCpWAql67uR8yvVDTIWNkMkFFOsiYalt1k8+iiUhmuMa+pT0FaN8CFJvibkFhuLweN97qvpneFjoB0dbeGqOwa/BzojxGvea4WYVYLcW8c4ouolzohZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaQnotDrWNiXOg52ORebYn9NwfPraEStlK62ZKOR3n0=;
 b=fojjHKBhQl2SoVdM7a06w2nVxgvYp9pb+a5UmTp3eCvAL8AwtOfmP4yuR3iBVuhLOrdGqXjW+EGXq+yXlxy/8MbsLtvzKsrHA6U7V1prmHguEBHrUEfOsVioWfnKXZ19LVD9QG6O+sGKpp6owEz8mLzshkscFFpAaP1HJeqAtZRahUVdfzHqa65y9/TIU+MDi6dxmbVU2Krj2BymMgU7c3D5s4DB9OmgYHNJ6cM9t7uG6+cid9sp2gfx+iraFjyE1BxrSllm4HsQQgVLS1DqjkeB9ZZwUtr179+EO2R96uLCBnytfsJARYRgkdsL18kE+GuJgXos3fKDJbUzs/6zvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaQnotDrWNiXOg52ORebYn9NwfPraEStlK62ZKOR3n0=;
 b=lGiStPcC953kVCwKng54/GL64yk7bxMYa+Tnjs4DikVn1KjIjxAS/EAVc5lACkspD3QVUyJxExgQ3th9EjzoQX0uZb+w4KL8TwmgDJhKMxfdV+ByeSX+7+xIzSN+BDbM9r9qlrE1wL0LAcRsput/4b0/c3psleZeCieyi3wjwq8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4549.namprd12.prod.outlook.com (2603:10b6:208:268::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 9 Jul
 2020 08:48:13 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 08:48:13 +0000
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Steven Price <Steven.Price@arm.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        lepton <ytht.net@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com>
 <20200708095405.GJ3278063@phenom.ffwll.local>
 <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com>
 <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
 <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com>
 <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
 <CAKMK7uHe_dZvdfEx7Sd73QRNFPpDoTGVo-=BcU8cRwFhUVRtHA@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <bdf4b521-eb21-3381-ee06-98eb3b1cbbc6@amd.com>
Date:   Thu, 9 Jul 2020 10:48:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAKMK7uHe_dZvdfEx7Sd73QRNFPpDoTGVo-=BcU8cRwFhUVRtHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::49) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 08:48:11 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7397f864-4167-428d-c3d9-08d823e4d0a8
X-MS-TrafficTypeDiagnostic: MN2PR12MB4549:
X-Microsoft-Antispam-PRVS: <MN2PR12MB45492899D775EF9F7384133A83640@MN2PR12MB4549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTgJRm2WFxjTrvlchTB4J9bos7+rwHbbS4YeJyCKlNmjOVX2xFOV4n37t/dEVlc670u8A1z8LpNK8iNRGlckBeGy11V6JXsXpatWiRTDqhiZkZ0Ihl6CqDanASd5OxMGAyVbHBeUPdRGVn0LxenLzSYn1KCla+z/ATMwKzZroTUpImPSnobMCyPWhxc1rnGV3/2SZju5iY3JY5W/I9Qik7otWlWVVJgkJ5GCbg97yeMIeOz928og9miX847jfyAu1fxpHdLVsJUnzX6X27NKOf8U4TxG7slI00gXAYEft9P7XkrZKEtk+lClvfywiBvVQ9+Uj0sqdH/STEGwV9reodcsi2MSv9uMP2+AgRYcrptHqfGC+F3Xw3lsRIGhFOHOu1pObzvRPXaKrUalCq17cf4fuqHQXNS4dqRC4jEQBYGEtoCbwpbRgmLeybrFPkGdNgFOLklmARJKzaIkb5PPjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(7416002)(4326008)(8676002)(66574015)(52116002)(31686004)(6486002)(83080400001)(31696002)(86362001)(186003)(2616005)(966005)(83380400001)(8936002)(53546011)(16526019)(2906002)(6666004)(5660300002)(54906003)(66476007)(66556008)(110136005)(316002)(478600001)(66946007)(36756003)(45080400002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PsQpGgAzS0XMji203unhTB8Yi5LWOClkQNrE4VzFaGjpxW3SJW5mvc8xcIdag0gLN6v7daq7VW0nHFyYpF3Vwm0NJLFeRvXvyRhnbnD70TFakW6FmoTbSSKEYC8SYOLGUW6BgOxcuA9XRa+hU3llXx+6OvchcljtppmaKqYdNwleOabSlo3ZGFnB9lVcH88Ibyy8T96+l19hFYPnKS/K1wvckmIDIQ2PoBctvbA8JYMWqBYzadFS33I63w17Hn8lttEj41SPfQmG49UdmCCN3i+EF4grOy3oJQh4xAdRecTy5d03BKqtSJo9eEOOZFX1tALIKW/8WsZsEoPzCUdnRm0/vks8J/xwtBPCsenlWGzEYhtfJBGGEJ/6NmZlIwzItdtl5bPQPqvGN/ZO90Q7SQDpfm0qv9S/nQr7VUVh5hkNi0TwXIx28Tp30s6lYjjQtTkoCEVBk6smcgTAB/6yu8DmzV31BSGDwjZ8NbIGOYs+7UJn9TI/optdI6kv4rOkUUDx9qRDN37RgPh9cDoK0neZGOBSpe2CzPY6Jwpp/GKk5v1bSu8RmAoiP+Ky0L2M
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7397f864-4167-428d-c3d9-08d823e4d0a8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 08:48:13.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlNsGmttP0BNTOxz7OHVR2NM9306mrSlh5qkNB45gBof0YiuQSjLDygIqCxe1uh5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4549
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 08.07.20 um 18:19 schrieb Daniel Vetter:
> On Wed, Jul 8, 2020 at 6:11 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Wed, Jul 8, 2020 at 5:05 PM Christian König <christian.koenig@amd.com> wrote:
>>> Am 08.07.20 um 17:01 schrieb Daniel Vetter:
>>>> On Wed, Jul 8, 2020 at 4:37 PM Christian König <christian.koenig@amd.com> wrote:
>>>>> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
>>>>>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>>>>>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>>>>>>> Quoting lepton (2020-07-07 19:17:51)
>>>>>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>>> If we assign obj->filp, we believe that the create vgem bo is native and
>>>>>>>>>>>> allow direct operations like mmap() assuming it behaves as backed by a
>>>>>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>>>>>>>>> not always meaningful and the shmemfs backing store misleading.
>>>>>>>>>>>>
>>>>>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
>>>>>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>>>>>>> What do you mean by "regular mmap access" here?  It looks like vgem is
>>>>>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
>>>>>>>>>>> drm_gem_dumb_map_offset
>>>>>>>>>> As I too found out, and so had to correct my story telling.
>>>>>>>>>>
>>>>>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
>>>>>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
>>>>>>>>>> igt to see how it was being used.
>>>>>>>>> Now it seems your fix is to disable "regular mmap" on imported dma buf
>>>>>>>>> for vgem. I am not really a graphic guy, but then the api looks like:
>>>>>>>>> for a gem handle, user space has to guess to find out the way to mmap
>>>>>>>>> it. If user space guess wrong, then it will fail to mmap. Is this the
>>>>>>>>> expected way
>>>>>>>>> for people to handle gpu buffer?
>>>>>>>> You either have a dumb buffer handle, or a dma-buf fd. If you have the
>>>>>>>> handle, you have to use the dumb buffer API, there's no other way to
>>>>>>>> mmap it. If you have the dma-buf fd, you should mmap it directly. Those
>>>>>>>> two are clear.
>>>>>>>>
>>>>>>>> It's when you import the dma-buf into vgem and create a handle out of
>>>>>>>> it, that's when the handle is no longer first class and certain uAPI
>>>>>>>> [the dumb buffer API in particular] fail.
>>>>>>>>
>>>>>>>> It's not brilliant, as you say, it requires the user to remember the
>>>>>>>> difference between the handles, but at the same time it does prevent
>>>>>>>> them falling into coherency traps by forcing them to use the right
>>>>>>>> driver to handle the object, and have to consider the additional ioctls
>>>>>>>> that go along with that access.
>>>>>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an importer
>>>>>>> is illegal.
>>>>>>>
>>>>>>> What we could maybe try to do is to redirect this mmap() API call on the
>>>>>>> importer to the exporter, but I'm pretty sure that the fs layer wouldn't
>>>>>>> like that without changes.
>>>>>> We already do that, there's a full helper-ified path from I think shmem
>>>>>> helpers through prime helpers to forward this all. Including handling
>>>>>> buffer offsets and all the other lolz back&forth.
>>>>> Oh, that most likely won't work correctly with unpinned DMA-bufs and
>>>>> needs to be avoided.
>>>>>
>>>>> Each file descriptor is associated with an struct address_space. And
>>>>> when you mmap() through the importer by redirecting the system call to
>>>>> the exporter you end up with the wrong struct address_space in your VMA.
>>>>>
>>>>> That in turn can go up easily in flames when the exporter tries to
>>>>> invalidate the CPU mappings for its DMA-buf while moving it.
>>>>>
>>>>> Where are we doing this? My last status was that this is forbidden.
>>>> Hm I thought we're doing all that already, but looking at the code
>>>> again we're only doing this when opening a new drm fd or dma-buf fd.
>>>> So the right file->f_mapping is always set at file creation time.
>>>>
>>>> And we indeed don't frob this more when going another indirection ...
>>>> Maybe we screwed up something somewhere :-/
>>>>
>>>> Also I thought the mapping is only taken after the vma is instatiated,
>>>> otherwise the tricks we're playing with dma-buf already wouldn't work:
>>>> dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
>>>> it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
>>>> whether we could adjust vm_file too. Or is that the thing that's
>>>> forbidden?
>>> Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
>>>
>>> But changing vma->vm_file, that's something I haven't seen before and
>>> most likely could blow up badly.
>> Ok, I read the shmem helpers again, I think those are the only ones
>> which do the importer mmap -> dma_buf_mmap() forwarding, and hence
>> break stuff all around here.
>>
>> They also remove the vma->vm_pgoff offset, which means
>> unmap_mapping_range wont work anyway. I guess for drivers which use
>> shmem helpers the hard assumption is that a) can't use p2p dma and b)
>> pin everything into system memory.
>>
>> So not a problem. But something to keep in mind. I'll try to do a
>> kerneldoc patch to note this somewhere. btw on that, did the
>> timeline/syncobj documentation patch land by now? Just trying to make
>> sure that doesn't get lost for another few months or so :-/
> Ok, so maybe it is a problem. Because there is a drm_gem_shmem_purge()
> which uses unmap_mapping_range underneath, and that's used by
> panfrost. And panfrost also uses the mmap helper. Kinda wondering
> whether we broke some stuff here, or whether the reverse map is
> installed before we touch vma->vm_pgoff.

I think the key problem here is that unmap_mapping_range() doesn't blow 
up immediately when this is wrong.

E.g. we just have a stale CPU page table entry which allows userspace to 
write to freed up memory, but we don't really notice that immediately....

Maybe we should stop allowing to mmap() DMA-buf through the importer 
file descriptor altogether and only allow mapping it through its own fd 
or the exporter.

Christian.

> panfrost folks, does panfrost purged buffer handling of mmap still
> work correctly? Do you have some kind of igt or similar for this?
>
> Cheers, Daniel
>
>> Cheers, Daniel
>>
>>> Christian.
>>>
>>>> -Daniel
>>>>
>>>>> Christian.
>>>>>
>>>>>> Of course there's still the problem that many drivers don't forward the
>>>>>> cache coherency calls for begin/end cpu access, so in a bunch of cases
>>>>>> you'll cache cacheline dirt soup. But that's kinda standard procedure for
>>>>>> dma-buf :-P
>>>>>>
>>>>>> But yeah trying to handle the mmap as an importer, bypassing the export:
>>>>>> nope. The one exception is if you have some kind of fancy gart with
>>>>>> cpu-visible pci bar (like at least integrated intel gpus have). But in
>>>>>> that case the mmap very much looks&acts like device access in every way.
>>>>>>
>>>>>> Cheers, Daniel
>>>>>>
>>>>>>> Regards,
>>>>>>> Christian.
>>>>>>>
>>>>>>>
>>>>>>>> -Chris
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fblog.ffwll.ch%2F&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7Ca4429cf3610248b1122f08d8235ac32a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637298220041879219&amp;sdata=DoNpTWtuKAfiwqUdYw7INhajhH1rvzSncDivXWkv%2FDI%3D&amp;reserved=0
>
>

