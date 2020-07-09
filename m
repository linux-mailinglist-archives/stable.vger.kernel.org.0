Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC635219B6C
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 10:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgGIItr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 04:49:47 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:27968
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgGIItr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 04:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT/d/Qu6Oimvj6nBDoAg003XqlIt9nYTqgH5/BVuFtcsvteJNRRbKUsiklgna33Nv2qxuk9I7yzkKvJXocZx7T1JIy0ZbJ0vJDfXtx+yQT1vJ5tb1+NByVHTOaro/4DoxpdHZ9DTA2vSYRs8Pl5+aOZ6EfMhPKzZw2hv3J67+0MNzSbHZxt1ZLv5vIw/uFnioRlVW5S69KI+EcdxqfUA+h2cLG6j8yqVsgHaN+hGGBYmn6FqWIGZ/e6X7I1jpHE6Gyexyy0eYTyNFzBBZSkkk9rrfvCjR3DNzqBGCIhZJ2V9VRiZugPzYAmamljm501LE5gDvRvNQQb9pgpXlw0QiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvmaBjgsMConbnWnb+VzL1Vnx3CJ4BQwN7WVgaY/JY8=;
 b=oGUmUjNObfC2r5jrwsAX+pEMyckCgXLe87rJN3oqzsnOELPO4a+Yb7Hh51cv0AVeAPz8ZkNV/Wb6tVoV+0ujg0k/x6War6Ul+6r+9OjloNGFI4ppB3TXkZIXGwy6kEIlMLRKSXgEG/6CXH0oKAhilzyKEf+SrNaGa57529q/H8odIF7F6OCUr1pH7LRt1J4xFeesBf3+YLIQNXmn0za7/JJFiA3SnP9q5OfFb9o8weCfPUDQBoKgvXvYu2nwhk9OlmC9L0qhk7cqps/kZeXG/ePOstLy6+Bd3NSembu7FKGAMiFgPlTAYQ+SAF8rGpxowmt/gdRZNEaFSZ6OdMmeIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvmaBjgsMConbnWnb+VzL1Vnx3CJ4BQwN7WVgaY/JY8=;
 b=lF+KLmt2aK4bhTQNhTfj370hMTFVNUO6nRU0aZa2Uf40GjGxfa6r/hqU5CQ1jHZqmxO1GIB6ZtaQxx0k6meg23yFRj2vpv+7s66bxWG86VMOW8EHk6ZS3p5aRhNITMtmAsrCqNZwx5TKiXV5NyVBAHorosoDAMGi91/yDRzJYfA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4549.namprd12.prod.outlook.com (2603:10b6:208:268::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 9 Jul
 2020 08:49:43 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 08:49:43 +0000
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Daniel Vetter <daniel@ffwll.ch>
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <e4d7e26c-4ac5-8ada-dc75-ae02654112b4@amd.com>
Date:   Thu, 9 Jul 2020 10:49:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAKMK7uEA65DT=7Qxku5Mvdcm6ii9qnyeR03Es+E-oCsxXkJBmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0067.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::20) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR10CA0067.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 08:49:41 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9cfc121f-d33d-44ea-86ca-08d823e5061b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4549:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4549370CD545DAD1ABABE2A183640@MN2PR12MB4549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIx/V798bBfE500Vff9PjF+lIJNFe18SLr1IaHchl9D2yeLy/Q76EQXxgsfCqM/Kgk/sI56QVBipFh0LUCeADMu0W4F4uvAbOBusfEgs3W7f1jpNeN8NmmHxkLSpAZaPeKtbeOFBtV1/6t6m5E9yY8QkwEDfZULU3R5M8dGvRhVZIDwh2YNvr7XwsTWB6ezp5pi9NtkAriaKrC4EyrH6fnE1tcWIzX62EO2pF/P8Zp8Zl2LWjAnDUk5TkLbe/mU0MDGi3/IWbQFw1y0zWE9tvneTETbrw0lqehMRGCP9BfCFYo6X0S05GhE25y9ZOenn8I6tX7U/hE+TyqGpbn2QRWzD9wfEmh56cpFe/5F4oNX0dbX4dysRi/FBGJ5SU+pB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(4326008)(8676002)(66574015)(52116002)(31686004)(6486002)(31696002)(86362001)(186003)(2616005)(83380400001)(8936002)(6916009)(53546011)(16526019)(2906002)(6666004)(5660300002)(54906003)(66476007)(66556008)(316002)(478600001)(66946007)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wacRURPunEiT6J4NJL1/8Qx61VPDYLi3hj0BioH21l7pbnYgkdMpVNcKbUe16gfZy9X8sXalXM7cgshG3cZ+iC1tp/6j3Ryxv6c4BCinhEd9rXgga3/9aObjzoH13zT2gFlMuKftQFOoQakqMjjKmnb3xqyCXxYlftjFhaDTkov4G3Vrymu8mEdAhu2/SLOil+nFGwdBEKpP5tLOq49h8zh3VgSx1sAh1VYs/4KBVRByjYUmSjDlRB8WBt7Nla28kQDUhiM6iDPg1OJ4NTyuGKY0bz/e/cVQwSyDlg50AuFEf/cLa71BOqwKHq+n0/80sWYt/58W2pASXKPVa5pavI/Hd2+Ho6NuvnNkxZQAH6FGYKFdcgapaS8aD2UyEl/BLO71JFKxGzpzmXiVb7dJ8BvjIEaUxImMR82IgHqvTNQOqH9V+QdfmZAwOp2oQfg9Fs6czcHTZdgEdJ01W8rmdFIXPSufOWboU4N+TsBmej4w9SZICPQLPXGMV1sZ5SudrhU8X7XJjMoYa1rqx2asMVa/HGrrVscofXJnsG5111iome58QZ4PgmQ45NedYWYK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cfc121f-d33d-44ea-86ca-08d823e5061b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 08:49:43.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyNBjYhF55mt0t231AwPDcYK6JrhDTT7Vn1FJ16XiOpgmDkxftCe/MrvFkDKIT1C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4549
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 08.07.20 um 18:11 schrieb Daniel Vetter:
> On Wed, Jul 8, 2020 at 5:05 PM Christian König <christian.koenig@amd.com> wrote:
>> Am 08.07.20 um 17:01 schrieb Daniel Vetter:
>>> On Wed, Jul 8, 2020 at 4:37 PM Christian König <christian.koenig@amd.com> wrote:
>>>> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
>>>>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>>>>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>>>>>> Quoting lepton (2020-07-07 19:17:51)
>>>>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>> If we assign obj->filp, we believe that the create vgem bo is native and
>>>>>>>>>>> allow direct operations like mmap() assuming it behaves as backed by a
>>>>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>>>>>>>> not always meaningful and the shmemfs backing store misleading.
>>>>>>>>>>>
>>>>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
>>>>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>>>>>> What do you mean by "regular mmap access" here?  It looks like vgem is
>>>>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
>>>>>>>>>> drm_gem_dumb_map_offset
>>>>>>>>> As I too found out, and so had to correct my story telling.
>>>>>>>>>
>>>>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
>>>>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
>>>>>>>>> igt to see how it was being used.
>>>>>>>> Now it seems your fix is to disable "regular mmap" on imported dma buf
>>>>>>>> for vgem. I am not really a graphic guy, but then the api looks like:
>>>>>>>> for a gem handle, user space has to guess to find out the way to mmap
>>>>>>>> it. If user space guess wrong, then it will fail to mmap. Is this the
>>>>>>>> expected way
>>>>>>>> for people to handle gpu buffer?
>>>>>>> You either have a dumb buffer handle, or a dma-buf fd. If you have the
>>>>>>> handle, you have to use the dumb buffer API, there's no other way to
>>>>>>> mmap it. If you have the dma-buf fd, you should mmap it directly. Those
>>>>>>> two are clear.
>>>>>>>
>>>>>>> It's when you import the dma-buf into vgem and create a handle out of
>>>>>>> it, that's when the handle is no longer first class and certain uAPI
>>>>>>> [the dumb buffer API in particular] fail.
>>>>>>>
>>>>>>> It's not brilliant, as you say, it requires the user to remember the
>>>>>>> difference between the handles, but at the same time it does prevent
>>>>>>> them falling into coherency traps by forcing them to use the right
>>>>>>> driver to handle the object, and have to consider the additional ioctls
>>>>>>> that go along with that access.
>>>>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an importer
>>>>>> is illegal.
>>>>>>
>>>>>> What we could maybe try to do is to redirect this mmap() API call on the
>>>>>> importer to the exporter, but I'm pretty sure that the fs layer wouldn't
>>>>>> like that without changes.
>>>>> We already do that, there's a full helper-ified path from I think shmem
>>>>> helpers through prime helpers to forward this all. Including handling
>>>>> buffer offsets and all the other lolz back&forth.
>>>> Oh, that most likely won't work correctly with unpinned DMA-bufs and
>>>> needs to be avoided.
>>>>
>>>> Each file descriptor is associated with an struct address_space. And
>>>> when you mmap() through the importer by redirecting the system call to
>>>> the exporter you end up with the wrong struct address_space in your VMA.
>>>>
>>>> That in turn can go up easily in flames when the exporter tries to
>>>> invalidate the CPU mappings for its DMA-buf while moving it.
>>>>
>>>> Where are we doing this? My last status was that this is forbidden.
>>> Hm I thought we're doing all that already, but looking at the code
>>> again we're only doing this when opening a new drm fd or dma-buf fd.
>>> So the right file->f_mapping is always set at file creation time.
>>>
>>> And we indeed don't frob this more when going another indirection ...
>>> Maybe we screwed up something somewhere :-/
>>>
>>> Also I thought the mapping is only taken after the vma is instatiated,
>>> otherwise the tricks we're playing with dma-buf already wouldn't work:
>>> dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
>>> it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
>>> whether we could adjust vm_file too. Or is that the thing that's
>>> forbidden?
>> Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
>>
>> But changing vma->vm_file, that's something I haven't seen before and
>> most likely could blow up badly.
> Ok, I read the shmem helpers again, I think those are the only ones
> which do the importer mmap -> dma_buf_mmap() forwarding, and hence
> break stuff all around here.
>
> They also remove the vma->vm_pgoff offset, which means
> unmap_mapping_range wont work anyway. I guess for drivers which use
> shmem helpers the hard assumption is that a) can't use p2p dma and b)
> pin everything into system memory.
>
> So not a problem. But something to keep in mind. I'll try to do a
> kerneldoc patch to note this somewhere. btw on that, did the
> timeline/syncobj documentation patch land by now? Just trying to make
> sure that doesn't get lost for another few months or so :-/

I still haven't found time to double check the documentation and most 
likely won't in quite a while.

Sorry for that, but yeah you know :)

Christian.

>
> Cheers, Daniel
>
>> Christian.
>>
>>> -Daniel
>>>
>>>> Christian.
>>>>
>>>>> Of course there's still the problem that many drivers don't forward the
>>>>> cache coherency calls for begin/end cpu access, so in a bunch of cases
>>>>> you'll cache cacheline dirt soup. But that's kinda standard procedure for
>>>>> dma-buf :-P
>>>>>
>>>>> But yeah trying to handle the mmap as an importer, bypassing the export:
>>>>> nope. The one exception is if you have some kind of fancy gart with
>>>>> cpu-visible pci bar (like at least integrated intel gpus have). But in
>>>>> that case the mmap very much looks&acts like device access in every way.
>>>>>
>>>>> Cheers, Daniel
>>>>>
>>>>>> Regards,
>>>>>> Christian.
>>>>>>
>>>>>>
>>>>>>> -Chris
>

