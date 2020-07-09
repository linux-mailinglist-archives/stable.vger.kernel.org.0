Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E253421A1E9
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGIOPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 10:15:39 -0400
Received: from mail-eopbgr680086.outbound.protection.outlook.com ([40.107.68.86]:37144
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbgGIOPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 10:15:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sxpi7mNV/54mkJk9cMIMeNYBTDtY5UeI4wSGhK2YIBHaSln5b/SYneE1yaD7hOZ8nvmUQTBNrOvbmAR+rASQPzlv5ssMWJ8yKVXawyY/n5AfODMCYGJB7Ab7O7IOvUzrqqTEpld/hYPB0ZrCJZB4KhCOuHFx+gn65RpS3bvh+me4AurP73sUxPayfakJfNsPA7EV2aJXM243B+qZNEEbNAlK0wtxGwtHV/PbPDifRXW5o/aFA29hAMvLTOeKU4oam5k90j3nqI6JEMmpjVrsdkjAWABpqm3sDETiJmgnpotljxr/36+acZWD3jX3suaLjkCLWAxttYwlJd372uluIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcYTdXDs4/37mm8TEJLxqX3IdgTbQR72mzuLlUN8+0I=;
 b=IHUVAKkC6ZQ3s0oo0LDV95PtJeeazaKbufMKJDzciV5jz+XcvXSmtqwjLZBcwvvV+Mo2flehniLIq/vw3hPjnROP5Zx0PUxLHgdOeqBNbF2+y8sx2WxtozwhaTCx/21Ms4yUXU7kqmmahsuDFlCm7kP1SO7EBOlKf1hy3tTSFImLVT5FK4hiBY7xGuuztEKKbYIylM/eQj+4mLibCRIclB60xWna+Jrcrkw5v12yv/JUlx6k9e8d/uJFoncgiCYFnh3t2U6VBQcXUxhgOdZVbjQC5vzwdSSsQqfr+D8PERWnYdsGtPW8r7WrbZUYF3GJmhmCbUo5hVs+vgUrZqLA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcYTdXDs4/37mm8TEJLxqX3IdgTbQR72mzuLlUN8+0I=;
 b=pqBmAvr2+P4V+l+nxyMJe20GNNzueTAgNkhVklmx+6yB0xgKX4cNChelaaIBXN3STkexWF2uLZdS3RqWd5RWGQchglIkAO1djluGklycyDk/lTf3mvuLllHIBdy2O/2DlQ9/12P66ssZ2mayehAAEBUxA32rAXe39mn4GouFDZ8=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 14:15:35 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::a16e:8812:b4c0:918d%6]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 14:15:35 +0000
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Steven Price <steven.price@arm.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Cc:     =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>, lepton <ytht.net@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
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
 <bdf4b521-eb21-3381-ee06-98eb3b1cbbc6@amd.com>
 <856a735f-0ed2-bfac-481e-e88304f14dff@arm.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <79f747af-90fb-1473-00d5-76a7154d464a@amd.com>
Date:   Thu, 9 Jul 2020 16:15:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <856a735f-0ed2-bfac-481e-e88304f14dff@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR05CA0090.eurprd05.prod.outlook.com
 (2603:10a6:207:1::16) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM3PR05CA0090.eurprd05.prod.outlook.com (2603:10a6:207:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Thu, 9 Jul 2020 14:15:33 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fca5d4c-e3fa-46cc-a231-08d824128bd7
X-MS-TrafficTypeDiagnostic: MN2PR12MB4304:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4304BE95B519995EE628FE2783640@MN2PR12MB4304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKHiyVDB9WbuiOiC2TBRd9JzeD97Ma+G0u/oxAGQWXWHQ99ADPelrSQ/HlfP7NZIBmEfmTzk19rTuCbZElISlYKWAWYc7Mh9mRdy75QLZYyWmf9ezimUYcbpIanbr05+Qrf4JcX+gZ/ibGGtkFCuRw2Qi4zGwx22JpnnKvGjPL+0FOlPdxj/9KVPTBK7wWD22ve1wb7yBUV0TJpwPpkRhNqrWr4HoBQL8lVlJx4X0gH7yFz9Yk98/16SNitTRcfulbytxsBLLIb9gj8YbLrDaXfAEC/1BUyeK7R6zYKbFOw/35YtN0QN3Cr+R9vAFfW8Yv8JdZ2CQjvK6uQsd54jnBxiVWUa07khxQkpvHq5Ij6UvffOC9YAqvU67lZzDnBP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(316002)(8676002)(31696002)(5660300002)(110136005)(66556008)(478600001)(6486002)(186003)(16526019)(7416002)(4326008)(2906002)(53546011)(36756003)(6666004)(83380400001)(66574015)(31686004)(86362001)(54906003)(52116002)(8936002)(2616005)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A9G9lzsXGf8wVrmQEnHS2a3vAC7K8rAGYBcsvscW9ft8bE59pHKk9UpEG1xDKlnCm9rGepmODjgzsVzpCRCfp4kct0GkCWqYl5BSIHwhkBCLAtalfmUHDyVpdk1bSDD2SeWjPQqV6wgB8mRyKeTfIzpZ/MYQmTJlxYgn2q0KDLuRPeNHtb9kHCH+Zzi27C++4WnSVzSBKpHvN4MnRdRJTSVnT3+LHrlAJX/LbizaLfmCN4HYUvbC+i6cucAJXHzw8OIzfJvbIFQCHAm3tFN5IlkSreWV5ga4neq5HL3+twauEOAt1HwdZx0mD9YhnpZb2erumFersqXCdr4YrRiUhOLTtWGb1wuBbBPeYEw/lSYM22cdz61dcguKZmGKXJEOabhxeBKmVVYk7rZXXgyf7bAXqAQ4a/SFr/T8N5S8xZArF/dB9GOYrR+BONknYGja7JahuFiio73WeFdLGPoj2fuSMS8alFMMBnrUdO58LMlnPsradCZ2Bp1vt2ugIWiU2PYCbKY5wmuuKZVWDPMvgGWzrhPeYilFAY9cV1U1ntMIrPh5tzm6+spDD5P+z4t+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fca5d4c-e3fa-46cc-a231-08d824128bd7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 14:15:34.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOKCOpMrzJgMxciBclL1gL3rfbtGYuynry3JUzO0F/pn32bOjW1l7kumBV5RMzFo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 09.07.20 um 15:54 schrieb Steven Price:
> On 09/07/2020 09:48, Christian König wrote:
>> Am 08.07.20 um 18:19 schrieb Daniel Vetter:
>>> On Wed, Jul 8, 2020 at 6:11 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>>>> On Wed, Jul 8, 2020 at 5:05 PM Christian König 
>>>> <christian.koenig@amd.com> wrote:
>>>>> Am 08.07.20 um 17:01 schrieb Daniel Vetter:
>>>>>> On Wed, Jul 8, 2020 at 4:37 PM Christian König 
>>>>>> <christian.koenig@amd.com> wrote:
>>>>>>> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
>>>>>>>> On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian König wrote:
>>>>>>>>> Am 07.07.20 um 20:35 schrieb Chris Wilson:
>>>>>>>>>> Quoting lepton (2020-07-07 19:17:51)
>>>>>>>>>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson 
>>>>>>>>>>> <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>>> Quoting lepton (2020-07-07 18:05:21)
>>>>>>>>>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson 
>>>>>>>>>>>>> <chris@chris-wilson.co.uk> wrote:
>>>>>>>>>>>>>> If we assign obj->filp, we believe that the create vgem 
>>>>>>>>>>>>>> bo is native and
>>>>>>>>>>>>>> allow direct operations like mmap() assuming it behaves 
>>>>>>>>>>>>>> as backed by a
>>>>>>>>>>>>>> shmemfs inode. When imported from a dmabuf, the 
>>>>>>>>>>>>>> obj->pages are
>>>>>>>>>>>>>> not always meaningful and the shmemfs backing store 
>>>>>>>>>>>>>> misleading.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Note, that regular mmap access to a vgem bo is via the 
>>>>>>>>>>>>>> dumb buffer API,
>>>>>>>>>>>>>> and that rejects attempts to mmap an imported dmabuf,
>>>>>>>>>>>>> What do you mean by "regular mmap access" here?  It looks 
>>>>>>>>>>>>> like vgem is
>>>>>>>>>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then 
>>>>>>>>>>>>> it doesn't call
>>>>>>>>>>>>> drm_gem_dumb_map_offset
>>>>>>>>>>>> As I too found out, and so had to correct my story telling.
>>>>>>>>>>>>
>>>>>>>>>>>> By regular mmap() access I mean mmap on the vgem bo [via 
>>>>>>>>>>>> the dumb buffer
>>>>>>>>>>>> API] as opposed to mmap() via an exported dma-buf fd. I had 
>>>>>>>>>>>> to look at
>>>>>>>>>>>> igt to see how it was being used.
>>>>>>>>>>> Now it seems your fix is to disable "regular mmap" on 
>>>>>>>>>>> imported dma buf
>>>>>>>>>>> for vgem. I am not really a graphic guy, but then the api 
>>>>>>>>>>> looks like:
>>>>>>>>>>> for a gem handle, user space has to guess to find out the 
>>>>>>>>>>> way to mmap
>>>>>>>>>>> it. If user space guess wrong, then it will fail to mmap. Is 
>>>>>>>>>>> this the
>>>>>>>>>>> expected way
>>>>>>>>>>> for people to handle gpu buffer?
>>>>>>>>>> You either have a dumb buffer handle, or a dma-buf fd. If you 
>>>>>>>>>> have the
>>>>>>>>>> handle, you have to use the dumb buffer API, there's no other 
>>>>>>>>>> way to
>>>>>>>>>> mmap it. If you have the dma-buf fd, you should mmap it 
>>>>>>>>>> directly. Those
>>>>>>>>>> two are clear.
>>>>>>>>>>
>>>>>>>>>> It's when you import the dma-buf into vgem and create a 
>>>>>>>>>> handle out of
>>>>>>>>>> it, that's when the handle is no longer first class and 
>>>>>>>>>> certain uAPI
>>>>>>>>>> [the dumb buffer API in particular] fail.
>>>>>>>>>>
>>>>>>>>>> It's not brilliant, as you say, it requires the user to 
>>>>>>>>>> remember the
>>>>>>>>>> difference between the handles, but at the same time it does 
>>>>>>>>>> prevent
>>>>>>>>>> them falling into coherency traps by forcing them to use the 
>>>>>>>>>> right
>>>>>>>>>> driver to handle the object, and have to consider the 
>>>>>>>>>> additional ioctls
>>>>>>>>>> that go along with that access.
>>>>>>>>> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs 
>>>>>>>>> of an importer
>>>>>>>>> is illegal.
>>>>>>>>>
>>>>>>>>> What we could maybe try to do is to redirect this mmap() API 
>>>>>>>>> call on the
>>>>>>>>> importer to the exporter, but I'm pretty sure that the fs 
>>>>>>>>> layer wouldn't
>>>>>>>>> like that without changes.
>>>>>>>> We already do that, there's a full helper-ified path from I 
>>>>>>>> think shmem
>>>>>>>> helpers through prime helpers to forward this all. Including 
>>>>>>>> handling
>>>>>>>> buffer offsets and all the other lolz back&forth.
>>>>>>> Oh, that most likely won't work correctly with unpinned DMA-bufs 
>>>>>>> and
>>>>>>> needs to be avoided.
>>>>>>>
>>>>>>> Each file descriptor is associated with an struct address_space. 
>>>>>>> And
>>>>>>> when you mmap() through the importer by redirecting the system 
>>>>>>> call to
>>>>>>> the exporter you end up with the wrong struct address_space in 
>>>>>>> your VMA.
>>>>>>>
>>>>>>> That in turn can go up easily in flames when the exporter tries to
>>>>>>> invalidate the CPU mappings for its DMA-buf while moving it.
>>>>>>>
>>>>>>> Where are we doing this? My last status was that this is forbidden.
>>>>>> Hm I thought we're doing all that already, but looking at the code
>>>>>> again we're only doing this when opening a new drm fd or dma-buf fd.
>>>>>> So the right file->f_mapping is always set at file creation time.
>>>>>>
>>>>>> And we indeed don't frob this more when going another indirection 
>>>>>> ...
>>>>>> Maybe we screwed up something somewhere :-/
>>>>>>
>>>>>> Also I thought the mapping is only taken after the vma is 
>>>>>> instatiated,
>>>>>> otherwise the tricks we're playing with dma-buf already wouldn't 
>>>>>> work:
>>>>>> dma-buf has the buffer always at offset 0, whereas gem drm_fd 
>>>>>> mmap has
>>>>>> it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
>>>>>> whether we could adjust vm_file too. Or is that the thing that's
>>>>>> forbidden?
>>>>> Yes, exactly. Modifying vm_pgoff is harmless, tons of code does that.
>>>>>
>>>>> But changing vma->vm_file, that's something I haven't seen before and
>>>>> most likely could blow up badly.
>>>> Ok, I read the shmem helpers again, I think those are the only ones
>>>> which do the importer mmap -> dma_buf_mmap() forwarding, and hence
>>>> break stuff all around here.
>>>>
>>>> They also remove the vma->vm_pgoff offset, which means
>>>> unmap_mapping_range wont work anyway. I guess for drivers which use
>>>> shmem helpers the hard assumption is that a) can't use p2p dma and b)
>>>> pin everything into system memory.
>>>>
>>>> So not a problem. But something to keep in mind. I'll try to do a
>>>> kerneldoc patch to note this somewhere. btw on that, did the
>>>> timeline/syncobj documentation patch land by now? Just trying to make
>>>> sure that doesn't get lost for another few months or so :-/
>>> Ok, so maybe it is a problem. Because there is a drm_gem_shmem_purge()
>>> which uses unmap_mapping_range underneath, and that's used by
>>> panfrost. And panfrost also uses the mmap helper. Kinda wondering
>>> whether we broke some stuff here, or whether the reverse map is
>>> installed before we touch vma->vm_pgoff.
>>
>> I think the key problem here is that unmap_mapping_range() doesn't 
>> blow up immediately when this is wrong.
>>
>> E.g. we just have a stale CPU page table entry which allows userspace 
>> to write to freed up memory, but we don't really notice that 
>> immediately....
>>
>> Maybe we should stop allowing to mmap() DMA-buf through the importer 
>> file descriptor altogether and only allow mapping it through its own 
>> fd or the exporter.
>
> That is what I tried to do with panfrost a while ago:
>
>    583bbf46133c drm/panfrost: Use drm_gem_map_offset()
>
>    panfrost_ioctl_mmap_bo() contains a reimplementation of
>    drm_gem_map_offset() but with a bug - it allows mapping imported
>    objects (without going through the exporter). Fix this by switching to
>    use the newly renamed drm_gem_map_offset() function instead which has
>    the bonus of simplifying the code.
>
> Sadly it was followed by:
>
>    be855382bacb Revert "drm/panfrost: Use drm_gem_map_offset()"
>    This reverts commit 583bbf46133c726bae277e8f4e32bfba2a528c7f.
>
>    Turns out we need mmap to work on imported BOs even if the current 
> code
>    is buggy.

Mhm, we might need to push back on the revert.

>> Christian.
>>
>>> panfrost folks, does panfrost purged buffer handling of mmap still
>>> work correctly? Do you have some kind of igt or similar for this?
>
> I'm not aware of any real testing of this. And I fear it probably 
> isn't getting much in the way of real-world testing either otherwise 
> someone would have grown tired of the "Purging xx bytes" message[1]
>
> I'm a little bit lost on this thread - are you expecting this patch to 
> break panfrost? We shouldn't be purging imported memory. Although I'm 
> not sure what (if anything) stops you trying to mark imported memory 
> as "don't need". Or indeed what would happen.

As long as panfrost keeps the imported DMA-bufs pinned everything should 
be fine as it is.

But this can open up a security hole you can push an elephant through. 
So you need to keep this in the back of your mind if this is ever 
implemented.

Christian.

>
> Steve
>
> [1] I have a patch silencing that, but recently haven't had much time 
> for working on Panfrost, and don't have my WFH setup quite as slick as 
> I did when I was in the office.

