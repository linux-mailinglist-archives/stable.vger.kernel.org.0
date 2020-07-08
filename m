Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8704D218AB9
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgGHPFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:05:23 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:17347
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729868AbgGHPFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:05:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAUoiyor0hOEXq7cD+K6ygkWB+vLvE+Etg8jBb80uqefXWQPmrWIOdmPowu0sJKPI6ZHU+cvk1EITziYL7zfoaRhxMA0MVcoIPjRIEudJMnbiKY/H7RSX/0P94EXUhhT1Q2vYaMINGwmGlnkyLTLXRjuEKQWfIDgbDAfDtHU6e+6NIlaVu8mxRWCITZ76XP4KeCAxgPqyKUFlnjLtu4IQJsoC4k+uqXCJQyycLPEAgSAz+zg05UU8rfjje24tzGi5ZAHCYJvpJQ9H5xPe91pVViqofxbA/3c5XiJYKmRy+cCkAURD4zzhN22mLad8bYL6Yi29FEFOAZsiNXuPzeBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PMK5douIACopavoIw/0X4e4IeXI5MdVYI2RZ4aIY2U=;
 b=gHVuV4hxbdH7b7AGbK6Yh3qCl0Uro+RcZpSfAcrh4CbMq18HwW5jy0hGYnEUkiKwlLkfb2w2WMR3wlWSMBNDigXG6A1JibMyePVbRy8vqgmcQyLvwy2J/B7x4vQcJwFy+5wJHuCnYzIm1R5TpQeXnCTLUqzRi5d1gVx+16jlmgB6ZdgRS6apkgcNYtOYSuC+7Q0xil6+gZ4AkpWFh0pICTR/4F/ouCOIV4v/OIv7yYFIimELgH4pskUGuBc/pDA88iQ6J0DbMtTo4R0kJ7ZMuYskgM1/S1p+pKoyTp+K5VFnb6AP0i1/vac46mFS1VKCqe/YOXt4TrM/wxn2U4QiKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PMK5douIACopavoIw/0X4e4IeXI5MdVYI2RZ4aIY2U=;
 b=NERyydbknGnD3gIC/E7ZL/I4LuZzRaKZfXntddyhR3CNToZmwfRQOqOcS1q/McGyG78PWfnZaJPpTxDZzphy3AUlqy/N3r8bjPuV82HbSKSqTfthx6tIBVRsJ3fEJhkT2IRKkCJL9ozNuvz1M5RryX4qnnwWZnTm1Em8OaHwEwU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3725.namprd12.prod.outlook.com (2603:10b6:208:162::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Wed, 8 Jul
 2020 15:05:19 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 15:05:19 +0000
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <ea2ba563-11ba-efc3-44db-ae83920225d6@amd.com>
Date:   Wed, 8 Jul 2020 17:05:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR07CA0018.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::31) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR07CA0018.eurprd07.prod.outlook.com (2603:10a6:208:ac::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Wed, 8 Jul 2020 15:05:18 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcdc3f09-573e-4929-a063-08d823505433
X-MS-TrafficTypeDiagnostic: MN2PR12MB3725:
X-Microsoft-Antispam-PRVS: <MN2PR12MB372592B5886E31E7DF12614583670@MN2PR12MB3725.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dHtbYDJCpVs+Kw8QkMAiPi+sj5IPV1x9kfiX3urI2UGC3bbHdCVBX/0B5EW3DSxGpJjtStMhrdlNbwqV3pyB+iQPD2VnzsFDNeGOKxUyXmM3Vd2BBZLUVssk97eHhzb2udoCEkvFQiu6Owh8QsR2I0UM4RI05a7OBedpUuE2kbEsGXCxJaduYO7gP3mUGcegh6A3MdA6Gs/P8VOPxB+6I2pDf1iovNFSSy3LA2KpsgOK6U/3Z3ZxOI/kalV0Ttp1AN9micQKeYuX49ZuKIFFYUly68nL9EiWttGYTVdsUS6EQv7YZagZMoa0ltiqZQTZBkQv86TQP+qf7Cvmsja39r3/zYBLIbAMownukmJCHWtsUNyIFAhNShRmtXOzn5Eq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(396003)(39850400004)(136003)(66476007)(66556008)(66946007)(86362001)(31696002)(52116002)(6916009)(54906003)(478600001)(4326008)(316002)(6666004)(2616005)(53546011)(16526019)(36756003)(186003)(2906002)(31686004)(6486002)(5660300002)(83380400001)(8676002)(8936002)(66574015)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pZeVNLmIUNOih2pAk6Cc/Nvc+HFYQBj9exckc2BFPeI5adnJKUeVuU8gEzGQXOueT7S75KBN+SU1jaFtwKHkXlX2oQKwyYzoopI3ZtT9Rt1WMXU1NpKZ4CHuSnlVIcFesEYJWDmTBnUwMdT7H/zWAGNChIRCwnH2G/KZO43fIlOngMHYBmxhaO1a9HyOl1u5Q5zlo21qX4FB4kH8GQegrTsqE3TnljRiTmI1AhVH7PgknuGYPgR7wEo6sxJSm9LUKpo0n8IFGA4OgR0VGc6AfkEZ6IlLJJwAu13x6joPlsxmmy16ZTeBO3IDBXiLTrWKVgHtmlh7te8YncXoawetoXtMv2rq9cWM2ofCdeQeeAS87FrSqTCLWMp6vfyaVBLVJJS1zmLsSt1vm0oj24c3suzLrvNklD3jI8Au4m5rbkZW6kK+Fpzj/+oRlzyUs0n9eGhYry2ftJnMRkzd0ooEhvIaItWxFAmRt1hFl5Rvx+zoPciMiICyUhdqNUsBjpZh3VcxJBp3RvCMQsnEfA7NYxRwwOIKJLjwoC1iQ6/xa0pK8/gidYRZwgIB5u/EGxRf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdc3f09-573e-4929-a063-08d823505433
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:05:19.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q456GVvVwk4bHoj13hNs3S7mssgFj+cSU1obwXeLxkaaHmlhY/C8LLj0xaIef2pm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3725
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 08.07.20 um 17:01 schrieb Daniel Vetter:
> On Wed, Jul 8, 2020 at 4:37 PM Christian König <christian.koenig@amd.com> wrote:
>> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
>>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>>>> Quoting lepton (2020-07-07 19:17:51)
>>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>>>>>>>> If we assign obj->filp, we believe that the create vgem bo is native and
>>>>>>>>> allow direct operations like mmap() assuming it behaves as backed by a
>>>>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
>>>>>>>>> not always meaningful and the shmemfs backing store misleading.
>>>>>>>>>
>>>>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
>>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>>>> What do you mean by "regular mmap access" here?  It looks like vgem is
>>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
>>>>>>>> drm_gem_dumb_map_offset
>>>>>>> As I too found out, and so had to correct my story telling.
>>>>>>>
>>>>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
>>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
>>>>>>> igt to see how it was being used.
>>>>>> Now it seems your fix is to disable "regular mmap" on imported dma buf
>>>>>> for vgem. I am not really a graphic guy, but then the api looks like:
>>>>>> for a gem handle, user space has to guess to find out the way to mmap
>>>>>> it. If user space guess wrong, then it will fail to mmap. Is this the
>>>>>> expected way
>>>>>> for people to handle gpu buffer?
>>>>> You either have a dumb buffer handle, or a dma-buf fd. If you have the
>>>>> handle, you have to use the dumb buffer API, there's no other way to
>>>>> mmap it. If you have the dma-buf fd, you should mmap it directly. Those
>>>>> two are clear.
>>>>>
>>>>> It's when you import the dma-buf into vgem and create a handle out of
>>>>> it, that's when the handle is no longer first class and certain uAPI
>>>>> [the dumb buffer API in particular] fail.
>>>>>
>>>>> It's not brilliant, as you say, it requires the user to remember the
>>>>> difference between the handles, but at the same time it does prevent
>>>>> them falling into coherency traps by forcing them to use the right
>>>>> driver to handle the object, and have to consider the additional ioctls
>>>>> that go along with that access.
>>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an importer
>>>> is illegal.
>>>>
>>>> What we could maybe try to do is to redirect this mmap() API call on the
>>>> importer to the exporter, but I'm pretty sure that the fs layer wouldn't
>>>> like that without changes.
>>> We already do that, there's a full helper-ified path from I think shmem
>>> helpers through prime helpers to forward this all. Including handling
>>> buffer offsets and all the other lolz back&forth.
>> Oh, that most likely won't work correctly with unpinned DMA-bufs and
>> needs to be avoided.
>>
>> Each file descriptor is associated with an struct address_space. And
>> when you mmap() through the importer by redirecting the system call to
>> the exporter you end up with the wrong struct address_space in your VMA.
>>
>> That in turn can go up easily in flames when the exporter tries to
>> invalidate the CPU mappings for its DMA-buf while moving it.
>>
>> Where are we doing this? My last status was that this is forbidden.
> Hm I thought we're doing all that already, but looking at the code
> again we're only doing this when opening a new drm fd or dma-buf fd.
> So the right file->f_mapping is always set at file creation time.
>
> And we indeed don't frob this more when going another indirection ...
> Maybe we screwed up something somewhere :-/
>
> Also I thought the mapping is only taken after the vma is instatiated,
> otherwise the tricks we're playing with dma-buf already wouldn't work:
> dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
> it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
> whether we could adjust vm_file too. Or is that the thing that's
> forbidden?

Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.

But changing vma->vm_file, that's something I haven't seen before and 
most likely could blow up badly.

Christian.

> -Daniel
>
>> Christian.
>>
>>> Of course there's still the problem that many drivers don't forward the
>>> cache coherency calls for begin/end cpu access, so in a bunch of cases
>>> you'll cache cacheline dirt soup. But that's kinda standard procedure for
>>> dma-buf :-P
>>>
>>> But yeah trying to handle the mmap as an importer, bypassing the export:
>>> nope. The one exception is if you have some kind of fancy gart with
>>> cpu-visible pci bar (like at least integrated intel gpus have). But in
>>> that case the mmap very much looks&acts like device access in every way.
>>>
>>> Cheers, Daniel
>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>
>>>>> -Chris
>

